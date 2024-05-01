
@echo off

TITLE "[Tqk ]  RIGHT MENU FOR WIN 11"

setlocal EnableDelayedExpansion

@REM #### COLOR CODE FOR TERMINAL  #########################################

SET codeRED="\n\033[0;31m"
SET codeGREEN="\n\033[0;32m"
SET codeORANGE="\n\033[0;33m"
SET codeBLUE="\n\033[0;34m"
SET codeMAGENTA="\n\033[0;35m"
SET codeCYAN="\n\033[0;36m"
SET codeWHITE="\n\033[0;37m"

@REM #### MAIN CODE  ######################################################

:__BEGIN
printf %codeGREEN%
printf "\n---- [ TqK ]  ADJUST RIGHT MENU FOR WINDOWS 11---------------------\n "
printf %codeWHITE%

:__INPUT
printf "Please choose number:\n"
printf "\t1. Show old Context Menu\n"
printf "\t2. Show modern Context Menu\n"

printf "\n"
SET /p __inVAR= ^>^> 
if %__inVAR%==1 (CALL :__RESTORE)
if %__inVAR%==2 (CALL :__MODERN) 
if %__inVAR%==3 (CALL :__END) else (CALL :__WARNING)


:__RESTORE
printf %codeBLUE%
printf "\n1. Restore the old Context Menu in Windows 11"
printf %codeORANGE%
printf "\n--> CHANGING ^!"
reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve
printf %codeGREEN%
printf "\n--> DONE ^!"
printf %codeWHITE%
CALL :__RESTART


:__MODERN
printf %codeBLUE%
printf "\n1. Restore the old Context Menu in Windows 11"
printf %codeORANGE%
printf "\n--> CHANGING ^!"
reg.exe delete "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /f
printf %codeGREEN%
printf "\n--> DONE ^!"
printf %codeWHITE%
CALL :__RESTART


:__RESTART
printf %codeGREEN%
printf "\n-----"
printf %codeWHITE%
printf "\nDO YOU WANT TO RESTART NOW?\n"
printf "\t1. YES\n"
printf "\t2. CANCEL\n"

printf "\n"
SET /p __retVAR= ^>^> 
if %__retVAR%==1 (CALL :__REST_NOW)
if %__retVAR%==2 (CALL :__REST_CANCEL) else (CALL :__WARNING)


:__REST_NOW
printf "\n[ INFO ] RESTART NOW ^!"
shutdown -r -t 2
CALL :__END



:__REST_CANCEL
printf %codeCYAN%
printf "\n[ INFO ] RESTART CANCEL ^!"
printf %codeWHITE%
CALL :__END


:__WARNING
printf %codeRED%
printf "\n[ WARNING ] => YOUR NUMBER IS NOT IN THE LIST^!"
printf %codeWHITE%



:__END
printf %codeMAGENTA%
printf "\n***  THANKS FOR USE^!  END OF PROGRAM^!"
printf %codeGREEN%
printf "\n------------------------[ Made by TqK ]----------------------------\n"
printf %codeWHITE%

endlocal
pause
exit