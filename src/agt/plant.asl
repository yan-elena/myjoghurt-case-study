image_threshold(0.3).
                                    // factors(unit, active, available, image, likelihood, count_reduce_times)
factors(unit, true, true, 1, 1, 0).    //factors of the unit agent with its active/removed state, image and likelihood

!start.

+!start
    <-  ?image_threshold(T);
        .println("image threshold: ", T);
        .println("plant agent started") .

+!order(LQ, N, MN, MX)
    <-  .println("received order: ", LQ, " quantity: ", N);
        .println("decide which unit agent to assign the order...");

        ?factors(U, true, true, I, L, T);      //select an active and available unit agent

        .println("selected agent to handle the order: ", U);

        -+factors(U, true, false, I, L, 0);    //update unit availability
        +order_status(U, LQ, N, 0, MN, MX). //start the filling process

-!order(LQ, N, MN, MX)
    <-  .println("no unit agent available to handle the order");
        .wait(1000);
        .println("try again to send the order...");
        !order(LQ, N, MN, MX).

+!fill_bottle(U, LQ, N, X, MN, MX)
    <-  .send(U, tell, fill_bottle(LQ, X, MN, MX));  //tell the unit agent to fill the bottle X with liquid LQ in the range MN-MX
        .println("send order to ", U, " agent to fill the bottle ", X).

+completed_bottle(U, LQ, L, X) : order_status(U, LQ, N, X-1, MN, MX)   //unit agent has completed the bottle
    <-  +fill_bottle(U, LQ, N, X, MN, MX).     //fulfilled obligation


// update unit's factors, positive
+!update_factors(U, X, L) : fill_bottle(U, LQ, N, X, MN, MX) &  L>=MN & L<=MX
    <-  .println("**** S0 - update_factors for ",U," ****");

        ?factors(U, S, A, I, K, T);
        -+factors(U, S, A, I + 0.2, K, T);             //update unit images

        .println("update unit image: ", I + 0.2);

        +update_factors(U, X, L).                       //fulfilled obligation


// update unit's factors, negative
+!update_factors(U, X, L) : fill_bottle(U, LQ, N, X, MN, MX)
    <-  .println("**** S0 - update_factors for ",U,"****");

        ?factors(U, S, A, I, K, T);
        -+factors(U, S, A, I - 0.2, K, T);                 //update unit factors

        .println("update unit image: ", I - 0.2);

        +update_factors(U, X, L).                       //fulfilled obligation


+sanction(Ag, fill_next_bottle(U, LQ, L, X))
    <-  .println("--------- bottle ", X, " completed ------");
        ?order_status(U, LQ, N, _, MN, MX);
        -+order_status(U, LQ, N, X, MN, MX).            // update order status, fill next bottle


// reduce likelihood sanction

+sanction(Ag, reduce_likelihood(U)) : .my_name(Ag)
    <-  .println("**** SANCTION S3: reduce unit's likelihood");
        ?factors(U, S, A, I, L, T);
        -+factors(U, S, A, I, L-0.2, T+1);

        .println("likelihood: ",  L-0.2, " reduce times: ", T+1);

        .println("--------- bottle ", X, " completed ---------");
        ?order_status(U, LQ, N, C, MN, MX);
        -+order_status(U, LQ, N, C + 1, MN, MX).        //update the order status

// remove unit sanction

+sanction(Ag, remove_unit(U)) : .my_name(Ag)
    <-  .println("**** SANCTION S4: remove unit");
        ?factors(U, _, A, I, L, T);
        -+factors(U, false, A, I, L, T);

        .println("ALARM: unit agent removed ").


+active(obligation(Ag,Norm,What,Deadline)) : .my_name(Ag)
    <-  .print("obliged to ", What);
        !What.

+fulfilled(O) <- .print("Fulfilled ",O).

+unfulfilled(O) <- .print("Unfulfilled ",O).

+sanction(Ag,Sanction)[norm(NormId,Event)]
   <- .print("Sanction ",Sanction," for ",Ag," created from norm ", NormId, " that is ",Event).

{ include("$jacamoJar/templates/common-cartago.asl") }