package com.qa.template.runners;

import com.qa.framework.runners.UIAPITestNGRunner;

/**
 * Template entry point for UI and API tests (TestNG).
 * Extends wrapper's UIAPITestNGRunner; uses ace-base + wrapper glue.
 * Add template glue package to @CucumberOptions here if you add step defs in this project.
 *
 * Run: mvn test -Dtest=RunUIAPITests
 * Or run with InterceptorRunnerTest for DB: mvn test runs both DB and UI/API.
 */
public class RunUIAPITests extends UIAPITestNGRunner {
}
