package qe.context;

import io.cucumber.spring.CucumberContextConfiguration;
import org.springframework.test.context.ContextConfiguration;

@CucumberContextConfiguration
@ContextConfiguration(classes = {SpringConfiguration.class})
public class CucumberSpringConfiguration {}
