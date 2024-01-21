image_threshold(0.3).
factors(unit, true, 1, 1).     //factors of the unit agent with its active/removed state, image and likelihood
reduce_times(0).

!start.

+!start : true
    <- .println("plant agent started") .

+!order(L, N)
    <-  .println("received order: ", L, " quantity: ", N);
        .println("decide which unit agent to assign the order...");
        ?factors(U, true, _, _);

        +order_status(U, L, N, 0).

+!fill_bottle(U, L, N, C)
    <-  .send(U, tell, fill_bottle(L, C));
        .println("send order to ", U, " agent").

-!order(L, N)
    <- .println("no unit agent available to handle the order").


+filling_range(MN, MX)
    <-  .println("received filling range: min  ", MN, " max: ", MX);
        .send(unit, tell, filling_range(MN, MX));
        .

+completed_bottle(U, L, C) : order_status(U, L, N, _)
    <-  .println("bottle ", C, " from ", U, " completed");
        -+order_status(U, L, N, C);
        +fill_bottle(U, L, N, C);
        .



// update factors sanction

// positive sanction, within the range
+sanction(Ag,update_factors(U, "positive")) : .my_name(Ag)
    <-  .println("**** positive sanction update_factors for ",Ag," ****");

        ?factors(U, S, I, L);
        -+factors(U, S, I + 0.2, L);
        -+reduce_times(0);

        .println("update unit image: ", I + 0.2);
        .


// negative sanction, less than the range
+sanction(Ag,update_factors(U, "negative")) : .my_name(Ag)
    <-  .println("**** negative sanction update_factors for ",U,"****");

        ?factors(U, S, I, L);
        -+factors(U, S, I - 0.2, L);

        .println("update unit image: ", I - 0.2);

        ?order_status(U, LQ, N, C);
        +completed_bottle(U, LQ, C + 1);
        .


// self cleaning sanction

+sanction(Ag, reduce_likelihood(U)) : .my_name(Ag)
    <-  .println("**** sanction: reduce unit's likelihood");
        ?factors(U, S, I, L);
        -+factors(U, S, I, L - 0.2);
        ?reduce_times(T);
        -+reduce_times(T+1);

        .println("likelihood: ",  L - 0.2, " reduce times: ", T+1);
        .

        //!completed_bottle.

// remove unit sanction

+sanction(Ag, remove_unit(U)) : .my_name(Ag)
    <-  .println("**** sanction: remove unit");
        ?factors(U, _, I, L);
        -+factors(U, false, I, L);

        .println("ALARM: unit agent removed ");
        .


+active(obligation(Ag,Norm,What,Deadline)) : .my_name(Ag)
    <-  .println("----------------------");
        .print("obliged to ",obligation(Ag,Norm,What,Deadline));
        !What.

+fulfilled(O) <- .print("Fulfilled ",O).

+unfulfilled(O) <- .print("Unfulfilled ",O).

+sanction(Ag,Sanction)[norm(NormId,Event)]
   <- .print("Sanction ",Sanction," for ",Ag," created from norm ", NormId, " that is ",Event).

{ include("$jacamoJar/templates/common-cartago.asl") }