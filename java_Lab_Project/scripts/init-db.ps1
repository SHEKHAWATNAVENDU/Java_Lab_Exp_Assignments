# -----------------------------------------------------------------------------
#  scripts/init-db.ps1
#  ShopSphere - Safe, Non-Destructive Database Schema Initializer
#
#  PURPOSE:
#    Initializes the MySQL `shopsphere` database using `schema-init.sql`.
#    This script is completely NON-DESTRUCTIVE:
#    - Uses CREATE TABLE IF NOT EXISTS
#    - Uses INSERT IGNORE for seed data
#    - NEVER drops existing tables or modifies existing customer data
#    - Interactively prompts for your password via non-echoing secure input
#
#  HOW TO RUN (from the project root):
#    powershell -ExecutionPolicy Bypass -File scripts\init-db.ps1
# -----------------------------------------------------------------------------

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  ShopSphere - Safe Database Schema Initialization        " -ForegroundColor Cyan
Write-Host "  (Non-Destructive: Preserves all existing tables/data)   " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""

# -- 1. Resolve Parameters -----------------------------------------------------
$dbHost = if ($env:DB_HOST) { $env:DB_HOST } else { "localhost" }
$dbPort = if ($env:DB_PORT) { $env:DB_PORT } else { "3307" }
$dbName = if ($env:DB_NAME) { $env:DB_NAME } else { "shopsphere" }

$dbUser = $env:DB_USER
if (-not $dbUser) {
    $inputUser = Read-Host "[DB_USER] Enter MySQL username (press Enter for 'root')"
    $dbUser = if ([string]::IsNullOrWhiteSpace($inputUser)) { "root" } else { $inputUser.Trim() }
}

$dbPassword = $env:DB_PASSWORD
if (-not $dbPassword) {
    $securePassword = Read-Host "[DB_PASSWORD] Enter MySQL password for user '$dbUser'" -AsSecureString
    $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword)
    try {
        $dbPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
    } finally {
        [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
    }
}

# -- 2. Locate mysql.exe -------------------------------------------------------
$mysqlExe = $null

$cmd = Get-Command mysql -ErrorAction SilentlyContinue
if ($cmd) {
    $mysqlExe = $cmd.Source
} else {
    $candidates = @(
        "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe",
        "C:\Program Files\MySQL\MySQL Server 8.4\bin\mysql.exe",
        "C:\Program Files\MySQL\MySQL Workbench 8.0\mysql.exe",
        "C:\tools\mysql\bin\mysql.exe",
        "C:\xampp\mysql\bin\mysql.exe"
    )
    foreach ($path in $candidates) {
        if (Test-Path $path) {
            $mysqlExe = $path
            break
        }
    }
}

if (-not $mysqlExe) {
    Write-Host "[WARNING] mysql.exe command-line tool was not found in PATH or standard directories." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "You can initialize the database using MySQL Workbench:" -ForegroundColor Cyan
    Write-Host "  1. Open MySQL Workbench and connect to your local MySQL server."
    Write-Host "  2. Go to File -> Open SQL Script..."
    Write-Host "  3. Select: $(Resolve-Path (Join-Path $PSScriptRoot '..\schema-init.sql'))"
    Write-Host "  4. Click the lightning bolt icon (Execute)."
    Write-Host "  5. Refresh the Schemas navigator to confirm the 12 tables appear."
    Write-Host ""
    exit 1
}

Write-Host "[MYSQL]    Found client: $mysqlExe" -ForegroundColor Green
Write-Host "[TARGET]   Host: $dbHost | Port: $dbPort | Database: $dbName | User: $dbUser" -ForegroundColor Green

# -- 3. Locate schema-init.sql -------------------------------------------------
$sqlFile = (Resolve-Path (Join-Path $PSScriptRoot "..\schema-init.sql")).Path
if (-not (Test-Path $sqlFile)) {
    Write-Host "[ERROR] schema-init.sql not found at: $sqlFile" -ForegroundColor Red
    exit 1
}
$sqlFileForward = $sqlFile.Replace('\', '/')

# -- 4. Execute schema-init.sql ------------------------------------------------
Write-Host ""
Write-Host "Applying schema-init.sql non-destructively..." -ForegroundColor Cyan

$env:MYSQL_PWD = $dbPassword
try {
    & $mysqlExe --host=$dbHost --port=$dbPort --user=$dbUser --default-character-set=utf8mb4 -e "source $sqlFileForward" 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[ERROR] Database execution failed with exit code $LASTEXITCODE." -ForegroundColor Red
        exit 1
    }
    Write-Host "[SUCCESS] Schema initialized successfully." -ForegroundColor Green

    # -- 5. Verify Tables ------------------------------------------------------
    Write-Host ""
    Write-Host "Verifying tables in database '$dbName'..." -ForegroundColor Cyan

    $checkQuery = "SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_SCHEMA='$dbName' ORDER BY TABLE_NAME;"
    $tableOutput = & $mysqlExe --host=$dbHost --port=$dbPort --user=$dbUser --skip-column-names -e $checkQuery 2>$null
    $tables = @($tableOutput -split "`r?`n" | Where-Object { $_ -match '\S' })

    Write-Host "Found $($tables.Count) table(s) in '$dbName':" -ForegroundColor Cyan
    foreach ($t in $tables) {
        Write-Host "  [OK] $t" -ForegroundColor Green
    }

    $expectedTables = @(
        "addresses", "cart", "categories", "coupon_usage", "coupons",
        "order_items", "orders", "payments", "products", "reviews",
        "users", "wishlist"
    )

    $missing = @()
    foreach ($expected in $expectedTables) {
        if ($tables -notcontains $expected) {
            $missing += $expected
        }
    }

    if ($missing.Count -gt 0) {
        Write-Host ""
        Write-Host "[WARNING] Missing expected tables: $($missing -join ', ')" -ForegroundColor Red
        exit 1
    } else {
        Write-Host ""
        Write-Host "[SUCCESS] All 12 required tables are present and verified." -ForegroundColor Green
        Write-Host "Database is ready for Tomcat 9 and ShopSphere." -ForegroundColor Green
    }
    Write-Host ""
} finally {
    $env:MYSQL_PWD = $null
    $dbPassword = $null
}
