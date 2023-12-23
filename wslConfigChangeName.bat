@echo off

title [Tqk]__ Rename .wslconfig

setlocal EnableDelayedExpansion
set __name=.wslconfig
set __rename=__wslconfig.txt
set __path=C:\Users\KahirrChan\

cd /d %__path%

echo:
echo [ RENAME WSLCONFIG FILE ] ----------------------------------------
echo:

:__BEGIN
echo Please choose number:
echo    1. Get the name file
echo    2. Change name
echo    3. Exit

echo.
set /p __input= ^>  
echo. 

echo #####
echo.
if %__input%==1 (call :__GETNAME)
if %__input%==2 (call :__RENNAME)
if %__input%==3 (call :__END) else (call :__WARNING)




:__GETNAME
for %%x in (*wsl*) do (set __retV=%%x)
echo    ---^> File name:  %__retV%
echo.
echo.
echo ----------------------------------------
call :__BEGIN


:__RENNAME
for %%x in (*wsl*) do (set __retV=%%x)
if %__retV%==%__name% (set __reN=%__rename%) else (set __reN=%__name%)

echo    - File name: %__retV%
echo    - Rename to: %__reN%

if %__retV%==%__name% (ren %__name% %__rename%) else (ren %__rename% %__name%)
echo.
echo ---^> DONE^^! CHANGED NAME^^!
echo.
echo ----------------------------------------
call :__BEGIN


:__WARNING
echo.
echo [ WARNING ] ===^> YOUR NUMBER IS NOT IN THE LIST^^!


:__END
echo.
echo END OF PROGRAM^!
echo.
echo ------------------------[ Made by TqK ]---------------------------
echo.
endlocal

pause
exit