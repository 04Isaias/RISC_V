-- October 17, 2025
-- Isaias M Ramirez
-- The circuit described within this file is a
-- 1-bit full adder.
library IEEE; 
use IEEE.std_logic_1164.all;
entity full_adder is
    port(
        a     : in  std_logic;
        b     : in  std_logic;
        c_in  : in std_logic;
        s     : out std_logic;
        c_out : out std_logic
    );
end full_adder;

architecture data_flow_arch of full_adder is
begin
    s <= a XOR b XOR c_in;
    c_out <= (a AND b) OR (a AND c_in) OR ( b AND c_in);
end data_flow_arch;
