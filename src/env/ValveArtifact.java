import cartago.Artifact;
import cartago.OPERATION;
import cartago.OpFeedbackParam;

import java.util.Random;

public class ValveArtifact extends Artifact {

    private int estimation;
    private Random random;

    public void init(int estimation) {
        this.estimation = estimation;
        this.random = new Random();
        defineObsProperty("level", 0);
    }

    @OPERATION
    void openValveAndFill() {

        log("...open valve");
        log("...fill");
        try {
            Thread.sleep(estimation);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
        log("...close valve");

        int level = random.nextInt(estimation - 10, estimation + 10);
        log("level: " + level);
        getObsProperty("level").updateValue(level);
    }

    @OPERATION
    void updateEstimation(int estimation) {
        this.estimation = estimation;
    }

    @OPERATION
    void getFlowRateEstimation(OpFeedbackParam<Integer> estimation) {
        estimation.set(this.estimation);
    }
}
