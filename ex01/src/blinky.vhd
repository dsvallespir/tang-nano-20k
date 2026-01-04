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