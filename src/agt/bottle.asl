!start.

+!start
    <-
       .println("send order to plant agent");
       .send(plant, tell, order("yogurt", 10));
       .send(plant, tell, filling_range(200, 205));
       .
