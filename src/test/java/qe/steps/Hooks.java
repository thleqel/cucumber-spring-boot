package qe.steps;

import io.cucumber.java.Before;

public class Hooks {
  @Before
  public void before() {
    System.out.println("Before hook");
  }
}
