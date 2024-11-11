package qe.context;

import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;

@TestConfiguration
public class SpringConfiguration {
  @Bean
  SharedState sharedState() {
    return new SharedState();
  }
}
