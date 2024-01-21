!start.

+!start
    <-
       .println("send order to plant agent");
       .send(plant, achieve, order("yogurt", 5));
       .send(plant, tell, filling_range(200, 205));
       .

+level(L)
    <- .println("observed level: ", L).


{ include("$jacamoJar/templates/common-cartago.asl") }