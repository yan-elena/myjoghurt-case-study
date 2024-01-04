+relation(unit, plant, valve).

!start.

+!start : true
    <- .println("valve agent started") .

+order(L, N)
    <- +filled(L, 0).

+!fill_bottle(L)
    <-  ?filled(L, N2);
        .println("fill bottle of ", L, " n.  ", N2 + 1);
        -+filled(L, N2 + 1).
//        +fill_bottle(L).

+active(obligation(Ag,Norm,What,Deadline)) : .my_name(Ag)
   <- .print("obliged to ",What);
      !What.
      //+What.

+fulfilled(O) <- .print("Fulfilled ",O).

+unfulfilled(O) <- .print("Unfulfilled ",O).

+sanction(Ag,remove_from_systems)
   <- .println("**** I am implementing the sanction for ",Ag," ****").

+sanction(Ag,Sanction)[norm(NormId,Event)]
   <- .print("Sanction ",Sanction," for ",Ag," created from norm ", NormId, " that is ",Event).
