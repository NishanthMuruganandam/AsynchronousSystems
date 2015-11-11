---- MODULE MC ----
EXTENDS TimeClocks, TLC

\* CONSTANT definitions @modelParameterConstants:0N
const_14441032024152000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:1maxClock
const_14441032024253000 == 
3
----

\* CONSTRAINT definition @modelParameterContraint:0
constr_14441032024354000 ==
\A s \in Sites: clock[s] <= maxClock
----
\* SPECIFICATION definition @modelBehaviorSpec:0
spec_14441032024465000 ==
Spec
----
\* INVARIANT definition @modelCorrectnessInvariants:0
inv_14441032024566000 ==
Safety
----
\* PROPERTY definition @modelCorrectnessProperties:0
prop_14441032024667000 ==
StarvationFree
----
\* PROPERTY definition @modelCorrectnessProperties:1
prop_14441032024768000 ==
Liveness
----
=============================================================================
\* Modification History
\* Created Mon Oct 05 23:46:42 EDT 2015 by nishanth
