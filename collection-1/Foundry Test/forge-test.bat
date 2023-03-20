::wsl
@echo off
title Forge-unit test %DATE% %TIME% 

CALL :more
pause
CALL :run
EXIT /B %ERRORLEVEL% 

:run
echo ready to run, press any key
pause
forge test -vvv > what.txt
echo %DATE% >> what.txt
echo %TIME% >> what.txt
echo result save on : what.txt
pause
forge test --gas-report
pause
EXIT /B 0

:more
MORE what.txt
