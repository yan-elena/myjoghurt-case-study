threshold(0.7, 5).                      // image and reduction count threshold
factors(unit, 0, true, true, 1, 1, 0).  // factors(unit, active, available, image, likelihood, count_reduce_times)
!start.

+!start
    <-  ?threshold(I, R);
        .println("image threshold: ", I, " reduction count threshold: ", R);
        .println("plant agent started") .

+!order(LQ, N, MN, MX)
    <-  .println("handle order: ", LQ, " quantity: ", N);
        .println("decide which unit agent to assign the order...");

        ?factors(U, _, true, true, I, L, T);      //select an active and available unit agent

        .println("selected agent to handle the order: ", U);

        -+factors(U, 0, true, false, I, L, 0);    //update unit availability
        +order_status(U, LQ, N, 0, MN, MX). //start the filling process

-!order(LQ, N, MN, MX)
    <-  .println("no unit agent available to handle the order");
        .wait(5000);
        .println("try again to assign the order...");
        !order(LQ, N, MN, MX).

+!fill_bottle(U, LQ, N, X, MN, MX)
    <-  .println("--------- fill bottle ", X, " ------");
        .send(U, tell, fill_bottle(LQ, X, MN, MX));  //tell the unit agent to fill the bottle X with liquid LQ in the range MN-MX
        .println("send order to ", U, " agent to fill the bottle ", X).

+completed_bottle(U, LQ, L, X) : order_status(U, LQ, N, X-1, MN, MX)   //unit agent has completed the bottle
    <-  +fill_bottle(U, LQ, N, X, MN, MX).     //fulfilled obligation


// update unit's factors, positive
+!update_factors(U, X, L) : fill_bottle(U, LQ, N, X, MN, MX) &  L>=MN & L<=MX
    <-  .println("**** update positive factors for ",U," ****");

        ?factors(U, X-1, S, A, I, K, T);
        -+factors(U, X, S, A, I + 0.05, K, 0);           //update unit images

        .println("update unit image: ", I + 0.05);

        +update_factors(U, X, L).                       //fulfilled obligation


// update unit's factors, negative
+!update_factors(U, X, L) : fill_bottle(U, LQ, N, X, MN, MX)
    <-  .println("**** update negative factors for ",U,"****");

        ?factors(U, X-1, S, A, I, K, T);
        -+factors(U, X, S, A, I - 0.05, K, T);           //update unit factors

        .println("update unit image: ", I - 0.05);

        +update_factors(U, X, L).                       //fulfilled obligation


+sanction(Ag, fill_next_bottle(U, LQ, L, X))
    <-  ?order_status(U, LQ, N, _, MN, MX);
        -+order_status(U, LQ, N, X, MN, MX).            // update order status, fill next bottle


// reduce likelihood sanction

+sanction(Ag, reduce_likelihood(U)) : .my_name(Ag)
    <-  .println("**** SANCTION S3: reduce unit's likelihood");
        ?factors(U, X, S, A, I, L, T);
        -+factors(U, X, S, A, I, L-0.05, T+1);

        .println("likelihood: ",  L-0.05, " reduce times: ", T+1);

        ?order_status(U, LQ, N, C, MN, MX);
        -+order_status(U, LQ, N, C + 1, MN, MX).        //update the order status

// remove unit sanction

+sanction(Ag, remove_unit(U)) : .my_name(Ag)
    <-  .println("**** SANCTION S4: remove unit");
        ?factors(U, X, _, A, I, L, T);
        -+factors(U, X, false, A, I, L, T);

        .println("ALARM: unit agent removed ");

        ?order_status(U, LQ, N, C, MN, MX);
        !order(LQ, N-C, MN, MX).


+active(obligation(Ag,Norm,What,Deadline)) : .my_name(Ag)
    <-  .print("obliged to ", What);
        !What.

+fulfilled(O) <- .print("Fulfilled ",O).

+unfulfilled(O) <- .print("Unfulfilled ",O).

+sanction(Ag,Sanction)[norm(NormId,Event)]
   <- .print("Sanction ",Sanction," for ",Ag," created from norm ", NormId, " that is ",Event).

{ include("$jacamoJar/templates/common-cartago.asl") }