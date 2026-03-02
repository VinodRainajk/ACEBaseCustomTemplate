# Tags vs Profiles: Complete Guide

## The Confusion

Many people think tags like `@Oracle` or `@MySQL` automatically control which database profile is used. **This is NOT true!**

---

## Visual Explanation

### ❌ What People Think Happens

```
Feature file has @Oracle tag
        │
        ▼
System automatically uses oracle-config.properties
        │
        ▼
Tests run against Oracle
```

**This is WRONG!** Tags don't control profiles.

### ✅ What Actually Happens

```
Feature file explicitly specifies profile:
  Given I set the active database profile to "oracle-schema1"
        │
        ▼
System looks for file: oracle-schema1-config.properties
        │
        ▼
Loads credentials from that file
        │
        ▼
Tests run against that specific Oracle schema
```

---

## Side-by-Side Comparison

| Aspect | Tags | Profiles |
|--------|------|----------|
| **Purpose** | Filter & document tests | Configure database connection |
| **Location** | In feature files | In config/*.properties files |
| **Syntax** | `@Oracle` `@MySQL` | `"oracle-schema1"` `"mysql-dev"` |
| **Controls** | Which tests run | Which database to connect to |
| **Specified** | Above Feature/Scenario | In Given step |
| **Example** | `@DB @Oracle @HR` | `"oracle-schema1"` |

---

## Complete Example

### You Have 3 Oracle Schemas

```
Oracle Server (localhost:1521)
├── HR Schema (hr_user / hr_password)
├── SALES Schema (sales_user / sales_password)
└── INVENTORY Schema (inv_user / inv_password)
```

### Step 1: Create 3 Config Files

**config/oracle-hr-config.properties**
```properties
db.username=hr_user
db.password=hr_password
db.schema=HR
```

**config/oracle-sales-config.properties**
```properties
db.username=sales_user
db.password=sales_password
db.schema=SALES
```

**config/oracle-inventory-config.properties**
```properties
db.username=inv_user
db.password=inv_password
db.schema=INVENTORY
```

### Step 2: Write Feature File with Tags AND Profile Names

```gherkin
@DB @Oracle
Feature: Oracle Multi-Schema Testing

  @DB @Oracle @HR
  Scenario: Test HR Schema
    Given I set the active database profile to "oracle-hr"  # ← Profile name
    And I have a database connection named "hr_db" using profile "oracle-hr"
    When I connect to the database "hr_db"
    When I execute the query "SELECT * FROM HR.EMPLOYEES"
    Then the query should execute successfully

  @DB @Oracle @Sales
  Scenario: Test SALES Schema
    Given I set the active database profile to "oracle-sales"  # ← Different profile
    And I have a database connection named "sales_db" using profile "oracle-sales"
    When I connect to the database "sales_db"
    When I execute the query "SELECT * FROM SALES.ORDERS"
    Then the query should execute successfully

  @DB @Oracle @Inventory
  Scenario: Test INVENTORY Schema
    Given I set the active database profile to "oracle-inventory"  # ← Different profile
    And I have a database connection named "inv_db" using profile "oracle-inventory"
    When I connect to the database "inv_db"
    When I execute the query "SELECT * FROM INVENTORY.PRODUCTS"
    Then the query should execute successfully
```

### Step 3: Run Tests

```bash
# Run ALL Oracle tests (all 3 schemas)
mvn test -Dcucumber.filter.tags="@Oracle"

# Run ONLY HR schema tests
mvn test -Dcucumber.filter.tags="@Oracle and @HR"

# Run ONLY SALES schema tests
mvn test -Dcucumber.filter.tags="@Oracle and @Sales"
```

---

## What Tags Actually Do

### Purpose 1: Documentation

```gherkin
@DB @Oracle @HR @Smoke @Critical
Scenario: Verify HR employees
```

Anyone reading this knows:
- `@DB` - It's a database test
- `@Oracle` - It tests Oracle database
- `@HR` - It tests HR schema
- `@Smoke` - It's a smoke test
- `@Critical` - It's a critical test

### Purpose 2: Filtering

```bash
# Run only smoke tests
mvn test -Dcucumber.filter.tags="@Smoke"

# Run only Oracle tests
mvn test -Dcucumber.filter.tags="@Oracle"

# Run Oracle HR tests
mvn test -Dcucumber.filter.tags="@Oracle and @HR"

# Run all Oracle EXCEPT Inventory
mvn test -Dcucumber.filter.tags="@Oracle and not @Inventory"

# Run critical smoke tests
mvn test -Dcucumber.filter.tags="@Smoke and @Critical"
```

### Purpose 3: CI/CD Organization

```yaml
# Jenkins Pipeline
stages:
  - stage: Smoke Tests
    steps:
      - mvn test -Dcucumber.filter.tags="@Smoke"
  
  - stage: HR Tests
    steps:
      - mvn test -Dcucumber.filter.tags="@HR"
  
  - stage: Oracle Tests
    steps:
      - mvn test -Dcucumber.filter.tags="@Oracle"
```

---

## Common Scenarios

### Scenario 1: Multiple MySQL Environments

**Config Files:**
```
config/
├── mysql-dev-config.properties      (dev-server, dev_user)
├── mysql-test-config.properties     (test-server, test_user)
└── mysql-prod-config.properties     (prod-server, prod_user)
```

**Feature File:**
```gherkin
@DB @MySQL
Feature: Environment Testing

  @DB @MySQL @Dev
  Scenario: Test Dev Environment
    Given I set the active database profile to "mysql-dev"
    And I have a database connection named "devdb" using profile "mysql-dev"
    When I connect to the database "devdb"
    Then I should be connected to the database

  @DB @MySQL @Test
  Scenario: Test Test Environment
    Given I set the active database profile to "mysql-test"
    And I have a database connection named "testdb" using profile "mysql-test"
    When I connect to the database "testdb"
    Then I should be connected to the database
```

**Run Tests:**
```bash
# Run dev tests only
mvn test -Dcucumber.filter.tags="@Dev"

# Run test environment tests only
mvn test -Dcucumber.filter.tags="@Test"
```

### Scenario 2: Multiple Oracle Schemas in Same Environment

**Config Files:**
```
config/
├── oracle-prod-hr-config.properties
├── oracle-prod-sales-config.properties
└── oracle-prod-inventory-config.properties
```

**Feature File:**
```gherkin
@DB @Oracle @Prod
Feature: Production Oracle Testing

  @DB @Oracle @Prod @HR
  Scenario: Test Prod HR
    Given I set the active database profile to "oracle-prod-hr"
    And I have a database connection named "hr" using profile "oracle-prod-hr"
    When I connect to the database "hr"
    Then I should be connected to the database

  @DB @Oracle @Prod @Sales
  Scenario: Test Prod SALES
    Given I set the active database profile to "oracle-prod-sales"
    And I have a database connection named "sales" using profile "oracle-prod-sales"
    When I connect to the database "sales"
    Then I should be connected to the database
```

---

## The Rule

### Simple Rule to Remember

**Tags = What you want to RUN**
```bash
mvn test -Dcucumber.filter.tags="@Oracle and @HR"
# "I want to run Oracle HR tests"
```

**Profiles = What you want to CONNECT TO**
```gherkin
Given I set the active database profile to "oracle-hr"
# "I want to connect to the HR schema"
```

---

## Debugging: Profile Not Found

### Error Message
```
Configuration file not found: config/oracle-schema1-config.properties
```

### Checklist

1. ✅ **Check feature file** - What profile name is specified?
   ```gherkin
   Given I set the active database profile to "oracle-schema1"
                                               ↑
                                        This is the profile name
   ```

2. ✅ **Check config file exists** - Does the file exist?
   ```
   src/test/resources/config/oracle-schema1-config.properties
                              ↑
                        Must match profile name exactly
   ```

3. ✅ **Check file name matches** - Are they identical?
   ```
   Profile name: "oracle-schema1"
   File name:    "oracle-schema1-config.properties"
                  ↑ Must match ↑
   ```

4. ✅ **Check location** - Is file in correct location?
   ```
   src/test/resources/config/  ← Must be here
   ```

---

## Best Practices

### ✅ DO: Use Both Tags and Profiles

```gherkin
@DB @Oracle @HR @Smoke
Scenario: Test HR Schema
  Given I set the active database profile to "oracle-hr"
  # Tag @HR for filtering, profile "oracle-hr" for connection
```

### ✅ DO: Make Profile Names Descriptive

```
oracle-prod-hr-config.properties        ✅ Clear
oracle-dev-sales-config.properties      ✅ Clear
mysql-test-users-config.properties      ✅ Clear

oracle1-config.properties               ❌ Unclear
db-config.properties                    ❌ Unclear
config.properties                       ❌ Unclear
```

### ✅ DO: Document Your Naming Convention

Create a file like `config/README.md`:
```markdown
# Profile Naming Convention

Format: {database}-{environment}-{schema}-config.properties

Examples:
- oracle-prod-hr-config.properties
- mysql-dev-config.properties
- postgresql-test-users-config.properties
```

### ❌ DON'T: Assume Tags Control Profiles

```gherkin
@DB @Oracle
Scenario: Test Oracle
  # Missing: Given I set the active database profile to "oracle-hr"
  # System won't know which Oracle to connect to!
```

---

## Summary

| Question | Answer |
|----------|--------|
| Do tags control which profile is used? | **NO** |
| How does system know which profile to use? | You specify it explicitly in the feature file |
| What are tags for? | Filtering tests and documentation |
| What are profiles for? | Database connection configuration |
| Can I have multiple profiles for same DB type? | **YES** - as many as you need |
| Do profile names need to match tags? | **NO** - they're independent |
| Where do I specify the profile? | In the `Given I set the active database profile to "..."` step |

---

## Quick Reference

### To Add a New Oracle Schema

1. **Create config file:** `config/oracle-newschema-config.properties`
2. **Add credentials:** `db.username=...`, `db.password=...`
3. **Use in feature:**
   ```gherkin
   Given I set the active database profile to "oracle-newschema"
   ```
4. **Add tags for filtering:**
   ```gherkin
   @DB @Oracle @NewSchema
   ```
5. **Run tests:**
   ```bash
   mvn test -Dcucumber.filter.tags="@NewSchema"
   ```

Done! 🎉
