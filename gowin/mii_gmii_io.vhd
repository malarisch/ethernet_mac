-- Gowin-compatible variant of the MII/GMII I/O block.
--

library ieee;
use ieee.std_logic_1164.all;

use work.ethernet_types.all;

entity mii_gmii_io is
    port(
        clock_125_i     : in  std_ulogic;
        clock_tx_o      : out std_ulogic;
        clock_rx_o      : out std_ulogic;
        speed_select_i  : in  t_ethernet_speed;

        -- MII/GMII pins
        mii_tx_clk_i    : in  std_ulogic;
        mii_tx_en_o     : out std_ulogic;
        mii_txd_o       : out t_ethernet_data;
        mii_rx_clk_i    : in  std_ulogic;
        mii_rx_er_i     : in  std_ulogic;
        mii_rx_dv_i     : in  std_ulogic;
        mii_rxd_i       : in  t_ethernet_data;

        -- GMII GTX clock (gigabit only, unused on Gowin/RMII)
        gmii_gtx_clk_o  : out std_ulogic;

        -- Internal MAC <-> IO interface
        int_mii_tx_en_i : in  std_ulogic;
        int_mii_txd_i   : in  t_ethernet_data;
        int_mii_rx_er_o : out std_ulogic;
        int_mii_rx_dv_o : out std_ulogic;
        int_mii_rxd_o   : out t_ethernet_data
    );
end entity;

architecture Behavioral of mii_gmii_io is
    signal clock_tx : std_ulogic;
    signal clock_rx : std_ulogic;
begin
    -- No gigabit support on Gowin/RMII: TX clock comes straight from the PHY
    clock_tx <= mii_tx_clk_i;
    clock_rx <= mii_rx_clk_i;

    gmii_gtx_clk_o <= '0';

    clock_tx_o <= clock_tx;
    clock_rx_o <= clock_rx;

    process(clock_tx)
    begin
        if rising_edge(clock_tx) then
            mii_tx_en_o <= int_mii_tx_en_i;
            mii_txd_o   <= int_mii_txd_i;
        end if;
    end process;

    process(clock_rx)
    begin
        if rising_edge(clock_rx) then
            int_mii_rx_dv_o <= mii_rx_dv_i;
            int_mii_rx_er_o <= mii_rx_er_i;
            int_mii_rxd_o   <= mii_rxd_i;
        end if;
    end process;

    -- speed_select_i is unused in this variant but kept on the port to
    -- preserve a uniform interface with the Intel variant.
    assert speed_select_i /= SPEED_1000MBPS
        report "mii_gmii_io (gowin): gigabit mode requested but not supported"
        severity warning;
end architecture;
