!start.

+!start
    <-
       .println("send order('yogurt', 10, 200, 205) to plant agent");
       .send(plant, achieve, order("yogurt", 10, 200, 205));
       .

+level(N, L)
    <- .println("observed level: ", L, " mm").


{ include("$jacamoJar/templates/common-cartago.asl") }