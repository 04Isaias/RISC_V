-- July 18, 2026
-- Isaias M Ramirez
-- The circuit described within this file
-- is a ROM instruction memory component that has 32-bits input/outputs
-- it is hardcoded with the sample program of Figure 7.2 from the harris and harris book
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity instruction_memory is 
    port(
        address   :   in  STD_LOGIC_VECTOR (31 downto 0);
        readData  :   out STD_LOGIC_VECTOR (31 downto 0)
    );
end instruction_memory;
architecture data_flow_arch of instruction_memory is
begin
    readData <= X"FFC4A303" when (address = X"00001000") else
                X"0064A423" when (address = X"00001004") else
                X"0062E233" when (address = X"00001008") else
                X"FE420AE3" when (address = X"0000100C") else
                X"00000000";
end architecture data_flow_arch;