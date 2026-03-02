@DB @Oracle
Feature: Oracle Multi-Schema Testing
  As a QA engineer
  I want to test different Oracle schemas
  So that I can validate data across multiple schemas

  @DB @Oracle @HR
  Scenario: Test HR Schema - Verify Employees
    Given I set the active database profile to "oracle-schema1"
    And I have a database connection named "hr_db" using profile "oracle-schema1"
    When I connect to the database "hr_db"
    Then I should be connected to the database
    When I execute the query "SELECT COUNT(*) as total FROM HR.EMPLOYEES"
    Then the query should execute successfully
    And the query should return 1 row(s)

  @DB @Oracle @HR
  Scenario: Test HR Schema - Verify Departments
    Given I set the active database profile to "oracle-schema1"
    And I have a database connection named "hr_db" using profile "oracle-schema1"
    When I connect to the database "hr_db"
    When I execute the query "SELECT DEPARTMENT_ID, DEPARTMENT_NAME FROM HR.DEPARTMENTS WHERE DEPARTMENT_ID = 10"
    Then the query should execute successfully
    And the first row should contain column "DEPARTMENT_NAME" with value "Administration"

  @DB @Oracle @Sales
  Scenario: Test SALES Schema - Verify Orders
    Given I set the active database profile to "oracle-schema2"
    And I have a database connection named "sales_db" using profile "oracle-schema2"
    When I connect to the database "sales_db"
    Then I should be connected to the database
    When I execute the query "SELECT COUNT(*) as total FROM SALES.ORDERS"
    Then the query should execute successfully
    And the query should return 1 row(s)

  @DB @Oracle @Sales
  Scenario: Test SALES Schema - Verify Customers
    Given I set the active database profile to "oracle-schema2"
    And I have a database connection named "sales_db" using profile "oracle-schema2"
    When I connect to the database "sales_db"
    When I execute the query "SELECT CUSTOMER_ID, CUSTOMER_NAME FROM SALES.CUSTOMERS WHERE CUSTOMER_ID = 1"
    Then the query should execute successfully
    And the result set should contain a column "CUSTOMER_NAME"

  @DB @Oracle @Inventory
  Scenario: Test INVENTORY Schema - Verify Products
    Given I set the active database profile to "oracle-schema3"
    And I have a database connection named "inventory_db" using profile "oracle-schema3"
    When I connect to the database "inventory_db"
    Then I should be connected to the database
    When I execute the query "SELECT COUNT(*) as total FROM INVENTORY.PRODUCTS"
    Then the query should execute successfully

  @DB @Oracle @Inventory
  Scenario: Test INVENTORY Schema - Verify Stock Levels
    Given I set the active database profile to "oracle-schema3"
    And I have a database connection named "inventory_db" using profile "oracle-schema3"
    When I connect to the database "inventory_db"
    When I execute the query "SELECT PRODUCT_ID, STOCK_QUANTITY FROM INVENTORY.STOCK WHERE PRODUCT_ID = 100"
    Then the query should execute successfully
    And all rows should have column "STOCK_QUANTITY" not null
