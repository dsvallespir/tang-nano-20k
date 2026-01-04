PROJECT = blinky
TOP = blinky
SOURCES = src/blinky.vhd
CONSTRAINTS = constraints/tang-nano.cst
BAORD= tangnano20k
CHIP=GW2AR-LV18QN88C8/I7
DEVICE = GW2A-18C

all: build/$(PROJECT).fs

# Synthesis using GHDL + Yosys
build/$(PROJECT).json: $(SOURCES)
	mkdir -p build
	# Method 1: Single command
	yosys -m ghdl -D LEDS_NR=8 -p "ghdl --std=08 $(SOURCES) -e $(TOP); synth_gowin -top $(TOP) -json $@"
	#yosys -m ghdl -p "ghdl --std=08 $(SOURCES) -e $(TOP); synth_gowin -top $(TOP) -json $@"
	
	# OR Method 2: Two-step (more reliable)
	# ghdl -a --std=08 $(SOURCES)
	# ghdl -e --std=08 $(TOP)
	# yosys -m ghdl -p "ghdl $(TOP); synth_gowin -top $(TOP) -json $@"

# Place & Route
build/$(PROJECT).pack: build/$(PROJECT).json $(CONSTRAINTS)
	nextpnr-himbaechel --json $< --vopt family=GW2A-18C --vopt cst=$(CONSTRAINTS) \
		--device $(CHIP) --write $@

# Generate bitstream
build/$(PROJECT).fs: build/$(PROJECT).pack
	gowin_pack -d $(DEVICE) -o $@ $<

# Program FPGA
program: build/$(PROJECT).fs
	openFPGALoader -b tangnano20k $<

# Clean
clean:
	rm -rf build

help:
	@echo "make        - Build bitstream"
	@echo "make program - Program FPGA"
	@echo "make clean  - Clean build files"

.PHONY: all program clean help