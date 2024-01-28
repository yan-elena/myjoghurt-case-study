//liquid type and amount
filling_status("yogurt", 5000).

!start.

+!start
    <-  .println("container agent started").

+level(N, L)
    <-  ?filling_status(LQ, A);
        -+filling_status(LQ, A - L);
        .println("remained  ", A - L, " ", LQ, " mm in the container").

{ include("$jacamoJar/templates/common-cartago.asl") }