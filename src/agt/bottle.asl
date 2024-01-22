!start.

+!start
    <-
       .println("send order to plant agent");
       .send(plant, achieve, order("yogurt", 10));
       .send(plant, tell, filling_range(200, 205));
       .

+level(L)
    <- .println("observed level: ", L, " mm").


{ include("$jacamoJar/templates/common-cartago.asl") }