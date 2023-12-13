!start.

+!start : true
    <- .println("valve agent started") .

+sanction(NormId,Event,Sanction) <- .print("Sanction ",Sanction," created for norm ", NormId, " that is ",Event).

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moise/asl/org-obedient.asl") }