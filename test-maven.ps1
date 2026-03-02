# Run tests using Maven repository POM
# Usage: .\test-maven.ps1
# Usage: .\test-maven.ps1 -Dtest=DBTestRunner

Write-Host "Running tests with MAVEN REPOSITORY configuration..." -ForegroundColor Cyan
mvn -f pom.xml test $args
