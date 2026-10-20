# -----------------------------------------------------------------------------
#  scripts/run-local.ps1
#  ShopSphere - Secure local development launcher for Windows PowerShell
#
#  PURPOSE:
#    Sets database environment variables for the current process, then
#    launches a Maven build and/or Tomcat.  The password is entered
#    interactively via a non-echoing prompt and is NEVER written to a file,
#    printed to the console, or stored in shell history.
#
#  HOW TO RUN (from the project root):
#    powershell -ExecutionPolicy Bypass -File scripts\run-local.ps1
#
#  TARGET SERVER: Apache Tomcat 9.0.x (Servlet 4.0 / javax.servlet)
#
#  IMPORTANT - Tomcat Windows service:
#    If you run Tomcat as a Windows service (via tomcat9.exe), environment
#    variables set here do NOT flow into that service.  Use setenv.bat instead.
# -----------------------------------------------------------------------------

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ShopSphere - Local Environment Setup  " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# -- 1. DB_HOST ----------------------------------------------------------------
if (-not $env:DB_HOST) {
    $env:DB_HOST = "localhost"
    Write-Host "[DB_HOST]  Not set - using default: localhost" -ForegroundColor Yellow
} else {
    Write-Host "[DB_HOST]  Using existing value: $env:DB_HOST" -ForegroundColor Green
}

# -- 2. DB_PORT ----------------------------------------------------------------
if (-not $env:DB_PORT) {
    $env:DB_PORT = "3307"
    Write-Host "[DB_PORT]  Not set - using default: 3307" -ForegroundColor Yellow
} else {
    Write-Host "[DB_PORT]  Using existing value: $env:DB_PORT" -ForegroundColor Green
}

# -- 3. DB_NAME ----------------------------------------------------------------
if (-not $env:DB_NAME) {
    $env:DB_NAME = "shopsphere"
    Write-Host "[DB_NAME]  Not set - using default: shopsphere" -ForegroundColor Yellow
} else {
    Write-Host "[DB_NAME]  Using existing value: $env:DB_NAME" -ForegroundColor Green
}

# -- 4. DB_URL -----------------------------------------------------------------
if (-not $env:DB_URL) {
    $env:DB_URL = "jdbc:mysql://$($env:DB_HOST):$($env:DB_PORT)/$($env:DB_NAME)?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true"
    Write-Host "[DB_URL]   Constructed: $env:DB_URL" -ForegroundColor DarkGray
} else {
    Write-Host "[DB_URL]   Using existing value: $env:DB_URL" -ForegroundColor Green
}

# -- 5. DB_USER ----------------------------------------------------------------
if (-not $env:DB_USER) {
    Write-Host ""
    $inputUser = Read-Host "[DB_USER]  Enter your MySQL username (press Enter for 'root')"
    if ([string]::IsNullOrWhiteSpace($inputUser)) {
        $env:DB_USER = "root"
        Write-Host "[DB_USER]  Using: root" -ForegroundColor Green
    } else {
        $env:DB_USER = $inputUser.Trim()
        Write-Host "[DB_USER]  Using: $env:DB_USER" -ForegroundColor Green
    }
} else {
    Write-Host "[DB_USER]  Using existing value: $env:DB_USER" -ForegroundColor Green
}

# -- 6. DB_PASSWORD ------------------------------------------------------------
#  Read-Host -AsSecureString prevents the password from appearing on screen
#  or being stored in the PowerShell history buffer.
if (-not $env:DB_PASSWORD) {
    Write-Host ""
    $securePassword = Read-Host "[DB_PASSWORD]  Enter your MySQL password" -AsSecureString

    # Convert SecureString -> plain text only for the environment variable scope.
    # The plain text string lives only in this process's memory; it is never
    # written to disk or printed.
    $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword)
    try {
        $env:DB_PASSWORD = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
    } finally {
        # Immediately zero out the unmanaged BSTR memory
        [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
    }

    Write-Host "[DB_PASSWORD]  Password captured (not displayed)." -ForegroundColor Green
} else {
    Write-Host "[DB_PASSWORD]  Using existing value from environment." -ForegroundColor Green
}

# -- 7. Summary ----------------------------------------------------------------
Write-Host ""
Write-Host "Environment variables set for this session:" -ForegroundColor Cyan
Write-Host "  DB_HOST     = $env:DB_HOST"
Write-Host "  DB_PORT     = $env:DB_PORT"
Write-Host "  DB_NAME     = $env:DB_NAME"
Write-Host "  DB_URL      = $env:DB_URL"
Write-Host "  DB_USER     = $env:DB_USER"
Write-Host "  DB_PASSWORD = [hidden]"
Write-Host ""

# -- 8. Maven build ------------------------------------------------------------
Write-Host "Building the project with Maven..." -ForegroundColor Cyan
Write-Host "(Running: mvn clean package -q)" -ForegroundColor DarkGray
Write-Host ""

$mvnResult = & mvn clean package -q 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "Maven build FAILED. Output:" -ForegroundColor Red
    $mvnResult | ForEach-Object { Write-Host $_ }
    Write-Host ""
    Write-Host "Fix the build errors above, then re-run this script." -ForegroundColor Red
    exit 1
}
Write-Host "Maven build succeeded.  WAR: target\shopsphere.war" -ForegroundColor Green
Write-Host ""

# -- 9. Deploy WAR to Tomcat ---------------------------------------------------
#  Adjust TOMCAT_HOME to your actual Tomcat installation directory.
$TOMCAT_HOME = $env:CATALINA_HOME

if (-not $TOMCAT_HOME) {
    $knownTomcatPaths = @(
        "C:\Users\XYZ\Server\apache-tomcat-9.0.123",
        "F:\java_Lab\apache-tomcat-9.0.121",
        "$env:USERPROFILE\Downloads\apache-tomcat-9.0.121\apache-tomcat-9.0.121",
        "C:\apache-tomcat-9.0.121",
        "C:\Program Files\Apache Software Foundation\Tomcat 9.0"
    )
    foreach ($cand in $knownTomcatPaths) {
        if (Test-Path $cand) {
            $TOMCAT_HOME = $cand
            Write-Host "Auto-detected Tomcat 9 at: $TOMCAT_HOME" -ForegroundColor Green
            break
        }
    }
}

if (-not $TOMCAT_HOME) {
    Write-Host "CATALINA_HOME is not set." -ForegroundColor Yellow
    Write-Host "Please enter the full path to your Tomcat directory" -ForegroundColor Yellow
    Write-Host "(e.g. C:\Users\XYZ\Server\apache-tomcat-9.0.123):" -ForegroundColor Yellow
    $TOMCAT_HOME = Read-Host "Tomcat path"
}

if (-not (Test-Path $TOMCAT_HOME)) {
    Write-Host "Tomcat directory not found: $TOMCAT_HOME" -ForegroundColor Red
    Write-Host "Skipping WAR deployment.  Copy target\shopsphere.war manually." -ForegroundColor Yellow
} else {
    $warSource = Join-Path $PSScriptRoot "..\target\shopsphere.war"
    $webappsDir = Join-Path $TOMCAT_HOME "webapps"
    Write-Host "Copying shopsphere.war to $webappsDir ..." -ForegroundColor Cyan
    Copy-Item -Path $warSource -Destination $webappsDir -Force
    Write-Host "WAR deployed." -ForegroundColor Green
    Write-Host ""

    # -- 9. Start Tomcat (catalina.bat run - inherits this process's env vars) --
    Write-Host "Starting Tomcat in this console window..." -ForegroundColor Cyan
    Write-Host "(Press Ctrl+C to stop Tomcat)" -ForegroundColor DarkGray
    Write-Host ""

    $catalinaScript = Join-Path $TOMCAT_HOME "bin\catalina.bat"
    if (-not (Test-Path $catalinaScript)) {
        Write-Host "catalina.bat not found at: $catalinaScript" -ForegroundColor Red
        Write-Host "Start Tomcat manually from its bin directory." -ForegroundColor Yellow
    } else {
        # 'catalina.bat run' runs Tomcat in the foreground, inheriting all
        # environment variables set above (including DB_PASSWORD).
        & $catalinaScript run
    }
}

# -- 10. Cleanup - clear the password from this process's environment ----------
#  After Tomcat exits (or if deployment was skipped), clear the password so it
#  does not linger in any parent shell that may have dot-sourced this script.
$env:DB_PASSWORD = $null
Write-Host ""
Write-Host "DB_PASSWORD has been cleared from this session." -ForegroundColor DarkGray
