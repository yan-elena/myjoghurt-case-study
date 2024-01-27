image_threshold(0.3).

// factors(unit, active, available, image, likelihood)
factors(unit, true, true, 1, 1).     //factors of the unit agent with its active/removed state, image and likelihood
reduce_times(0).

!start.

+!start : true
    <-  ?image_threshold(T);
        .println("image threshold: ", T);
        .println("plant agent started") .

+!order(LQ, N, MN, MX)
    <-  .println("received order: ", LQ, " quantity: ", N);
        .println("decide which unit agent to assign the order...");
        ?factors(U, true, true, I, L);      //select an active and available unit agent

        .println("selected agent to handle the order: ", U);

        -+factors(U, true, false, I, L);    //update unit availability
        +order_status(U, LQ, N, 0, MN, MX).

+!fill_bottle(U, L, N, C, MN, MX)
    <-  .send(U, tell, fill_bottle(L, C, MN, MX));
        .println("send order to ", U, " agent to fill the bottle ", C).

-!order(LQ, N, MN, MX)
    <-  .println("no unit agent available to handle the order");
        .wait(1000);
        .println("try again to send the order...");
        !order(LQ, N, MN, MX).

/*
+level(L): order_status(U, LQ, N, C, MN, MX) & L > MN & L < MX
    <-  .println("bottle completed");
        +fill_bottle(U, LQ, N, C + 1, MN, MX);  //fulfill obligation
        -+order_status(U, LQ, N, C + 1, MN, MX).
*/

+level(L) : order_status(U, LQ, N, C, MN, MX) & L > MN & L < MX
    <-  +fill_bottle(U, LQ, N, C + 1, MN, MX);  //fulfill obligation
        +completed(LQ, C + 1, N, L).

+level(L) : order_status(U, LQ, N, C, MN, MX)
    <-  +completed(LQ, C + 1, N, L).

// update factors sanction

// positive sanction, within the range
+sanction(Ag,update_factors(U, "positive")) : .my_name(Ag)
    <-  .println("**** positive sanction update_factors for ",Ag," ****");

        ?factors(U, S, A, I, L);
        -+factors(U, S, A, I + 0.2, L);
        -+reduce_times(0);

        .println("update unit image: ", I + 0.2);
        ?order_status(U, LQ, N, C, MN, MX);
        -+order_status(U, LQ, N, C + 1, MN, MX).    //next bottle
        //+completed(LQ, C + 1).


// negative sanction, outside the range
+sanction(Ag,update_factors(U, "negative")) : .my_name(Ag)
    <-  .println("**** S0: negative sanction update_factors for ",U,"****");

        ?factors(U, S, A, I, L);
        -+factors(U, S, A, I - 0.2, L);

        .println("update unit image: ", I - 0.2);

        ?order_status(U, LQ, N, C, MN, MX);
        -+order_status(U, LQ, N, C + 1, MN, MX).    //next bottle
        //+completed(LQ, C + 1). //todo: controllare i casi



// reduce likelihood sanction

+sanction(Ag, reduce_likelihood(U)) : .my_name(Ag)
    <-  .println("**** SANCTION S3: reduce unit's likelihood");
        ?factors(U, S, A, I, L);
        -+factors(U, S, A, I, L - 0.2);
        ?reduce_times(T);
        -+reduce_times(T+1);

        .println("likelihood: ",  L - 0.2, " reduce times: ", T+1);
        ?order_status(U, LQ, N, C, MN, MX);
        -+order_status(U, LQ, N, C + 1, MN, MX).        //next bottle
        //+completed(LQ, C + 1).

// remove unit sanction

+sanction(Ag, remove_unit(U)) : .my_name(Ag)
    <-  .println("**** SANCTION S4: remove unit");
        ?factors(U, _, A, I, L);
        -+factors(U, false, A, I, L);

        .println("ALARM: unit agent removed ").


+active(obligation(Ag,Norm,What,Deadline)) : .my_name(Ag)
    <-  .println("----------------------");
        .print("obliged to ",obligation(Ag,Norm,What,Deadline));
        !What.

+fulfilled(O) <- .print("Fulfilled ",O).

+unfulfilled(O) <- .print("Unfulfilled ",O).

+sanction(Ag,Sanction)[norm(NormId,Event)]
   <- .print("Sanction ",Sanction," for ",Ag," created from norm ", NormId, " that is ",Event).

{ include("$jacamoJar/templates/common-cartago.asl") }