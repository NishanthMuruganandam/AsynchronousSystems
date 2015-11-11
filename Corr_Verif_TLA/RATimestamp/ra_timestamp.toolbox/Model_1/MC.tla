---- MODULE MC ----
EXTENDS ra_timestamp, TLC

\* CONSTANT definitions @modelParameterConstants:1N
const_1443993974053783000 == 
3
----

\* CONSTANT definitions @modelParameterConstants:2maxClock
const_1443993974063784000 == 
3
----

\* CONSTANT definitions @modelParameterConstants:3request_per_process
const_1443993974073785000 == 
1
----

\* CONSTRAINT definition @modelParameterContraint:0
constr_1443993974084786000 ==
\A s \in Sites: clock[s] <= maxClock
----
\* SPECIFICATION definition @modelBehaviorSpec:0
spec_1443993974094787000 ==
Spec
----
\* INVARIANT definition @modelCorrectnessInvariants:0
inv_1443993974104788000 ==
Safety
----
\* PROPERTY definition @modelCorrectnessProperties:0
prop_1443993974114789000 ==
Liveness
----
\* PROPERTY definition @modelCorrectnessProperties:1
prop_1443993974124790000 ==
StarvationFree
----
=============================================================================
\* Modification History
\* Created Sun Oct 04 17:26:14 EDT 2015 by nishanth
