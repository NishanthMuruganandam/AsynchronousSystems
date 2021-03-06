--------------------------- MODULE ra_timestamp ----------------------------
(* Ricart and Agrawala's timestamp based distributed mutual-exclusion algorithm*)

EXTENDS Naturals, Sequences, TLC
CONSTANT N, maxClock,request_per_process

Sites == 1 .. N
Comms == N+1 .. 2*N
site(c) == c - N  
max(x,y) == IF x < y THEN y ELSE x

(* --algorithm ra_timestamp
       variables        
         network = [fromm \in Sites |-> [to \in Sites |-> << >> ]]; 
         clock = [s \in Sites |-> 1];
         deferQ  = [fromm \in Sites |-> [to \in Sites |-> 0 ]]; 
         isRequesting = [s \in Sites |-> 0];
         state = [s \in Sites |-> "idle"];         
         reply_received = [s \in Sites |-> 0];
         req_list= [s \in Sites |->request_per_process];
         kill=0;
                       
       define 
         send(net, from, to, msg) == 
           [net EXCEPT ![from][to] = Append(@, msg)]
 
         broadcast(net, from, msg) ==
           [net EXCEPT ![from] = [to \in Sites |-> Append(net[from][to], msg)]]
       end define;
       
       process Site \in Sites
       variables  from,tmp;
       begin
         start:
           while req_list[self] # 0 
           do
         ncrit: 
             skip;
         try:
             network := broadcast(network, self,[kind |-> "request", clk |-> clock[self]]);
             state[self] := "waiting";             
             isRequesting[self] :=  clock[self];
             
         enter:
             await reply_received[self]= N-1;
         crit:
             req_list[self]:=req_list[self]-1;
             state[self] := "owner";             
         a1: 
             from:=1;
             isRequesting[self] := 0;
             reply_received[self] :=0;
         a2:    
             while from<=N 
             do
                if (deferQ[self][from]=1) then
                   state[self] := "idle";
                   
                   network:=send(network,self,from,[kind |-> "reply", clk |-> clock[self]]);
                   deferQ[self][from]:=0;
                end if;
                from := from+1;
             end while ;  
         a3:
           from:=2;
           tmp:=0;
         a4:   
           tmp:=req_list[1];
         a5:
           while from<=N
           do
           tmp:=tmp + req_list[from];
           from:=from+1;
           end while;
         a6:
           if tmp=0 then
           kill := 1;
           end if;
          end while;              
       end process;

       process Comm \in Comms       
       variables me, from, msg, _net;
       begin
         start1:
            me:= site(self);   
         comm1:
           while kill=0 
           do             
             from:=1;
        check2: 
           while from<=N do
                if (from # me) then 
        check_for_given_from1:   
                while Len(network[from][me]) > 0 do 
                msg := Head(network[from][me]);
                _net := [network EXCEPT ![from][me] = Tail(@)];
                if msg.kind = "request" then  
                clock[me] := max(clock[me], msg.clk) + 1;  
                if ((pc[me] # "crit") \lor (isRequesting[me] = 0) \lor ((isRequesting[me] # 0) \land (isRequesting[me]>msg.clk)))  then
                     network:=send(network,me,from,[kind |-> "reply", clk |-> clock[me]]) ;
                else
                deferQ[me][from]:=1
                end if;
                end if;
                if msg.kind = "reply" then
                if msg.clk>isRequesting[me] then
                reply_received[me] := reply_received[me] + 1
                end if;
                end if;
         update:       
                network := _net;
                end while;
                end if;
         increment_from:       
                from:=from+1  
           end while;
           end while;
       end process;
     end algorithm
*)

\* BEGIN TRANSLATION
\* Process variable from of process Site at line 32 col 19 changed to from_
CONSTANT defaultInitValue
VARIABLES network, clock, deferQ, isRequesting, state, reply_received, 
          req_list, kill, pc

(* define statement *)
send(net, from, to, msg) ==
  [net EXCEPT ![from][to] = Append(@, msg)]

broadcast(net, from, msg) ==
  [net EXCEPT ![from] = [to \in Sites |-> Append(net[from][to], msg)]]

VARIABLES from_, tmp, me, from, msg, _net

vars == << network, clock, deferQ, isRequesting, state, reply_received, 
           req_list, kill, pc, from_, tmp, me, from, msg, _net >>

ProcSet == (Sites) \cup (Comms)

Init == (* Global variables *)
        /\ network = [fromm \in Sites |-> [to \in Sites |-> << >> ]]
        /\ clock = [s \in Sites |-> 1]
        /\ deferQ = [fromm \in Sites |-> [to \in Sites |-> 0 ]]
        /\ isRequesting = [s \in Sites |-> 0]
        /\ state = [s \in Sites |-> "idle"]
        /\ reply_received = [s \in Sites |-> 0]
        /\ req_list = [s \in Sites |->request_per_process]
        /\ kill = 0
        (* Process Site *)
        /\ from_ = [self \in Sites |-> defaultInitValue]
        /\ tmp = [self \in Sites |-> defaultInitValue]
        (* Process Comm *)
        /\ me = [self \in Comms |-> defaultInitValue]
        /\ from = [self \in Comms |-> defaultInitValue]
        /\ msg = [self \in Comms |-> defaultInitValue]
        /\ _net = [self \in Comms |-> defaultInitValue]
        /\ pc = [self \in ProcSet |-> CASE self \in Sites -> "start"
                                        [] self \in Comms -> "start1"]

start(self) == /\ pc[self] = "start"
               /\ IF req_list[self] # 0
                     THEN /\ pc' = [pc EXCEPT ![self] = "ncrit"]
                     ELSE /\ pc' = [pc EXCEPT ![self] = "Done"]
               /\ UNCHANGED << network, clock, deferQ, isRequesting, state, 
                               reply_received, req_list, kill, from_, tmp, me, 
                               from, msg, _net >>

ncrit(self) == /\ pc[self] = "ncrit"
               /\ TRUE
               /\ pc' = [pc EXCEPT ![self] = "try"]
               /\ UNCHANGED << network, clock, deferQ, isRequesting, state, 
                               reply_received, req_list, kill, from_, tmp, me, 
                               from, msg, _net >>

try(self) == /\ pc[self] = "try"
             /\ network' = broadcast(network, self,[kind |-> "request", clk |-> clock[self]])
             /\ state' = [state EXCEPT ![self] = "waiting"]
             /\ isRequesting' = [isRequesting EXCEPT ![self] = clock[self]]
             /\ pc' = [pc EXCEPT ![self] = "enter"]
             /\ UNCHANGED << clock, deferQ, reply_received, req_list, kill, 
                             from_, tmp, me, from, msg, _net >>

enter(self) == /\ pc[self] = "enter"
               /\ reply_received[self]= N-1
               /\ pc' = [pc EXCEPT ![self] = "crit"]
               /\ UNCHANGED << network, clock, deferQ, isRequesting, state, 
                               reply_received, req_list, kill, from_, tmp, me, 
                               from, msg, _net >>

crit(self) == /\ pc[self] = "crit"
              /\ req_list' = [req_list EXCEPT ![self] = req_list[self]-1]
              /\ state' = [state EXCEPT ![self] = "owner"]
              /\ pc' = [pc EXCEPT ![self] = "a1"]
              /\ UNCHANGED << network, clock, deferQ, isRequesting, 
                              reply_received, kill, from_, tmp, me, from, msg, 
                              _net >>

a1(self) == /\ pc[self] = "a1"
            /\ from_' = [from_ EXCEPT ![self] = 1]
            /\ isRequesting' = [isRequesting EXCEPT ![self] = 0]
            /\ reply_received' = [reply_received EXCEPT ![self] = 0]
            /\ pc' = [pc EXCEPT ![self] = "a2"]
            /\ UNCHANGED << network, clock, deferQ, state, req_list, kill, tmp, 
                            me, from, msg, _net >>

a2(self) == /\ pc[self] = "a2"
            /\ IF from_[self]<=N
                  THEN /\ IF (deferQ[self][from_[self]]=1)
                             THEN /\ state' = [state EXCEPT ![self] = "idle"]
                                  /\ network' = send(network,self,from_[self],[kind |-> "reply", clk |-> clock[self]])
                                  /\ deferQ' = [deferQ EXCEPT ![self][from_[self]] = 0]
                             ELSE /\ TRUE
                                  /\ UNCHANGED << network, deferQ, state >>
                       /\ from_' = [from_ EXCEPT ![self] = from_[self]+1]
                       /\ pc' = [pc EXCEPT ![self] = "a2"]
                  ELSE /\ pc' = [pc EXCEPT ![self] = "a3"]
                       /\ UNCHANGED << network, deferQ, state, from_ >>
            /\ UNCHANGED << clock, isRequesting, reply_received, req_list, 
                            kill, tmp, me, from, msg, _net >>

a3(self) == /\ pc[self] = "a3"
            /\ from_' = [from_ EXCEPT ![self] = 2]
            /\ tmp' = [tmp EXCEPT ![self] = 0]
            /\ pc' = [pc EXCEPT ![self] = "a4"]
            /\ UNCHANGED << network, clock, deferQ, isRequesting, state, 
                            reply_received, req_list, kill, me, from, msg, 
                            _net >>

a4(self) == /\ pc[self] = "a4"
            /\ tmp' = [tmp EXCEPT ![self] = req_list[1]]
            /\ pc' = [pc EXCEPT ![self] = "a5"]
            /\ UNCHANGED << network, clock, deferQ, isRequesting, state, 
                            reply_received, req_list, kill, from_, me, from, 
                            msg, _net >>

a5(self) == /\ pc[self] = "a5"
            /\ IF from_[self]<=N
                  THEN /\ tmp' = [tmp EXCEPT ![self] = tmp[self] + req_list[from_[self]]]
                       /\ from_' = [from_ EXCEPT ![self] = from_[self]+1]
                       /\ pc' = [pc EXCEPT ![self] = "a5"]
                  ELSE /\ pc' = [pc EXCEPT ![self] = "a6"]
                       /\ UNCHANGED << from_, tmp >>
            /\ UNCHANGED << network, clock, deferQ, isRequesting, state, 
                            reply_received, req_list, kill, me, from, msg, 
                            _net >>

a6(self) == /\ pc[self] = "a6"
            /\ IF tmp[self]=0
                  THEN /\ kill' = 1
                  ELSE /\ TRUE
                       /\ kill' = kill
            /\ pc' = [pc EXCEPT ![self] = "start"]
            /\ UNCHANGED << network, clock, deferQ, isRequesting, state, 
                            reply_received, req_list, from_, tmp, me, from, 
                            msg, _net >>

Site(self) == start(self) \/ ncrit(self) \/ try(self) \/ enter(self)
                 \/ crit(self) \/ a1(self) \/ a2(self) \/ a3(self)
                 \/ a4(self) \/ a5(self) \/ a6(self)

start1(self) == /\ pc[self] = "start1"
                /\ me' = [me EXCEPT ![self] = site(self)]
                /\ pc' = [pc EXCEPT ![self] = "comm1"]
                /\ UNCHANGED << network, clock, deferQ, isRequesting, state, 
                                reply_received, req_list, kill, from_, tmp, 
                                from, msg, _net >>

comm1(self) == /\ pc[self] = "comm1"
               /\ IF kill=0
                     THEN /\ from' = [from EXCEPT ![self] = 1]
                          /\ pc' = [pc EXCEPT ![self] = "check2"]
                     ELSE /\ pc' = [pc EXCEPT ![self] = "Done"]
                          /\ from' = from
               /\ UNCHANGED << network, clock, deferQ, isRequesting, state, 
                               reply_received, req_list, kill, from_, tmp, me, 
                               msg, _net >>

check2(self) == /\ pc[self] = "check2"
                /\ IF from[self]<=N
                      THEN /\ IF (from[self] # me[self])
                                 THEN /\ pc' = [pc EXCEPT ![self] = "check_for_given_from1"]
                                 ELSE /\ pc' = [pc EXCEPT ![self] = "increment_from"]
                      ELSE /\ pc' = [pc EXCEPT ![self] = "comm1"]
                /\ UNCHANGED << network, clock, deferQ, isRequesting, state, 
                                reply_received, req_list, kill, from_, tmp, me, 
                                from, msg, _net >>

increment_from(self) == /\ pc[self] = "increment_from"
                        /\ from' = [from EXCEPT ![self] = from[self]+1]
                        /\ pc' = [pc EXCEPT ![self] = "check2"]
                        /\ UNCHANGED << network, clock, deferQ, isRequesting, 
                                        state, reply_received, req_list, kill, 
                                        from_, tmp, me, msg, _net >>

check_for_given_from1(self) == /\ pc[self] = "check_for_given_from1"
                               /\ IF Len(network[from[self]][me[self]]) > 0
                                     THEN /\ msg' = [msg EXCEPT ![self] = Head(network[from[self]][me[self]])]
                                          /\ _net' = [_net EXCEPT ![self] = [network EXCEPT ![from[self]][me[self]] = Tail(@)]]
                                          /\ IF msg'[self].kind = "request"
                                                THEN /\ clock' = [clock EXCEPT ![me[self]] = max(clock[me[self]], msg'[self].clk) + 1]
                                                     /\ IF ((pc[me[self]] # "crit") \lor (isRequesting[me[self]] = 0) \lor ((isRequesting[me[self]] # 0) \land (isRequesting[me[self]]>msg'[self].clk)))
                                                           THEN /\ network' = send(network,me[self],from[self],[kind |-> "reply", clk |-> clock'[me[self]]])
                                                                /\ UNCHANGED deferQ
                                                           ELSE /\ deferQ' = [deferQ EXCEPT ![me[self]][from[self]] = 1]
                                                                /\ UNCHANGED network
                                                ELSE /\ TRUE
                                                     /\ UNCHANGED << network, 
                                                                     clock, 
                                                                     deferQ >>
                                          /\ IF msg'[self].kind = "reply"
                                                THEN /\ IF msg'[self].clk>isRequesting[me[self]]
                                                           THEN /\ reply_received' = [reply_received EXCEPT ![me[self]] = reply_received[me[self]] + 1]
                                                           ELSE /\ TRUE
                                                                /\ UNCHANGED reply_received
                                                ELSE /\ TRUE
                                                     /\ UNCHANGED reply_received
                                          /\ pc' = [pc EXCEPT ![self] = "update"]
                                     ELSE /\ pc' = [pc EXCEPT ![self] = "increment_from"]
                                          /\ UNCHANGED << network, clock, 
                                                          deferQ, 
                                                          reply_received, msg, 
                                                          _net >>
                               /\ UNCHANGED << isRequesting, state, req_list, 
                                               kill, from_, tmp, me, from >>

update(self) == /\ pc[self] = "update"
                /\ network' = _net[self]
                /\ pc' = [pc EXCEPT ![self] = "check_for_given_from1"]
                /\ UNCHANGED << clock, deferQ, isRequesting, state, 
                                reply_received, req_list, kill, from_, tmp, me, 
                                from, msg, _net >>

Comm(self) == start1(self) \/ comm1(self) \/ check2(self)
                 \/ increment_from(self) \/ check_for_given_from1(self)
                 \/ update(self)

Next == (\E self \in Sites: Site(self))
           \/ (\E self \in Comms: Comm(self))
           \/ (* Disjunct to prevent deadlock on termination *)
              ((\A p \in ProcSet: pc[p] = "Done") /\ UNCHANGED vars)

Spec == Init /\ [][Next]_vars

Termination == <>(\A self \in Sites: pc[self] = "Done")

\* END TRANSLATION
 StarvationFree == \A p \in Sites : SF_state(enter(p))
    Liveness == \A p \in Sites : /\ WF_state(enter(p))
                            /\ \A q \in Sites \{p} : WF_state (comm1(q))
    Safety == \A p,q \in Sites : (state[p] = "crit" /\ state[q] = "crit") => (p = q)

=======================================================================================


