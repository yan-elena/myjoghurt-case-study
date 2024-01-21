image_threshold(0.3).
factors(unit, true, 1).     //factors of the unit agent with its active/removed state and its image

!start.

+!start : true
    <- .println("plant agent started") .

+!order(L, N)
    <-  .println("received order: ", L, " quantity: ", N);
        .println("decide which unit agent to assign the order...");
        ?factors(U, true, _);
        
        +order_status(U, L, N, 0);
        
        .send(U, tell, fill_bottle(L, N));      //todo activate norm n1 to unit agent
        .println("send order to ", U, " agent").

-!order(L, N)
    <- .println("no unit agent available to handle the order").

+level(L) : filling_range(MIN, MAX) & L>=MIN & L<=MAX
    <- .println("observed level: ", L, " -> in the range, obligation fulfilled");
        ?order_status(U, LQ, N, D);
        +fill_bottle(LQ, D + 1);
        !completed_bottle.

+!completed_bottle
    <-  ?order_status(L, D);
        .println("bottle ", D+1, " completed");
        -+order_status(L, D + 1).

+filling_range(MN, MX)
    <-  .println("received filling range: min  ", MN, " max: ", MX);
        .send(unit, tell, filling_range(MN, MX));
        .

// update factors sanction

// positive sanction, within the range
+sanction(Ag,update_factors) : fulfilled(O) & .my_name(Ag)
    <-  .println("**** positive sanction update_factors for ",Ag," ****");

        ?factors(unit, true, 1).

        .println("update deviation factor: positive, 0");
        .println("update learning factor, image: ", I+0.2, ", frequency: ", C/D, " efficacy: ", E);

        !completed_bottle.


// negative sanction, less than the range
+sanction(Ag,update_factors) : unfulfilled(O) & level(L) & filling_range(MIN, MAX) & L<MIN & .my_name(Ag)
    <-  .println("**** negative sanction update_factors for ",Ag,", filled level less than the range ****");
        !update_negative_factors(MIN - L);

        ?learning_factor(I, _, _);
        ?threshold(T);
        .println("I: ", I, " T: ", T);
        if (I >= T) {
            !completed_bottle;
            .println("no other sanctions, completed bottle");
        }.

// negative sanction, more than the range
+sanction(Ag,update_factors) : unfulfilled(O) & level(L) & filling_range(MIN, MAX) & L>MAX & .my_name(Ag)
    <-  .println("**** negative sanction update_factors for ",Ag,", filled level more than the range ****");
        !update_negative_factors(MAX - L);

        ?learning_factor(I, _, _);
        ?threshold(T);
        .println("I: ", I, " T: ", T);
        if (I >= T) {
            !completed_bottle;
            .println("no other sanctions, completed bottle");
        }.



// self cleaning sanction

+sanction(Ag, self_cleaning) : .my_name(Ag)
    <-  .println("**** sanction: activate valve's self cleaning routing");
        selfCleaning;
        .println("finish cleaning");

        !completed_bottle.

// adjust flow rate sanction

+sanction(Ag, adjust_flow_rate) : .my_name(Ag)
    <-  .println("**** sanction: adjust valve's flow rate estimation");
        ?deviation_factor(P, M);
        getFlowRateEstimation(E);
        updateEstimation(E + M);

        ?adjust_times(T);
        -+adjust_times(T+1);
        .println("number of consecutive adjustments executed: ", T+1);
        !completed_bottle.

+!update_negative_factors(M)       // magnitude
    <-  ?unfulfilled_count(C);
        -+unfulfilled_count(C+1);

        ?order_status(U, _, D);
        ?deviation_factor(P, _);
        -+deviation_factor("negative", M);
        ?learning_factor(I, _, E);
        -+learning_factor(I-0.2, (C+1)/(D+1), E);

        .println("update deviation factor: negative, ", M);
        .println("update learning factor, image: ", I-0.2, ", frequency: ", (C+1)/(D+1), " efficacy: ", E).


+unfulfilled(O)
    <-  .print("Unfulfilled ",O).

+sanction(Ag,remove_from_systems)
   <-   .println("**** I am implementing the sanction for ",Ag," ****").

+sanction(Ag,Sanction)[norm(NormId,Event)]
   <-   .print("Sanction ",Sanction," for ",Ag," created from norm ", NormId, " that is ",Event).


{ include("$jacamoJar/templates/common-cartago.asl") }