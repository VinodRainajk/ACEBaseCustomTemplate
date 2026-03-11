package com.qa.template.runners;

import com.acebase.runners.APITestRunner;
import com.acebase.runners.UITestRunner;
import com.qa.framework.runners.DBTestRunner;
import org.junit.platform.suite.api.SelectClasses;
import org.junit.platform.suite.api.Suite;

/**
 * Template entry point - routes @DB, @UI, @API scenarios to the appropriate runners.
 * Run: mvn test
 */
@Suite
@SelectClasses({
    DBTestRunner.class,
    UITestRunner.class,
    APITestRunner.class
})
public class InterceptorRunnerTest {
}
