-- February 28, 2026
-- Isaias M Ramirez
-- The circuit described within this file
-- defaults to a 32-bit NOT.
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity gen_NOT is
    generic(num_bits : integer := 32);
    port(
        A       : in    STD_LOGIC_VECTOR( num_bits - 1 downto 0);
        result  : out   STD_LOGIC_VECTOR( num_bits - 1 downto 0)
    );
end gen_NOT;

architecture data_flow_arch of gen_NOT is 
    begin
        result <= NOT A;
    end data_flow_arch;