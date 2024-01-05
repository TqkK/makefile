@echo off

title [Tqk]__ Rename WSL Config File

setlocal EnableDelayedExpansion
set __name=.wslconfig
set __rename=__wslconfig.txt
set __path=C:\Users\TranQuangKhai
;set __path=C:\Users\KahirrChan\

cd /d %__path%

for %%x in (*wsl*) do (set __retV=%%x)

echo:
echo [ RENAME WSLCONFIG FILE ] ----------------------------------------
echo                           ------------------------ [ Made by Tqk ]
echo:

:__BEGIN
echo Please choose number:
echo    1. Get the name file
echo    2. Get file content
echo    3. Edit file content
echo    4. Change name
echo    5. Exit

echo.
set /p __input= ^>  
echo. 

echo #####
echo.
if %__input%==1 (call :__GETNAME)
if %__input%==2 (call :__GETCONTENT)
if %__input%==3 (call :__EDITCONTENT)
if %__input%==4 (call :__RENNAME)
if %__input%==5 (call :__END) else (call :__WARNING)




:__GETNAME
echo    ---^> File name:  %__retV%
echo.
echo.
echo ----------------------------------------
call :__BEGIN


:__GETCONTENT
echo.
echo ----------------------------------------
echo.
cat %__retV%
echo.
echo.
echo ----------------------------------------
call :__BEGIN


:__EDITCONTENT
echo.
echo ----------------------------------------
echo.
echo    ---^> Opened  %__retV%
echo.
echo ----------------------------------------
notepad %__retV%
call :__BEGIN


:__RENNAME
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
echo [ WARNING ]  YOUR NUMBER IS NOT IN THE LIST^^!


:__END
echo.
echo   *** END OF PROGRAM ^^!
echo.
echo ------------------------[ Made by TqK ]---------------------------
echo.
endlocal

pause
exit
