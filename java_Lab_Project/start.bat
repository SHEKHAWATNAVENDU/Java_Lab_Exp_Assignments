@echo off
title ShopSphere
cd /d "%~dp0"

echo ===================================================
echo           ShopSphere E-Commerce Launcher
echo ===================================================
echo.

:: 1. Ensure MySQL service is running
echo [1/4] Ensuring MySQL database service is running...
net start MySQL80 >nul 2>&1

:: 2. Set environment variables
set "DB_HOST=localhost"
set "DB_PORT=3307"
set "DB_NAME=shopsphere"
set "DB_USER=root"
set "DB_PASSWORD=12345"
set "CATALINA_HOME=C:\Users\XYZ\Server\apache-tomcat-9.0.123"
set "CATALINA_BASE=C:\Users\XYZ\Server\apache-tomcat-9.0.123"

:: 3. Stop any existing Tomcat instance on port 8080 to prevent port conflicts
for /f "tokens=5" %%a in ('netstat -aon ^| findstr ":8080" ^| findstr "LISTENING"') do (
    taskkill /F /PID %%a >nul 2>&1
)

:: 4. Package WAR with Maven
echo [2/4] Packaging application with Maven...
call mvn clean package -DskipTests -q
if %ERRORLEVEL% neq 0 (
    echo.
    echo [ERROR] Maven build failed.
    pause
    exit /b %ERRORLEVEL%
)

:: 5. Deploy to Tomcat webapps
echo [3/4] Deploying shopsphere.war to Tomcat...
copy /y "target\shopsphere.war" "%CATALINA_HOME%\webapps\" >nul

:: 6. Launch Tomcat and open browser
echo [4/4] Starting Tomcat server...
echo.
echo Application URL: http://localhost:8080/shopsphere/
echo (Press Ctrl+C to stop the server)
echo.

start "" "http://localhost:8080/shopsphere/"
call "%CATALINA_HOME%\bin\catalina.bat" run
