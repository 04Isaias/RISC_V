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
        ResultSrc   :   out STD_LOGIC_VECTOR (1 downto 0);             
        Branch      :   out STD_LOGIC;
        Jump        :   out STD_LOGIC;
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
    signal out_vec : STD_LOGIC_VECTOR ( 10 downto 0 );
begin
    -- all X values from table are set to 0
    -- input control bits are from the Opcode (7 bits)
    --                                XXX_XXXX
    -- output control bits are out_vec (10 bits): 
    -- RegWrite ImmSrc ALUSrc MemWrite ResultSrc Branch ALUOp Jump
    --    X       XX     X       X        XX       X     XX     X
    with (op) select
        out_vec <= "10010010000" when "0000011", -- lw
                   "10010000100" when "0010011", -- addi, andi, ori, slti
                   "00111000000" when "0100011", -- sw
                   "10000000100" when "0110011", -- R-type
                   "01000001010" when "1100011", -- beq
                   "11100100001" when "1101111", -- Jump
                   (others => '0') when others;
    RegWrite <= out_vec  (10);
    ImmSrc   <= out_vec  (9 downto 8);
    ALUSrc   <= out_vec  (7);
    MemWrite <= out_vec  (6);
    ResultSrc<= out_vec  (5 downto 4);
    Branch   <= out_vec  (3);
    ALUOp    <= out_vec  (2 downto 1);
    Jump     <= out_vec  (0);
    
end architecture dataflow_arch;