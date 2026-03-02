/**
 * Test Runners Package.
 * 
 * <p>
 * <strong>NOTE:</strong> Test runners are now provided by the custom-ace-base-wrapper library.
 * You no longer need to create runners in this package.
 * </p>
 * 
 * <h2>Available Runners (from library):</h2>
 * <ul>
 *   <li>com.qa.framework.runners.BaseTestRunner - All tests (DB + UI + API)</li>
 *   <li>com.qa.framework.runners.DBTestRunner - Only @DB tests</li>
 *   <li>com.qa.framework.runners.UITestRunner - Only @UI tests</li>
 *   <li>com.qa.framework.runners.APITestRunner - Only @API tests</li>
 * </ul>
 * 
 * <h2>Usage:</h2>
 * <pre>
 * mvn test -Dtest=com.qa.framework.runners.DBTestRunner
 * mvn test -Dtest=com.qa.framework.runners.UITestRunner
 * mvn test -Dtest=com.qa.framework.runners.APITestRunner
 * </pre>
 * 
 * <p>
 * If you need custom runners, you can create them here and extend the base runners from the library.
 * </p>
 */
package com.qa.template.runners;
