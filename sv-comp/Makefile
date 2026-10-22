# Build and run the sv-comp micro-benchmark suite.
#
#   make ir      capture every *.c to build/ir/*.ll (wllvm whole-program flow)
#   make test    build the IR, run the compiler on each benchmark and score
#                the results against verdicts.json
#   make clean   remove the build and results artifacts
#
# CLANG, WLLVM and COMPILER default to tools on PATH and the sibling compiler
# build; override them on the command line or environment when that is wrong.
# IR capture itself always goes through the repository-wide build.sh.

CAPTURE ?= ../../../scripts/build.sh
CLANG ?= clang
WLLVM ?= wllvm
COMPILER ?= ../../../compiler/build/delphi-compiler
PYTHON ?= python3

IR_DIR ?= build/ir

C_SOURCES := $(sort $(wildcard *.c))
IR_FILES := $(patsubst %.c,$(IR_DIR)/%.ll,$(C_SOURCES))

.PHONY: ir test clean

ir: $(IR_FILES)

test: ir
	$(PYTHON) run_sv_comp.py --compiler $(COMPILER) --ir-dir $(IR_DIR)

$(IR_DIR)/%.ll: %.c $(CAPTURE) | $(IR_DIR)
	$(CAPTURE) --clang $(CLANG) --wllvm $(WLLVM) --output-dir $(IR_DIR) $<

$(IR_DIR):
	mkdir -p $@

clean:
	rm -rf build results
