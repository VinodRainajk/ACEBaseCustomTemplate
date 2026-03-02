# Profile Naming and Tag Strategy Guide

## Understanding Tags vs Profiles

### ❌ Common Misconception
```gherkin
@DB @Oracle
Scenario: Test Oracle
  # Tag @Oracle does NOT automatically use oracle-config.properties!
```

**Tags are NOT linked to profiles!** Tags are only for:
- Documentation (showing what the test is for)
- Filtering (running specific subsets of tests)

### ✅ How It Actually Works

The profile is specified **explicitly in the feature file**:

```gherkin
@DB @Oracle @HR
Scenario: Test Oracle HR Schema
  Given I set the active database profile to "oracle-schema1"  # ← THIS determines the profile
  And I have a database connection named "hr_db" using profile "oracle-schema1"
```

---

## Profile Naming Conventions

### Pattern 1: Database Type Only
Use when you have ONE instance per database type:

```
config/
├── mysql-config.properties
├── postgresql-config.properties
├── sqlserver-config.properties
└── oracle-config.properties
```

**Usage:**
```gherkin
Given I set the active database profile to "mysql"
```

### Pattern 2: Database + Schema/Instance
Use when you have MULTIPLE schemas/instances of the same database type:

```
config/
├── oracle-schema1-config.properties    # HR Schema
├── oracle-schema2-config.properties    # SALES Schema
├── oracle-schema3-config.properties    # INVENTORY Schema
├── mysql-instance1-config.properties
└── mysql-instance2-config.properties
```

**Usage:**
```gherkin
Given I set the active database profile to "oracle-schema1"
Given I set the active database profile to "oracle-schema2"
```

### Pattern 3: Database + Environment
Use when you have MULTIPLE environments (dev, test, staging, prod):

```
config/
├── mysql-dev-config.properties
├── mysql-test-config.properties
├── mysql-staging-config.properties
├── mysql-prod-config.properties
├── postgresql-dev-config.properties
└── postgresql-test-config.properties
```

**Usage:**
```gherkin
Given I set the active database profile to "mysql-dev"
Given I set the active database profile to "mysql-test"
```

### Pattern 4: Database + Environment + Schema
Use when you have MULTIPLE environments AND schemas:

```
config/
├── oracle-dev-hr-config.properties
├── oracle-dev-sales-config.properties
├── oracle-test-hr-config.properties
├── oracle-test-sales-config.properties
├── oracle-prod-hr-config.properties
└── oracle-prod-sales-config.properties
```

**Usage:**
```gherkin
Given I set the active database profile to "oracle-dev-hr"
Given I set the active database profile to "oracle-prod-sales"
```

---

## Tag Strategy

### Purpose of Tags

Tags serve THREE purposes:

#### 1. Documentation
```gherkin
@DB @Oracle @HR @Smoke
Scenario: Verify HR employees
```
Anyone reading this knows:
- It's a database test (`@DB`)
- It tests Oracle (`@Oracle`)
- It tests HR schema (`@HR`)
- It's a smoke test (`@Smoke`)

#### 2. Filtering Tests
```bash
# Run only Oracle tests
mvn test -Dcucumber.filter.tags="@Oracle"

# Run only HR schema tests
mvn test -Dcucumber.filter.tags="@HR"

# Run Oracle HR smoke tests
mvn test -Dcucumber.filter.tags="@Oracle and @HR and @Smoke"

# Run all Oracle tests EXCEPT Inventory
mvn test -Dcucumber.filter.tags="@Oracle and not @Inventory"
```

#### 3. CI/CD Pipeline Organization
```yaml
# Jenkins/GitLab CI
smoke-tests:
  script: mvn test -Dcucumber.filter.tags="@Smoke"

hr-tests:
  script: mvn test -Dcucumber.filter.tags="@HR"

oracle-tests:
  script: mvn test -Dcucumber.filter.tags="@Oracle"
```

### Recommended Tag Hierarchy

```
@DB                           # Top level - all database tests
├── @MySQL                    # Database type
│   ├── @Dev                  # Environment
│   ├── @Test
│   └── @Staging
├── @Oracle                   # Database type
│   ├── @HR                   # Schema/Module
│   ├── @Sales
│   └── @Inventory
├── @PostgreSQL               # Database type
└── @SQLServer                # Database type

@Smoke                        # Test priority
@Regression                   # Test priority
@Critical                     # Test priority
```

---

## Complete Example: Multiple Oracle Schemas

### Configuration Files

**oracle-schema1-config.properties (HR Schema)**
```properties
db.username=hr_user
db.password=hr_password123
db.schema=HR
```

**oracle-schema2-config.properties (SALES Schema)**
```properties
db.username=sales_user
db.password=sales_password456
db.schema=SALES
```

**oracle-schema3-config.properties (INVENTORY Schema)**
```properties
db.username=inventory_user
db.password=inventory_password789
db.schema=INVENTORY
```

### Feature File

```gherkin
@DB @Oracle
Feature: Oracle Multi-Schema Testing

  @DB @Oracle @HR @Smoke
  Scenario: Test HR Schema
    Given I set the active database profile to "oracle-schema1"
    And I have a database connection named "hr_db" using profile "oracle-schema1"
    When I connect to the database "hr_db"
    When I execute the query "SELECT * FROM HR.EMPLOYEES"
    Then the query should execute successfully

  @DB @Oracle @Sales @Smoke
  Scenario: Test SALES Schema
    Given I set the active database profile to "oracle-schema2"
    And I have a database connection named "sales_db" using profile "oracle-schema2"
    When I connect to the database "sales_db"
    When I execute the query "SELECT * FROM SALES.ORDERS"
    Then the query should execute successfully

  @DB @Oracle @Inventory @Regression
  Scenario: Test INVENTORY Schema
    Given I set the active database profile to "oracle-schema3"
    And I have a database connection named "inv_db" using profile "oracle-schema3"
    When I connect to the database "inv_db"
    When I execute the query "SELECT * FROM INVENTORY.PRODUCTS"
    Then the query should execute successfully
```

### Running Tests

```bash
# Run ALL Oracle tests (all schemas)
mvn test -Dcucumber.filter.tags="@Oracle"

# Run ONLY HR schema tests
mvn test -Dcucumber.filter.tags="@Oracle and @HR"

# Run ONLY SALES schema tests
mvn test -Dcucumber.filter.tags="@Oracle and @Sales"

# Run Oracle smoke tests (HR + SALES only, not INVENTORY)
mvn test -Dcucumber.filter.tags="@Oracle and @Smoke"

# Run HR and SALES tests (exclude INVENTORY)
mvn test -Dcucumber.filter.tags="@Oracle and not @Inventory"
```

---

## How the System Knows Which Profile to Use

### Step-by-Step Flow

```
1. Feature file specifies profile explicitly:
   Given I set the active database profile to "oracle-schema1"
        │
        ▼
2. Step definition receives profile name:
   @Given("I set the active database profile to {string}")
   public void iSetTheActiveDatabaseProfileTo(String profile) {
       configManager.setActiveProfile(profile);  // profile = "oracle-schema1"
   }
        │
        ▼
3. ConfigurationManager looks for file:
   config/oracle-schema1-config.properties
        │
        ▼
4. DatabaseConfig loads properties:
   db.username=hr_user
   db.password=hr_password123
   db.schema=HR
        │
        ▼
5. DatabaseConnectionFactory creates connection:
   new DatabaseConnection(url, "hr_user", "hr_password123", driver)
        │
        ▼
6. Connection established to HR schema
```

### Key Point

**The profile name in the feature file MUST match the config file name:**

```gherkin
Given I set the active database profile to "oracle-schema1"
                                            ↓
                                    Must match filename:
                                    oracle-schema1-config.properties
```

---

## Best Practices

### ✅ DO: Be Explicit
```gherkin
@DB @Oracle @HR
Scenario: Test HR Schema
  Given I set the active database profile to "oracle-schema1"  # Clear and explicit
```

### ❌ DON'T: Assume Tags Control Profiles
```gherkin
@DB @Oracle
Scenario: Test Oracle
  # Missing: Given I set the active database profile to "oracle-schema1"
  # System won't know which Oracle schema to use!
```

### ✅ DO: Use Descriptive Profile Names
```properties
oracle-prod-hr-config.properties        # Clear: Production HR schema
mysql-dev-users-config.properties       # Clear: Dev environment, users DB
```

### ❌ DON'T: Use Ambiguous Names
```properties
oracle1-config.properties               # Unclear: What is oracle1?
db-config.properties                    # Unclear: Which database?
```

### ✅ DO: Document Your Profiles
```properties
# oracle-schema1-config.properties
# Purpose: HR Schema - Human Resources Database
# Owner: HR Team
# Last Updated: 2026-03-02
```

---

## Profile Organization Strategies

### Strategy 1: Flat Structure (Simple)
```
config/
├── mysql-config.properties
├── oracle-hr-config.properties
├── oracle-sales-config.properties
└── postgresql-config.properties
```

### Strategy 2: By Database Type (Medium)
```
config/
├── mysql/
│   ├── dev-config.properties
│   ├── test-config.properties
│   └── prod-config.properties
├── oracle/
│   ├── hr-config.properties
│   ├── sales-config.properties
│   └── inventory-config.properties
└── postgresql/
    └── main-config.properties
```

**Note:** If using folders, update profile names:
```gherkin
Given I set the active database profile to "mysql/dev"
Given I set the active database profile to "oracle/hr"
```

### Strategy 3: By Environment (Complex)
```
config/
├── dev/
│   ├── mysql-config.properties
│   ├── oracle-hr-config.properties
│   └── oracle-sales-config.properties
├── test/
│   ├── mysql-config.properties
│   └── oracle-hr-config.properties
└── prod/
    ├── mysql-config.properties
    └── oracle-hr-config.properties
```

---

## Summary

### Key Takeaways

1. **Tags ≠ Profiles**
   - Tags are for filtering and documentation
   - Profiles are explicitly specified in feature files

2. **Profile Name = Config File Name**
   ```gherkin
   "oracle-schema1" → oracle-schema1-config.properties
   ```

3. **Be Explicit**
   - Always specify profile in feature file
   - Don't rely on defaults or assumptions

4. **Use Descriptive Names**
   - `oracle-prod-hr` > `oracle1`
   - `mysql-dev-users` > `db1`

5. **Organize for Your Needs**
   - Multiple schemas? Use `db-schema-config.properties`
   - Multiple environments? Use `db-env-config.properties`
   - Both? Use `db-env-schema-config.properties`

---

**Remember:** The system knows which profile to use because you tell it explicitly in the feature file!
