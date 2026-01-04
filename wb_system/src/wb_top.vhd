library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity wb_system_top is 
    port (
        -- Clock and Reset
        clk_27m     : in std_logic;
        reset_n     : in std_logic;


        -- Wishbone Master Interface
        wb_adr_o    : out std_logic_vector(31 downto 0);
        wb_dat_o    : out std_logic_vector(31 downto 0);
        wb_dat_i    : in std_logic_vector(31 downto 0);
        wb_we_o     : out std_logic;
        wb_sel_o    : out std_logic_vector(3 downto 0);
        wb_stb_o    : out std_logic;
        wb_cyc_o    : out std_logic;
        wb_ack_i    : in std_logic;

        -- UART Interface
        uart_tx     : out std_logic;
        uart_rx     : in std_logic

        -- GPIO Interface
        gpio_out    : out std_logic_vector(15 downto 0);
        gpio_in     : in std_logic_vector(15 downto 0);

        -- Leds
        leds        : out std_logic_vector(5 downto 0);

    );

end entity wb_system_top;

architecture rtl of wb_system_top is

