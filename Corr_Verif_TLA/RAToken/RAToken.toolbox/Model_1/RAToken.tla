--------------------------- MODULE RAToken ----------------------------
(* Ricart and Agrawala's token based distributed mutual-exclusion algorithm*)

EXTENDS Naturals, Sequences, TLC
CONSTANT N, maxClock

Sites == 1 .. N
Comms == N+1 .. 2*N
site(c) == c - N  
max(x,y) == IF x < y THEN y ELSE x

(* --algorithm RAToken
       variables        
         network = [fromm \in Sites |-> [to \in Sites |-> << >> ]];
         clock = [s \in Sites |-> 1];
         reqQ  = [s \in Sites |-> [k \in Sites |-> 0 ]]; 
         token = [s \in Sites |-> 0];   
         state = [s \in Sites |-> "idle"];
         token_held = [s \in Sites |-> FALSE];
         token_present = [token_held EXCEPT ![1] = TRUE];
         
       define 
         send(net, from, to, msg) == 
           [net EXCEPT ![from][to] = Append(@, msg)]
           
         broadcast(net, from, msg) ==
           [net EXCEPT ![from] = [to \in Sites |-> Append(net[from][to], msg)]]
       end define;

       macro insertRequest(s, from, clk)
       begin
         if reqQ[s][from] < clk then reqQ[s][from] := clk 
         end if;
       end macro; 
       
       process Site \in Sites
       variables  j, me;
           
       begin
         start:
           while TRUE
           do
         ncrit: 
             skip;
         try:
             if (token_present[self] = FALSE) then  state[self] := "waiting";                                      
                network := broadcast(network, self, 
                                  [kind |-> "request", clk |-> clock[self]]);
             end if;
             await token_present[self] = TRUE;
                                  
         enter:             
             token_held[self]:=TRUE;         
             
         crit:
             state[self] := "owner";             
         exit:
             state[self] := "idle";         
             token[self] := clock[self];
             token_held[self]:=FALSE;
             me:=self;
             j:=me+1;
             
         part1:
             while j \leq N do
                if (token_held[self] # TRUE \land reqQ[me][j] > token[j]) \land (token_present[me] = TRUE)  
                then token_present[self] := FALSE;
                     network:=send(network,me,j,[kind |-> "token"]) ;
                end if;
             j:=j+1;
             end while;
             j:=1;
         part2:
             while j < self do
                if (token_held[self] # TRUE \land reqQ[me][j] > token[j]) \land (token_present[me] = TRUE)  
                then  token_present[self] := FALSE;
                      network:=send(network,me,j,[kind |-> "token"]) ;
                end if;
             j:=j+1;
             end while;              
           end while;
       end process;

       process Comm \in Comms       
       variables me, from, msg, _net, j;
       begin
         start1:
            me:= site(self);
         comm1:
           while TRUE 
           do             
             from:=1;
        check1:  
             while from<=N do
                if (from # me) \land (Len(network[from][me]) > 0) then 
        check_for_given_from1: 
                    while Len(network[from][me]) > 0 do                  
                           msg := Head(network[from][me]);
                          _net := [network EXCEPT ![from][me] = Tail(@)];    
                           if msg.kind = "request" then
                              insertRequest(me, from, msg.clk);
                              clock[me] := max(clock[me], msg.clk) + 1;
                              if (token_present[me] = TRUE) \land (token_held[me] = FALSE) then  
                                 j:=me+1;
                                 commPart1:
                                     while j \leq N do
                                        if (token_held[me] # TRUE \land reqQ[me][j] > token[j]) \land (token_present[me] = TRUE)  
                                        then token_present[me] := FALSE;
                                             network:=send(network,me,j,[kind |-> "token"]) ;
                                        end if;
                                     j:=j+1;
                                     end while;
                                     j:=1;
                                 commPart2:
                                     while j < me do
                                        if (token_held[me] # TRUE \land reqQ[me][j] > token[j]) \land (token_present[me] = TRUE)  
                                        then  token_present[me] := FALSE;
                                              network:=send(network,me,j,[kind |-> "token"]) ;
                                        end if;
                                     j:=j+1;
                                     end while;  
                               end if;
                       update1:
                              network := _net;
                              
                           elsif (msg.kind = "token") then                              
                              token_present[me] := TRUE;
                              network := _net;            
                           end if;
                    end while;                   
                end if;
             next1:
                from:=from+1;                   
             end while;
           end while;
       end process;
     end algorithm
*)

\* BEGIN TRANSLATION
\* Process variable j of process Site at line 37 col 19 changed to j_
\* Process variable me of process Site at line 37 col 22 changed to me_
CONSTANT defaultInitValue
VARIABLES network, clock, reqQ, token, state, token_held, token_present, pc

(* define statement *)
send(net, from, to, msg) ==
  [net EXCEPT ![from][to] = Append(@, msg)]

broadcast(net, from, msg) ==
  [net EXCEPT ![from] = [to \in Sites |-> Append(net[from][to], msg)]]

VARIABLES j_, me_, me, from, msg, _net, j

vars == << network, clock, reqQ, token, state, token_held, token_present, pc, 
           j_, me_, me, from, msg, _net, j >>

ProcSet == (Sites) \cup (Comms)

Init == (* Global variables *)
        /\ network = [fromm \in Sites |-> [to \in Sites |-> << >> ]]
        /\ clock = [s \in Sites |-> 1]
        /\ reqQ = [s \in Sites |-> [k \in Sites |-> 0 ]]
        /\ token = [s \in Sites |-> 0]
        /\ state = [s \in Sites |-> "idle"]
        /\ token_held = [s \in Sites |-> FALSE]
        /\ token_present = [token_held EXCEPT ![1] = TRUE]
        (* Process Site *)
        /\ j_ = [self \in Sites |-> defaultInitValue]
        /\ me_ = [self \in Sites |-> defaultInitValue]
        (* Process Comm *)
        /\ me = [self \in Comms |-> defaultInitValue]
        /\ from = [self \in Comms |-> defaultInitValue]
        /\ msg = [self \in Comms |-> defaultInitValue]
        /\ _net = [self \in Comms |-> defaultInitValue]
        /\ j = [self \in Comms |-> defaultInitValue]
        /\ pc = [self \in ProcSet |-> CASE self \in Sites -> "start"
                                        [] self \in Comms -> "start1"]

start(self) == /\ pc[self] = "start"
               /\ pc' = [pc EXCEPT ![self] = "ncrit"]
               /\ UNCHANGED << network, clock, reqQ, token, state, token_held, 
                               token_present, j_, me_, me, from, msg, _net, j >>

ncrit(self) == /\ pc[self] = "ncrit"
               /\ TRUE
               /\ pc' = [pc EXCEPT ![self] = "try"]
               /\ UNCHANGED << network, clock, reqQ, token, state, token_held, 
                               token_present, j_, me_, me, from, msg, _net, j >>

try(self) == /\ pc[self] = "try"
             /\ IF (token_present[self] = FALSE)
                   THEN /\ state' = [state EXCEPT ![self] = "waiting"]
                        /\ network' = broadcast(network, self,
                                             [kind |-> "request", clk |-> clock[self]])
                   ELSE /\ TRUE
                        /\ UNCHANGED << network, state >>
             /\ token_present[self] = TRUE
             /\ pc' = [pc EXCEPT ![self] = "enter"]
             /\ UNCHANGED << clock, reqQ, token, token_held, token_present, j_, 
                             me_, me, from, msg, _net, j >>

enter(self) == /\ pc[self] = "enter"
               /\ token_held' = [token_held EXCEPT ![self] = TRUE]
               /\ pc' = [pc EXCEPT ![self] = "crit"]
               /\ UNCHANGED << network, clock, reqQ, token, state, 
                               token_present, j_, me_, me, from, msg, _net, j >>

crit(self) == /\ pc[self] = "crit"
              /\ state' = [state EXCEPT ![self] = "owner"]
              /\ pc' = [pc EXCEPT ![self] = "exit"]
              /\ UNCHANGED << network, clock, reqQ, token, token_held, 
                              token_present, j_, me_, me, from, msg, _net, j >>

exit(self) == /\ pc[self] = "exit"
              /\ state' = [state EXCEPT ![self] = "idle"]
              /\ token' = [token EXCEPT ![self] = clock[self]]
              /\ token_held' = [token_held EXCEPT ![self] = FALSE]
              /\ me_' = [me_ EXCEPT ![self] = self]
              /\ j_' = [j_ EXCEPT ![self] = me_'[self]+1]
              /\ pc' = [pc EXCEPT ![self] = "part1"]
              /\ UNCHANGED << network, clock, reqQ, token_present, me, from, 
                              msg, _net, j >>

part1(self) == /\ pc[self] = "part1"
               /\ IF j_[self] \leq N
                     THEN /\ IF (token_held[self] # TRUE \land reqQ[me_[self]][j_[self]] > token[j_[self]]) \land (token_present[me_[self]] = TRUE)
                                THEN /\ token_present' = [token_present EXCEPT ![self] = FALSE]
                                     /\ network' = send(network,me_[self],j_[self],[kind |-> "token"])
                                ELSE /\ TRUE
                                     /\ UNCHANGED << network, token_present >>
                          /\ j_' = [j_ EXCEPT ![self] = j_[self]+1]
                          /\ pc' = [pc EXCEPT ![self] = "part1"]
                     ELSE /\ j_' = [j_ EXCEPT ![self] = 1]
                          /\ pc' = [pc EXCEPT ![self] = "part2"]
                          /\ UNCHANGED << network, token_present >>
               /\ UNCHANGED << clock, reqQ, token, state, token_held, me_, me, 
                               from, msg, _net, j >>

part2(self) == /\ pc[self] = "part2"
               /\ IF j_[self] < self
                     THEN /\ IF (token_held[self] # TRUE \land reqQ[me_[self]][j_[self]] > token[j_[self]]) \land (token_present[me_[self]] = TRUE)
                                THEN /\ token_present' = [token_present EXCEPT ![self] = FALSE]
                                     /\ network' = send(network,me_[self],j_[self],[kind |-> "token"])
                                ELSE /\ TRUE
                                     /\ UNCHANGED << network, token_present >>
                          /\ j_' = [j_ EXCEPT ![self] = j_[self]+1]
                          /\ pc' = [pc EXCEPT ![self] = "part2"]
                     ELSE /\ pc' = [pc EXCEPT ![self] = "start"]
                          /\ UNCHANGED << network, token_present, j_ >>
               /\ UNCHANGED << clock, reqQ, token, state, token_held, me_, me, 
                               from, msg, _net, j >>

Site(self) == start(self) \/ ncrit(self) \/ try(self) \/ enter(self)
                 \/ crit(self) \/ exit(self) \/ part1(self) \/ part2(self)

start1(self) == /\ pc[self] = "start1"
                /\ me' = [me EXCEPT ![self] = site(self)]
                /\ pc' = [pc EXCEPT ![self] = "comm1"]
                /\ UNCHANGED << network, clock, reqQ, token, state, token_held, 
                                token_present, j_, me_, from, msg, _net, j >>

comm1(self) == /\ pc[self] = "comm1"
               /\ from' = [from EXCEPT ![self] = 1]
               /\ pc' = [pc EXCEPT ![self] = "check1"]
               /\ UNCHANGED << network, clock, reqQ, token, state, token_held, 
                               token_present, j_, me_, me, msg, _net, j >>

check1(self) == /\ pc[self] = "check1"
                /\ IF from[self]<=N
                      THEN /\ IF (from[self] # me[self]) \land (Len(network[from[self]][me[self]]) > 0)
                                 THEN /\ pc' = [pc EXCEPT ![self] = "check_for_given_from1"]
                                 ELSE /\ pc' = [pc EXCEPT ![self] = "next1"]
                      ELSE /\ pc' = [pc EXCEPT ![self] = "comm1"]
                /\ UNCHANGED << network, clock, reqQ, token, state, token_held, 
                                token_present, j_, me_, me, from, msg, _net, j >>

next1(self) == /\ pc[self] = "next1"
               /\ from' = [from EXCEPT ![self] = from[self]+1]
               /\ pc' = [pc EXCEPT ![self] = "check1"]
               /\ UNCHANGED << network, clock, reqQ, token, state, token_held, 
                               token_present, j_, me_, me, msg, _net, j >>

check_for_given_from1(self) == /\ pc[self] = "check_for_given_from1"
                               /\ IF Len(network[from[self]][me[self]]) > 0
                                     THEN /\ msg' = [msg EXCEPT ![self] = Head(network[from[self]][me[self]])]
                                          /\ _net' = [_net EXCEPT ![self] = [network EXCEPT ![from[self]][me[self]] = Tail(@)]]
                                          /\ IF msg'[self].kind = "request"
                                                THEN /\ IF reqQ[me[self]][from[self]] < (msg'[self].clk)
                                                           THEN /\ reqQ' = [reqQ EXCEPT ![me[self]][from[self]] = msg'[self].clk]
                                                           ELSE /\ TRUE
                                                                /\ reqQ' = reqQ
                                                     /\ clock' = [clock EXCEPT ![me[self]] = max(clock[me[self]], msg'[self].clk) + 1]
                                                     /\ IF (token_present[me[self]] = TRUE) \land (token_held[me[self]] = FALSE)
                                                           THEN /\ j' = [j EXCEPT ![self] = me[self]+1]
                                                                /\ pc' = [pc EXCEPT ![self] = "commPart1"]
                                                           ELSE /\ pc' = [pc EXCEPT ![self] = "update1"]
                                                                /\ j' = j
                                                     /\ UNCHANGED << network, 
                                                                     token_present >>
                                                ELSE /\ IF (msg'[self].kind = "token")
                                                           THEN /\ token_present' = [token_present EXCEPT ![me[self]] = TRUE]
                                                                /\ network' = _net'[self]
                                                           ELSE /\ TRUE
                                                                /\ UNCHANGED << network, 
                                                                                token_present >>
                                                     /\ pc' = [pc EXCEPT ![self] = "check_for_given_from1"]
                                                     /\ UNCHANGED << clock, 
                                                                     reqQ, j >>
                                     ELSE /\ pc' = [pc EXCEPT ![self] = "next1"]
                                          /\ UNCHANGED << network, clock, reqQ, 
                                                          token_present, msg, 
                                                          _net, j >>
                               /\ UNCHANGED << token, state, token_held, j_, 
                                               me_, me, from >>

update1(self) == /\ pc[self] = "update1"
                 /\ network' = _net[self]
                 /\ pc' = [pc EXCEPT ![self] = "check_for_given_from1"]
                 /\ UNCHANGED << clock, reqQ, token, state, token_held, 
                                 token_present, j_, me_, me, from, msg, _net, 
                                 j >>

commPart1(self) == /\ pc[self] = "commPart1"
                   /\ IF j[self] \leq N
                         THEN /\ IF (token_held[me[self]] # TRUE \land reqQ[me[self]][j[self]] > token[j[self]]) \land (token_present[me[self]] = TRUE)
                                    THEN /\ token_present' = [token_present EXCEPT ![me[self]] = FALSE]
                                         /\ network' = send(network,me[self],j[self],[kind |-> "token"])
                                    ELSE /\ TRUE
                                         /\ UNCHANGED << network, 
                                                         token_present >>
                              /\ j' = [j EXCEPT ![self] = j[self]+1]
                              /\ pc' = [pc EXCEPT ![self] = "commPart1"]
                         ELSE /\ j' = [j EXCEPT ![self] = 1]
                              /\ pc' = [pc EXCEPT ![self] = "commPart2"]
                              /\ UNCHANGED << network, token_present >>
                   /\ UNCHANGED << clock, reqQ, token, state, token_held, j_, 
                                   me_, me, from, msg, _net >>

commPart2(self) == /\ pc[self] = "commPart2"
                   /\ IF j[self] < me[self]
                         THEN /\ IF (token_held[me[self]] # TRUE \land reqQ[me[self]][j[self]] > token[j[self]]) \land (token_present[me[self]] = TRUE)
                                    THEN /\ token_present' = [token_present EXCEPT ![me[self]] = FALSE]
                                         /\ network' = send(network,me[self],j[self],[kind |-> "token"])
                                    ELSE /\ TRUE
                                         /\ UNCHANGED << network, 
                                                         token_present >>
                              /\ j' = [j EXCEPT ![self] = j[self]+1]
                              /\ pc' = [pc EXCEPT ![self] = "commPart2"]
                         ELSE /\ pc' = [pc EXCEPT ![self] = "update1"]
                              /\ UNCHANGED << network, token_present, j >>
                   /\ UNCHANGED << clock, reqQ, token, state, token_held, j_, 
                                   me_, me, from, msg, _net >>

Comm(self) == start1(self) \/ comm1(self) \/ check1(self) \/ next1(self)
                 \/ check_for_given_from1(self) \/ update1(self)
                 \/ commPart1(self) \/ commPart2(self)

Next == (\E self \in Sites: Site(self))
           \/ (\E self \in Comms: Comm(self))

Spec == Init /\ [][Next]_vars

\* END TRANSLATION

(* -------------------- definitions for verification -------------------- *)

(* constraint for bounding the state space during model checking *)
ClockConstraint == \A s \in Sites : clock[s] <= maxClock

(* mutual exclusion *)
  
 \*END TRANSLATION
    StarvationFree == \A p \in Sites : state[p] = "waiting" ~> state[p] = "owner"

    Liveness == \A p \in Sites : /\ WF_state(enter(p))
                            /\ \A q \in Sites \{p} : WF_state (comm1(q))
 Safety == \A p,q \in Sites : (state[p] = "owner" /\ state[q] = "owner") => (p = q)
  

============================================================================


