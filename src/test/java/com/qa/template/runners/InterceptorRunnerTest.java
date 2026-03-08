package com.qa.template.runners;

import com.qa.framework.runners.InterceptorRunner;

/**
 * Template entry point for running all tests via InterceptorRunner.
 * Extends InterceptorRunner so Surefire discovers it from src/test/java.
 * Routes @DB, @UI, @API scenarios to the appropriate runners.
 */
public class InterceptorRunnerTest extends InterceptorRunner {
}
