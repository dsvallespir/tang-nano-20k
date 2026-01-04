library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity wb_led_controller is
    port (
        -- Wishbone Interface
        wb_clk_i   : in std_logic;
        wb_rst_i   : in std_logic;
        wb_adr_i   : in  std_logic_vector(31 downto 0);  -- Address bus
        wb_dat_i   : in  std_logic_vector(31 downto 0);
        wb_dat_o   : out std_logic_vector(31 downto 0);
        wb_we_i    : in  std_logic;                      -- Write enable (1=write, 0=read)
        wb_sel_i   : in  std_logic_vector(3 downto 0);   -- Byte select
        wb_stb_i   : in  std_logic;                      -- Strobe (transaction valid)
        wb_cyc_i   : in  std_logic;                      -- Cycle valid
        wb_ack_o   : out std_logic;                      -- Acknowledge

        -- Hardware Interface
        leds_o     : out std_logic_vector(5 downto 0)
        buttons_i  : in  std_logic_vector(3 downto 0)

    );
end entity wb_led_controller;

architecture rtl of wb_led_controller is
    -- Internal registers
    signal reg_control : std_logic_vector(31 downto 0) := (others => '0');
    signal reg_config  : std_logic_vector(31 downto 0) := (others => '0');

    -- Control signals
    signal ack         : std_logic := '0';
    signal reg_select  : integer range 0 to 3;

    -- Constants for register addresses
    constant ADDR_CONTROL : std_logic_vector(31 downto 0) := x"00000000";
    constant ADDR_STATUS  : std_logic_vector(31 downto 0) := x"00000004";
    constant ADDR_CONFIG  : std_logic_vector(31 downto 0) := x"00000008";

begin
    process(wb_adr_i)
    begin
        case wb_adr_i is
            when x"00" => reg_select <= 0;  -- Control Register
            when x"04" => reg_select <= 1;  -- Status Register
            when x"08" => reg_select <= 2;  -- Config Register
            when others => reg_select <= 3; -- Invalid
        end case;
    end process;


    process(wb_clk_i)
    begin
        if rising_edge(wb_clk_i) then
            if wb_rst_i = '1' then
                -- Reset
                reg_control <= (others => '0');
                reg_config  <= (others => '0');
                ack         <= '0';
                wb_dat_o    <= (others => '0');
            else
                ack <= '0';  -- Default no acknowledge
                
                -- Valid transaction
                if  wb_stb_i = '1' and wb_cyc_i = '1' then
                    -- Write (CPU -> Pheripheral)
                    if wb_we_i = '1' then 
                        case reg_select is
                            