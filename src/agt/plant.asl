!start.

+!start : true
    <- .println("plant agent started") .

+order(L, N)
    <- .println("received order: ", L, " quantity: ", N);
       .send(unit, tell, order(L, N));
       .println("send order to unit agent").


+unfulfilled(O) <- .print("Unfulfilled ",O).

+sanction(Ag,remove_from_systems)
   <- .println("**** I am implementing the sanction for ",Ag," ****").

+sanction(Ag,Sanction)[norm(NormId,Event)]
   <- .print("Sanction ",Sanction," for ",Ag," created from norm ", NormId, " that is ",Event).
