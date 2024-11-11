package qe.context;

import io.cucumber.spring.ScenarioScope;
import lombok.Getter;
import lombok.Setter;
import org.springframework.stereotype.Component;

@Getter
@Setter
@Component
@ScenarioScope
public class SharedState {
  private int count;
  private String message;
}
