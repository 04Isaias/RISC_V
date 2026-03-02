-- February 28, 2026
-- Isaias M Ramirez
-- The circuit described within this file
-- defaults to a 32-bit AND.
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity gen_AND is
    generic(num_bits : integer := 32);
    port(
        A       : in    STD_LOGIC_VECTOR( num_bits - 1 downto 0);
        B       : in    STD_LOGIC_VECTOR( num_bits - 1 downto 0);
        result  : out   STD_LOGIC_VECTOR( num_bits - 1 downto 0)
    );
end gen_AND;

architecture data_flow_arch of gen_AND is 
    begin
        result <= A AND B;
    end data_flow_arch;