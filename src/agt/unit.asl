unfulfilled_count(0).
deviation_factor(positive, 0). // deviation factor with polarity and magnitude
learning_factor(1, 0, 1). // learning factor with the image, frequency and efficacy
threshold(0.7).
adjust_times(0).

!start.

+!start
    <-  .println("unit agent started") .

+order(L, N)
    <-  +completed(L, 0).

+!fill_bottle(L, N)
    <-  .println("---------------------------------");
        .println("call valve operation to fill the bottle ", N);
        openValveAndFill.

+level(L) : filling_range(MIN, MAX) & L>=MIN & L<=MAX
    <- .println("observed level: ", L, " -> in the range, obligation fulfilled");
        ?completed(LQ, D);
        +fill_bottle(LQ, D + 1);
        !completed_bottle.

+!completed_bottle
    <-  ?completed(L, D);
        .println("bottle ", D+1, " completed");
        -+completed(L, D + 1).

// update factors sanction

// positive sanction, within the range
+sanction(Ag,update_factors) : fulfilled(O) & .my_name(Ag)
    <-  .println("**** positive sanction update_factors for ",Ag," ****");
        ?completed(L, D);
        -+adjust_times(0);                      //reset the count

        ?learning_factor(I, _, E);
        ?unfulfilled_count(C);
        -+learning_factor(I+0.2, C/D, E);       //update the learning factor
        -+deviation_factor("positive", 0);      //update the deviation factor
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

        ?completed(_, D);
        ?deviation_factor(P, _);
        -+deviation_factor("negative", M);
        ?learning_factor(I, _, E);
        -+learning_factor(I-0.2, (C+1)/(D+1), E);

        .println("update deviation factor: negative, ", M);
        .println("update learning factor, image: ", I-0.2, ", frequency: ", (C+1)/(D+1), " efficacy: ", E).


+active(obligation(Ag,Norm,What,Deadline)) : .my_name(Ag)
   <- .print("obliged to ",obligation(Ag,Norm,What,Deadline));
      !What.

+fulfilled(O) <- .print("Fulfilled ",O).

+unfulfilled(O) <- .print("Unfulfilled ",O).

+sanction(Ag,Sanction)[norm(NormId,Event)]
   <- .print("Sanction ",Sanction," for ",Ag," created from norm ", NormId, " that is ",Event).

{ include("$jacamoJar/templates/common-cartago.asl") }