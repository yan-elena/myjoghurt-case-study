relation(unit, container, valve).
tolerance_range(20, 22).

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

        +filled(L, 0, 0);

        .

+!start_filling(V, L, N1) : fill(L, N2) & N2 < N1
    <-  .send(V, tell, fill_bottle(L, N2 + 1));
        .println("send message to valve agent to fill the bottle ", N2 + 1);
        -+fill(L, N2 + 1);
        !start_filling(V, L, N1).


+!start_filling(V, L, N) : fill(L, N)
    <-  .println("start filling process").

// notification of filled bottle
+filled(L,N1,Q) : order(L, N2) & N1 < N2
    <-  ?relation(U, C, V);

        //notify to container agent
        .send(C, tell, filled(Q));

        //fill next bottle
        .send(V, tell, fill_bottle(L, N1 + 1));
        .println("send message to valve agent to fill the bottle ", N1 + 1).

+filled(L,N,Q) : order(L, N)
    <-  +filling_process(L, N);
        .println("completing filling process").

+active(obligation(Ag,Norm,What,Deadline)) : .my_name(Ag)
   <- .print("obliged to ",obligation(Ag,Norm,What,Deadline));
      !What.

+fulfilled(O) <- .print("Fulfilled ",O).

+unfulfilled(O) <- .print("Unfulfilled ",O).

+sanction(Ag,update_image)
   <- .println("**** I am implementing the sanction for ",Ag," ****").

+sanction(Ag,Sanction)[norm(NormId,Event)]
   <- .print("Sanction ",Sanction," for ",Ag," created from norm ", NormId, " that is ",Event).
