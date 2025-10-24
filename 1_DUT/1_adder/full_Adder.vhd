-- October 17, 2025
-- Isaias M Ramirez
-- The circuit described within this file is a
-- 1-bit full adder.
library IEEE; 
use IEEE.std_logic_1164.all;
entity full_adder is
    port(
        a     : in  STD_LOGIC;
        b     : in  STD_LOGIC;
        c_in  : in  STD_LOGIC;
        s     : out STD_LOGIC;
        c_out : out STD_LOGIC
    );
end full_adder;

architecture data_flow_arch of full_adder is
begin
    s <= a XOR b XOR c_in;
    c_out <= (a AND b) OR (a AND c_in) OR ( b AND c_in);
end data_flow_arch;
