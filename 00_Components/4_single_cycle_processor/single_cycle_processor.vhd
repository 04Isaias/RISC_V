-- July 22, 2026
-- Isaias M Ramirez
-- The circuit described within this file
-- is a generic single cycle processor that defaults to use 32-bits
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity single_cycle_processor is 
    generic (num_bits_in_processor: integer := 32);
    port(
        nothing_yet : in STD_LOGIC
    );
end single_cycle_processor;

architecture struct of single_cycle_processor is
    -- internal signals
    signal PCNext           :   STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
    signal Instr            :   STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
    signal SrcA             :   STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
    signal SrcB             :   STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
    signal ALUResult        :   STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
    signal ReadData         :   STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
    -- declare components
    -- program counter declaration
    component pc is
        generic( num_bits : integer := num_bits_in_processor ); 
        port(
            PCNext  :   in  STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
            reset   :   in  STD_LOGIC;
            clk     :   in  STD_LOGIC;
            PC      :   out STD_LOGIC_VECTOR ( num_bits - 1 downto 0 )            
        );
    end component;
    -- instruction memory declaration
    component instruction_memory is
        port(
            address :   in  STD_LOGIC_VECTOR ( 31 downto 0);
            readData :   in  STD_LOGIC_VECTOR ( 31 downto 0)
        );
    end component;
    -- register file declaration
    component register_file is
        generic( 
            num_bits         : integer := num_bits_in_processor;
            num_register     : integer;   -- defaults to 32 bits
            address_var_size : integer ); -- defaults to 5 bits
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
        generic( num_bits : integer := num_bits_in_processor );
        port(
            A       :   in      STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
            B       :   in      STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
            control :   in      STD_LOGIC_VECTOR ( 2 downto 0 );
            result  :   out     STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
            flags   :   out     STD_LOGIC_VECTOR ( 3 downto 0) 
        );
    end component;
    -- data memory declaration
    component data_memory is
        generic (
            num_bits      : integer := num_bits_in_processor;
            num_registers : integer  -- depth defaults to 32 bits
        );
        port(
            address      : in STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
            write_data   : in STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
            write_enable : in STD_LOGIC; 
            clk          : in STD_LOGIC; 

            read_data    : out STD_LOGIC_VECTOR ( num_bits - 1 downto 0 )
        );
    end component;
    -- generic adder declaration
    component gen_adder is
        generic(num_bits : integer := 32);
        port(
            carry_in                : in    STD_LOGIC;
            uint_1                  : in    STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
            uint_2                  : in    STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
            uint_sum                : out   STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
            gen_adder_c_out         : out   STD_LOGIC
        );        
    end component;
begin

end architecture struct;