!start.

+!start
    <-
        .println("send order to unit agent");
       .send(plant, tell, order("yogurt", 10));
       .send(plant, tell, tolerance_range(209, 210));
       //.send(plant, tell, order("milk", 5));
       .
