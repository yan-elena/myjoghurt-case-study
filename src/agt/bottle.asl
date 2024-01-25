!start.

+!start
    <-
       .println("send order('yogurt', 10, 200, 205) to plant agent");
       .send(plant, achieve, order("yogurt", 10, 200, 205));
       .

+level(L)
    <- .println("observed level: ", L, " mm").


{ include("$jacamoJar/templates/common-cartago.asl") }