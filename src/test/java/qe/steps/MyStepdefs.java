package qe.steps;

import io.cucumber.java.Before;
import io.cucumber.java.en.Then;
import qe.context.SharedState;

public class MyStepdefs extends BaseStep {

  @Before
  public void before() {
    this.sharedState = new SharedState();
  }

  @Then("This is step {int}")
  public void thisIsStep(int arg0) throws InterruptedException {
    Thread.sleep(2000);
    System.out.println("This is step " + arg0);
    sharedState.setCount(arg0);
  }
}
