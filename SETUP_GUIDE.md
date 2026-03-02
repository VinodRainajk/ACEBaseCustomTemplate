# Setup Guide for ACE Base Custom Template

## Quick Setup (5 Minutes)

### Step 1: Install the Library JAR (2 minutes)

```bash
# Navigate to the library project
cd ../CustomACEBaseWrapper

# Build and install to local Maven repository
mvn clean install
```

**Expected Output:**
```
[INFO] Installing .../custom-ace-base-wrapper-1.0.0.jar to .../.m2/repository/...
[INFO] BUILD SUCCESS
```

### Step 2: Configure Your Database (2 minutes)

Edit `src/test/resources/config/mysql-config.properties`:

```properties
# Replace with your actual database details
db.url=jdbc:mysql://localhost:3306/your_database_name
db.username=your_username
db.password=your_password
```

### Step 3: Run Your First Test (1 minute)

```bash
# Navigate back to template project
cd ../ACEBaseCustomTemplate

# Run tests
mvn test -Ddb.profile=mysql
```

**Success!** You should see Cucumber tests executing.

---

## Detailed Setup

### Prerequisites

- ✅ Java 17 or higher installed
- ✅ Maven 3.6 or higher installed
- ✅ Database server running (MySQL, PostgreSQL, SQL Server, or Oracle)
- ✅ Database credentials available

### Verify Prerequisites

```bash
# Check Java version
java -version
# Should show: java version "17" or higher

# Check Maven version
mvn -version
# Should show: Apache Maven 3.6 or higher
```

### Installation Steps

#### 1. Clone or Download Projects

Ensure you have both projects:
```
QAFramework/
├── CustomACEBaseWrapper/      # Library with step definitions
└── ACEBaseCustomTemplate/     # Template with feature files
```

#### 2. Build the Library

```bash
cd CustomACEBaseWrapper
mvn clean install -DskipTests
```

This installs the library to your local Maven repository (`~/.m2/repository`).

#### 3. Verify Library Installation

Check that the JAR was created:
```bash
ls target/custom-ace-base-wrapper-1.0.0.jar
```

#### 4. Configure Database Profiles

Navigate to template project:
```bash
cd ../ACEBaseCustomTemplate
```

Edit profile files in `src/test/resources/config/`:

**For MySQL:**
```bash
# Edit mysql-config.properties
nano src/test/resources/config/mysql-config.properties
```

Update these properties:
```properties
db.url=jdbc:mysql://YOUR_HOST:3306/YOUR_DATABASE
db.username=YOUR_USERNAME
db.password=YOUR_PASSWORD
```

**For PostgreSQL:**
```properties
db.url=jdbc:postgresql://YOUR_HOST:5432/YOUR_DATABASE
db.username=YOUR_USERNAME
db.password=YOUR_PASSWORD
```

**For SQL Server:**
```properties
db.url=jdbc:sqlserver://YOUR_HOST:1433;databaseName=YOUR_DATABASE
db.username=YOUR_USERNAME
db.password=YOUR_PASSWORD
```

**For Oracle:**
```properties
db.url=jdbc:oracle:thin:@YOUR_HOST:1521:YOUR_SID
db.username=YOUR_USERNAME
db.password=YOUR_PASSWORD
```

#### 5. Test Database Connection

Create a simple test to verify connection:

```bash
mvn test -Dtest=CucumberTestRunner -Dcucumber.filter.tags="@DB and @Smoke" -Ddb.profile=mysql
```

---

## Configuration Examples

### Example 1: Local MySQL Setup

```properties
# mysql-config.properties
db.type=mysql
db.driver=com.mysql.cj.jdbc.Driver
db.url=jdbc:mysql://localhost:3306/testdb
db.host=localhost
db.port=3306
db.database=testdb
db.username=root
db.password=root123
```

### Example 2: Remote PostgreSQL Setup

```properties
# postgresql-config.properties
db.type=postgresql
db.driver=org.postgresql.Driver
db.url=jdbc:postgresql://db.example.com:5432/proddb
db.host=db.example.com
db.port=5432
db.database=proddb
db.username=dbuser
db.password=SecurePass123!
```

### Example 3: Docker MySQL Setup

```properties
# mysql-config.properties
db.type=mysql
db.driver=com.mysql.cj.jdbc.Driver
db.url=jdbc:mysql://127.0.0.1:3306/testdb
db.host=127.0.0.1
db.port=3306
db.database=testdb
db.username=root
db.password=docker
```

---

## Running Tests - Complete Guide

### Basic Test Execution

```bash
# Run all tests with default profile
mvn test

# Run with specific profile
mvn test -Ddb.profile=mysql
mvn test -Ddb.profile=postgresql
```

### Tag-Based Execution

```bash
# Run smoke tests only
mvn test -Dcucumber.filter.tags="@Smoke"

# Run regression tests only
mvn test -Dcucumber.filter.tags="@Regression"

# Run MySQL-specific tests
mvn test -Dcucumber.filter.tags="@MySQL" -Ddb.profile=mysql

# Run user management tests
mvn test -Dcucumber.filter.tags="@UserManagement"

# Combine tags (AND)
mvn test -Dcucumber.filter.tags="@DB and @Smoke"

# Combine tags (OR)
mvn test -Dcucumber.filter.tags="@Smoke or @Regression"

# Exclude tags
mvn test -Dcucumber.filter.tags="@DB and not @Slow"
```

### Feature-Specific Execution

```bash
# Run specific feature file
mvn test -Dcucumber.features="src/test/resources/features/database_operations.feature"

# Run multiple feature files
mvn test -Dcucumber.features="src/test/resources/features/database_operations.feature,src/test/resources/features/user_management.feature"
```

### Parallel Execution

Add to `pom.xml`:
```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-surefire-plugin</artifactId>
    <configuration>
        <parallel>methods</parallel>
        <threadCount>4</threadCount>
    </configuration>
</plugin>
```

Then run:
```bash
mvn test -Ddb.profile=mysql
```

---

## Troubleshooting

### Problem 1: Library Not Found

**Error:**
```
Could not resolve dependencies for project com.qa.framework:ace-base-custom-template
```

**Solution:**
```bash
cd ../CustomACEBaseWrapper
mvn clean install
cd ../ACEBaseCustomTemplate
mvn clean test
```

### Problem 2: Step Definitions Not Found

**Error:**
```
Undefined step: Given I have a database connection named "testdb"
```

**Solution:**
Verify `cucumber.properties` has correct glue path:
```properties
cucumber.glue=com.qa.framework.stepdefinitions.db
```

### Problem 3: Database Connection Failed

**Error:**
```
Failed to connect to database: Connection refused
```

**Solutions:**
1. Verify database is running:
   ```bash
   # For MySQL
   mysql -u root -p -e "SELECT 1"
   
   # For PostgreSQL
   psql -U postgres -c "SELECT 1"
   ```

2. Check credentials in profile file
3. Verify host and port are correct
4. Check firewall settings

### Problem 4: Configuration File Not Found

**Error:**
```
Configuration file not found: config/mysql-config.properties
```

**Solution:**
Ensure file exists in correct location:
```bash
ls src/test/resources/config/mysql-config.properties
```

### Problem 5: Wrong Profile Used

**Error:**
Tests running against wrong database

**Solution:**
Explicitly set profile:
```bash
mvn test -Ddb.profile=mysql
```

Or set in `pom.xml`:
```xml
<properties>
    <db.profile>mysql</db.profile>
</properties>
```

---

## Next Steps

1. ✅ **Customize Feature Files** - Modify existing or create new feature files
2. ✅ **Add More Profiles** - Create profiles for dev, test, staging environments
3. ✅ **Configure CI/CD** - Integrate with Jenkins, GitLab CI, GitHub Actions
4. ✅ **Add Test Data** - Create SQL scripts for test data setup
5. ✅ **Generate Reports** - View HTML reports in `target/cucumber-reports/`

---

## Support & Documentation

- **Library Documentation**: See `../CustomACEBaseWrapper/README.md`
- **Database Configuration**: See `../CustomACEBaseWrapper/DATABASE_CONFIGURATION.md`
- **Architecture**: See `../CustomACEBaseWrapper/ARCHITECTURE.md`
- **Cucumber Docs**: https://cucumber.io/docs/cucumber/

---

**Ready to start testing!** 🚀
