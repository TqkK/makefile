SHELL := pwsh

.PHONY: all create cleanF clean check 
.PHONY: compile compileInfo compileInfoDone 
.PHONY: runas build buildInfo buildDone buildInfoDone 
.PHONY: toBIN toBINinfo toBINinfoDone 
.PHONY: toHEX toHEXinfo toHEXinfoDone 
.PHONY: toLIST toLISTinfo toLISTinfoDone 
.PHONY: mapInfo size log clear help
.PHONY: flash flashP readMem readMemP readRegP properties open

###############################################################################################################################################################################################
#																															 																  #
#   											     	  									INITIATION																						  #
#																															 																  #
###############################################################################################################################################################################################

#	[ INITIATION | DECLARATION ] ---------------------------------------------------------------------------------------------
PathProject = 

# If the project name would like to be the same as the workspace name, type 'default' or type any name.
ProjectName = default

_armCortex = cortex-m4
_mainFile = main
_linkerFile = FLASH
_std = gnu11


#	[ INITIATION | DETERMINE EXTERN FILES ]	----------------------------------------------------------------------------------
_extHeaderFile = h
_extSourceFile = n/a
_extLinkerFile = ld
_extStartFile = s


#	[ INITIATION | DETERMINE PATH FILES ] ------------------------------------------------------------------------------------
PathMainFile = n/a
PathMainHeader = n/a
PathSourceFiles = n/a
PathHeaderFiles = n/a
PathLinkerFile = n/a
PathStartupFile = n/a

_pathMain = n/a

#		[ DETERMINE PATH FILES | COLECT FILES ] =============================================================================
PathRoot = $(CURDIR)
ifeq (default,$(ProjectName))
	ProjectName := $(lastword $(subst /, ,$(dir $(PathRoot))))
else
	ProjectName := $(ProjectName)
endif

#-- Nil loop
PathFiles = $(wildcard ../*)
_pathFiles := $(PathFiles) 

#-- 1st loop
PathFiles := $(foreach PathFiles,$(PathFiles),$(PathFiles)/)
PathFiles := $(foreach PathFiles,$(PathFiles),$(wildcard $(PathFiles)*))
_pathFiles += $(PathFiles) 

#-- 2nd loop
PathFiles := $(foreach PathFiles,$(PathFiles),$(PathFiles)/)
PathFiles := $(foreach PathFiles,$(PathFiles),$(wildcard $(PathFiles)*))
_pathFiles += $(PathFiles) 

#-- 3th loop
PathFiles := $(foreach PathFiles,$(PathFiles),$(PathFiles)/)
PathFiles := $(foreach PathFiles,$(PathFiles),$(wildcard $(PathFiles)*))
_pathFiles += $(PathFiles) 

#-- 4th loop
PathFiles := $(foreach PathFiles,$(PathFiles),$(PathFiles)/)
PathFiles := $(foreach PathFiles,$(PathFiles),$(wildcard $(PathFiles)*))
_pathFiles += $(PathFiles) 

#-- 5th loop
PathFiles := $(foreach PathFiles,$(PathFiles),$(PathFiles)/)
PathFiles := $(foreach PathFiles,$(PathFiles),$(wildcard $(PathFiles)*))
_pathFiles += $(PathFiles) 

#-- 6th loop
PathFiles := $(foreach PathFiles,$(PathFiles),$(PathFiles)/)
PathFiles := $(foreach PathFiles,$(PathFiles),$(wildcard $(PathFiles)*))
_pathFiles += $(PathFiles) 


_pathFiles := $(foreach _pathFiles,$(_pathFiles), $(if \
$(or $(findstring .$(_extHeaderFile),$(_pathFiles)),$(findstring .c,$(_pathFiles)),$(findstring .cpp,$(_pathFiles)),$(findstring .$(_extStartFile),$(_pathFiles)),$(findstring .$(_extLinkerFile),$(_pathFiles))),\
$(subst *,,$(_pathFiles))))

_pathFiles := $(sort $(_pathFiles))


#		[ DETERMINE PATH FILES | PATH TREATMENT ] ===========================================================================

#---- MAIN FILE
_pathMain := $(_pathFiles)
_pathMain := $(foreach _pathMain,$(_pathMain),$(if $(findstring $(_mainFile),$(_pathMain)),$(subst *,,$(_pathMain))))
_pathMain := $(strip $(_pathMain))

##---- TREATMENT
MainHeader := $(_pathMain)
MainHeader := $(foreach MainHeader,$(MainHeader),$(if $(findstring .$(_extHeaderFile),$(MainHeader)),$(subst *,,$(MainHeader))))
MainHeader := $(strip $(MainHeader))

PathMainHeader = $(dir $(MainHeader))

MainFile := $(_pathMain)
MainFile := $(foreach MainFile,$(MainFile),$(if $(findstring $(_mainFile),$(MainFile)),$(subst *,,$(MainFile))))
MainFile := $(foreach MainFile,$(MainFile),$(if $(findstring .$(_extHeaderFile),$(MainFile)),,$(subst *,,$(MainFile))))

MainFile := $(strip $(MainFile))

PathMainFile = $(dir $(MainFile))

_extSourceFile := $(if $(findstring cpp, $(MainFile)),cpp,c)


#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#
#---- LIBRARY FILES
_pathLibs := $(_pathFiles)
_pathLibs := $(foreach _pathLibs,$(_pathLibs),$(or $(if $(findstring .$(_extHeaderFile),$(_pathLibs)),$(subst *,,$(_pathLibs))), \
$(if $(findstring .$(_extSourceFile),$(_pathLibs)),$(subst *,,$(_pathLibs)))))
_pathLibs := $(foreach _pathLibs,$(_pathLibs),$(if $(findstring $(_mainFile),$(_pathLibs)),,$(subst *,,$(_pathLibs))))
_pathLibs := $(strip $(_pathLibs))

##---- TREATMENT
PathHeaderFiles := $(_pathLibs)
PathHeaderFiles := $(foreach PathHeaderFiles,$(PathHeaderFiles),$(if $(findstring .$(_extHeaderFile),$(PathHeaderFiles)),$(subst *,,$(PathHeaderFiles))))
PathHeaderFiles := $(strip $(PathHeaderFiles))
PathHeaderFiles := $(sort $(dir $(PathHeaderFiles)))


HeaderFiles := $(_pathLibs)
HeaderFiles := $(foreach HeaderFiles,$(HeaderFiles),$(if $(findstring .$(_extHeaderFile),$(HeaderFiles)),$(subst *,,$(HeaderFiles))))
HeaderFiles := $(strip $(HeaderFiles))


SourceFiles := $(_pathLibs)
SourceFiles := $(foreach SourceFiles,$(SourceFiles),$(if $(findstring .$(_extHeaderFile),$(SourceFiles)),,$(subst *,,$(SourceFiles))))
SourceFiles := $(strip $(SourceFiles))

PathSourceFiles = $(sort $(dir $(SourceFiles)))


#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#
#---- LINKER FILES
_pathLinker := $(_pathFiles)

##---- TREATMENT
LinkerFile := $(_pathLinker)
LinkerFile := $(foreach LinkerFile,$(LinkerFile),$(if $(findstring .$(_extLinkerFile),$(LinkerFile)),$(subst *,,$(LinkerFile))))
LinkerFile := $(strip $(LinkerFile))

PathLinkerFile := $(sort $(dir $(LinkerFile)))

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#
#---- STARTUP FILES
_pathStartup := $(_pathFiles)

##---- TREATMENT
StartupFile := $(_pathStartup)
StartupFile := $(foreach StartupFile,$(StartupFile),$(if $(findstring .$(_extStartFile),$(StartupFile)),$(subst *,,$(StartupFile))))
StartupFile := $(foreach StartupFile,$(StartupFile),$(if $(findstring .svd,$(StartupFile)),,$(subst *,,$(StartupFile))))
StartupFile := $(strip $(StartupFile))

PathStartupFile := $(dir $(StartupFile))


###############################################################################################################################################################################################
#																															 																  #
#   											     	  									BUILDING																						  #
#																															 																  #
###############################################################################################################################################################################################

#	[ BUILDING | PATH OF OUTPUT FILES ]	--------------------------------------------------------------------------------------
PathBuild = ../Debug
# PathBin = $(PathBuild)/Bin
PathBin = $(PathBuild)
PathObj := $(foreach PathSourceFiles,$(PathSourceFiles),$(subst ../,$(PathBuild)/,$(PathSourceFiles)))
PathObjS = $(subst $(notdir $(S_ObjFile)),,$(S_ObjFile))
PathObjMain = $(subst ../,$(PathBuild)/,$(PathMainFile))

PathObj += $(PathObjMain)
PathObj := $(sort $(dir $(PathObj)))


#	[ BUILDING | COLLECT FILES ]	------------------------------------------------------------------------------------------

#		[ COLLECT FILES | SOURCE FILES ] ====================================================================================
_pathSourceColect = $(PathMainFile)
_pathSourceColect += $(PathSourceFiles)
_pathSourceColect := $(sort $(_pathSourceColect))
vpath %.$(_extSourceFile) $(_pathSourceColect)


#		[ COLLECT FILES | HEADER FILES ] ====================================================================================
_pathHeaderColect = $(PathMainHeader)
_pathHeaderColect += $(PathHeaderFiles)
_pathHeaderColect := $(sort $(_pathHeaderColect))
vpath %.$(_extHeaderFile) $(_pathHeaderColect)


#		[ COLLECT FILES | OBJECT FILES ] ====================================================================================
ObjFiles = $(foreach SourceFiles,$(SourceFiles),$(subst .$(_extSourceFile),.o,$(SourceFiles)))
ObjFiles := $(foreach ObjFiles,$(ObjFiles),$(subst ../,$(PathBuild)/,$(ObjFiles)))
ObjFiles := $(strip $(ObjFiles))


#		[ COLLECT FILES | MAIN OBJECT FILE ] ================================================================================
ObjMain = $(subst .$(_extSourceFile),.o,$(MainFile))
ObjMain := $(subst ../,$(PathBuild)/,$(ObjMain))
ObjMain := $(strip $(ObjMain))


#		[ COLLECT FILES | START UP OBJECT FILES ] ===========================================================================
S_ObjFile = $(subst .$(_extStartFile),.o,$(StartupFile))
S_ObjFile := $(subst ../,$(PathBuild)/,$(S_ObjFile))
S_ObjFile := $(strip $(S_ObjFile))


#		[ COLLECT FILES | LINKER FILES ] ====================================================================================
LDFile = $(foreach LinkerFile,$(LinkerFile),$(if $(findstring $(_linkerFile),$(LinkerFile)),$(subst *,,$(LinkerFile))))
LDFile := $(subst  ,,$(LDFile))
LDFile := $(strip $(LDFile))


#		[ COLLECT FILES | DEPENDENT FILES ] =================================================================================
DepFiles = $(subst .o,.d,$(ObjFiles))
DepFiles := $(strip $(DepFiles))

DepMain = $(subst .o,.d,$(ObjMain))
DepMain := $(strip $(DepMain))


#		[ COLLECT FILES | OUTPUT FILES ] ====================================================================================
MapFile = $(PathBin)/$(ProjectName).map
ElfFile = $(PathBin)/$(ProjectName).elf
BinFile = $(PathBin)/$(ProjectName).bin
HexFile = $(PathBin)/$(ProjectName).hex
ListFile = $(PathBin)/$(ProjectName).list


###############################################################################################################################################################################################
#																															 																  #
#   											     	  									CLI COMMAND																						  #
#																															 																  #
###############################################################################################################################################################################################


#	[ CMD | ARM-GNU OPTIONS ]	----------------------------------------------------------------------------------------------

#---- COMPILER
CC = $(if $(findstring cpp, $(_extSourceFile)), arm-none-eabi-g++, arm-none-eabi-gcc)
CC := $(strip $(CC))

#---- LINKER
LD = arm-none-eabi-ld

#---- OBJCOPY 
OBJ_CP = arm-none-eabi-objcopy

#---- OBJDUMP
OBJ_DP = arm-none-eabi-objdump

#---- PROGRAMMER
oPRGER = ST-LINK_CLI
PRGER = STM32_Programmer_CLI

#---- OPTIONS
__UseFloatPrintf = -u _printf_float
__UseFloatScanf = -u _scanf_float

OBJ_OPT = -g -Wall -mcpu=$(_armCortex) -std=$(_std) -mthumb -DDEBUG --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard $(__UseFloatPrintf) $(__UseFloatScanf)
OBJ_OPT2 = -O0 -ffunction-sections -fdata-sections -c
ASM_OPT = -g -Wall -mcpu=$(_armCortex) -std=$(_std) -mthumb -x assembler-with-cpp -c

#
# USE --specs=rdimon.specs if code have printf
# else use --specs=nosys.specs 
#
 
ELF_OPT = -mcpu=$(_armCortex) -mthumb --specs=nano.specs --specs=nosys.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard $(__UseFloatPrintf) $(__UseFloatScanf)
ELF_OPT2 = -Wl,--no-warn-rwx-segment
ELF_OPT3 = -Wl,--gc-sections -static 

#	[ CMD | ALL ]	----------------------------------------------------------------------------------------------------------
all: help

testP:
	@pwsh -WorkingDirectory $(PathProject)

#	[ CMD | RUN AS ]	------------------------------------------------------------------------------------------------------
runas: build flashP

#	[ CMD | CREATE ]	------------------------------------------------------------------------------------------------------
create:
	@echo.
	@echo [ STM32 ^| Makefile ^| CREATE ] ----------------------------------------------------------------------
	@echo ----------------------------------------------------------------------------------------------------
	@if not exist "$(subst /,\,$(PathBuild))" (echo   ----^>  BUILD FOLDER IS NOT FOUND! CREATING FOLDER.)
	@if not exist "$(subst /,\,$(PathBuild))" (mkdir $(subst /,\,$(PathObj)) $(subst /,\,$(PathObjS)));else echo   ----^>  BUILD FOLDER IS EXIST!
	@echo.


#	[ CMD | CLEAN FILES ]	---------------------------------------------------------------------------------------------------
cleanF:
	@echo.
	@echo [ STM32 ^| Makefile ^| CLEAN FILES ] -----------------------------------------------------------------
	@echo ----------------------------------------------------------------------------------------------------
	@for /R $(subst /,\,$(PathBuild)) %%f in (*.o;*) do del /F /Q "%%f"
	@echo   ----^>  FILES IS CLEANED!
	@echo.


#	[ CMD | CLEAN BUILT FOLDER ]	------------------------------------------------------------------------------------------
clean:
	@echo.
	@echo [ STM32 ^| Makefile ^| CLEAN BUILT FOLDER ] ----------------------------------------------------------
	@echo ----------------------------------------------------------------------------------------------------
	@rmdir /S /Q $(subst /,\,$(PathBuild))
	@echo   ----^>  FOLDER IS CLEANED!
	@echo.


#	[ CMD | CHECK ]	----------------------------------------------------------------------------------------------------------
check:
	@cls
	@echo.
	@echo [ STM32 ^| Makefile ^| CHECK ] -----------------------------------------------------------------------
	@echo ----------------------------------------------------------------------------------------------------
	@echo.
	@if exist "$(subst /,\,$(PathBuild))" (echo   ----^>  BUILD FOLDER IS EXIST!); else (echo   ----^>  BUILD FOLDER IS NOT FOUND! CREATING FOLDER.)
	@if not exist "$(subst /,\,$(PathBuild))" (echo   ----^>  FOLDER CREATED!)
	@if exist "$(subst /,\,$(PathBuild))" (for /R $(subst /,\,$(PathBuild)) %%f in (*.o;*) do del /F /Q "%%f");\
	else (mkdir $(subst /,\,$(PathObj)) $(subst /,\,$(PathObjS)))
	@echo.
	@echo  ***********************************
	@echo.
	@echo   ----^>  CHECKING IS DONE!
	@echo.


#	[ CMD | COMPILE ]	------------------------------------------------------------------------------------------------------
compile: check compileInfo $(DepMain) $(S_ObjFile) $(ObjFiles) $(ObjMain)  compileInfoDone

compileInfo:
	@echo.
	@echo [ STM32 ^| Makefile ^| COMPILE ] ---------------------------------------------------------------------
	@echo ----------------------------------------------------------------------------------------------------
	@echo.
	@echo   *** Project Name           :  $(ProjectName)
	@echo.
	@echo   *** Files Address:
	@echo 	- Main file          :  $(MainFile)
	@echo 	- Header main file   :  $(MainHeader)
	@echo 	- Header files       :  $(HeaderFiles)
	@echo 	- Source files       :  $(SourceFiles)
	@echo 	- Startup file       :  $(StartupFile)
	@echo 	- Linker file        :  $(LDFile)
	@echo.
	@echo   ----^>  STARTING COMPILING PROJECT!
	@echo   ----^>  USE "$(CC)" COMPILER.
	@echo.

compileInfoDone:
	@echo.
	@echo   *** Object Files Address:
	@echo.
	@echo 	- Object Main        :  $(ObjMain)
	@echo 	- Object Files       :  $(ObjFiles)
	@echo 	- Object Startup     :  $(S_ObjFile)
	@echo.
	@echo   ----^>  COMPILING IS DONE!
	@echo.


#	[ CMD | BUILD ]	----------------------------------------------------------------------------------------------------------
build: compile buildInfo $(ElfFile) buildDone toBIN toHEX toLIST mapInfo size buildInfoDone


buildInfo:
	@echo.
	@echo [ STM32 ^| Makefile ^| BUILD ] -----------------------------------------------------------------------
	@echo ----------------------------------------------------------------------------------------------------
	@echo.
	@echo   ----^>  STARTING BUILDING PROJECT!
	@echo.

buildDone:
	@echo  ***********************************
	@echo.
	@echo   ----^>  BUILDING IS DONE!
	@echo.

buildInfoDone:
	@echo.
	@echo.
	@echo ====================================================================================================
	@echo ====================================================================================================
	@echo.
	@echo ==                                  -#- STM32 Makefile -#-                                        ==
	@echo ==                                 -#- Written by [TqK] -#-                                       ==
	@echo.
	@echo ====================================================================================================
	@echo ====================================================================================================
	@echo.

##	[BUILD | CMD | BIN]	-------------------------------------------------------------------------------------

toBIN: toBINinfo $(BinFile) toBINinfoDone
	
toBINinfo:
	@echo.
	@echo   ^## [ STM32 ^| Makefile ^| BUILD ^| TO BIN ] ---------------------------------------------------------
	@echo ----------------------------------------------------------------------------------------------------

toBINinfoDone:
	@echo.
	@echo       *** Binary Project File Address:
	@echo.
	@echo         - Bin Project File   :  $(BinFile)
	@echo.
	@echo    ----^>  OBJCOPY TO BIN IS DONE!
	@echo.


##	[BUILD | CMD | HEX]	-------------------------------------------------------------------------------------
toHEX: toHEXinfo $(HexFile) toHEXinfoDone


toHEXinfo:
	@echo.
	@echo   ^## [ STM32 ^| Makefile ^| BUILD ^| TO HEX ] ---------------------------------------------------------
	@echo ----------------------------------------------------------------------------------------------------

toHEXinfoDone:
	@echo.
	@echo       *** Hexadecima Project File Address:
	@echo.
	@echo         - Hex Project File   :  $(HexFile)
	@echo.
	@echo    ----^>  OBJCOPY TO HEX IS DONE!
	@echo.

##	[BUILD | CMD | LIST] ------------------------------------------------------------------------------------
toLIST: toLISTinfo $(ListFile) toLISTinfoDone


toLISTinfo:
	@echo.
	@echo   ^## [ STM32 ^| Makefile ^| BUILD ^| TO LIST ] --------------------------------------------------------
	@echo ----------------------------------------------------------------------------------------------------

toLISTinfoDone:
	@echo.
	@echo       *** List Project File Address:
	@echo.
	@echo         - List Project File  :  $(ListFile)
	@echo.
	@echo    ----^>  OBJDUMP TO LIST IS DONE!
	@echo.

##	[BUILD | CMD | SIZE] ------------------------------------------------------------------------------------
size:
	@echo.
	@echo   ^## [ STM32 ^| Makefile ^| BUILD ^| SIZE ] -----------------------------------------------------------
	@echo ----------------------------------------------------------------------------------------------------
	@echo.
	@echo.
	@if not exist "$(ElfFile)" (echo   ----^>  DONT HAVE THE ELF FILE. PLEASE REBUILD THE PROJECT!)
	@if exist "$(ElfFile)" (size "$(ElfFile)")
	@echo.
	@echo.
	@if exist "$(ElfFile)" 	(echo   ----^>  MAY UPLOAD YOUR CODE WITH CMD "make upload")
	@echo.	

##	[BUILD | CMD | MAP] ------------------------------------------------------------------------------------
mapInfo:
	@echo.
	@echo   ^## [ STM32 ^| Makefile ^| BUILD ^| TO MAP ] ---------------------------------------------------------
	@echo ----------------------------------------------------------------------------------------------------
	@echo.
	@echo      ##  ---
	@echo          ^|
	@echo          ^| Converting to $(notdir $(MapFile))
	@echo          ^|
	@echo          ---
	@echo            ---^>  Done!
	@echo.
	@echo       *** Map Project File Address:
	@echo.
	@echo         - Map Project File   :  $(MapFile)
	@echo.
	@echo    ----^>  CONVERTING IS DONE TO MAP FILE!
	@echo.

##	[BUILD | CMD | OPEN] -----------------------------------------------------------------------------------
open:
	@echo.
	@echo [ STM32 ^| Makefile ^| OPEN ] ------------------------------------------------------------------------
	@echo ----------------------------------------------------------------------------------------------------
	@echo.
	@echo    ----^>  OPENING $(PathBin)
	@echo.
	@-explorer.exe /n,$(subst /,\\,$(PathBin))
	@echo  ***********************************
	@echo.
	@echo    ----^>  THE FOLDER IS OPENED!
	@echo.


#	[ CMD | RUN GNU ]	------------------------------------------------------------------------------------------------------

$(DepFiles):
	@$(CC) $(OBJ_OPT) $(foreach _pathHeaderColect,$(_pathHeaderColect),-I$(_pathHeaderColect)) -MM $(subst $(PathBuild),..,$(subst .d,.$(_extSourceFile), $(@))) -MF $(@)
	
$(DepMain): $(DepFiles)
	@$(CC) $(OBJ_OPT) $(foreach _pathHeaderColect,$(_pathHeaderColect),-I$(_pathHeaderColect)) -MM $(subst $(PathBuild),..,$(subst .d,.$(_extSourceFile), $(@))) -MF $(@)

# $(ObjFiles):
# 	@echo $(CC) $(OBJ_OPT) -I$(dir $(foreach HeaderFiles,$(HeaderFiles),$(if $(findstring $(subst .o,,$(@F)),$(HeaderFiles)),$(subst *,,$(HeaderFiles)))))\
# 	 $(OBJ_OPT2) $(subst $(PathBuild),.,$(subst .o,.$(_extSourceFile),$(@))) -o $(@)

########## @ECHO

$(ObjFiles):
	@echo.
	@echo      ##  ---
	@echo          ^|
	@echo          ^| Compiling $(subst $(PathBuild),..,$(subst .o,.$(_extSourceFile),$(@)))
	@echo          ^|
	@echo          ---
	@$(CC) $(OBJ_OPT) $(foreach _pathHeaderColect,$(_pathHeaderColect),-I$(_pathHeaderColect))\
	 $(OBJ_OPT2) $(subst $(PathBuild),..,$(subst .o,.$(_extSourceFile),$(@))) -MMD -MP -MF $(@:%o=%d) -o $(@)
	@echo            ---^>  Done!
	@echo.

$(ObjMain):
	@echo.
	@echo      ##  ---
	@echo          ^|
	@echo          ^| Compiling $(subst $(PathBuild),..,$(subst .o,.$(_extSourceFile),$(@)))
	@echo          ^|
	@echo          ---
	@$(CC) $(OBJ_OPT) $(foreach _pathHeaderColect,$(_pathHeaderColect),-I$(_pathHeaderColect)) $(OBJ_OPT2) $(subst $(PathBuild),..,$(subst .o,.$(_extSourceFile), $(@))) -MMD -MP -MF $(@:%o=%d) -o $(@)
	@echo            ---^>  Done!
	@echo.

$(S_ObjFile):
	@echo.
	@echo      ##  ---
	@echo          ^|
	@echo          ^| Compiling $(subst $(PathBuild),..,$(subst .o,.$(_extStartFile),$(@)))
	@echo          ^|
	@echo          ---
	@$(CC) $(ASM_OPT) $(subst $(PathBuild),..,$(subst .o,.$(_extStartFile), $(@))) -o $(@)
	@echo            ---^>  Done!
	@echo.

$(ElfFile):
	@echo.
	@echo      ##  ---
	@echo          ^|
	@echo          ^| Building $(notdir $(@))
	@echo          ^|
	@echo          ---
	@$(CC) $(ObjFiles) $(ObjMain) $(S_ObjFile) $(ELF_OPT) -T$(LDFile) $(ELF_OPT2),-Map=$(MapFile) $(ELF_OPT3) -o $(@)
	@echo            ---^>  Done!
	@echo.

$(BinFile):
	@echo.
	@echo      ##  ---
	@echo          ^|
	@echo          ^| Objcoping to $(notdir $(@))
	@echo          ^|
	@echo          ---
	@$(OBJ_CP) -O binary $(ElfFile) $(@)
	@echo            ---^>  Done!
	@echo.

$(HexFile):
	@echo.
	@echo      ##  ---
	@echo          ^|
	@echo          ^| Objcoping to $(notdir $(@))
	@echo          ^|
	@echo          ---
	@$(OBJ_CP) -O ihex $(ElfFile) $(@)
	@echo            ---^>  Done!
	@echo.

$(ListFile):
	@echo.
	@echo      ##  ---
	@echo          ^|
	@echo          ^| Objcoping to $(notdir $(@))
	@echo          ^|
	@echo          ---
	@$(OBJ_DP) -h -S $(ElfFile) > $(@)
	@echo            ---^>  Done!
	@echo.


########## NOT @ECHO

# $(ObjFiles):
# 	@echo.
# 	@echo      ##  [ Compiling $(subst $(PathBuild),..,$(subst .o,.$(_extSourceFile),$(@))) ]
# 	@$(CC) $(OBJ_OPT) $(foreach _pathHeaderColect,$(_pathHeaderColect),-I$(_pathHeaderColect))\
# 	 $(OBJ_OPT2) $(subst $(PathBuild),..,$(subst .o,.$(_extSourceFile),$(@))) -o $(@)
# 	@echo.

# $(ObjMain):
# 	@echo.
# 	@echo      ##  [ Compiling $(subst $(PathBuild),..,$(subst .o,.$(_extSourceFile),$(@))) ]
# 	@$(CC) $(OBJ_OPT) $(foreach _pathHeaderColect,$(_pathHeaderColect),-I$(_pathHeaderColect)) $(OBJ_OPT2) $(subst $(PathBuild),..,$(subst .o,.$(_extSourceFile), $(@))) -o $(@)
# 	@echo.

# $(S_ObjFile):
# 	@echo.
# 	@echo      ##  [ Compiling $(subst $(PathBuild),..,$(subst .o,.$(_extStartFile),$(@))) ]
# 	@$(CC) $(ASM_OPT) $(subst $(PathBuild),..,$(subst .o,.$(_extStartFile), $(@))) -o $(@)
# 	@echo.

# $(ElfFile):
# 	@echo.
# 	@echo      ##  [ Building $(@) ]
# 	@$(CC) $(ObjFiles) $(ObjMain) $(S_ObjFile) $(ELF_OPT) -T$(LDFile) $(ELF_OPT2),-Map=$(MapFile) $(ELF_OPT3) -o $(@)
# 	@echo.

# $(BinFile):
# 	@echo.
# 	@echo      ##  [ Objcoping to $(@) ]
# 	@$(OBJ_CP) -O binary $(ElfFile) $(@)
# 	@echo.

# $(HexFile):
# 	@echo.
# 	@echo      ##  [ Objcoping $(@) ]
# 	@$(OBJ_CP) -O ihex $(ElfFile) $(@)
# 	@echo.

# $(ListFile):
# 	@echo.
# 	@echo      ##  [ Objcoping $(@) ]
# 	@$(OBJ_DP) -h -S $(ElfFile) > $(@)
# 	@echo.



#	[ CMD | UPLOAD ]	------------------------------------------------------------------------------------------------------
flash:
	@echo.
	@echo [ STM32 ^| Makefile ^| UPLOAD ] ----------------------------------------------------------------------
	@echo ----------------------------------------------------------------------------------------------------
	@echo.
	@$(oPRGER) -c SWD -P $(HexFile) -V -TVolt -Rst
	@echo.
	@echo    ----^>  UPLOADING IS DONE!
	@echo.

flashP:
	@echo.
	@echo [ STM32 ^| Makefile ^| UPLOAD ] ----------------------------------------------------------------------
	@echo ----------------------------------------------------------------------------------------------------
	@echo.
	@$(PRGER) -c port=SWD -d $(HexFile) -rst
	@echo.
	@echo    ----^> UPLOADING IS DONE!
	@echo.	

#	[ CMD | READ REGISTER ]	--------------------------------------------------------------------------------------------------
readMem-%:
	@echo.
	@echo [ STM32 ^| Makefile ^| READ 8 BYTES ] ----------------------------------------------------------------
	@echo ----------------------------------------------------------------------------------------------------
	@echo.
	@$(oPRGER) -c SWD -r8 $(subst readMem-,,$(@)) 10
	@echo    ----^>  READING IS DONE!
	@echo.

readMemP-%:
	@echo.
	@echo [ STM32 ^| Makefile ^| READ 8 BYTES ] ----------------------------------------------------------------
	@echo ----------------------------------------------------------------------------------------------------
	@echo.
	@$(PRGER) -c port=SWD -r8 $(subst readMemP-,,$(@)) 10
	@echo    ----^>  READING IS DONE!
	@echo.

readRegP:
	@echo.
	@echo [ STM32 ^| Makefile ^| READ REGISTER ] ---------------------------------------------------------------
	@echo ----------------------------------------------------------------------------------------------------
	@echo.
	@$(PRGER) -c port=SWD -regdump ../Debug/Reg-$(_armCortex).log
	@echo    ----^> READING IS DONE!
	@echo.	
	@-explorer.exe /n,..\\$(subst ../,,$(PathBuild))
	@echo.
	@echo.	

#	[ CMD | MCU PROPERTIES ]	----------------------------------------------------------------------------------------------
properties:
	@echo.
	@echo [ STM32 ^| Makefile ^| PROPERTIES ] ------------------------------------------------------------------
	@echo ----------------------------------------------------------------------------------------------------
	@echo.
	@$(oPRGER) -c SWD -List
	@echo    ----^>  DONE!
	@echo.

propertiesP:
	@echo.
	@echo [ STM32 ^| Makefile ^| PROPERTIES ] ------------------------------------------------------------------
	@echo ----------------------------------------------------------------------------------------------------
	@echo.
	@$(PRGER) -c port=SWD --list
	@echo    ----^>  DONE!
	@echo.

#	[ CMD | PRINT LOG ]	------------------------------------------------------------------------------------------------------
log-%:
	@echo.
	@echo [ STM32 ^| Makefile ^| LOG ] -------------------------------------------------------------------------
	@echo ----------------------------------------------------------------------------------------------------
	@echo.
	@echo $($(subst log-,,$@))
	@echo.

#	[ CMD | CLEAR ]	----------------------------------------------------------------------------------------------------------
clear:
	@cls


#	[ CMD | HELP ]	----------------------------------------------------------------------------------------------------------
help:
	@cls
	@echo.
	@echo [ STM32 ^| Makefile ^| HELP ] ------------------------------------------------------------------------
	@echo ----------------------------------------------------------------------------------------------------
	@echo.
	@echo  * The MAKEFILE file is the same address of Main project file.
	@echo  * Built project  : {WorkspaceFolder} / $(subst ../,,$(PathBuild))
	@echo  * Form project   :
	@echo         ^|
	@echo         ^|-- {WorkspaceFolder}
	@echo               ^|
	@echo               ^|-- Core
	@echo                   ^|
	@echo                   ^|-- Inc
	@echo                   ^|-- Src
	@echo                   ^|-- {StartupFile Folder}
	@echo               ^|
	@echo               ^|-- Drivers
	@echo                   ^|
	@echo                   ^|-- Inc
	@echo                   ^|-- Src
	@echo               ^|
	@echo               ^|-- {Linker File}
	@echo.
	@echo [ STM32 ^| Makefile ^| CLI ] -------------------------------------------------------------------------
	@echo ----------------------------------------------------------------------------------------------------
	@echo.
	@echo  1 - [ make compile       ] : to compile the project
	@echo  2 - [ make build         ] : to build the project
	@echo  3 - [ make upload        ] : to upload your code
	@echo  4 - [ make clean         ] : to delete the BUILD folder
	@echo                           *-----*
	@echo  5 - [ make flashP        ] : to program the hex file to MCU
	@echo  6 - [ make readMemP-addr ] : to read memory address of MCU
	@echo  7 - [ make readRegP      ] : to read peripheral register of MCU
	@echo  8 - [ make propertiesP   ] : to check MCU properties
	@echo.
	@echo ----------------------------------------------------------------------------------------------------
	@echo ----------------------------------------------------------------------------------------------------
	@echo.
	@echo                        		     -#- STM32 Makefile -#-
	@echo                        		    -#- Written by [TqK] -#-
	@echo.
	@echo ----------------------------------------------------------------------------------------------------
	@echo ----------------------------------------------------------------------------------------------------
	@echo.