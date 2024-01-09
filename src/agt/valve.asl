!start.

+!start : true
    <-  .println("valve agent started") ;
        +flow_rate(5).

+!fill(L, N)
    <-  .println("fill bottle of ", L);
        +fill(L, N).

+active(obligation(Ag,Norm,What,Deadline)) : .my_name(Ag)
   <-   .print("obliged to ",obligation(Ag,Norm,What,Deadline));
        !What.

+fulfilled(obligation(_,_,fill(L,N),_))
   <-   .send(unit, signal, filled(L,N));
        .print("Fulfilled obligation - bottle filled with liquid: ", L, " n: ", N).

+unfulfilled(O) <- .print("Unfulfilled ",O).

+sanction(Ag,update_image)
   <- .println("**** I am implementing the sanction for ",Ag," ****").

+sanction(Ag,Sanction)[norm(NormId,Event)]
   <- .print("Sanction ",Sanction," for ",Ag," created from norm ", NormId, " that is ",Event).
