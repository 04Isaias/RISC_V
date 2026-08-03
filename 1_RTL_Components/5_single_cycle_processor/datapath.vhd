-- July 23, 2026
-- Isaias M Ramirez
-- The circuit described within this file
-- is a geneeric datapth for a single-cycle RISC-V processor that defaults to 32-bits.
library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity datapath is 
    generic(
        local_num_bits : integer := 32;
        local_addr_size: integer := 5);
    port(
        instruction     : in    STD_LOGIC_VECTOR ( local_num_bits - 1 downto 0 );
        ReadData        : in    STD_LOGIC_VECTOR ( local_num_bits - 1 downto 0 );
        ImmSrc          : in    STD_LOGIC_VECTOR ( 1 downto 0);
        clk             : in    STD_LOGIC;
        RegWrite        : in    STD_LOGIC;
        ALUSrc          : in    STD_LOGIC;
        ResultSrc       : in    STD_LOGIC;
        PCSrc           : in    STD_LOGIC;
        pc_out          : out   STD_LOGIC_VECTOR ( local_num_bits - 1 downto 0 );
        alu_result      : out   STD_LOGIC_VECTOR ( local_num_bits - 1 downto 0 );
        WriteData       : out   STD_LOGIC_VECTOR ( local_num_bits - 1 downto 0 )
    );
end datapath;

architecture struct_arch of datapath is 
    -- program counter declaration
    component pc is
        generic(num_bits : integer);
        port(
            PCNext  :   in  STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
            reset   :   in  STD_LOGIC;
            clk     :   in  STD_LOGIC;
            PC      :   out STD_LOGIC_VECTOR ( num_bits - 1 downto 0 )
        );
    end component;
    -- register file declaration
    component register_file is
        generic( 
            num_bits         : integer ;-- width 
            num_register     : integer ;-- depth 
            address_var_size : integer -- defaults to 5 bits
        );
        port(
            read_addr_1  : in STD_LOGIC_VECTOR ( address_var_size - 1 downto 0);
            read_addr_2  : in STD_LOGIC_VECTOR ( address_var_size - 1 downto 0);
            write_addr_3 : in STD_LOGIC_VECTOR ( address_var_size - 1 downto 0);
            write_data   : in STD_LOGIC_VECTOR ( num_bits - 1 downto 0);
            write_enable : in STD_LOGIC;
            clk          : in STD_LOGIC;

            read_data_1  : out STD_LOGIC_VECTOR ( num_bits - 1 downto 0);
            read_data_2  : out STD_LOGIC_VECTOR ( num_bits - 1 downto 0)
        );         
    end component;
    -- arithmetic logic unit declaration
    component ALU is
        generic(num_bits : integer);
        port(
            A       :   in      STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
            B       :   in      STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
            control :   in      STD_LOGIC_VECTOR ( 2 downto 0 );
            result  :   out     STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
            flags   :   out     STD_LOGIC_VECTOR ( 3 downto 0) 
        );
    end component;
    -- generic adder declaration
    component gen_adder is 
        generic(num_bits : integer);
        port(
            carry_in                : in    STD_LOGIC;
            uint_1                  : in    STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
            uint_2                  : in    STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
            uint_sum                : out   STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
            gen_adder_c_out         : out   STD_LOGIC
        );
    end component;
    -- sign extender declaration
    -- This sign exteder is not generic
    -- it's 
    component sign_extender is
        port (
            num_in   :   in  STD_LOGIC_VECTOR   ( 23 downto 0);
            imm_src  :   in  STD_LOGIC_VECTOR   ( 1 downto 0);
            num_ext  :   out STD_LOGIC_VECTOR   ( 31 downto 0)
        );
    end component;
    -- two to one mux
    component my_2t1_mux is 
        generic (num_bits : integer);
        port (
            A       : in    STD_LOGIC_VECTOR( num_bits - 1 downto 0);
            B       : in    STD_LOGIC_VECTOR( num_bits - 1 downto 0);
            control : in    STD_LOGIC;
            result  : out   STD_LOGIC_VECTOR( num_bits - 1 downto 0)
        );
    end component;
    -- internal signal declarations
    signal SrcA               : STD_LOGIC_VECTOR ( local_num_bits - 1 downto 0 );
    signal SrcB               : STD_LOGIC_VECTOR ( local_num_bits - 1 downto 0 );
    signal ALUResult          : STD_LOGIC_VECTOR ( local_num_bits - 1 downto 0 );
    signal ImmExt             : STD_LOGIC_VECTOR ( local_num_bits - 1 downto 0 );
    signal PCPlus4            : STD_LOGIC_VECTOR ( local_num_bits - 1 downto 0 );
    signal read_data_2        : STD_LOGIC_VECTOR ( local_num_bits - 1 downto 0 );
    signal result_mux_out     : STD_LOGIC_VECTOR ( local_num_bits - 1 downto 0 );
    signal PCTarget           : STD_LOGIC_VECTOR ( local_num_bits - 1 downto 0 );
    signal PCNext             : STD_LOGIC_VECTOR ( local_num_bits - 1 downto 0 );
    
begin
    -- mux that provides input for the program counter
    pc_next : my_2t1_mux
        generic map ( num_bits => local_num_bits)
        port map (
            A       => PCPlus4,
            B       => PCTarget,
            control => PCSrc,
            result  => PCNext 
        );
    -- wiring up the program counter
    my_pc : pc
        generic map ( num_bits => local_num_bits)
        port map(
            PCNext => PCNext, 
            reset  => '0', -- no reset yet
            clk    => clk,
            PC     => pc_out
        );
    -- wiring up program adder that incrments address
    my_adder : gen_adder
        generic map(num_bits => local_num_bits)
        port map(
            carry_in => '0', -- carries are unused
            uint_1 => pc_out,
            uint_2 => ((others=>'0'),X"4"), -- put 4 in lsb 0 all others
            uint_sum => PCPlus4, 
            gen_adder_c_out => '0'
        );
    -- Register File
    my_reg_file : register_file
        generic map(
            num_bits => local_num_bits,
            num_register => local_num_bits,
            address_var_size => local_addr_size
        )
        port map(
            read_addr_1     => instruction( 19 downto 15),  -- A1
            read_addr_2     => (others => '0'),             -- A2
            write_addr_3    => instruction( 11 downto 7),   -- A3
            write_data      => result_mux_out,              -- WD3 in the schematic
            write_enable    => RegWrite,                    
            clk             => clk,
            read_data_1     => SrcA,                        -- RD1
            read_data_2     => read_data_2                  -- RD2
        );
    -- Arithmetic Logic Unit
    my_alu : ALU
        generic map (num_bits => local_num_bits)
        port map (
            A => SrcA,
            B => SrcB,
            control => (others => '0'),
            result => ALUResult,
            flags => open
        );
    alu_result <= ALUresult;
    -- extender
    my_extender    : sign_extender
    port map (
            num_in  => instruction( 31 downto 7 ),
            imm_src => ImmSrc, 
            num_ext => ImmExt
        );
    -- muxes for R-type instruction support (add, sub, or, and, slt)
    -- mux to select alu input between read_data_2 and immExt 
    SrcB_mux : my_2t1_mux 
    generic map (num_bits => local_num_bits)
    port map (
        A => read_data_2,
        B => ImmExt,
        control => ALUSrc,
        result => SrcB
     );
     -- adder to compute the branch target address
    PCTarget_adder : gen_adder
    generic map ( num_bits => local_num_bits )
    port map (
        carry_in        => open, 
        uint_1          => pc_out,
        uint_2          => ImmExt,
        uint_sum        => PCTarget,
        gen_adder_c_out => open

    );
     -- mux to select between the data memory input and the ALUResult
    result_mux : my_2t1_mux
    generic map ( num_bits => local_num_bits)
    port map (
        A => ALUResult, 
        B => ReadData, 
        control => ResultSrc, 
        result => result_mux_out
    );
    WriteData <= read_data_2;
    

end architecture struct_arch;
