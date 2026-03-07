@echo off
setlocal

cd /d "%~dp0"
cd app

set "PYTHON_CMD=py -3"
where py >nul 2>&1
if errorlevel 1 set "PYTHON_CMD=python"

if not exist "venv\" (
    echo Creating virtual environment...
    %PYTHON_CMD% -m venv venv
)

call venv\Scripts\activate.bat
pip install -q -r requirements.txt

set APP_MODE=client
%PYTHON_CMD% app.py %*
