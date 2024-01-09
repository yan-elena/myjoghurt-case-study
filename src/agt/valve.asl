!start.

+!start : true
    <-  .println("valve agent started");
        +flow_rate(2000).

+!fill(L, N)
    <-  .println("open valve");
        .println("fill ", L, "...");
        ?flow_rate(R);
        .wait(R);
        .println("close valve");
        +fill(L, N).

+active(obligation(Ag,Norm,What,Deadline)) : .my_name(Ag)
   <-   .print("obliged to ",obligation(Ag,Norm,What,Deadline));
        !What.

+fulfilled(obligation(_,_,fill(L,N),_))
   <-   .print("fulfilled obligation - bottle n: ", N, " filled with ", L);
        .send(unit, tell, filled(L,N)).

+unfulfilled(O)
   <-   .print("Unfulfilled ",O).

+sanction(Ag,update_image)
   <- .println("**** I am implementing the sanction for ",Ag," ****").

+sanction(Ag,Sanction)[norm(NormId,Event)]
   <- .print("Sanction ",Sanction," for ",Ag," created from norm ", NormId, " that is ",Event).
