-- February 28, 2026
-- Isaias M Ramirez
-- The circuit described within this file
-- defaults to a 32-bit eight to one mux.
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity my_8t1_mux is
    generic(num_bits : integer := 32);
    port(
        A       : in    STD_LOGIC_VECTOR( num_bits - 1 downto 0);
        B       : in    STD_LOGIC_VECTOR( num_bits - 1 downto 0);
        C       : in    STD_LOGIC_VECTOR( num_bits - 1 downto 0);
        D       : in    STD_LOGIC_VECTOR( num_bits - 1 downto 0);
        E       : in    STD_LOGIC_VECTOR( num_bits - 1 downto 0);
        F       : in    STD_LOGIC_VECTOR( num_bits - 1 downto 0);
        G       : in    STD_LOGIC_VECTOR( num_bits - 1 downto 0);
        H       : in    STD_LOGIC_VECTOR( num_bits - 1 downto 0);
        control : in    STD_LOGIC_VECTOR( 2 downto 0 );
        result  : out   STD_LOGIC_VECTOR( num_bits - 1 downto 0)
    );
end my_8t1_mux;

architecture data_flow_arch of my_8t1_mux is 
    begin
        result <= A when (control = "000") else
                  B when (control = "001") else
                  C when (control = "010") else
                  D when (control = "011") else
                  E when (control = "100") else
                  F when (control = "101") else
                  G when (control = "110") else
                  H when (control = "111") else
                  (others =>'0');
    end data_flow_arch;