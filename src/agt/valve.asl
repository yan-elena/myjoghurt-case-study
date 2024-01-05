!start.

+!start : true
    <-  .println("valve agent started") ;
        +flow_rate(5).

+!fill(L, N)
    <-  .println("fill bottle of ", L).

+active(obligation(Ag,Norm,What,Deadline)) : .my_name(Ag)
   <- .print("obliged to ",obligation(Ag,Norm,What,Deadline));
      !What;
      +What.

+fulfilled(O) <- .print("Fulfilled ",O).

+unfulfilled(O) <- .print("Unfulfilled ",O).

+sanction(Ag,remove_from_systems)
   <- .println("**** I am implementing the sanction for ",Ag," ****").

+sanction(Ag,Sanction)[norm(NormId,Event)]
   <- .print("Sanction ",Sanction," for ",Ag," created from norm ", NormId, " that is ",Event).
