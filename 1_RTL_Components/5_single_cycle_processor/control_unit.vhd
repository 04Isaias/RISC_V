-- July 31, 2026
-- Isaias M Ramirez
-- The circuit within this file
-- is a control unit for a RISC-V processor
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity control_unit is
    port (
        op          : in STD_LOGIC_VECTOR (6 downto 0);
        funct3       : in STD_LOGIC_VECTOR (2 downto 0);
        funct7       : in STD_LOGIC;
        zero        : in STD_LOGIC;

        PCSrc       : out STD_LOGIC;
        ResultSrc   : out STD_LOGIC;
        MemWrite    : out STD_LOGIC;
        RegWrite    : out STD_LOGIC;
        ALUSrc      : out STD_LOGIC;
        ALUControl  : out STD_LOGIC_VECTOR ( 2 downto 0);
        ImmSrc      : out STD_LOGIC_VECTOR ( 1 downto 0)
    );
end control_unit;
architecture hybrid_arch of control_unit is
    --main decoder declaration
    component main_decoder is
        port(
            op : in STD_LOGIC_VECTOR (6 downto 0);

            RegWrite    :   out STD_LOGIC;
            ImmSrc      :   out STD_LOGIC_VECTOR    ( 1 downto 0);
            ALUSrc      :   out STD_LOGIC;        
            MemWrite    :   out STD_LOGIC;
            ResultSrc   :   out STD_LOGIC;             
            Branch      :   out STD_LOGIC;
            ALUOp       :   out STD_LOGIC_VECTOR    ( 1 downto 0)
        );
    end component;
    --alu decoder declaration
    component alu_decoder is
        port(
            op5         :   in  STD_LOGIC;
            funct3      :   in  STD_LOGIC_VECTOR ( 2 downto 0 );
            funct7      :   in  STD_LOGIC;
            ALUOp       :   in  STD_LOGIC_VECTOR ( 1 downto 0 ); 
             
            ALUControl  :   out STD_LOGIC_VECTOR (2 downto 0 )
        );
    end component;
    -- declare internal signals
    signal ALUOp  : STD_LOGIC_VECTOR ( 1 downto 0);
    signal Branch : STD_LOGIC;
begin
    my_main_decoder : main_decoder
    port map (
        op => op,
        RegWrite => RegWrite,
        ImmSrc => ImmSrc,
        ALUSrc => ALUSrc,
        MemWrite =>MemWrite, 
        ResultSrc => ResultSrc,
        Branch => Branch,
        ALUOp => ALUOp
    );
    my_alu_decoder : alu_decoder
    port map (
        op5 => op(5),
        funct3 => funct3,
        funct7 => funct7,
        ALUOp => ALUOp,
        ALUControl => ALUControl
    );
    PCSrc <= Branch AND zero;
end architecture hybrid_arch;

