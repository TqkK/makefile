.PHONY: all check compile build run create clean cleanF log help

#### PATH OF MAIN
MAIN_PATH=.

MAIN_INCLUDE_PATH=$(MAIN_PATH)

#### PATH OF SRC
# Header files are the same position of Cpp files
LIB_PATH=LIB
SRC_PATH=$(LIB_PATH)/INOUT
#SRC_PATH+=$(LIB_PATH)/Ticket
#SRC_PATH+=$(LIB_PATH)/Passenger

#### PATH OF BUILD
BUILD_PATH=BUILD
BIN_PATH=$(BUILD_PATH)/BIN
OBJ_PATH=$(BUILD_PATH)/OBJ/LIB
OBJ_MAIN_PATH=$(BUILD_PATH)/OBJ

#------ MAIN FILE
MAIN_FILE=$(wildcard $(MAIN_PATH)/*.cpp)
MAIN_NAME_EXT=$(notdir $(MAIN_FILE))
MAIN_NAME=$(subst .cpp,,$(MAIN_NAME_EXT))

MAIN_OBJ=$(OBJ_MAIN_PATH)/$(MAIN_NAME).o


#------ SRC FILE
SRC_FILE=$(foreach SRC_PATH,$(SRC_PATH),$(wildcard $(SRC_PATH)/*.cpp))
SRC_NAME_EXT=$(foreach SRC_FILE,$(SRC_FILE),$(notdir $(SRC_FILE)))
SRC_NAME=$(subst .cpp,,$(SRC_NAME_EXT))

SRC_OBJ:=$(foreach SRC_NAME,$(SRC_NAME),$(OBJ_PATH)/$(SRC_NAME).o)


#------ EXECUTABLE FILE
EXE_FILE=$(BIN_PATH)/$(MAIN_NAME).exe

#--------------------------------------------------------------
CC = g++
CFLAGS = -Wall -g
LIBS = -lm

all: checkDIR
#============= CHECK CMD
check:
	@if exist "$(BUILD_PATH)" (for /R $(BUILD_PATH) %%f in (*.o;*) do del /F /Q "%%f");else (mkdir $(subst /,\,$(BIN_PATH));$(subst /,\,$(OBJ_PATH)))

#============= COMPILE CMD
compile: check $(SRC_OBJ) $(MAIN_OBJ)
	@echo --- COMPILE DONE---

#============= BUILD CMD
build: compile $(EXE_FILE)
	@echo --- BUILD DONE and MAY RUN PROJECT WITH "make run".---

$(SRC_OBJ):
	$(CC) $(CFLAGS) -I $(@:$(OBJ_PATH)/%.o=$(LIB_PATH)/%)/ -c $(@:$(OBJ_PATH)/%.o=$(LIB_PATH)/%)/$(@F:%.o=%.cpp) -o $@

$(MAIN_OBJ):$(MAIN_FILE)
	$(CC) $(CFLAGS) -I $(MAIN_INCLUDE_PATH)/ -c $< -o $@

# @echo $(CC) $(CFLAGS) -o $@ $(MAIN_FILE) $(SRC_OBJ) $(LIBS)
$(EXE_FILE):
	$(CC) $(CFLAGS) -o $@ $(MAIN_OBJ) $(SRC_OBJ) $(LIBS)

#============= RUN CMD
run: 
	@echo.
	@echo ----------------------- RUN PROJECT -----------------------
	@if exist "$(EXE_FILE)" ("$(EXE_FILE)");else (echo EXECUTABLE FILE DO NOT EXIST!)

#============= CREATE CMD
create:
	@if not exist "$(BUILD_PATH)" (mkdir $(subst /,\,$(BIN_PATH));$(subst /,\,$(OBJ_PATH)));else echo (FOLDER EXIST!)

#============= CLEAN CMD
clean:
	@rmdir /S /Q $(BUILD_PATH)
	@echo --- CLEAN FOLDER DONE ---

cleanF:
	@for /R $(BUILD_PATH) %%f in (*.o;*) do del /F /Q "%%f"
	@echo --- CLEAN FILES DONE ---

#============= PRINT CMD
log-%:
	@echo $($(subst log-,,$@))

#============= HELP CMD
help:
	@echo 1 - [make compile]: to compile the project
	@echo 2 - [make build]: to build the project
	@echo 3 - [make run]: to run the project
	@echo 4 - [make clean]: to delete the BUILD folder

