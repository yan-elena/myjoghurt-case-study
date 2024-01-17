relation(unit, container, valve).
unful_count(0).

!start.

+!start
    <-  .println("unit agent started") .

+!filling_process(L, N)
    <-  .println("start filling process - liquid: ", L, " quantity: ",  N);

        ?relation(U, C, V);
        .send(V, askOne, flow_rate(X), R);
        .println("asked for the estimated flow rate from valve: ", R);
        .send(C, askOne, filling_status(L, A), S);
        .println("asked for the filling status from the container: ", S);

        !next_bottle(L, 0);

        .

+!start_filling(V, L, N1) : fill(L, N2) & N2 < N1
    <-  .send(V, tell, fill_bottle(L, N2 + 1));
        .println("send message to valve agent to fill the bottle ", N2 + 1);
        -+fill(L, N2 + 1);
        !start_filling(V, L, N1).


+!start_filling(V, L, N) : fill(L, N)
    <-  .println("start filling process").

// notification of filled bottle
+filled(L,N1,A) : order(L, N2) & N1 < N2
    <-  ?relation(U, C, V);

        //notify to container agent
        .send(C, tell, filled(A));

        //check the amount
        .println("check the amount of the liquid: ", A);
        !check_amount(L, N1, A).

+filled(L,N,A) : order(L, N)
    <-  +filling_process(L, N);
        .println("completing filling process");
        ?relation(U, C, V);
        .send(V, tell, fill(L,N)).

+!check_amount(L,N,A) : tolerance_range(MIN, MAX) & A>MIN & A<MAX
    <-  ?relation(U, C, V);
        .println("amount ok");
        .send(V, tell, fill(L,N));
        -+unful_count(0);
        !next_bottle(L, N).

+!check_amount(L,N,A)
    <-  ?unful_count(C);
        -+unful_count(C+1);
        .println("amount ", A, " not good, count: ", C+1);
        !check_sanctions(C+1).

+!check_sanctions(F) : F < 2
    <-  ?relation(U, C, V);
        .send(V, tell, adjust).

+!check_sanctions(F)
    <-  ?relation(U, C, V);
        .send(V, tell, self_cleaning).

+!next_bottle(L, N)
    <-  ?relation(U, C, V);
        .println("send message to valve agent to fill the bottle ", N + 1);
        .send(V, tell, fill_bottle(L, N+1)).

+finished_adjust(L, N)
    <- !next_bottle(L, N).

+active(obligation(Ag,Norm,What,Deadline)) : .my_name(Ag)
   <- .print("obliged to ",obligation(Ag,Norm,What,Deadline));
      !What.

+fulfilled(O) <- .print("Fulfilled ",O).

+unfulfilled(O) <- .print("Unfulfilled ",O).

+sanction(Ag,update_image)
   <- .println("**** I am implementing the sanction for ",Ag," ****").

+sanction(Ag,Sanction)[norm(NormId,Event)]
   <- .print("Sanction ",Sanction," for ",Ag," created from norm ", NormId, " that is ",Event).
