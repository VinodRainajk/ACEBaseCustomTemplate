package com.qa.template.runners;

import com.qa.framework.runners.DBTestRunner;
import org.junit.platform.suite.api.SelectClasses;
import org.junit.platform.suite.api.Suite;

/**
 * Template entry point for DB tests (JUnit).
 * Runs @DB scenarios via DBTestRunner.
 * For UI/API see {@link RunUIAPITests} (TestNG). Run all: mvn test
 */
@Suite
@SelectClasses({
    DBTestRunner.class
})
public class InterceptorRunnerTest {
}
