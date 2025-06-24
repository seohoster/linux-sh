@echo off
title Network Control
:menu
cls
echo Network Control Menu

:: Clear variables
set "adapter1_name="
set "adapter1_state="
set "adapter2_name="
set "adapter2_state="

:: Get adapter names and states
set "adapter_count=0"
for /f "tokens=1,2,3,*" %%a in ('netsh interface show interface ^| findstr /R /C:"^ *[A-Za-z]"') do (
    if "%%b"=="Connected" (
        if !adapter_count! lss 2 (
            set /a adapter_count+=1
            if !adapter_count!==1 (
                set "adapter1_name=%%d"
                set "adapter1_state=Enabled"
            ) else (
                set "adapter2_name=%%d"
                set "adapter2_state=Enabled"
            )
        )
    ) else if "%%b"=="Disconnected" (
        if !adapter_count! lss 2 (
            set /a adapter_count+=1
            if !adapter_count!==1 (
                set "adapter1_name=%%d"
                set "adapter1_state=Disabled"
            ) else (
                set "adapter2_name=%%d"
                set "adapter2_state=Disabled"
            )
        )
    )
)

:: Display adapter states
echo Current Status:
if defined adapter1_name (
    echo %adapter1_name%: %adapter1_state%
) else (
    echo No adapters found.
)
if defined adapter2_name (
    echo %adapter2_name%: %adapter2_state%
)

:: Suggestion based on first adapter state
echo.
if "%adapter1_state%"=="Enabled" (
    echo Suggested: Disable Network (Option 1)
) else (
    echo Suggested: Enable Network (Option 2)
)
echo.
echo 1. Disable Network
echo 2. Enable Network
echo 3. Exit
set /p choice=Select an option (1-3): 

if "%choice%"=="1" (
    if defined adapter1_name netsh interface set interface "%adapter1_name%" admin=disable
    if defined adapter2_name netsh interface set interface "%adapter2_name%" admin=disable
    echo All network interfaces disabled.
    pause
    goto menu
)
if "%choice%"=="2" (
    if defined adapter1_name netsh interface set interface "%adapter1_name%" admin=enable
    if defined adapter2_name netsh interface set interface "%adapter2_name%" admin=enable
    echo All network interfaces enabled.
    pause
    goto menu
)
if "%choice%"=="3" (
    exit
)
echo Invalid choice. Please select 1, 2, or 3.
pause
goto menu