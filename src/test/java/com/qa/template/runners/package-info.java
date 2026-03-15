/**
 * Test Runners Package.
 *
 * <ul>
 *   <li>{@link InterceptorRunnerTest} - DB tests (JUnit)</li>
 *   <li>{@link RunUIAPITests} - UI and API tests (TestNG, extends wrapper UIAPITestNGRunner)</li>
 * </ul>
 *
 * <p>Run all: mvn test. Run DB only: -Dtest=InterceptorRunnerTest. Run UI/API only: -Dtest=RunUIAPITests.</p>
 * <p>To add template-specific step defs, add your glue package in RunUIAPITests @CucumberOptions.</p>
 */
package com.qa.template.runners;
