!start.

+!start
    <-  +relation(unit, container, valve);
        .println("unit agent started") .

+!filling_process(L, N)
    <-  .println("start filling process - liquid: ", L, " quantity: ",  N);
        -order(L, N);       //remove the belief to avoid create more obligations

        ?relation(U, C, V);
        .send(V, askOne, flow_rate(X), R);
        .println("asked for the estimated flow rate from valve: ", R);
        .send(C, askOne, filling_status(L, N), S);
        .println("asked for the filling status from the container: ", S);

        +filled(L, 0);
        ?relation(U, C, V);
        !start_filling(V, L, N);
        .

+!start_filling(V, L, N1) : filled(L, N2) & N2 < N1
    <-  .send(V, tell, fill_bottle(L, N2 + 1));
        .println("send message to valve agent to fill the bottle ", N2 + 1);
        -+filled(L, N2 + 1);
        !start_filling(V, L, N1).

+!start_filling(V, L, N1) : filled(L, N2) & N2 == N1
    <-  .println("completing filling process").

+active(obligation(Ag,Norm,What,Deadline)) : .my_name(Ag)
   <- .print("obliged to ",obligation(Ag,Norm,What,Deadline));
      !What;
      +What.

+fulfilled(O) <- .print("Fulfilled ",O).

+unfulfilled(O) <- .print("Unfulfilled ",O).

+sanction(Ag,update_image)
   <- .println("**** I am implementing the sanction for ",Ag," ****").

+sanction(Ag,Sanction)[norm(NormId,Event)]
   <- .print("Sanction ",Sanction," for ",Ag," created from norm ", NormId, " that is ",Event).
