-- July 31, 2026
-- Isaias M Ramirez
-- The circuit within this file
-- is a sub-component of the risc-v control unit
-- it decodes the the instruction and produces all 
-- control signals not related to the ALU and two internal signals.
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity main_decoder is
    port (
        op          :   in  STD_LOGIC_VECTOR    ( 6 downto 0);
        
        -- order of outputs like that of 
        --Table 7.2 in smith&smith book
        RegWrite    :   out STD_LOGIC;
        ImmSrc      :   out STD_LOGIC_VECTOR    ( 1 downto 0);
        ALUSrc      :   out STD_LOGIC;        
        MemWrite    :   out STD_LOGIC;
        ResultSrc      :   out STD_LOGIC;             
        Branch      :   out STD_LOGIC;
        ALUOp       :   out STD_LOGIC_VECTOR    ( 1 downto 0)
    );
end main_decoder;

-- So here, I have the option between manually deriving the circuit
-- from the truth table in the literature, but it is less error
-- prone and time consuming to use a select structure.
-- additional reason: logic is sorted in LUTs on an FPGA anyway
-- it would matter more if it were ASIC.
-- to do this, I can create an internal signal and cherry pick 
-- bits in the vector for the output. 
architecture dataflow_arch of main_decoder is
    signal out_vec : STD_LOGIC_VECTOR ( 8 downto 0 );
begin
    -- all X values from table are set to 0
    with (op) select
        out_vec <= "100101000" when "0000011", -- lw
                   "001110000" when "0100011", -- sw
                   "100000010" when "0110011", -- R-type
                   "010000101" when "1100011", -- beq
                    (others => '0') when others;
    RegWrite <= out_vec  (8);
    ImmSrc   <= out_vec  (7 downto 6);
    ALUSrc   <= out_vec  (5);
    MemWrite <= out_vec  (4);
    ResultSrc<= out_vec  (3);
    Branch   <= out_vec  (2);
    ALUOp    <= out_vec  (1 downto 0);
    
end architecture dataflow_arch;