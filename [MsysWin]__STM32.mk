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
	@printf "\n\033[0;36m"
	@printf "[ STM32 | Makefile | CREATE ] ----------------------------------------------------------------------"
	@printf "\n----------------------------------------------------------------------------------------------------"
	@printf "\033[0;37m"
	@if [ ! -d "$(PathBuild)" ]; then (printf "\n   ---->  BUILD FOLDER IS NOT FOUND! CREATING FOLDER.\n"); else (printf "\n   ---->  BUILD FOLDER IS EXIST!\n");fi
	@if [ ! -d "$(PathBuild)" ]; then (mkdir -p $(PathObj) $(PathObjS));fi
	@printf "\n"


#	[ CMD | CLEAN FILES ]	---------------------------------------------------------------------------------------------------
cleanF:
	@printf "\n\033[0;36m"
	@printf "[ STM32 | Makefile | CLEAN FILES ] -----------------------------------------------------------------"
	@printf "\n----------------------------------------------------------------------------------------------------"
	@printf "\033[0;37m"
	@rm -rf $(PathBuild)/
	@printf "\n\n   ---->  FILES IS CLEANED!\n\n"

#	[ CMD | CLEAN BUILT FOLDER ]	------------------------------------------------------------------------------------------
clean:
	@printf "\\033[0;36mn"
	@printf "[ STM32 | Makefile | CLEAN BUILT FOLDER ] ----------------------------------------------------------"
	@printf "\n----------------------------------------------------------------------------------------------------"
	@printf "\033[0;37m"
	@rm -rf $(PathBuild)/*
	@printf "\n\n   ---->  FOLDER IS CLEANED!\n\n"


#	[ CMD | CHECK ]	----------------------------------------------------------------------------------------------------------
check:
	@cls
	@printf "\n\033[0;36m"
	@printf "[ STM32 | Makefile | CHECK ] -----------------------------------------------------------------------"
	@printf "\n----------------------------------------------------------------------------------------------------"
	@printf "\n\033[0;37m"
	@if [ -d "$(PathBuild)" ]; then (rm -rf $(PathBuild)/*; mkdir -p $(PathObj) $(PathObjS));fi 
	@if [ ! -d "$(PathBuild)" ]; then (printf "\n   ---->  BUILD FOLDER IS NOT FOUND! CREATING FOLDER.\n"); else (printf "\n   ---->  BUILD FOLDER IS EXIST!\n");fi
	@if [ ! -d "$(PathBuild)" ]; then (printf "   ---->  FOLDER CREATED!");fi 
	@if [ ! -d "$(PathBuild)" ]; then (mkdir -p $(PathObj) $(PathObjS));fi 
	@printf "\n"
	@printf "\n\033[43m**********************************************************************\033[40m"
	@printf "\n\n   ---->  CHECKING IS DONE!\n\n"


#	[ CMD | COMPILE ]	------------------------------------------------------------------------------------------------------
compile: check compileInfo $(DepMain) $(S_ObjFile) $(ObjFiles) $(ObjMain)  compileInfoDone

compileInfo:
	@printf "\n\033[0;36m"
	@printf "[ STM32 | Makefile | COMPILE ] ---------------------------------------------------------------------"
	@printf "\n----------------------------------------------------------------------------------------------------"
	@printf "\n\033[0;37m"
	@printf "\n   *** Project Name          :  $(ProjectName)"
	@printf "\n"
	@printf "\n   *** Files Address:"
	@printf "\n 	- Main file          :  $(MainFile)"
	@printf "\n\n 	- Header main file   :  $(MainHeader)"
	@printf "\n\n 	- Header files       :  $(HeaderFiles)"
	@printf "\n\n 	- Source files       :  $(SourceFiles)"
	@printf "\n\n 	- Startup file       :  $(StartupFile)"
	@printf "\n\n 	- Linker file        :  $(LDFile)"
	@printf "\n"
	@printf "\n\n\033[0;32m       ====>  USE "$(CC)" COMPILER.\n\033[0;37m"
	@printf "\n\033[43m**********************************************************************\033[40m"
	@printf "\n\n\033[1;35m       ====>  STARTING COMPILING PROJECT!\033[0;37m"
	@printf "\n\033[0;37m"

compileInfoDone:
	@printf "\n"
	@printf "\n   *** Object Files Address:"
	@printf "\n"
	@printf "\n 	- Object Main        :  $(ObjMain)"
	@printf "\n\n 	- Object Files       :  $(ObjFiles)"
	@printf "\n\n 	- Object Startup     :  $(S_ObjFile)"
	@printf "\n\033[0;32m"
	@printf "\n       ====>  COMPILING IS DONE!\n"
	@printf "\n\033[0;37m"


#	[ CMD | BUILD ]	----------------------------------------------------------------------------------------------------------
build: compile buildInfo $(ElfFile) buildDone toBIN toHEX toLIST mapInfo size buildInfoDone


buildInfo:
	@printf "\n\033[0;36m"
	@printf "[ STM32 | Makefile | BUILD ] -----------------------------------------------------------------------"
	@printf "\n----------------------------------------------------------------------------------------------------"
	@printf "\n\033[0;37m"
	@printf "\n\033[1;35m       ====>  STARTING BUILDING PROJECT!\n"
	@printf "\n\033[0;37m"

buildDone:
	@printf "\n\033[43m**********************************************************************\033[40m"
	@printf "\n\033[0;32m"
	@printf "\n       ====>  BUILDING IS DONE!\n"
	@printf "\n\033[0;37m"

buildInfoDone:
	@printf "\n\033[1;36m"
	@printf "\n ===================================================================================================="
	@printf "\n\033[1;32m"
	@printf "\n                                    -#- STM32 Makefile -#-"
	@printf "\n                                   -#- Written by [TqK] -#-"
	@printf "\n\033[1;36m"
	@printf "\n ===================================================================================================="
	@printf "\n\n\033[0;37m"

##	[BUILD | CMD | BIN]	-------------------------------------------------------------------------------------

toBIN: toBINinfo $(BinFile) toBINinfoDone
	
toBINinfo:
	@printf "\n\n\033[0;36m"
	@printf "   ## [ STM32 | Makefile | BUILD | TO BIN ] ---------------------------------------------------------"
	@printf "\n ----------------------------------------------------------------------------------------------------"
	@printf "\033[0;37m"

toBINinfoDone:
	@printf "\n"
	@printf "       *** Binary Project File Address:"
	@printf "\n"
	@printf "         - Bin Project File   :  $(BinFile)"
	@printf "\n\033[0;32m"
	@printf "\n       ====>  OBJCOPY TO BIN IS DONE!"
	@printf "\n\n\033[0;37m"


##	[BUILD | CMD | HEX]	-------------------------------------------------------------------------------------
toHEX: toHEXinfo $(HexFile) toHEXinfoDone


toHEXinfo:
	@printf "\n\033[0;36m"
	@printf "   ## [ STM32 | Makefile | BUILD | TO HEX ] ---------------------------------------------------------"
	@printf "\n ----------------------------------------------------------------------------------------------------"
	@printf "\033[0;37m"

toHEXinfoDone:
	@printf "\n"
	@printf "       *** Hexadecima Project File Address:"
	@printf "\n"
	@printf "         - Hex Project File   :  $(HexFile)"
	@printf "\n\033[0;32m"
	@printf "\n       ====>  OBJCOPY TO HEX IS DONE!"
	@printf "\n\n\033[0;37m"

##	[BUILD | CMD | LIST] ------------------------------------------------------------------------------------
toLIST: toLISTinfo $(ListFile) toLISTinfoDone


toLISTinfo:
	@printf "\n\033[0;36m"
	@printf "   ## [ STM32 | Makefile | BUILD | TO LIST ] --------------------------------------------------------"
	@printf "\n ----------------------------------------------------------------------------------------------------"
	@printf "\033[0;37m"

toLISTinfoDone:
	@printf "\n"
	@printf "       *** List Project File Address:"
	@printf "\n"
	@printf "         - List Project File  :  $(ListFile)"
	@printf "\n\033[0;32m"
	@printf "\n       ====>  OBJDUMP TO LIST IS DONE!"
	@printf "\n\n\033[0;37m"

##	[BUILD | CMD | SIZE] ------------------------------------------------------------------------------------
size:
	@printf "\n\033[0;36m"
	@printf "   ## [ STM32 | Makefile | BUILD | SIZE ] -----------------------------------------------------------"
	@printf "\n ----------------------------------------------------------------------------------------------------"
	@printf "\n\033[0;37m"
	@printf "\n"
	@if [ ! -e "$(ElfFile)" ]; then (printf "   ---->  DONT HAVE THE ELF FILE. PLEASE REBUILD THE PROJECT!");fi
	@if [ -e "$(ElfFile)" ]; then (size "$(ElfFile)"; printf "\033[0;33m\n\n\t\t====>  MAY UPLOAD YOUR CODE WITH CMD make upload");fi
	@printf "\n\n\033[0;37m"	

##	[BUILD | CMD | MAP] ------------------------------------------------------------------------------------
mapInfo:
	@printf "\n\033[0;36m"
	@printf "   ## [ STM32 | Makefile | BUILD | TO MAP ] ---------------------------------------------------------"
	@printf "\n ----------------------------------------------------------------------------------------------------"
	@printf "\n\033[0;37m      ##  ---"
	@printf "\n          |"
	@printf "\n          | Converting to \033[1;33m$(notdir $(MapFile))\033[0;37m"
	@printf "\n          |"
	@printf "\n          ---"
	@printf "\n\033[1;36m            --->  Done!\033[0;37m"
	@printf "\n\n       *** Map Project File Address:"
	@printf "\n         - Map Project File   :  $(MapFile)"
	@printf "\n\n\033[0;32m       ====>  CONVERTING IS DONE TO MAP FILE!"
	@printf "\n\n\033[0;37m"

##	[BUILD | CMD | OPEN] -----------------------------------------------------------------------------------
open:
	@printf "\n\033[0;36m"
	@printf " [ STM32 | Makefile | OPEN ] ------------------------------------------------------------------------"
	@printf "\n ----------------------------------------------------------------------------------------------------"
	@printf "\n\033[0;37m    ---->  OPENING $(PathBin)"
	@printf "\n"
	@start "$(subst ../,..\,$(PathBin))"
	@printf "\n  ***********************************"
	@printf "\n\n    ---->  THE FOLDER IS OPENED!"
	@printf "\n\n"


#	[ CMD | RUN GNU ]	------------------------------------------------------------------------------------------------------

$(DepFiles):
	@$(CC) $(OBJ_OPT) $(foreach _pathHeaderColect,$(_pathHeaderColect),-I$(_pathHeaderColect)) -MM $(subst $(PathBuild),..,$(subst .d,.$(_extSourceFile), $(@))) -MF $(@)
	
$(DepMain): $(DepFiles)
	@$(CC) $(OBJ_OPT) $(foreach _pathHeaderColect,$(_pathHeaderColect),-I$(_pathHeaderColect)) -MM $(subst $(PathBuild),..,$(subst .d,.$(_extSourceFile), $(@))) -MF $(@)

# $(ObjFiles):
# 	@printf " $(CC) $(OBJ_OPT) -I$(dir $(foreach HeaderFiles,$(HeaderFiles),$(if $(findstring $(subst .o,,$(@F)),$(HeaderFiles)),$(subst *,,$(HeaderFiles)))))\
# 	 $(OBJ_OPT2) $(subst $(PathBuild),.,$(subst .o,.$(_extSourceFile),$(@))) -o $(@)

########## @printf "

$(ObjFiles):
	@printf "\n      ##  ---"
	@printf "\n          |"
	@printf "\n          | Compiling \033[1;33m$(subst $(PathBuild),..,$(subst .o,.$(_extSourceFile),$(@)))\033[0;37m"
	@printf "\n          |"
	@printf "\n          ---"
	@$(CC) $(OBJ_OPT) $(foreach _pathHeaderColect,$(_pathHeaderColect),-I$(_pathHeaderColect))\
	 $(OBJ_OPT2) $(subst $(PathBuild),..,$(subst .o,.$(_extSourceFile),$(@))) -MMD -MP -MF $(@:%o=%d) -o $(@)
	@printf "\n\033[1;36m            --->  Done!"
	@printf "\n\n\033[0;37m"

$(ObjMain):
	@printf "\n      ##  ---"
	@printf "\n          |"
	@printf "\n          | Compiling \033[1;33m$(subst $(PathBuild),..,$(subst .o,.$(_extSourceFile),$(@)))\033[0;37m"
	@printf "\n          |"
	@printf "\n          ---"
	@$(CC) $(OBJ_OPT) $(foreach _pathHeaderColect,$(_pathHeaderColect),-I$(_pathHeaderColect)) $(OBJ_OPT2) $(subst $(PathBuild),..,$(subst .o,.$(_extSourceFile), $(@))) -MMD -MP -MF $(@:%o=%d) -o $(@)
	@printf "\n\033[1;36m            --->  Done!"
	@printf "\n\n\033[0;37m"

$(S_ObjFile):
	@printf "\n      ##  ---"
	@printf "\n          |"
	@printf "\n          | Compiling \033[1;33m$(subst $(PathBuild),..,$(subst .o,.$(_extStartFile),$(@)))\033[0;37m"
	@printf "\n          |"
	@printf "\n          ---"
	@$(CC) $(ASM_OPT) $(subst $(PathBuild),..,$(subst .o,.$(_extStartFile), $(@))) -o $(@)
	@printf "\n\033[1;36m           --->  Done!"
	@printf "\n\n\033[0;37m"

$(ElfFile):
	@printf "\n      ##  ---"
	@printf "\n          |"
	@printf "\n          | Building \033[1;33m$(notdir $(@))\033[0;37m"
	@printf "\n          |"
	@printf "\n          ---"
	@$(CC) $(ObjFiles) $(ObjMain) $(S_ObjFile) $(ELF_OPT) -T$(LDFile) $(ELF_OPT2),-Map=$(MapFile) $(ELF_OPT3) -o $(@)
	@printf "\n\033[1;36m            --->  Done!"
	@printf "\n\n\033[0;37m"

$(BinFile):
	@printf "\n      ##  ---"
	@printf "\n          |"
	@printf "\n          | Objcoping to \033[1;33m$(notdir $(@))\033[0;37m"
	@printf "\n          |"
	@printf "\n          ---"
	@$(OBJ_CP) -O binary $(ElfFile) $(@)
	@printf "\n\033[1;36m            --->  Done!"
	@printf "\n\n\033[0;37m"

$(HexFile):
	@printf "\n      ##  ---"
	@printf "\n          |"
	@printf "\n          | Objcoping to \033[1;33m$(notdir $(@))\033[0;37m"
	@printf "\n          |"
	@printf "\n          ---"
	@$(OBJ_CP) -O ihex $(ElfFile) $(@)
	@printf "\n\033[1;36m            --->  Done!"
	@printf "\n\n\033[0;37m"

$(ListFile):
	@printf "\n      ##  ---"
	@printf "\n          |"
	@printf "\n          | Objcoping to \033[1;33m$(notdir $(@))\033[0;37m"
	@printf "\n          |"
	@printf "\n          ---"
	@$(OBJ_DP) -h -S $(ElfFile) > $(@)
	@printf "\n\033[1;36m            --->  Done!"
	@printf "\n\n\033[0;37m"


########## NOT @printf "

# $(ObjFiles):
# 	@printf "\n"
# 	@printf "      ##  [ Compiling $(subst $(PathBuild),..,$(subst .o,.$(_extSourceFile),$(@))) ]
# 	@$(CC) $(OBJ_OPT) $(foreach _pathHeaderColect,$(_pathHeaderColect),-I$(_pathHeaderColect))\
# 	 $(OBJ_OPT2) $(subst $(PathBuild),..,$(subst .o,.$(_extSourceFile),$(@))) -o $(@)
# 	@printf "\n"

# $(ObjMain):
# 	@printf "\n"
# 	@printf "      ##  [ Compiling $(subst $(PathBuild),..,$(subst .o,.$(_extSourceFile),$(@))) ]
# 	@$(CC) $(OBJ_OPT) $(foreach _pathHeaderColect,$(_pathHeaderColect),-I$(_pathHeaderColect)) $(OBJ_OPT2) $(subst $(PathBuild),..,$(subst .o,.$(_extSourceFile), $(@))) -o $(@)
# 	@printf "\n"

# $(S_ObjFile):
# 	@printf "\n"
# 	@printf "      ##  [ Compiling $(subst $(PathBuild),..,$(subst .o,.$(_extStartFile),$(@))) ]
# 	@$(CC) $(ASM_OPT) $(subst $(PathBuild),..,$(subst .o,.$(_extStartFile), $(@))) -o $(@)
# 	@printf "\n"

# $(ElfFile):
# 	@printf "\n"
# 	@printf "      ##  [ Building $(@) ]
# 	@$(CC) $(ObjFiles) $(ObjMain) $(S_ObjFile) $(ELF_OPT) -T$(LDFile) $(ELF_OPT2),-Map=$(MapFile) $(ELF_OPT3) -o $(@)
# 	@printf "\n"

# $(BinFile):
# 	@printf "\n"
# 	@printf "      ##  [ Objcoping to $(@) ]
# 	@$(OBJ_CP) -O binary $(ElfFile) $(@)
# 	@printf "\n"

# $(HexFile):
# 	@printf "\n"
# 	@printf "      ##  [ Objcoping $(@) ]
# 	@$(OBJ_CP) -O ihex $(ElfFile) $(@)
# 	@printf "\n"

# $(ListFile):
# 	@printf "\n"
# 	@printf "      ##  [ Objcoping $(@) ]
# 	@$(OBJ_DP) -h -S $(ElfFile) > $(@)
# 	@printf "\n"



#	[ CMD | UPLOAD ]	------------------------------------------------------------------------------------------------------
flash:
	@printf "\n\033[0;36m"
	@printf " [ STM32 | Makefile | UPLOAD ] ----------------------------------------------------------------------"
	@printf "\n ----------------------------------------------------------------------------------------------------"
	@printf "\n\033[0;37m"
	@$(oPRGER) -c SWD -P $(HexFile) -V -TVolt -Rst
	@printf "\n"
	@printf "\n\033[0;32m    ---->  UPLOADING IS DONE!"
	@printf "\n\n\033[0;37m"

flashP:
	@printf "\n\033[0;36m"
	@printf " [ STM32 | Makefile | UPLOAD ] ----------------------------------------------------------------------"
	@printf "\n ----------------------------------------------------------------------------------------------------"
	@printf "\n\033[0;37m"
	@$(PRGER) -c port=SWD -d $(HexFile) -rst
	@printf "\n"
	@printf "\n\033[0;32m    ----> UPLOADING IS DONE!"
	@printf "\n\n\033[0;37m"	

#	[ CMD | READ REGISTER ]	--------------------------------------------------------------------------------------------------
readMem-%:
	@printf "\n\033[0;36m"
	@printf " [ STM32 | Makefile | READ 8 BYTES ] ----------------------------------------------------------------"
	@printf "\n ----------------------------------------------------------------------------------------------------"
	@printf "\n\033[0;37m"
	@$(oPRGER) -c SWD -r8 $(subst readMem-,,$(@)) 10
	@printf "\n\033[0;32m    ---->  READING IS DONE!"
	@printf "\n\n\033[0;37m"

readMemP-%:
	@printf "\n\033[0;36m"
	@printf " [ STM32 | Makefile | READ 8 BYTES ] ----------------------------------------------------------------"
	@printf "\n ----------------------------------------------------------------------------------------------------"
	@printf "\n\033[0;37m"
	@$(PRGER) -c port=SWD -r8 $(subst readMemP-,,$(@)) 10
	@printf "\n\033[0;32m    ---->  READING IS DONE!"
	@printf "\n\n\033[0;37m"

readRegP:
	@printf "\n\033[0;36m"
	@printf " [ STM32 | Makefile | READ REGISTER ] ---------------------------------------------------------------"
	@printf "\n ----------------------------------------------------------------------------------------------------"
	@printf "\n\033[0;37m"
	@$(PRGER) -c port=SWD -regdump ../Debug/Reg-$(_armCortex).log
	@printf "\n\033[0;32m    ----> READING IS DONE!"
	@printf "\n\033[0;37m"	
	@start "$(subst ../,..\,$(PathBin))"
	@printf "\n"
	@printf "\n"	

#	[ CMD | MCU PROPERTIES ]	----------------------------------------------------------------------------------------------
properties:
	@printf "\n\033[0;36m"
	@printf " [ STM32 | Makefile | PROPERTIES ] ------------------------------------------------------------------"
	@printf "\n ----------------------------------------------------------------------------------------------------"
	@printf "\n\033[0;37m"
	@$(oPRGER) -c SWD -List
	@printf "\n\033[0;32m    ---->  DONE!"
	@printf "\n\n\033[0;37m"

propertiesP:
	@printf "\n\033[0;36m"
	@printf " [ STM32 | Makefile | PROPERTIES ] ------------------------------------------------------------------"
	@printf "\n ----------------------------------------------------------------------------------------------------"
	@printf "\n\033[0;37m"
	@$(PRGER) -c port=SWD --list
	@printf "\n\033[0;32m    ---->  DONE!"
	@printf "\n\n\033[0;37m"

#	[ CMD | PRINT LOG ]	------------------------------------------------------------------------------------------------------
log-%:
	@printf "\n\033[0;36m"
	@printf "\n[ STM32 | Makefile | LOG ] -------------------------------------------------------------------------"
	@printf "\n----------------------------------------------------------------------------------------------------\n"
	@printf "\n"
	@printf "$($(subst log-,,$@))\n"
	@printf "\n"

#	[ CMD | CLEAR ]	----------------------------------------------------------------------------------------------------------
clear:
	@clear


#	[ CMD | HELP ]	----------------------------------------------------------------------------------------------------------
help:
	@cls
	@printf "\n\033[0;36m"
	@printf " [ STM32 | Makefile | HELP ] ------------------------------------------------------------------------"
	@printf "\n ----------------------------------------------------------------------------------------------------"
	@printf "\n\033[0;37m"
	@printf "\n  * The MAKEFILE file is the same address of Main project file."
	@printf "\n  * Built project  : {WorkspaceFolder} / $(subst ../,,$(PathBuild))"
	@printf "\n  * Form project   :"
	@printf "\n         |"
	@printf "\n         |-- {WorkspaceFolder}"
	@printf "\n               |"
	@printf "\n               |-- Core"
	@printf "\n                   |"
	@printf "\n                   |-- Inc"
	@printf "\n                   |-- Src"
	@printf "\n                   |-- {StartupFile Folder}"
	@printf "\n               |"
	@printf "\n               |-- Drivers"
	@printf "\n                   |"
	@printf "\n                   |-- Inc"
	@printf "\n                   |-- Src"
	@printf "\n               |"
	@printf "\n               |-- {Linker File}"
	@printf "\n\033[0;36m"
	@printf "\n [ STM32 | Makefile | CLI ] -------------------------------------------------------------------------"
	@printf "\n ----------------------------------------------------------------------------------------------------"
	@printf "\n\033[0;37m"
	@printf "\n  1 - [ make compile       ] : to compile the project"
	@printf "\n  2 - [ make build         ] : to build the project"
	@printf "\n  3 - [ make upload        ] : to upload your code"
	@printf "\n  4 - [ make clean         ] : to delete the BUILD folder"
	@printf "\n                           *-----*"
	@printf "\n  5 - [ make flashP        ] : to program the hex file to MCU"
	@printf "\n  6 - [ make readMemP-addr ] : to read memory address of MCU"
	@printf "\n  7 - [ make readRegP      ] : to read peripheral register of MCU"
	@printf "\n  8 - [ make propertiesP   ] : to check MCU properties"
	@printf "\n\033[1;36m"
	@printf "\n ===================================================================================================="
	@printf "\n\033[1;32m"
	@printf "\n                                    -#- STM32 Makefile -#-"
	@printf "\n                                   -#- Written by [TqK] -#-"
	@printf "\n\033[1;36m"
	@printf "\n ===================================================================================================="
	@printf "\n\033[0;37m"