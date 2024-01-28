import cartago.Artifact;
import cartago.OPERATION;
import cartago.ObsProperty;
import cartago.OpFeedbackParam;

import java.util.Random;

public class ValveArtifact extends Artifact {

    private int estimation;
    private Random random;

    public void init(int estimation) {
        this.estimation = estimation;
        this.random = new Random();
    }

    @OPERATION
    void openValveAndFill(int index) {

        log("...open valve");
        log("...fill");
        try {
            Thread.sleep(estimation);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
        log("...close valve");

        int level = random.nextInt(estimation - 10, estimation + 10);
        log("filled, measuring level: " + level + " mm");

        if(hasObsProperty("level")) {
            ObsProperty levelObsProp = getObsProperty("level");
            levelObsProp.updateValue(0, index);
            levelObsProp.updateValue(1, level);
        } else {
            defineObsProperty("level", index, level);
        }
    }

    @OPERATION
    void selfCleaning() {
        log("...start cleaning");
        try {
            Thread.sleep(500);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
        log("...finish cleaning");
    }

    @OPERATION
    void updateEstimation(int estimation) {
        log("update estimation: " + estimation);
        this.estimation = estimation;
    }

    @OPERATION
    void getFlowRateEstimation(OpFeedbackParam<Integer> estimation) {
        estimation.set(this.estimation);
    }
}
