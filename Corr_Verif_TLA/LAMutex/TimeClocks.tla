----------------------------- MODULE TimeClocks -----------------------------
EXTENDS Naturals,Sequences
CONSTANT N, maxClock
Sites == 1 .. N
Comms == N+1 .. 2*N
site(c) == c - N
max(x,y) ==  IF x < y THEN y ELSE x

(*
--algorithm LamportMutex
variables
network = [from \in Sites |-> [to \in Sites |-> << >> ]];
clock = [s \in Sites |-> 1];
state = [s \in Sites |-> "idle"];
reqQ = [s \in Sites |-> <<>>];
acks = [s \in Sites |-> {}];

define 
beats(rq1,rq2) ==
    \/ rq1.clk < rq2.clk
    \/ rq1.clk = rq2.clk /\ rq1.site < rq2.site
    
send(net, from, to, msg) ==
    [net EXCEPT ![from][to] = Append(@,msg)]

broadcast(net,from,msg) == 
    [net EXCEPT ![from] = [to \in Sites |-> Append(net[from][to],msg)]]
end define;
    
macro insertRequest(s,from,clk)
begin 
    with entry = [site |-> from, clk |-> clk],
         len = Len(reqQ[s]),
         pos = CHOOSE i \in 1..len+1:
                /\ \A j \in 1..i-1 : beats(reqQ[s][j],entry)
                /\ \/ i = len+1
                   \/ beats(entry,reqQ[s][i])
    do
        reqQ[s] := SubSeq(reqQ[s],1,pos-1) \circ << entry >>
                   \circ SubSeq(reqQ[s],pos,len);
    end with;
end macro;

macro removeRequest(s,from)
begin
    with len = Len(reqQ[s]),
         pos = CHOOSE i \in 1..len : reqQ[s][i].site = from
    do
    if (reqQ[s][pos].site = from)
    then
      reqQ[s] := SubSeq(reqQ[s],1,pos-1) \circ SubSeq(reqQ[s],pos+1,len);
    end if;
    end with;
end macro;    

process Site \in Sites
begin 
    start:
        while TRUE
            do
                ncrit:
                   skip;
                try:
                    network := broadcast(network,self,[kind |-> "request",clk|->clock[self]]);
                    state[self] := "waiting";
                    acks[self] := {};
                enter:
                    await /\ Len(reqQ[self]) > 0
                          /\ Head(reqQ[self]).site = self
                          /\ acks[self] = Sites;
                crit:
                    state[self] := "owner";
                    skip;
                exit:
                    network := broadcast(network,self,[kind|-> "free"]);
                    state[self] := "idle";
                end while;
              end process;
                        
process Comm \in Comms
begin
    comm:
        while TRUE
            do
             with me = site(self),
                  from \in {s \in Sites : Len(network[s][me]) > 0},
                  msg = Head(network[from][me]),
                  _net = [network EXCEPT ![from][me] = Tail(@)]
             do
                if msg.kind = "request" then
                insertRequest(me,from,msg.clk);
                clock[me] := max(clock[me],msg.clk) + 1;
                network := send(_net,me,from,[kind|-> "ack"]);
                elsif(msg.kind = "ack") then
                  acks[me] := @ \union {from};
                  network := _net;
                elsif (msg.kind = "free") then
                  removeRequest(me,from);
                  network := _net;
                end if;
             end with;
     end while;
   end process;
   
 end algorithm
 
 *)
 
 \*BEGIN TRANSLATION
VARIABLES network, clock, state, reqQ, acks, pc

(* define statement *)
beats(rq1,rq2) ==
    \/ rq1.clk < rq2.clk
    \/ rq1.clk = rq2.clk /\ rq1.site < rq2.site

send(net, from, to, msg) ==
    [net EXCEPT ![from][to] = Append(@,msg)]

broadcast(net,from,msg) ==
    [net EXCEPT ![from] = [to \in Sites |-> Append(net[from][to],msg)]]


vars == << network, clock, state, reqQ, acks, pc >>

ProcSet == (Sites) \cup (Comms)

Init == (* Global variables *)
        /\ network = [from \in Sites |-> [to \in Sites |-> << >> ]]
        /\ clock = [s \in Sites |-> 1]
        /\ state = [s \in Sites |-> "idle"]
        /\ reqQ = [s \in Sites |-> <<>>]
        /\ acks = [s \in Sites |-> {}]
        /\ pc = [self \in ProcSet |-> CASE self \in Sites -> "start"
                                        [] self \in Comms -> "comm"]

start(self) == /\ pc[self] = "start"
               /\ pc' = [pc EXCEPT ![self] = "ncrit"]
               /\ UNCHANGED << network, clock, state, reqQ, acks >>

ncrit(self) == /\ pc[self] = "ncrit"
               /\ TRUE
               /\ pc' = [pc EXCEPT ![self] = "try"]
               /\ UNCHANGED << network, clock, state, reqQ, acks >>

try(self) == /\ pc[self] = "try"
             /\ network' = broadcast(network,self,[kind |-> "request",clk|->clock[self]])
             /\ state' = [state EXCEPT ![self] = "waiting"]
             /\ acks' = [acks EXCEPT ![self] = {}]
             /\ pc' = [pc EXCEPT ![self] = "enter"]
             /\ UNCHANGED << clock, reqQ >>

enter(self) == /\ pc[self] = "enter"
               /\ /\ Len(reqQ[self]) > 0
                  /\ Head(reqQ[self]).site = self
                  /\ acks[self] = Sites
               /\ pc' = [pc EXCEPT ![self] = "crit"]
               /\ UNCHANGED << network, clock, state, reqQ, acks >>

crit(self) == /\ pc[self] = "crit"
              /\ state' = [state EXCEPT ![self] = "owner"]
              /\ TRUE
              /\ pc' = [pc EXCEPT ![self] = "exit"]
              /\ UNCHANGED << network, clock, reqQ, acks >>

exit(self) == /\ pc[self] = "exit"
              /\ network' = broadcast(network,self,[kind|-> "free"])
              /\ state' = [state EXCEPT ![self] = "idle"]
              /\ pc' = [pc EXCEPT ![self] = "start"]
              /\ UNCHANGED << clock, reqQ, acks >>

Site(self) == start(self) \/ ncrit(self) \/ try(self) \/ enter(self)
                 \/ crit(self) \/ exit(self)

comm(self) == /\ pc[self] = "comm"
              /\ LET me == site(self) IN
                   \E from \in {s \in Sites : Len(network[s][me]) > 0}:
                     LET msg == Head(network[from][me]) IN
                       LET _net == [network EXCEPT ![from][me] = Tail(@)] IN
                         IF msg.kind = "request"
                            THEN /\ LET entry == [site |-> from, clk |-> (msg.clk)] IN
                                      LET len == Len(reqQ[me]) IN
                                        LET pos == CHOOSE i \in 1..len+1:
                                                    /\ \A j \in 1..i-1 : beats(reqQ[me][j],entry)
                                                    /\ \/ i = len+1
                                                       \/ beats(entry,reqQ[me][i]) IN
                                          reqQ' = [reqQ EXCEPT ![me] = SubSeq(reqQ[me],1,pos-1) \circ << entry >>
                                                                       \circ SubSeq(reqQ[me],pos,len)]
                                 /\ clock' = [clock EXCEPT ![me] = max(clock[me],msg.clk) + 1]
                                 /\ network' = send(_net,me,from,[kind|-> "ack"])
                                 /\ acks' = acks
                            ELSE /\ IF (msg.kind = "ack")
                                       THEN /\ acks' = [acks EXCEPT ![me] = @ \union {from}]
                                            /\ network' = _net
                                            /\ reqQ' = reqQ
                                       ELSE /\ IF (msg.kind = "free")
                                                  THEN /\ LET len == Len(reqQ[me]) IN
                                                            LET pos == CHOOSE i \in 1..len : reqQ[me][i].site = from IN
                                                              IF (reqQ[me][pos].site = from)
                                                                 THEN /\ reqQ' = [reqQ EXCEPT ![me] = SubSeq(reqQ[me],1,pos-1) \circ SubSeq(reqQ[me],pos+1,len)]
                                                                 ELSE /\ TRUE
                                                                      /\ reqQ' = reqQ
                                                       /\ network' = _net
                                                  ELSE /\ TRUE
                                                       /\ UNCHANGED << network, 
                                                                       reqQ >>
                                            /\ acks' = acks
                                 /\ clock' = clock
              /\ pc' = [pc EXCEPT ![self] = "comm"]
              /\ state' = state

Comm(self) == comm(self)

Next == (\E self \in Sites: Site(self))
           \/ (\E self \in Comms: Comm(self))

 \*END TRANSLATION
(*** Correctness checking ***)
    StarvationFree == \A p \in Sites : SF_state(enter(p))
     Liveness == \A p \in Sites : /\ WF_state(enter(p))
                            /\ \A q \in Sites \{p} : WF_state (comm(q))
    Safety == \A p,q \in Sites : (state[p] = "owner" /\ state[q] = "owner") => (p = q)

Spec == Init /\ [][Next]_vars
=============================================================================
\* Modification History
\* Last modified Sun Oct 04 16:55:24 EDT 2015 by nishanth
\* Created Wed Sep 30 19:40:27 EDT 2015 by nishanth
