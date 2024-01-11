flow_rate(20).

!start.

+!start : true
    <-  ?flow_rate(R);
        +estimation(R*100);
        .println("valve agent started").

+!fill(L, N)
    <-  .println("...open valve");
        .println("...fill ", L);
        ?estimation(E);
        .wait(E);
        .println("...close valve");
        +fill(L, N).

+active(obligation(Ag,Norm,What,Deadline)) : .my_name(Ag)
   <-   .print("obliged to ",obligation(Ag,Norm,What,Deadline));
        !What.

+fulfilled(obligation(_,_,fill(L,N),_))
   <-   .random(R);
        A = 190 + (R * 100);    // measure the amount of liquid filled (simulated with a random number)
        .print("fulfilled obligation - bottle n: ", N, " filled with ", L, " amount: ", A);
        .send(unit, tell, filled(L, N, A)).

+unfulfilled(O)
   <-   .print("Unfulfilled ",O).

+sanction(Ag,update_image)
   <- .println("**** I am implementing the sanction for ",Ag," ****").

+sanction(Ag,Sanction)[norm(NormId,Event)]
   <- .print("Sanction ",Sanction," for ",Ag," created from norm ", NormId, " that is ",Event).
