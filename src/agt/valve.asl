flow_rate(20).

!start.

+!start : true
    <-  ?flow_rate(R);
        +estimation(180);
        .println("valve agent started").

+!fill(L, N)
    <-  .println("...open valve");
        .println("...fill ", L);
        ?estimation(E);
        .wait(E);
        .println("...close valve");

        .random(R);
        A = E + (R * 20);    // measure the amount of liquid filled (simulated with a random number)
        .send(unit, tell, filled(L, N, A))
        .

+active(obligation(Ag,Norm,What,Deadline)) : .my_name(Ag)
   <-   .print("obliged to ",obligation(Ag,Norm,What,Deadline));
        !What.

+fulfilled(obligation(_,_,fill(L,N),_))
   <-   .print("fulfilled obligation - bottle n: ", N, " filled with ", L).

+unfulfilled(O)
   <-   .print("Unfulfilled ",O).

+sanction(Ag,adjust_flow_rate(L, N, M))
   <-   .println("**** I am implementing the sanction adjust_flow_rate for ",Ag," ****");
        ?estimation(E);
        -+estimation(E + M);
        .println("new estimation: ", E + M);
        .send(unit, signal, finished_adjust(L, N, M)).

+sanction(Ag,Sanction)[norm(NormId,Event)]
   <- .print("**** I am implementing the sanction ",Sanction," for ",Ag).
