!start.

+!start : true
    <- .println("valve agent started") .

+sanction(NormId,Event,Sanction) <- .print("Sanction ",Sanction," created for norm ", NormId, " that is ",Event).

+fill_bottle(L, N)
    <-  removeFact(filled(L, N));
        addFact(fill_bottle(L, N + 1));
        addFact(filled(U, L, N + 1)).


// obligation to achieve a goal
+obligation(Ag,Norm,What,Deadline)[artifact_id(ArtId),norm(_,Un)]: .my_name(Ag)
   <- .print(" ---> working to achieve ",What);
      !What;
      .print(" <--- done");
      .

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
{ include("$moise/asl/org-obedient.asl") }