!start.

+!start
    <- //debug(inspector_gui(on));
        +relation(unit, plant, valve);
       .println("unit agent started") .

+filling_process(L, N)
    <- .println("filling process - liquid: ", L, " quantity: ",  N).

+!filling_process(L, N)
    <- .println("filling process - liquid: ", L, " quantity: ",  N).


+active(obligation(Ag,Norm,What,Deadline)) : .my_name(Ag)
   <- .print(" ---> working to achieve ",What);
      !What;
      .print(" <--- done");
      .

+unfulfilled(O) <- .print("Unfulfilled ",O).

+sanction(Ag,update_image)
   <- .println("**** I am implementing the sanction for ",Ag," ****").

+sanction(Ag,Sanction)[norm(NormId,Event)]
   <- .print("Sanction ",Sanction," for ",Ag," created from norm ", NormId, " that is ",Event).


{ include("$jacamo/templates/common-cartago.asl") }

//{ include("$jacamo/templates/common-moise.asl") }
//{ include("$moise/asl/org-obedient.asl") }
