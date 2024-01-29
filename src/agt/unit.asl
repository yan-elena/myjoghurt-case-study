unfulfilled_count(0).
deviation_factor(0, "positive", 0).  // deviation factor with the id number, polarity and magnitude
learning_factor(0, 1, 0, 1, 0).    // learning factor with the id number, image, frequency, efficacy and adjustment count
threshold(0.8, 3).                 // image and adjustment count threshold

!start.

+!start
    <-  ?threshold(IT, AT);
        .println("image threshold: ", IT, " adjustment count threshold: ", AT);
        .println("unit agent started") .

+!fill(L, N, MN, MX)
    <-  .println("call valve operation to fill the bottle ", N);
        openValveAndFill(N).

+level(N, L): fill_bottle(LQ, X, MN, MX) & .my_name(Ag)
    <-  .println("bottle no. ", X, " filled, level ", L);
        +fill(LQ, X, MN, MX);                                   //fulfilled obligation
        .send(plant, tell, completed_bottle(Ag, LQ, L, X)).     //notify plant agent of completing bottle

// positive sanction, within the range
+!update_factors(X, L) : fill_bottle(LQ, X, MN, MX) &  L>=MN & L<=MX
    <-  .println("**** bottle ", X, ": update POSITIVE factors");

        ?learning_factor(X-1, I, _, E, _);
        ?unfulfilled_count(C);
        -+learning_factor(X, I+0.1, C/X, E, 0);    //update the learning factor
        -+deviation_factor(X, "positive", 0);      //update the deviation factor

        .println("update deviation factor: positive, 0");
        .println("update learning factor, image: ", I+0.1, ", frequency: ", C/X, " efficacy: ", E, " adjustment count: ", 0);

        +update_factors(X, L).                  //fulfilled obligation

// negative sanction, less than the range
+!update_factors(X, L) : fill_bottle(LQ, X, MN, MX) & L<MN
    <-  .println("**** bottle ", X, ": update NEGATIVE factors: filled level less than the range ****");
        !update_negative_factors(LQ, X, L, MN - L).

// negative sanction, more than the range
+!update_factors(X, L) : fill_bottle(LQ, X, MN, MX) & L>MX
    <-  .println("**** bottle ", X, ": update NEGATIVE factors: filled level more than the range ****");
        !update_negative_factors(LQ, X, L, MX - L).

+!update_negative_factors(LQ, X, L, M)       // liquid, number, level, magnitude
    <-  ?unfulfilled_count(C);
        -+unfulfilled_count(C+1);

        -+deviation_factor(X, "negative", M);
        ?learning_factor(X-1, I, _, E, A);
        -+learning_factor(X, I-0.1, (C+1)/(X+1), E, A);

        .println("update deviation factor: negative, ", M);
        .println("update learning factor, image: ", I-0.1, ", frequency: ", (C+1)/(X+1), " efficacy: ", E, " adjustment count: ", A);

        +update_factors(X, L).

// SANCTIONS

// self cleaning sanction
+sanction(Ag, self_cleaning(X)) : .my_name(Ag)
    <-  .println("**** SANCTION S2: activate valve's cleaning routing");
        selfCleaning;
        ?learning_factor(X, I, F, E, _);
        -+learning_factor(X, I, F, E, 0);     //reset the adjustment count
        .println("finish cleaning").

// adjust flow rate sanction
+sanction(Ag, adjust_flow_rate(X)) : .my_name(Ag)
    <-  .println("**** SANCTION S1: adjust valve's flow rate estimation");
        ?deviation_factor(X, P, M);
        ?learning_factor(X, I, F, E, A);
        -+learning_factor(X, I, F, E, A+1);

        getFlowRateEstimation(R);
        updateEstimation(R + M);

        .println("update flow rate estimation: ", R + M);
        .println("update adjustment count: ", A+1).

+active(obligation(Ag,Norm,What,Deadline)) : .my_name(Ag)
   <- .print("obliged to ", What);
      !What.

+fulfilled(O) <- .print("Fulfilled ",O).

+unfulfilled(O) <- .print("Unfulfilled ",O).

+sanction(Ag,Sanction)[norm(NormId,Event)]
   <- .print("Sanction ",Sanction," for ",Ag," created from norm ", NormId, " that is ",Event).

{ include("$jacamoJar/templates/common-cartago.asl") }