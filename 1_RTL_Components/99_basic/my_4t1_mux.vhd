-- February 28, 2026
-- Isaias M Ramirez
-- The circuit described within this file
-- defaults to a 32-bit four to one mux.
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity my_4t1_mux is
    generic(num_bits : integer := 32);
    port(
        A       : in    STD_LOGIC_VECTOR( num_bits - 1 downto 0);
        B       : in    STD_LOGIC_VECTOR( num_bits - 1 downto 0);
        C       : in    STD_LOGIC_VECTOR( num_bits - 1 downto 0);
        D       : in    STD_LOGIC_VECTOR( num_bits - 1 downto 0);
        control : in    STD_LOGIC_VECTOR( 1 downto 0 );
        result  : out   STD_LOGIC_VECTOR( num_bits - 1 downto 0)
    );
end my_4t1_mux;

architecture data_flow_arch of my_4t1_mux is 
    begin
        result <= A when (control = "00") else
                  B when (control = "01") else
                  C when (control = "10") else
                  D when (control = "11") else
                  (others =>'0');
    end data_flow_arch;