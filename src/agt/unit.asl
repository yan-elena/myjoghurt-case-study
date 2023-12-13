!start.

+!start
    <- addFact(relation(unit, plant, valve));
       .println("unit agent started") .

+!filling_process(L, N, P_AG, V_AG)
    <- .my_name(U);
       .println("start filling process...");
       addFact(filling_process(L, N, P_AG, V_AG));
       addFact(filled(L, 0)).

// obligation to achieve a goal
+obligation(Ag,Norm,What,Deadline)[artifact_id(ArtId),norm(_,Un)]: .my_name(Ag)
   <- .print(" ---> working to achieve ",What);
      !What;
      .print(" <--- done");
      .

+sanction(NormId,Event,Sanction) <- .print("Sanction ",Sanction," created for norm ", NormId, " that is ",Event).
    
{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
{ include("$moise/asl/org-obedient.asl") }