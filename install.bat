@echo off
REM ############################################################################
REM Polymarket MCP Server - Windows Installation Script
REM
REM This script automates the installation and configuration of the Polymarket
REM MCP Server for Claude Desktop integration on Windows.
REM
REM Usage:
REM   install.bat              - Interactive installation
REM   install.bat /demo        - Install in DEMO mode (no wallet required)
REM   install.bat /help        - Show help message
REM
REM Author: Caio Vicentino
REM GitHub: https://github.com/caiovicentino/polymarket-mcp-server
REM ############################################################################

setlocal enabledelayedexpansion

REM Installation settings
set DEMO_MODE=false
set SKIP_CLAUDE_CONFIG=false
set INSTALL_DIR=%CD%
set VENV_DIR=%INSTALL_DIR%\venv
set PYTHON_MIN_VERSION=3.10

REM Parse command line arguments
:parse_args
if "%1"=="" goto start_install
if /i "%1"=="/demo" (
    set DEMO_MODE=true
    shift
    goto parse_args
)
if /i "%1"=="/help" goto show_help
echo Unknown option: %1
echo Use /help for usage information
exit /b 1

:show_help
echo Polymarket MCP Server - Installation Script
echo.
echo Usage:
echo   install.bat [OPTIONS]
echo.
echo Options:
echo   /demo              Install in DEMO mode (read-only, no wallet required)
echo   /help              Show this help message
echo.
echo Examples:
echo   install.bat                    - Full interactive installation
echo   install.bat /demo              - DEMO mode installation
echo.
exit /b 0

:start_install
cls
echo ================================================================
echo   Polymarket MCP Server - Automated Installer (Windows)
echo ================================================================
echo.
echo This script will:
echo   - Check Python version (3.10+ required)
echo   - Create virtual environment
echo   - Install all dependencies
echo   - Configure environment variables
echo   - Set up Claude Desktop integration
echo   - Test the installation
echo.
if "%DEMO_MODE%"=="true" (
    echo [INFO] Installing in DEMO mode (read-only, no wallet required)
    echo.
)
pause
echo.

REM Step 1: Check Python
echo [1/7] Checking Python version...

REM Try to find Python
where python >nul 2>&1
if %errorlevel% equ 0 (
    set PYTHON_CMD=python
) else (
    where python3 >nul 2>&1
    if %errorlevel% equ 0 (
        set PYTHON_CMD=python3
    ) else (
        echo [ERROR] Python not found
        echo.
        echo Please install Python 3.10 or higher from:
        echo https://www.python.org/downloads/
        echo.
        echo Make sure to check "Add Python to PATH" during installation
        pause
        exit /b 1
    )
)

REM Get Python version
for /f "tokens=2" %%v in ('%PYTHON_CMD% --version 2^>^&1') do set PYTHON_VERSION=%%v

echo [SUCCESS] Python %PYTHON_VERSION% found (%PYTHON_CMD%)
echo.

REM Step 2: Create virtual environment
echo [2/7] Creating virtual environment...

if exist "%VENV_DIR%" (
    echo [WARNING] Virtual environment already exists
    set /p RECREATE="Remove and recreate? (y/n): "
    if /i "!RECREATE!"=="y" (
        rmdir /s /q "%VENV_DIR%"
    ) else (
        echo [INFO] Using existing virtual environment
        goto activate_venv
    )
)

%PYTHON_CMD% -m venv "%VENV_DIR%"
if %errorlevel% neq 0 (
    echo [ERROR] Failed to create virtual environment
    pause
    exit /b 1
)
echo [SUCCESS] Virtual environment created
echo.

:activate_venv
REM Step 3: Activate and install dependencies
echo [3/7] Installing dependencies...

call "%VENV_DIR%\Scripts\activate.bat"
if %errorlevel% neq 0 (
    echo [ERROR] Failed to activate virtual environment
    pause
    exit /b 1
)

REM Upgrade pip
python -m pip install --quiet --upgrade pip

REM Install package
pip install --quiet -e .
if %errorlevel% neq 0 (
    echo [ERROR] Failed to install dependencies
    pause
    exit /b 1
)

echo [SUCCESS] Dependencies installed
echo.

REM Step 4: Configure environment
echo [4/7] Configuration...

if "%DEMO_MODE%"=="true" goto config_demo

echo.
echo Do you have a Polygon wallet with private key? (needed for trading)
set /p HAS_WALLET="(y/n): "

if /i not "!HAS_WALLET!"=="y" (
    echo [WARNING] No wallet provided - switching to DEMO mode
    set DEMO_MODE=true
    goto config_demo
)

:config_wallet
echo.
echo Enter your Polygon wallet private key:
echo (without 0x prefix, 64 hex characters)
set /p PRIVATE_KEY="> "

REM Validate private key length (basic check)
set KEY_LEN=0
set STR=!PRIVATE_KEY!
:strlen_loop
if defined STR (
    set STR=!STR:~1!
    set /a KEY_LEN+=1
    goto strlen_loop
)

if not !KEY_LEN! equ 64 (
    echo [ERROR] Invalid private key format (must be 64 hex characters)
    goto config_wallet
)

echo.
echo Enter your Polygon wallet address:
echo (0x followed by 40 hex characters)
set /p WALLET_ADDRESS="> "

REM Configure safety limits
echo.
echo Configure safety limits? (recommended for autonomous trading)
set /p CONFIG_LIMITS="(y/n): "

if /i "!CONFIG_LIMITS!"=="y" (
    set /p MAX_ORDER="Max order size USD (default: 1000): "
    if "!MAX_ORDER!"=="" set MAX_ORDER=1000

    set /p MAX_EXPOSURE="Max total exposure USD (default: 5000): "
    if "!MAX_EXPOSURE!"=="" set MAX_EXPOSURE=5000

    set /p AUTO_TRADE="Enable autonomous trading (y/n, default: y): "
    if /i "!AUTO_TRADE!"=="n" (
        set AUTO_TRADE_VALUE=false
    ) else (
        set AUTO_TRADE_VALUE=true
    )
) else (
    set MAX_ORDER=1000
    set MAX_EXPOSURE=5000
    set AUTO_TRADE_VALUE=true
)

REM Write .env file
(
echo # Polygon Wallet Configuration
echo POLYGON_PRIVATE_KEY=!PRIVATE_KEY!
echo POLYGON_ADDRESS=!WALLET_ADDRESS!
echo POLYMARKET_CHAIN_ID=137
echo.
echo # Safety Limits
echo MAX_ORDER_SIZE_USD=!MAX_ORDER!
echo MAX_TOTAL_EXPOSURE_USD=!MAX_EXPOSURE!
echo MAX_POSITION_SIZE_PER_MARKET=2000
echo MIN_LIQUIDITY_REQUIRED=10000
echo MAX_SPREAD_TOLERANCE=0.05
echo.
echo # Trading Controls
echo ENABLE_AUTONOMOUS_TRADING=!AUTO_TRADE_VALUE!
echo REQUIRE_CONFIRMATION_ABOVE_USD=500
echo AUTO_CANCEL_ON_LARGE_SPREAD=true
echo.
echo # Logging
echo LOG_LEVEL=INFO
) > .env

echo [SUCCESS] Configuration saved to .env
echo.
goto config_claude

:config_demo
echo [INFO] Running in DEMO mode (read-only, no trading)

REM Write .env file for demo mode
(
echo # DEMO MODE - Read-only access, no wallet required
echo DEMO_MODE=true
echo.
echo # Demo wallet (no real funds^)
echo POLYGON_PRIVATE_KEY=0000000000000000000000000000000000000000000000000000000000000001
echo POLYGON_ADDRESS=0x0000000000000000000000000000000000000001
echo.
echo # Safety Limits (demo defaults^)
echo MAX_ORDER_SIZE_USD=100
echo MAX_TOTAL_EXPOSURE_USD=500
echo ENABLE_AUTONOMOUS_TRADING=false
echo LOG_LEVEL=INFO
) > .env

echo [SUCCESS] DEMO mode configured
echo.

:config_claude
REM Step 5: Configure Claude Desktop
echo [5/7] Configuring Claude Desktop...

set CONFIG_DIR=%APPDATA%\Claude
set CONFIG_FILE=%CONFIG_DIR%\claude_desktop_config.json

REM Create directory if it doesn't exist
if not exist "%CONFIG_DIR%" mkdir "%CONFIG_DIR%"

REM Get Python path
for /f "delims=" %%i in ('where python') do set PYTHON_PATH=%%i

REM Prepare env vars
if "%DEMO_MODE%"=="true" (
    set ENV_VARS=        "DEMO_MODE": "true"
) else (
    REM Read from .env file
    for /f "tokens=1,2 delims==" %%a in ('findstr POLYGON_PRIVATE_KEY .env') do set PK=%%b
    for /f "tokens=1,2 delims==" %%a in ('findstr POLYGON_ADDRESS .env') do set WA=%%b
    set ENV_VARS=        "POLYGON_PRIVATE_KEY": "!PK!",^
        "POLYGON_ADDRESS": "!WA!"
)

REM Backup existing config
if exist "%CONFIG_FILE%" (
    echo [WARNING] Claude Desktop config already exists
    echo Backup will be created at: %CONFIG_FILE%.backup
    copy "%CONFIG_FILE%" "%CONFIG_FILE%.backup" >nul
)

REM Write config file
set INSTALL_DIR_JSON=%INSTALL_DIR:\=/%

(
echo {
echo   "mcpServers": {
echo     "polymarket": {
echo       "command": "!PYTHON_PATH!",
echo       "args": ["-m", "polymarket_mcp.server"],
echo       "cwd": "!INSTALL_DIR_JSON!",
echo       "env": {
echo !ENV_VARS!
echo       }
echo     }
echo   }
echo }
) > "%CONFIG_FILE%"

echo [SUCCESS] Claude Desktop configured
echo [INFO] Config location: %CONFIG_FILE%
echo.

REM Step 6: Test installation
echo [6/7] Testing installation...

python -c "import polymarket_mcp" 2>nul
if %errorlevel% equ 0 (
    echo [SUCCESS] Package import works
) else (
    echo [ERROR] Package import failed
    pause
    exit /b 1
)

echo [SUCCESS] Installation test passed
echo.

REM Step 7: Show completion
echo [7/7] Installation complete!
echo.
echo ================================================================
echo   Installation Successful!
echo ================================================================
echo.

if "%DEMO_MODE%"=="true" (
    echo Running in DEMO mode:
    echo   - Market discovery and analysis: ENABLED
    echo   - Real-time monitoring: ENABLED
    echo   - Trading functions: DISABLED (read-only^)
    echo.
    echo To enable trading:
    echo   1. Get a Polygon wallet with USDC
    echo   2. Run: install.bat (without /demo flag^)
    echo   3. Enter your wallet credentials
) else (
    echo Full trading mode enabled!
    echo.
    echo Safety Limits:
    type .env | findstr "MAX_ORDER_SIZE_USD MAX_TOTAL_EXPOSURE_USD ENABLE_AUTONOMOUS_TRADING"
)

echo.
echo Next Steps:
echo   1. Restart Claude Desktop application
echo   2. Look for 'polymarket' in available MCP servers
echo   3. Start asking Claude about Polymarket markets!
echo.
echo Example queries:
echo   - Show me trending markets on Polymarket
echo   - Analyze the top crypto prediction markets
echo   - What markets are closing in the next 24 hours?

if not "%DEMO_MODE%"=="true" (
    echo   - Buy $100 of YES in [market_id]
    echo   - Show my current positions
)

echo.
echo Documentation:
echo   - Setup Guide: %INSTALL_DIR%\SETUP_GUIDE.md
echo   - Tools Reference: %INSTALL_DIR%\TOOLS_REFERENCE.md
echo   - Usage Examples: %INSTALL_DIR%\USAGE_EXAMPLES.py
echo.
echo Happy trading!
echo.
pause
exit /b 0
