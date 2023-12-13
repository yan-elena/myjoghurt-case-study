!start.

+!start : true
    <- debug(inspector_gui(on));
       load("src/org/myjoghurt.npl");

       addFact(order(unit, "yogurt", 20));

       .wait(5000);

       removeFact(order(unit, "yogurt", 20));
       .

// obligation to achieve a goal
+obligation(Ag,Norm,What,Deadline)[artifact_id(ArtId),norm(_,Un)]: .my_name(Ag)
   <- .print(" ---> working to achieve ",What);
      !What;
      .print(" <--- done");
      .

+oblUnfulfilled(O) <- .print("Unfulfilled ",O).
+sanction(NormId,Event,Sanction) <- .print("Sanction ",Sanction," created for norm ", NormId, " that is ",Event).


{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
{ include("$moise/asl/org-obedient.asl") }
