---- MODULE MC ----
EXTENDS RAToken, TLC

\* CONSTANT definitions @modelParameterConstants:0N
const_1443994886215848000 == 
3
----

\* CONSTANT definitions @modelParameterConstants:1maxClock
const_1443994886225849000 == 
5
----

\* CONSTRAINT definition @modelParameterContraint:0
constr_1443994886235850000 ==
ClockConstraint
----
\* SPECIFICATION definition @modelBehaviorSpec:0
spec_1443994886245851000 ==
Spec
----
\* INVARIANT definition @modelCorrectnessInvariants:0
inv_1443994886255852000 ==
Safety
----
\* PROPERTY definition @modelCorrectnessProperties:0
prop_1443994886265853000 ==
StarvationFree
----
\* PROPERTY definition @modelCorrectnessProperties:1
prop_1443994886276854000 ==
Liveness
----
=============================================================================
\* Modification History
\* Created Sun Oct 04 17:41:26 EDT 2015 by nishanth
