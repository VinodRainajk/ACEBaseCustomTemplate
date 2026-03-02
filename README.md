# ACE Base Custom Template

This is a template project for database testing using Cucumber. It imports the `custom-ace-base-wrapper` library which contains all the step definitions and database connection logic.

## Project Structure

```
ACEBaseCustomTemplate/
├── src/
│   └── test/
│       ├── java/
│       │   └── com/
│       │       └── qa/
│       │           └── template/
│       │               └── runners/
│       │                   └── CucumberTestRunner.java
│       └── resources/
│           ├── config/                    # Database profiles
│           │   ├── mysql-config.properties
│           │   ├── postgresql-config.properties
│           │   ├── sqlserver-config.properties
│           │   └── oracle-config.properties
│           ├── features/                  # Cucumber feature files
│           │   ├── database_operations.feature
│           │   ├── multi_database_test.feature
│           │   └── user_management.feature
│           └── cucumber.properties
├── pom.xml
└── README.md
```

## What This Project Contains

### ✅ Feature Files
- **database_operations.feature** - Basic database operations (SELECT, UPDATE, connection tests)
- **multi_database_test.feature** - Tests for different database types
- **user_management.feature** - User management specific tests

### ✅ Database Profiles
- **mysql-config.properties** - MySQL database configuration
- **postgresql-config.properties** - PostgreSQL database configuration
- **sqlserver-config.properties** - SQL Server database configuration
- **oracle-config.properties** - Oracle database configuration

### ✅ Test Runners (from library)
- **No runners needed in this project!** Runners are provided by the `custom-ace-base-wrapper` library
- Available runners:
  - `com.qa.framework.runners.BaseTestRunner` - All tests (DB + UI + API)
  - `com.qa.framework.runners.DBTestRunner` - Only @DB tests
  - `com.qa.framework.runners.UITestRunner` - Only @UI tests
  - `com.qa.framework.runners.APITestRunner` - Only @API tests

## What This Project Does NOT Contain

❌ Step Definitions - These are in the `custom-ace-base-wrapper` library  
❌ Database Connection Logic - This is in the library  
❌ Configuration Management - This is in the library  

## Setup Instructions

### 1. Install the Library JAR

First, build and install the `custom-ace-base-wrapper` library:

```bash
cd ../CustomACEBaseWrapper
mvn clean install
```

### 2. Configure Database Profiles

Edit the profile files in `src/test/resources/config/` with your database credentials:

**Example: `mysql-config.properties`**
```properties
db.type=mysql
db.driver=com.mysql.cj.jdbc.Driver
db.url=jdbc:mysql://your-host:3306/your-database
db.username=your-username
db.password=your-password
```

### 3. Build This Project

```bash
cd ../ACEBaseCustomTemplate
mvn clean compile
```

## Running Tests

### Run All Tests with Default Profile (MySQL)
```bash
mvn test
```

### Run Tests with Specific Database Profile
```bash
mvn test -Ddb.profile=mysql
mvn test -Ddb.profile=postgresql
mvn test -Ddb.profile=sqlserver
mvn test -Ddb.profile=oracle
```

### Run Specific Test Runner
```bash
# Run only DB tests
mvn test -Dtest=com.qa.framework.runners.DBTestRunner

# Run only UI tests (if you have UI library)
mvn test -Dtest=com.qa.framework.runners.UITestRunner

# Run only API tests (if you have API library)
mvn test -Dtest=com.qa.framework.runners.APITestRunner

# Run all tests
mvn test -Dtest=com.qa.framework.runners.BaseTestRunner
```

### Run Tests with Specific Tags
```bash
# Run only smoke tests
mvn test -Dcucumber.filter.tags="@DB and @Smoke"

# Run only regression tests
mvn test -Dcucumber.filter.tags="@DB and @Regression"

# Run MySQL tests only
mvn test -Dcucumber.filter.tags="@DB and @MySQL" -Ddb.profile=mysql

# Run user management tests
mvn test -Dcucumber.filter.tags="@DB and @UserManagement"
```

## Adding New Tests

### 1. Create a New Feature File

Create a new `.feature` file in `src/test/resources/features/`:

```gherkin
@DB
Feature: Your Feature Name
  As a QA engineer
  I want to test something
  So that I can ensure quality

  Background:
    Given I set the active database profile to "mysql"
    And I have a database connection named "mydb" using profile "mysql"
    And I connect to the database "mydb"

  @DB @YourTag
  Scenario: Your test scenario
    When I execute the query "SELECT * FROM your_table"
    Then the query should execute successfully
```

### 2. Use Existing Step Definitions

All step definitions are provided by the `custom-ace-base-wrapper` library. Available steps:

#### Connection Steps
```gherkin
Given I have a database connection named "name" using profile "mysql"
Given I set the active database profile to "mysql"
Given I connect to the database "name"
When I disconnect from the database
Then I should be connected to the database
Then I should not be connected to the database
```

#### Query Execution Steps
```gherkin
When I execute the query "SELECT * FROM table"
When I execute the update query "UPDATE table SET col = 'value'"
```

#### Verification Steps
```gherkin
Then the query should return 5 row(s)
Then the query should return at least 1 row(s)
Then the first row should contain column "name" with value "John"
Then the update should affect 1 row(s)
Then the query should execute successfully
Then the result set should contain a column "email"
Then all rows should have column "id" not null
```

## Creating Custom Profiles

You can create additional profiles for different environments:

### 1. Create Profile File

Create `src/test/resources/config/dev-mysql-config.properties`:
```properties
db.type=mysql
db.driver=com.mysql.cj.jdbc.Driver
db.url=jdbc:mysql://dev-server:3306/dev_db
db.username=dev_user
db.password=dev_password
```

### 2. Use in Feature File

```gherkin
Given I set the active database profile to "dev-mysql"
And I have a database connection named "devdb" using profile "dev-mysql"
```

### 3. Run Tests

```bash
mvn test -Ddb.profile=dev-mysql
```

## Test Reports

After running tests, reports are generated in:
- **HTML Report**: `target/cucumber-reports/cucumber.html`
- **JSON Report**: `target/cucumber-reports/cucumber.json`
- **JUnit XML**: `target/cucumber-reports/cucumber.xml`

## Environment-Specific Configuration

### Development Environment
```bash
mvn test -Ddb.profile=dev-mysql
```

### Test Environment
```bash
mvn test -Ddb.profile=test-mysql
```

### Staging Environment
```bash
mvn test -Ddb.profile=staging-mysql
```

## Best Practices

1. ✅ **Keep profiles separate** - One profile per environment/database
2. ✅ **Use meaningful tags** - Tag scenarios by feature, priority, database type
3. ✅ **Never commit credentials** - Use environment variables or external config
4. ✅ **Organize feature files** - Group by feature/module
5. ✅ **Use Background** - Set up common steps in Background section
6. ✅ **Tag all scenarios** - Always include @DB tag for database tests

## Troubleshooting

### Issue: Step definitions not found
**Solution**: Ensure `custom-ace-base-wrapper` is installed:
```bash
cd ../CustomACEBaseWrapper
mvn clean install
```

### Issue: Configuration file not found
**Solution**: Check that profile file exists in `src/test/resources/config/`

### Issue: Connection refused
**Solution**: Verify database is running and credentials are correct in profile file

### Issue: Wrong database profile used
**Solution**: Explicitly set profile: `mvn test -Ddb.profile=mysql`

## Dependencies

This project depends on:
- **custom-ace-base-wrapper** (1.0.0) - Provides step definitions and database logic
- **Cucumber** (7.15.0) - BDD framework
- **JUnit** (5.9.3) - Test runner

## Maven Coordinates

```xml
<dependency>
    <groupId>com.qa.framework</groupId>
    <artifactId>ace-base-custom-template</artifactId>
    <version>1.0.0</version>
</dependency>
```

## Understanding Tags vs Profiles

**Important:** Tags like `@Oracle` or `@MySQL` do NOT automatically control which database profile is used!

See these guides for complete explanation:
- **[TAGS_VS_PROFILES.md](TAGS_VS_PROFILES.md)** - Understanding tags vs profiles
- **[PROFILE_NAMING_GUIDE.md](PROFILE_NAMING_GUIDE.md)** - Profile naming conventions and strategies

### Quick Summary

**Tags** - For filtering and documentation:
```bash
mvn test -Dcucumber.filter.tags="@Oracle and @HR"
```

**Profiles** - For database connection:
```gherkin
Given I set the active database profile to "oracle-schema1"
```

## Support

For issues related to:
- **Step definitions** - Check `custom-ace-base-wrapper` library documentation
- **Feature files** - Refer to Cucumber documentation
- **Database profiles** - See [PROFILE_NAMING_GUIDE.md](PROFILE_NAMING_GUIDE.md)
- **Tags vs Profiles** - See [TAGS_VS_PROFILES.md](TAGS_VS_PROFILES.md)

---

**Note**: This is a template project. Customize feature files and profiles according to your testing needs.
"# ACEBaseCustomTemplate" 
