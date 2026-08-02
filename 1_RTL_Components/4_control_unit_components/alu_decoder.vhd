-- July 31, 2026
-- Isaias M Ramirez
-- The circuit within this file
-- is the alu decoder component of a risc-v control unit.
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity alu_decoder is 
    port (
        op5         :   in  STD_LOGIC;
        funct3       :   in  STD_LOGIC_VECTOR ( 2 downto 0 );
        funct7      :   in  STD_LOGIC;
        ALUOp       :   in  STD_LOGIC_VECTOR ( 1 downto 0 ); 

        ALUControl :   out STD_LOGIC_VECTOR (2 downto 0 )
    );
end alu_decoder;

architecture dataflow_arch of alu_decoder is
    signal controls : STD_LOGIC_VECTOR( 6 downto 0);
begin
    controls <= (ALUOp & funct3 & op5 & funct7);

    with (controls) select
        ALUControl <= "000" when "00-----"|"1000000"|"1000001"|"1000010", --lw,sw,add
                      "001" when "01-----"|"1000011",                     -- beq
                      "010" when "1011100",                               -- sub
                      "011" when "1011000",                               -- or
                      "101" when "1001000",                               -- slt
                      (others=>'0') when others;
end architecture dataflow_arch;