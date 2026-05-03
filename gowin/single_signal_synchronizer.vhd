-- This file is part of the ethernet_mac project.
--
-- For the full copyright and license information, please read the
-- LICENSE.md file that was distributed with this source code.



library ieee;
use ieee.std_logic_1164.all;

entity single_signal_synchronizer is
    port(
        clock_target_i : in  std_ulogic;
        preset_i       : in  std_ulogic := '0';
        signal_i       : in  std_ulogic;
        signal_o       : out std_ulogic
    );
end entity;

architecture simple of single_signal_synchronizer is
    signal signal_tmp : std_ulogic := '1';
begin
    process(clock_target_i)
    begin
        if rising_edge(clock_target_i) then
            if preset_i = '1' then
                signal_tmp <= '1';
                signal_o   <= '1';
            else
                signal_tmp <= signal_i;
                signal_o   <= signal_tmp;
            end if;
        end if;
    end process;
end architecture;
