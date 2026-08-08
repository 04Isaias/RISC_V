-- July 22, 2026
-- Isaias M Ramirez
-- The circuit described within this file
-- is a generic single cycle processor that defaults to use 32-bits
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity single_cycle_processor is 
    generic (num_bits: integer := 32);
    port(
        Instr       :   in  STD_LOGIC_VECTOR ( num_bits -1 downto 0);
        ReadData    :   in  STD_LOGIC_VECTOR ( num_bits -1 downto 0);
        CLK         :   in  STD_LOGIC;
        reset       :   in  STD_LOGIC;

        PC          :   out STD_LOGIC_VECTOR (num_bits -1 downto 0);
        WriteData   :   out STD_LOGIC_VECTOR (num_bits -1 downto 0);
        DataAdr     :   out STD_LOGIC_VECTOR (num_bits -1 downto 0);
        MemWrite    :   out STD_LOGIC
    );
end single_cycle_processor;

architecture struct of single_cycle_processor is
    -- declare control unit
    component control_unit is
        port(
            op          : in STD_LOGIC_VECTOR (6 downto 0);
            funct3      : in STD_LOGIC_VECTOR (2 downto 0);
            funct7      : in STD_LOGIC;
            zero        : in STD_LOGIC;
            PCSrc       : out STD_LOGIC;
            ResultSrc   : out STD_LOGIC;
            MemWrite    : out STD_LOGIC;
            RegWrite    : out STD_LOGIC;
            ALUSrc      : out STD_LOGIC;
            ALUControl  : out STD_LOGIC_VECTOR ( 2 downto 0);
            ImmSrc      : out STD_LOGIC_VECTOR ( 1 downto 0)
        );
    end component;
    -- declare data path
    component datapath  is 
        generic (
                local_num_bits   : integer;
                local_addr_size  : integer
        );
        port(
            instruction     : in    STD_LOGIC_VECTOR ( local_num_bits - 1 downto 0 );
            ReadData        : in    STD_LOGIC_VECTOR ( local_num_bits - 1 downto 0 );
            ImmSrc          : in    STD_LOGIC_VECTOR ( 1 downto 0 );
            ALUControl      : in    STD_LOGIC_VECTOR ( 2 downto 0 );
            clk             : in    STD_LOGIC;
            RegWrite        : in    STD_LOGIC;
            ALUSrc          : in    STD_LOGIC;
            ResultSrc       : in    STD_LOGIC;
            PCSrc           : in    STD_LOGIC;
            reset           : in    STD_LOGIC;
            zero            : out   STD_LOGIC;
            pc_out          : out   STD_LOGIC_VECTOR ( local_num_bits - 1 downto 0 );
            alu_result      : out   STD_LOGIC_VECTOR ( local_num_bits - 1 downto 0 );
            WriteData       : out   STD_LOGIC_VECTOR ( local_num_bits - 1 downto 0 )
        );
    end component;
    --declare internal signals
    signal RegWrite    :   STD_LOGIC;
    signal ImmSrc      :   STD_LOGIC_VECTOR ( 1 downto 0 );
    signal ALUSrc      :   STD_LOGIC;
    signal ALUControl  :   STD_LOGIC_VECTOR ( 2 downto 0 );
    signal ResultSrc   :   STD_LOGIC;
    signal PCSrc       :   STD_LOGIC;
    signal zero        :   STD_LOGIC;
    
begin
    
    my_datapath : datapath
    generic map (
        local_num_bits  => num_bits,
        local_addr_size => 5
    )
    port map(
        instruction => instr,
        ReadData    => ReadData, 
        ImmSrc      => ImmSrc,
        ALUControl  => ALUControl,
        clk         => clk,
        RegWrite    => RegWrite,
        ALUSrc      => ALUSrc, 
        ResultSrc   => ResultSrc,
        PCSrc       => PCSrc, 
        reset       => reset,
        zero        => zero,
        pc_out      => PC,
        alu_result  => DataAdr,
        WriteData   => WriteData
    );

    my_control_unit : control_unit
    port map(
        op      => instr( 6  downto 0  ),
        funct3  => instr( 14 downto 12 ),
        funct7  => instr( 30 ),
        zero => zero,
        PCSrc => PCSrc,
        ResultSrc => ResultSrc,
        MemWrite => MemWrite,
        RegWrite => RegWrite,
        ALUSrc => ALUSrc, 
        ALUControl => ALUControl,
        ImmSrc => ImmSrc

    );
end architecture struct;