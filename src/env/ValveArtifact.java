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
        defineObsProperty("level", 0, 0);
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
        ObsProperty levelObsProp = getObsProperty("level");
        levelObsProp.updateValue(0, index);
        levelObsProp.updateValue(1, level);
    }

    @OPERATION
    void selfCleaning() {
        log("...start self cleaning routine");
        try {
            Thread.sleep(5000);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
        log("...finish self cleaning routine");
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
