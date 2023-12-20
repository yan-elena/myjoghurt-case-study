!start.

+!start : true
    <- .println("valve agent started") .

+!fill_bottle(L, N)
    <-  -filled(L, N - 1);
        +filled(L, N);
        .println("fill bottle ...").


+unfulfilled(O) <- .print("Unfulfilled ",O).

+sanction(Ag,remove_from_systems)
   <- .println("**** I am implementing the sanction for ",Ag," ****").

+sanction(Ag,Sanction)[norm(NormId,Event)]
   <- .print("Sanction ",Sanction," for ",Ag," created from norm ", NormId, " that is ",Event).
