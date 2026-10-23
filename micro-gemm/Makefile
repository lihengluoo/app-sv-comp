# Build and run the micro-gemm concurrency-pattern suite.
#
#   make ir              capture every *.c to build/ir/*.ll (wllvm whole-program flow)
#   make native          compile and run every scalar benchmark natively (self-check);
#                        the *_simd.c benchmarks are analysis-only and are skipped
#                        unless NATIVE_SIMD=1 (they need an AVX-512 VNNI host)
#   make test            run delphi-compiler on every captured benchmark and score
#                        the results against the verdict table in run_suite.sh
#   make audit-externals diff the external functions the gemm app IR declares
#                        against the union of the suite IR; every app external
#                        must appear in the suite.  Linker --wrap artifacts
#                        (@__real_*) are harness plumbing, not app behavior,
#                        and are excluded.
#   make clean           remove the build and results artifacts
#
# CLANG, WLLVM and COMPILER default to tools on PATH and the sibling compiler
# build; override them on the command line or environment when that is wrong.
# IR capture itself always goes through the repository-wide build.sh.

CAPTURE ?= ../../../scripts/build.sh
CLANG ?= clang
WLLVM ?= wllvm
COMPILER ?= ../../../compiler/build/delphi-compiler
CC ?= cc

IR_DIR ?= build/ir
GEMM_IR ?= $(lastword $(wildcard ../../../results/gemm-race/*/ir/scalar.ll))

C_SOURCES := $(sort $(wildcard *.c))
SCALAR_SOURCES := $(filter-out %_simd.c %_simd_race.c,$(C_SOURCES))
IR_FILES := $(patsubst %.c,$(IR_DIR)/%.ll,$(C_SOURCES))

ifeq ($(NATIVE_SIMD),1)
NATIVE_SOURCES := $(C_SOURCES)
else
NATIVE_SOURCES := $(SCALAR_SOURCES)
endif

.PHONY: ir native test audit-externals clean

ir: $(IR_FILES)

native:
	@mkdir -p build/bin
	@for src in $(NATIVE_SOURCES); do \
	    stem=$${src%.c}; \
	    $(CC) -std=c11 -O2 -pthread -Wall "$$src" -o build/bin/$$stem || exit 1; \
	    ./build/bin/$$stem || exit 1; \
	done
	@if [ "$(NATIVE_SIMD)" != "1" ]; then \
	    for src in $(filter-out $(SCALAR_SOURCES),$(C_SOURCES)); do \
	        echo "SKIP $${src%.c} (analysis-only; NATIVE_SIMD=1 on an AVX-512 VNNI host)"; \
	    done; \
	fi

test: ir
	./run_suite.sh --compiler $(COMPILER) --ir-dir $(IR_DIR)

audit-externals: ir
	@if [ -z "$(GEMM_IR)" ]; then \
	    echo "no gemm IR found; run the gemm capture or set GEMM_IR=<scalar.ll>"; exit 1; \
	fi
	@suite_file=build/app_vs_suite/suite_externals.txt; \
	app_file=build/app_vs_suite/app_externals.txt; \
	mkdir -p build/app_vs_suite; \
	cat $(IR_DIR)/*.ll | grep -h '^declare' | grep -oE '@[A-Za-z0-9_.$$]+' | sort -u > $$suite_file; \
	grep -h '^declare' "$(GEMM_IR)" | grep -oE '@[A-Za-z0-9_.$$]+' | sort -u | \
	    grep -v '^@__real_' > $$app_file; \
	missing=$$(comm -23 $$app_file $$suite_file); \
	echo "gemm IR: $(GEMM_IR)"; \
	echo "app externals:"; cat $$app_file; echo; \
	if [ -z "$$missing" ]; then \
	    echo "coverage OK: every gemm external appears in the suite IR"; \
	else \
	    echo "UNCOVERED gemm externals:"; echo "$$missing"; exit 1; \
	fi

$(IR_DIR)/%.ll: %.c $(CAPTURE) | $(IR_DIR)
	$(CAPTURE) --clang $(CLANG) --wllvm $(WLLVM) --output-dir $(IR_DIR) $<

$(IR_DIR):
	mkdir -p $@

clean:
	rm -rf build results
