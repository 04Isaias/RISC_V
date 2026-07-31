-- July 31, 2026
-- Isaias M Ramirez
-- The circuit within this file
-- is a control unit for a RISC-V processor
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity control_unit is
    port (
        op          : in STD_LOGIC_VECTOR (6 downto 0);
        func3       : in STD_LOGIC_VECTOR (2 downto 0);
        func7       : in STD_LOGIC;
        zero        : in STD_LOGIC;

        PCSrc       : out STD_LOGIC;
        ResultSrc   : out STD_LOGIC;
        MemWrite    : out STD_LOGIC;
        RegWrite    : out STD_LOGIC;
        ALUSrd      : out STD_LOGIC;
        ALUControl  : out STD_LOGIC_VECTOR ( 2 downto 0);
        ImmSrc      : out STD_LOGIC_VECTOR ( 1 downto 0)
    );
end control_unit;
architecture struct_arch of control_unit is
begin
end architecture struct_arch;

