!start.

+!start
    <-  //debug(inspector_gui(on));
        +relation(unit, container, valve);
        .println("unit agent started") .

+!filling_process(L, N)
    <- .println("start filling process - liquid: ", L, " quantity: ",  N);
       //+filling_process(L,N);

       ?relation(U, C, V);

       .send(V, askOne, flow_rate(X), R);
       .println("asked for the estimated flow rate from valve: ", R);
       .send(C, askOne, filling_status(L, N), S);
       .println("asked for the filling status from the container: ", S)
       .

+active(obligation(Ag,Norm,What,Deadline)) : .my_name(Ag)
   <- .print("obliged to ",What);
      !What.
      //+What.

+fulfilled(O) <- .print("Fulfilled ",O).

+unfulfilled(O) <- .print("Unfulfilled ",O).

+sanction(Ag,update_image)
   <- .println("**** I am implementing the sanction for ",Ag," ****").

+sanction(Ag,Sanction)[norm(NormId,Event)]
   <- .print("Sanction ",Sanction," for ",Ag," created from norm ", NormId, " that is ",Event).


{ include("$jacamo/templates/common-cartago.asl") }

//{ include("$jacamo/templates/common-moise.asl") }
//{ include("$moise/asl/org-obedient.asl") }
