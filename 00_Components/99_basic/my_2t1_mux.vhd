-- February 28, 2026
-- Isaias M Ramirez
-- The circuit described within this file
-- defaults to a 32-bit two to one mux.
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity my_2t1_mux is
    generic(num_bits : integer := 32);
    port(
        A       : in    STD_LOGIC_VECTOR( num_bits - 1 downto 0);
        B       : in    STD_LOGIC_VECTOR( num_bits - 1 downto 0);
        control : in    STD_LOGIC;
        result  : out   STD_LOGIC_VECTOR( num_bits - 1 downto 0)
    );
end my_2t1_mux;

architecture data_flow_arch of my_2t1_mux is 
    begin
        result <= A when (control = '0') else
                  B when (control = '1') else
                  (others =>'0');
    end data_flow_arch;