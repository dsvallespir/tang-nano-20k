library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity wb_slave is 
    port (
        wb_clk_i   : in std_logic;
        wb_rst_i   : in std_logic;

        -- Master to Slave
        wb_adr_i   : in  std_logic_vector(31 downto 0);  -- Address bus
        wb_dat_i   : in  std_logic_vector(31 downto 0);  -- Data input (master to slave)
        wb_dat_o   : out std_logic_vector(31 downto 0);  -- Data output (slave to master)
        wb_we_i    : in  std_logic;                      -- Write enable (1=write, 0=read)
        wb_sel_i   : in  std_logic_vector(3 downto 0);   -- Byte select
        wb_stb_i   : in  std_logic;                      -- Strobe (transaction valid)
        wb_cyc_i   : in  std_logic;                      -- Cycle valid
        wb_ack_o   : out std_logic;                      -- Acknowledge
        wb_err_o   : out std_logic;                      -- Error
        wb_rty_o   : out std_logic;                      -- Retry
        wb_stall_o : out std_logic                       -- Stall/pipeline control

    );
end entity wb_slave;