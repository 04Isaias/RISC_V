-- October 17, 2025
-- Isaias M Ramirez
-- The circuit described within this file
-- defaults to a 4-bit Carry Look Ahead adder.
library IEEE; 
use IEEE.STD_LOGIC_1164.all;

entity cla_adder is
    generic(num_bits : integer := 4);
    port(
        a       : in  STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
        b       : in  STD_LOGIC_VECTOR ( num_bits - 1 downto 0 ); 
        c_in    : in  STD_LOGIC;
        s       : out STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
        c_out   : out STD_LOGIC
    );
end cla_adder; 

architecture mixed_arch of cla_adder is 
    --internal signals
    signal propagate_i      : STD_LOGIC_VECTOR ( num_bits - 1 downto 0 ); 
    signal generate_i       : STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );  
    signal block_generate   : STD_LOGIC;
    signal block_propagate  : STD_LOGIC;
    signal carry_i          : STD_LOGIC_VECTOR ( num_bits downto 0 );
    signal sum_i            : STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
    --declaring component
    component full_adder is
    port(
        a     : in  STD_LOGIC;
        b     : in  STD_LOGIC;
        c_in  : in  STD_LOGIC;
        s     : out STD_LOGIC;
        c_out : out STD_LOGIC
    );
    end component;
begin
-- p_i_generate generates all of the propogate values for the CLA
p_i_generate: for bit_index in 0 to (num_bits -1) generate
    propagate_i(bit_index) <= a(bit_index) OR b(bit_index);
end generate p_i_generate;
-- block_propagate is the propagate value to evaluate the resultant carry
block_propagate <= AND propagate_i;
--g_i_generate is used to connect up all of the logic for the block_generate
generate_i(0) <= a(0) AND b(0);
g_i_generate: for bit_index in 1 to (num_bits - 1) generate
    generate_i(bit_index) <= 
        (a(bit_index) AND b(bit_index)) OR 
        (propagate_i(bit_index) AND generate_i(bit_index-1));
end generate g_i_generate;
--block_generate is the resultant generate used to calculate the carry
block_generate <= generate_i( num_bits - 1 );

c_out <= block_generate OR (block_Propagate AND c_in);

--calculate the sum
    carry_i(0) <= c_in;
    sum_ckt : for i in 0 to (num_bits - 1) generate
        full_adders : full_adder
            port map(
                a => a(i), 
                b => b(i), 
                c_in => carry_i(i),
                s => sum_i(i),
                c_out => carry_i(i+1) -- we don't use the last carry
            );
        end generate sum_ckt;
    s <= sum_i;

end architecture mixed_arch; 