unfulfilled_count(0).
deviation_factor(positive, 0). // deviation factor with polarity and magnitude
learning_factor(1, 0, 1). // learning factor with the image, frequency and efficacy
threshold(0.7).
adjust_times(0).
filling(0).

!start.

+!start
    <-  ?threshold(T);
        .println("image threshold: ", T);
        .println("unit agent started") .

+!fill(L, N, MN, MX)
    <-  .println("call valve operation to fill the bottle ", N);
        openValveAndFill(N).


+level(N, L): fill_bottle(LQ, N, MN, MX) // & L>=MN & L<=MX
    <-  .println("bottle no. ", N, " filled, level ", L);
        +fill(LQ, N, MN, MX).


// update factors sanction

// positive sanction, within the range
+!update_factors(L) : fill_bottle(LQ, N, MN, MX) &  L>=MN & L<=MX
    <-  .println("**** S0 - update factors: positive");
        -+adjust_times(0);                      //reset the count

        ?learning_factor(I, _, E);
        ?unfulfilled_count(C);
        -+learning_factor(I+0.2, C/N, E);       //update the learning factor
        -+deviation_factor("positive", 0);      //update the deviation factor
        .println("update deviation factor: positive, 0");
        .println("update learning factor, image: ", I+0.2, ", frequency: ", C/N, " efficacy: ", E);

        .my_name(Ag);
        .send(plant, tell, completed_bottle(Ag, LQ, L, N));
        .

// negative sanction, less than the range
+!update_factors(L) : fill_bottle(LQ, N, MN, MX) & L<MN
    <-  .println("**** S0 - update_factors: filled level less than the range ****");
        !update_negative_factors(LQ, N, MN - L).

// negative sanction, more than the range
+!update_factors(L) : fill_bottle(LQ, N, MN, MX) & L>MX
    <-  .println("**** S0 - update_factors: filled level more than the range ****");
        !update_negative_factors(LQ, N, MX - L).


// self cleaning sanction

+sanction(Ag, adjust_flow_rate) : .my_name(Ag)
    <-  .println("**** SANCTION S2: activate valve's self cleaning routing");
        selfCleaning;
        .println("finish cleaning");
        ?fill_bottle(LQ, N, _, _);
        ?level(L);
        .send(plant, tell, completed_bottle(Ag, LQ, L, N)).

// adjust flow rate sanction

+sanction(Ag, adjust_flow_rate) : .my_name(Ag)
    <-  .println("**** SANCTION S1: adjust valve's flow rate estimation");
        ?deviation_factor(P, M);
        getFlowRateEstimation(E);
        updateEstimation(E + M);

        ?adjust_times(T);
        -+adjust_times(T+1);
        .println("number of consecutive adjustments executed: ", T+1);
        ?level(L);
        ?fill_bottle(LQ, N, _, _);
        .send(plant, tell, completed_bottle(Ag, LQ, L, N)).

+!update_negative_factors(LQ, N, M)       // magnitude
    <-  ?unfulfilled_count(C);
        -+unfulfilled_count(C+1);

        ?deviation_factor(P, _);
        -+deviation_factor("negative", M);
        ?learning_factor(I, _, E);
        -+learning_factor(I-0.2, (C+1)/(N+1), E);

        .println("update deviation factor: negative, ", M);
        .println("update learning factor, image: ", I-0.2, ", frequency: ", (C+1)/(N+1), " efficacy: ", E);

        if (threshold(T) & I-0.2 > T) {
            ?level(L);
            .my_name(Ag);
            .send(plant, tell, completed_bottle(Ag, LQ, L, N));
        }.


+active(obligation(Ag,Norm,What,Deadline)) : .my_name(Ag)
   <- .print("obliged to ",obligation(Ag,Norm,What,Deadline));
      !What.

+fulfilled(O) <- .print("Fulfilled ",O).

+unfulfilled(O) <- .print("Unfulfilled ",O).

+sanction(Ag,Sanction)[norm(NormId,Event)]
   <- .print("Sanction ",Sanction," for ",Ag," created from norm ", NormId, " that is ",Event).

{ include("$jacamoJar/templates/common-cartago.asl") }