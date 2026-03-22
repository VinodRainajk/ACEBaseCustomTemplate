package com.qa.template.runners;

import org.junit.platform.suite.api.ConfigurationParameter;
import org.junit.platform.suite.api.IncludeEngines;
import org.junit.platform.suite.api.SelectClasspathResource;
import org.junit.platform.suite.api.Suite;

import static io.cucumber.junit.platform.engine.Constants.GLUE_PROPERTY_NAME;
import static io.cucumber.junit.platform.engine.Constants.PLUGIN_PROPERTY_NAME;

/**
 * DB test runner - filter comes from cucumber.filter.tags system property (set by Maven).
 * Runs scenarios matching @DB and environment tags (@all, @local, @qa, etc.).
 */
@Suite
@IncludeEngines("cucumber")
@SelectClasspathResource("features")
@ConfigurationParameter(key = GLUE_PROPERTY_NAME, value = "com.qa.framework.stepdefinitions.db, com.qa.framework.payload")
@ConfigurationParameter(
    key = PLUGIN_PROPERTY_NAME,
    value = "pretty, html:target/cucumber-reports/db-tests.html, json:target/cucumber-reports/db-tests.json, junit:target/cucumber-reports/db-tests.xml"
)
public class RunDBTests {
}
