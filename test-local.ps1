# Run tests using local development POM (reads from target folder)
# Usage: .\test-local.ps1
# Usage: .\test-local.ps1 -Dtest=DBTestRunner

Write-Host "Running tests with LOCAL DEV configuration (target folder)..." -ForegroundColor Cyan
mvn -f pom-local-dev.xml test $args
