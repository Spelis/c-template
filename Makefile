TARGET    := $(shell basename $(shell pwd))

CC        ?= cc
AR        ?= ar
DBG       ?= gdb

CPPFLAGS  ?=
CFLAGS    ?= -Wall -Wextra -O2
LDFLAGS   ?=
LDLIBS    ?=

SRC_DIR   ?= src
SRC       := $(shell find $(SRC_DIR) -name '*.c')
OBJ       := $(SRC:$(SRC_DIR)/%.c=build/%.o)
BUILD_DIR ?= build

build: dirs build/$(TARGET)

# Link
$(BUILD_DIR)/$(TARGET): $(OBJ)
	$(CXX) $(OBJ) $(LDFLAGS) $(LDLIBS) -o $@

# Compile C
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -MMD -MP -c $< -o $@

.PHONY: clean run debug

dirs:
	@mkdir -p build/ $(sort $(dir $(OBJ)))

run: build
	./$(BUILD_DIR)/$(TARGET)

debug:
	$(MAKE) CFLAGS="-g -O0" LDFLAGS="-g" build
	$(DBG) ./$(BUILD_DIR)/$(TARGET)

clean:
	rm -rf build


