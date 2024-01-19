unful_count(0).
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
    <-  .println("call valve operation to fill the bottle ", N);
        openValveAndFill.

+level(L) : filling_range(MIN, MAX) & L>=MIN & L<=MAX
    <- .println("observed level: ", L, " -> in the range");
        ?completed(LQ, D);
        +fill_bottle(LQ, D + 1);
        -+completed(LQ, D + 1);.

// positive sanction, within the range
+sanction(Ag,update_factors) : fulfilled(O)
    <-  .println("**** I am implementing the sanction update_factors for ",Ag," ****");
        ?completed(L, D);
        -+adjust_times(0);                      //reset the count

        ?learning_factor(I, _, E);
        ?unful_count(C);
        -+learning_factor(I+0.2, C/D, E);       //update the learning factor
        -+deviation_factor("positive", 0);      //update the deviation factor
        .println("update deviation factor: positive, 0");
        .println("update learning factor, image: ", I+0.2, ", frequency: ", C/N, " efficacy: ", E).


// negative sanction, less of the range
+sanction(Ag,update_factors) : unfulfilled(O) & level(L) & filling_range(MIN, MAX) & L<MIN
    <-  .println("**** I am implementing the sanction update_factors for ",Ag," ****");
        !update_negative_factors(MIN - L).

// negative sanction, more of the range
+sanction(Ag,update_factors) : unfulfilled(O) & level(L) & filling_range(MIN, MAX) & L>MAX
    <-  .println("**** I am implementing the sanction update_factors for ",Ag," ****");
        !update_negative_factors(MAX - L).

+!update_negative_factors(M)       // magnitude
    <-  ?unful_count(C);
        -+unful_count(C+1);

        ?adjust_times(T);
        -+adjust_times(T+1);

        ?completed(_, D);
        ?deviation_factor(P, _);
        -+deviation_factor("negative", M);
        ?learning_factor(I, _, E);
        -+learning_factor(I-0.2, (C+1)/D, E);

        .println("M: ", C, " D: ", D);
        .println("update deviation factor: negative, ", M);
        .println("update learning factor, image: ", I-0.2, ", frequency: ", (C+1)/D, " efficacy: ", E).











/*

+order(L, N)
    <-  .println("start filling process - liquid: ", L, " quantity: ",  N);

        getFlowRateEstimation(R);
        .println("asked for the estimated flow rate from valve: ", R);

        .send(container, askOne, filling_status(L, A), S);
        .println("asked for the filling status from the container: ", S);

        !next_bottle(L, 0);

        .

+!next_bottle(L, N)
    <-  
        .println("call valve operation to fill the bottle ", N + 1);
        openValveAndFill;
        +filling_bottle(L, N).





+!start_filling(V, L, N1) : fill(L, N2) & N2 < N1
    <-  .send(V, tell, fill_bottle(L, N2 + 1));
        .println("send message to valve agent to fill the bottle ", N2 + 1);
        -+fill(L, N2 + 1);
        !start_filling(V, L, N1).


+!start_filling(V, L, N) : fill(L, N)
    <-  .println("start filling process").

// notification of filled bottle
+filled(L,N1,A) : order(L, N2) & N1 < N2
    <-  

        //notify to container agent
        .send(container, tell, filled(A));

        //check the amount
        .println("check the amount of the liquid: ", A);
        !check_amount(L, N1, A).

+filled(L,N,A) : order(L, N)
    <-  +filling_process(L, N);
        .println("completing filling process");
        
        .send(V, tell, fill(L,N)).

// Evaluator capability

// within the range
+!check_amount(L,N,A) : filling_range(MIN, MAX) & A>MIN & A<MAX
    <-  ?relation(_, _, V);
        .println("amount ok");
        .send(V, tell, fill(L,N));
        -+adjust_times(0);              //reset the count

        ?learning_factor(I, _, E);      //update the factors
        ?unful_count(C);
        -+learning_factor(I+0.2, C/N, E);
        -+deviation_factor("positive", 0);

        !next_bottle(L, N).

// outside the range
+!check_amount(L,N,A) : filling_range(MIN, MAX) & A<MIN
    <-  !update_factors(N, A, MIN - A);
        !check_sanctions(L, N).

// outside the range
+!check_amount(L,N,A) : filling_range(MIN, MAX) & A>MAX
    <-  !update_factors(N, A, MAX - A);
        !check_sanctions(L, N).


+!update_factors(N, A, M)       // number, amount, magnitude
    <-  ?unful_count(C);
        -+unful_count(C+1);

        ?adjust_times(T);
        -+adjust_times(T+1);

        ?deviation_factor(P, _);
        -+deviation_factor("negative", M);
        ?learning_factor(I, _, E);
        -+learning_factor(I-0.2, (C+1)/N, E);

        .println("update deviation factor: negative, ", M);
        .println("update learning factor, image: ", I-0.2, ", frequency: ", (C+1)/N, " efficacy: ", E).



// Executor capability

// activates the valve’s self cleaning routing, if the problem persists for two consecutive times
+!check_sanctions(_, _) : adjust_times(T) & T > 3
    <-  .println("activate sanction self_cleaning: ");
        ?relation(_, _, V);
        .send(V, tell, self_cleaning).

// adjusts the estimated flow rate, if the image is below a threshold
+!check_sanctions(_, _) : learning_factor(I, _, _) & threshold(T) & I < T
                         & adjust_times(T2) & T2 < 3
    <-  .println("activate sanction adjust: ");
        

        ?deviation_factor(P, M);
        .send(V, tell, adjust(M)).

+!check_sanctions(L, N)
    <-  .println("no sanctions");
        ?relation(_, _, V);
        .send(V, tell, fill(L,N));
        !next_bottle(L, N).


+finished_adjust(L, N, M)
    <-  .println("estimation adjusted, next bottle");
        .send(valve, untell, adjust(M));
        !next_bottle(L, N).


*/


+active(obligation(Ag,Norm,What,Deadline)) : .my_name(Ag)
   <- .print("obliged to ",obligation(Ag,Norm,What,Deadline));
      !What.

+fulfilled(O) <- .print("Fulfilled ",O).

+unfulfilled(O) <- .print("Unfulfilled ",O).

+sanction(Ag,update_image)
   <- .println("**** I am implementing the sanction for ",Ag," ****").

+sanction(Ag,Sanction)[norm(NormId,Event)]
   <- .print("Sanction ",Sanction," for ",Ag," created from norm ", NormId, " that is ",Event).


{ include("$jacamoJar/templates/common-cartago.asl") }