//liquid type and amount
filling_status("yogurt", 5000).

!start.

+!start
    <-  .println("container agent started").

+filled(N)
    <-  ?filling_status(L, A);
        -+filling_status(L, A - N);
        .println("remained  ", A - N, " in the container").