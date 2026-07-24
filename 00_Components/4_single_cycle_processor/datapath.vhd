-- July 23, 2026
-- Isaias M Ramirez
-- The circuit described within this file
-- is a geneeric datapth for a single-cycle RISC-V processor that defaults to 32-bits.
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity datapath is 
    generic(local_num_bits : integer := 32);
    port(
        instruction     : in    STD_LOGIC_VECTOR ( local_num_bits - 1 downto 0 );
        read_data       : in    STD_LOGIC_VECTOR ( local_num_bits - 1 downto 0 );
        program_counter : out   STD_LOGIC_VECTOR ( local_num_bits - 1 downto 0 );
        alu_result      : out   STD_LOGIC_VECTOR ( local_num_bits - 1 downto 0 )
    );
end datapath;

architecture hybrid_arch of datapath is 
    -- register file declaration
    component register_file is
        generic( 
            num_bits         : integer := local_num_bits ;-- width 
            num_register     : integer := local_num_bits;-- depth 
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
        generic(num_bits : integer := local_num_bits);
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
        generic(num_bits : integer := local_num_bits);
        port(
            carry_in                : in    STD_LOGIC;
            uint_1                  : in    STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
            uint_2                  : in    STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
            uint_sum                : out   STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
            gen_adder_c_out         : out   STD_LOGIC
        );
    end component;
    -- sign extender declaration
    -- This sign exteder is not generic.
    component sign_extender is
        port (
            num_in   :   in  STD_LOGIC_VECTOR   ( 11 downto 0);
            num_ext  :   out STD_LOGIC_VECTOR   ( 31 downto 0)
        );
    end component;
begin
end architecture hybrid_arch;