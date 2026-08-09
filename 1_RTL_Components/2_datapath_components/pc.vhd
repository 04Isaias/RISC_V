-- July 7, 2026
-- Isaias M Ramirez
-- The circuit described within this file
-- is a generic program counter that defaults to 32-bits
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity pc is 
    generic( num_bits : integer := 32 );
    port(
        PCNext  :   in  STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
        reset   :   in  STD_LOGIC;
        clk     :   in  STD_LOGIC;
        PC      :   out STD_LOGIC_VECTOR ( num_bits - 1 downto 0 )
    );
end pc;

architecture behavioral_arc of pc is
begin
    
    pass_value : process(clk) is
    begin
        if rising_edge(clk) then 
            if(reset = '1') then
                PC <= X"00000000";
            else
                PC <= PCNext;
            end if;
        end if;
    end process pass_value;

end architecture behavioral_arc;