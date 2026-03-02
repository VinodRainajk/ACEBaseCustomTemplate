# World Database Setup Guide

This guide helps you set up the MySQL World sample database for testing.

## What is the World Database?

The World database is a standard MySQL sample database that contains:
- **city** table: 4,079 cities from around the world
- **country** table: 239 countries
- **countrylanguage** table: Languages spoken in each country

## Installation

### Option 1: Download from MySQL

1. Download the world database:
   ```bash
   # Download SQL file
   curl -O https://downloads.mysql.com/docs/world-db.zip
   
   # Or download manually from:
   # https://dev.mysql.com/doc/index-other.html
   ```

2. Extract and import:
   ```bash
   unzip world-db.zip
   mysql -u root -p < world.sql
   ```

### Option 2: Manual Creation

```sql
-- Connect to MySQL
mysql -u root -p

-- Create database
CREATE DATABASE world;
USE world;

-- Create city table
CREATE TABLE city (
  ID INT NOT NULL AUTO_INCREMENT,
  Name CHAR(35) NOT NULL DEFAULT '',
  CountryCode CHAR(3) NOT NULL DEFAULT '',
  District CHAR(20) NOT NULL DEFAULT '',
  Population INT NOT NULL DEFAULT '0',
  PRIMARY KEY (ID)
);

-- Insert sample data (for testing)
INSERT INTO city (Name, CountryCode, District, Population) VALUES
('New York', 'USA', 'New York', 8336817),
('Los Angeles', 'USA', 'California', 3979576),
('Chicago', 'USA', 'Illinois', 2693976),
('Houston', 'USA', 'Texas', 2320268),
('Phoenix', 'USA', 'Arizona', 1680992),
('Mumbai', 'IND', 'Maharashtra', 12691836),
('Delhi', 'IND', 'Delhi', 11034555),
('Bangalore', 'IND', 'Karnataka', 8443675),
('Tokyo', 'JPN', 'Tokyo-to', 9273000),
('London', 'GBR', 'England', 8982000);
```

### Option 3: Docker (Recommended for Testing)

```bash
# Run MySQL with world database
docker run -d \
  --name mysql-world \
  -e MYSQL_ROOT_PASSWORD=password \
  -e MYSQL_DATABASE=world \
  -p 3306:3306 \
  mysql:8.0

# Wait for MySQL to start
sleep 10

# Import world database
docker exec -i mysql-world mysql -uroot -ppassword world < world.sql
```

## Configuration

### Update Database Credentials

Edit the configuration file:
```bash
notepad src\test\resources\config\mysql-world-config.properties
```

Update these values:
```properties
db.url=jdbc:mysql://localhost:3306/world
db.username=root
db.password=YOUR_PASSWORD
```

### Verify Connection

```bash
# Test connection
mysql -h localhost -u root -p world

# Run a test query
SELECT COUNT(*) FROM city;
```

## Running Tests

### Run All World Database Tests

```bash
cd F:\Learning\QAFramework\ACEBaseCustomTemplate
mvn test -Dtest=com.qa.framework.runners.DBTestRunner -Dcucumber.filter.tags="@World"
```

### Run Specific Scenarios

```bash
# Count tests only
mvn test -Dtest=com.qa.framework.runners.DBTestRunner -Dcucumber.filter.tags="@World and @CityCount"

# Data validation tests
mvn test -Dtest=com.qa.framework.runners.DBTestRunner -Dcucumber.filter.tags="@World and @CityData"

# Smoke tests
mvn test -Dtest=com.qa.framework.runners.DBTestRunner -Dcucumber.filter.tags="@World and @Smoke"
```

## Feature File Overview

The `world_city_count.feature` file includes:

### Scenarios

1. **Count total cities**: Verifies total city count
2. **Verify count > 0**: Ensures cities exist
3. **Data structure**: Validates city table columns
4. **Country-specific count**: Counts cities by country
5. **Large cities**: Finds cities with population > 1M
6. **Top cities**: Retrieves most populated cities
7. **Null check**: Ensures data integrity
8. **Distinct countries**: Counts unique countries

### Tags

- `@DB` - Database test
- `@MySQL` - MySQL specific
- `@World` - World database
- `@Smoke` - Quick smoke test
- `@CityCount` - Count-related tests
- `@CityData` - Data validation tests

## Expected Results

### City Table Structure

```
+-------------+----------+------+-----+---------+----------------+
| Field       | Type     | Null | Key | Default | Extra          |
+-------------+----------+------+-----+---------+----------------+
| ID          | int      | NO   | PRI | NULL    | auto_increment |
| Name        | char(35) | NO   |     |         |                |
| CountryCode | char(3)  | NO   |     |         |                |
| District    | char(20) | NO   |     |         |                |
| Population  | int      | NO   |     | 0       |                |
+-------------+----------+------+-----+---------+----------------+
```

### Sample Query Results

```sql
-- Total cities (full world database)
SELECT COUNT(*) FROM city;
-- Result: 4079

-- Cities in USA
SELECT COUNT(*) FROM city WHERE CountryCode = 'USA';
-- Result: 274

-- Large cities (population > 1M)
SELECT COUNT(*) FROM city WHERE Population > 1000000;
-- Result: 238
```

## Troubleshooting

### Connection Refused

**Error:**
```
Failed to connect to database: Connection refused
```

**Solution:**
1. Ensure MySQL is running:
   ```bash
   # Windows
   net start MySQL80
   
   # Linux
   sudo systemctl start mysql
   
   # Docker
   docker start mysql-world
   ```

2. Verify port 3306 is open:
   ```bash
   netstat -an | findstr 3306
   ```

### Database Not Found

**Error:**
```
Unknown database 'world'
```

**Solution:**
```sql
-- Create database
CREATE DATABASE world;

-- Import world.sql
mysql -u root -p world < world.sql
```

### Access Denied

**Error:**
```
Access denied for user 'root'@'localhost'
```

**Solution:**
```bash
# Update password in config file
notepad src\test\resources\config\mysql-world-config.properties

# Or reset MySQL password
mysql -u root -p
ALTER USER 'root'@'localhost' IDENTIFIED BY 'new_password';
```

### Table Doesn't Exist

**Error:**
```
Table 'world.city' doesn't exist
```

**Solution:**
```sql
-- Verify database
USE world;
SHOW TABLES;

-- If empty, import world.sql
SOURCE world.sql;
```

## Quick Start Commands

```bash
# 1. Ensure wrapper is built
cd F:\Learning\QAFramework\CustomACEBaseWrapper
mvn clean package

# 2. Configure database
cd F:\Learning\QAFramework\ACEBaseCustomTemplate
notepad src\test\resources\config\mysql-world-config.properties

# 3. Run tests
mvn test -Dtest=com.qa.framework.runners.DBTestRunner -Dcucumber.filter.tags="@World"

# 4. View report
start target\cucumber-reports\db-tests.html
```

## Sample Data for Testing

If you don't have the full world database, use this minimal dataset:

```sql
USE world;

INSERT INTO city (Name, CountryCode, District, Population) VALUES
('Kabul', 'AFG', 'Kabol', 1780000),
('Amsterdam', 'NLD', 'Noord-Holland', 731200),
('Rotterdam', 'NLD', 'Zuid-Holland', 593321),
('Paris', 'FRA', 'Île-de-France', 2138551),
('Marseille', 'FRA', 'Provence-Alpes-Côte', 798430),
('Berlin', 'DEU', 'Berliini', 3386667),
('Hamburg', 'DEU', 'Hamburg', 1704735),
('Munich', 'DEU', 'Baijeri', 1194560),
('Sydney', 'AUS', 'New South Wales', 3276207),
('Melbourne', 'AUS', 'Victoria', 2865329);
```

## Resources

- [MySQL World Database Documentation](https://dev.mysql.com/doc/world-setup/en/)
- [Download World Database](https://dev.mysql.com/doc/index-other.html)
- [MySQL Sample Databases](https://www.mysqltutorial.org/mysql-sample-database.aspx)
