!start.

+!start : true
    <- makeArtifact(nb1,"ora4mas.nopl.NormativeBoard",[],AId);
       focus(AId);
       debug(inspector_gui(on));
       load("src/org/myjoghurt.npl");


       addFact(relation(unit, plant, valve));
       addFact(order(unit, "yogurt", 20));

       makeArtifact(ps1,"police.Sanctioner",[],SArt);
       listen(AId)[artifact_id(SArt)]; // ps1 get normative events (including sanctions) from nb1
       .wait(1000);

       removeFact(order(unit, "yogurt", 20));
       .

+oblUnfulfilled(O) <- .print("Unfulfilled ",O).
+sanction(NormId,Event,Sanction) <- .print("Sanction ",Sanction," created for norm ", NormId, " that is ",Event).


{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moise/asl/org-obedient.asl") }
