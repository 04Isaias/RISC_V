-- february 28, 2026
-- Isaias M Ramirez
-- The circuit described within this file
-- defaults to a 32-bit ALU with the following features
-- N negative flag      Z zero flag     C carry out flag        V overflow flag
-- A + B Sum            A - B sum       A AND B                 A OR B
-- future features: Multiplication, Division, Magnitude comparison
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity ALU is 
    generic(num_bits : integer := 32);
    port(
        A       :   in      STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
        B       :   in      STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
        control :   in      STD_LOGIC_VECTOR ( 1 downto 0 );
        result  :   out     STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
        N       :   out     STD_LOGIC;  -- negative
        Z       :   out     STD_LOGIC;  -- zero
        C       :   out     STD_LOGIC;  -- carry
        V       :   out     STD_LOGIC   -- overflow
    );
end ALU;

architecture structural_arch of ALU is 
    --internal signals
    signal b_mux_out            : STD_LOGIC_VECTOR ( num_bits - 1 downto 0 ) := (others => '0');
    signal r_mux_out            : STD_LOGIC_VECTOR ( num_bits - 1 downto 0 ) := (others => '0');
    signal adder_c_out          : STD_LOGIC                                  := '0';
    signal adder_sum_out        : STD_LOGIC_VECTOR ( num_bits - 1 downto 0 ) := (others => '0');
    signal ALUControl           : STD_LOGIC_VECTOR ( 1 downto 0 )            := (others => '0');
    --declare components
    component my_2t1_mux is 
        generic(num_bits : integer); -- defaults to 32 bit
        port(
            A       : in  STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
            B       : in  STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
            control : in STD_LOGIC;
            result  : out STD_LOGIC_VECTOR ( num_bits - 1 downto 0 )
        );
    end component;
    
    component my_4t1_mux is 
        generic(num_bits : integer); -- defaults to 32 bit
        port(
            A       : in  STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
            B       : in  STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
            C       : in  STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
            D       : in  STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
            control : in STD_LOGIC_VECTOR ( 1 downto 0);
            result  : out STD_LOGIC_VECTOR ( num_bits - 1 downto 0 )
        );
    end component;

    component gen_adder is 
        generic(num_bits : integer); -- defaults to 32 bits
        port(
            carry_in        :   in  STD_LOGIC;
            uint_1          :   in  STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
            uint_2          :   in  STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
            uint_sum        :   out STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
            gen_adder_c_out :   out STD_LOGIC
        );
    end component;

begin
    -- getting B and NOT B for addition and subtraction operations
    ALUControl <= control;
    mux_2t1 : my_2t1_mux
        generic map (num_bits => num_bits)
            port map(
                A => B,
                B => NOT B, 
                control => ALUControl(0),
                result => b_mux_out
            );
    
    -- 32-bit adder
    my_adder : gen_adder
    generic map(num_bits => num_bits)
        port map(
            carry_in => ALUControl(0),
            uint_1 => A,
            uint_2 => b_mux_out,
            uint_sum => adder_sum_out,
            gen_adder_c_out => adder_c_out
        );
    
    -- 4t1 mux this selects the ALU operation that is sent the result
    my_4t1 : my_4t1_mux
        generic map (num_bits => num_bits)
            port map(
                A => adder_sum_out,
                B => adder_sum_out,
                C => A AND B,
                D => A OR B,
                control => ALUControl,
                result => r_mux_out
            );
    -- connect the output
    result <= r_mux_out;
    -- compute the zero flag
    Z <= AND (NOT r_mux_out);
    -- Negative Flag
    N <= r_mux_out(num_bits - 1); -- last bit
    -- comput carry only for sum and subtraction opperations only
    C <= adder_c_out AND (NOT ALUControl(1));
    -- compute overflow for when (only sum and subtraction and when A and B have oposite signs)
    -- AND the sign is incorrect 
    V <=    (adder_sum_out(num_bits - 1) XOR A(num_bits - 1))
            AND
            (NOT(ALUControl(0) XOR A(num_bits - 1) XOR B(num_bits - 1)))
            AND
            (NOT(ALUControl(1)));

end architecture structural_arch;