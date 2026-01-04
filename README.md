

# Installing tools

### 1. Install Gowin 
Download from project p

### 2. Install apycula

I had to create a virtual environment, and then install there apycula
```bash
pip install apycula
```
Check the install path for pass to nextpnr

### 3. Build nextpnr (Place and Route)

```bash
mkdir -p build && cd build
cmake .. -DARCH="himbaechel" -DHIMBAECHEL_UARCH="gowin" -D APYCULA_INSTALL_PREFIX=~/tmp/setup_apicula/
make -j$(nproc)
sudo make install
```

### 4. Make a test project

```bash
blinky/
├─src/
|   └── blinky.vhdl
├─constraints/
|   └── tang-nano.cst
└──Makefile
```
blinky.vhdl:
```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity blinky is
    port(
        clk: in std_logic;
        led: out std_logic_vector(5 downto 0)
    );
end entity;

architecture rtl of blinky is
    signal counter: unsigned(23 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            counter <= counter + 1;
        end if;
    end process;
    
    -- Use different bits for different blink rates
    led(0) <= counter(23);  -- ~1.6 Hz
    led(1) <= counter(22);  -- ~3.2 Hz
    led(2) <= counter(21);  -- ~6.4 Hz
    led(3) <= counter(20);  -- ~12.8 Hz
    led(4) <= counter(19);  -- ~25.6 Hz
    led(5) <= counter(18);  -- ~51.2 Hz
end architecture;
```
Makefile:

```bash
PROJECT = blinky
TOP = blinky
SOURCES = src/blinky.vhd
CONSTRAINTS = constraints/tang-nano.cst
BAORD = tangnano20k
CHIP = GW2AR-LV18QN88C8/I7
DEVICE = GW2A-18C

all: build/$(PROJECT).fs

# Synthesis using GHDL + Yosys
build/$(PROJECT).json: $(SOURCES)
	mkdir -p build
	yosys -m ghdl -D LEDS_NR=8 -p "ghdl --std=08 $(SOURCES) -e $(TOP); synth_gowin -top $(TOP) -json $@"

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
```
The ouptut will be in `/build/blinky.fs`
```bash
openFPGALoader --detect

openFPGALoader -b tangnano20k build/blinky.fs
```