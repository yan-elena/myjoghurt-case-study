!start.

+!start
    <-
       .println("send order('yogurt', 15, 200, 205) to plant agent");
       .send(plant, achieve, order("yogurt", 15, 200, 205));
       .

{ include("$jacamoJar/templates/common-cartago.asl") }