-- October 24, 2025
-- Isaias M Ramirez
-- The circuit described within this file
-- defaults to a 32-bit adder.
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity gen_adder is
    generic(num_bits : integer := 32);
    port(
        uint_1      : in    STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
        uint_2      : in    STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
        uint_sum    : out   STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
        over_flow   : out   STD_LOGIC
    );
end gen_adder;

architecture structural_arch of gen_adder is
    -- internal signals
    signal carry_i : STD_LOGIC_VECTOR ( num_bits/4 downto 0 ); -- make this generic
    -- declare components
    component cla_adder is
    generic(num_bits : integer);
    port(
        a       : in  STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
        b       : in  STD_LOGIC_VECTOR ( num_bits - 1 downto 0 ); 
        c_in    : in  STD_LOGIC;
        s       : out STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
        c_out   : out STD_LOGIC
    );
    end component; 
begin
    -- create 8 adders and connect their carries together
    carry_i(0) <= '0';
    gen : for index in 0 to num_bits/4 generate
        a0 : cla_adder
            generic map(num_bits => 4)
            port map(
                a     => uint_1(( 3 + index*4) downto index*4),
                b     => uint_2(( 3 + index*4) downto index*4),
                c_in  => carry_i(index),
                s     => uint_sum(( 3 + index*4) downto index*4),
                c_out => carry_i(index + 1)
            );
    end generate;
    over_flow <= carry_i(num_bits/4);

end architecture structural_arch;
