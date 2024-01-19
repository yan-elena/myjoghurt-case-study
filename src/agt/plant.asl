!start.

+!start : true
    <- .println("plant agent started") .

+order(L, N)
    <-  .println("received order: ", L, " quantity: ", N);
        .send(unit, tell, order(L, N));      //activate norm n1 to unit agent
        .println("send order to unit agent").

+level(L)
    <- .println("observed level: ", L).



+filling_range(MN, MX)
    <-  .println("received tolerance range: min  ", MN, " max: ", MX);
        .send(unit, tell, filling_range(MN, MX));
        .

+unfulfilled(O)
    <-  .print("Unfulfilled ",O).

+sanction(Ag,remove_from_systems)
   <-   .println("**** I am implementing the sanction for ",Ag," ****").

+sanction(Ag,Sanction)[norm(NormId,Event)]
   <-   .print("Sanction ",Sanction," for ",Ag," created from norm ", NormId, " that is ",Event).


{ include("$jacamoJar/templates/common-cartago.asl") }