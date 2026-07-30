-- february 28, 2026
-- Isaias M Ramirez
-- The circuit described within this file
-- defaults to a 32-bit ALU with the following features
-- N negative flag      Z zero flag     C carry out flag        V overflow flag (flags: NZCV V is LSB)
-- A + B Sum (000)      A - B Sum (001)  A AND B(  )           A OR B (011)            A < B (101)
-- future features: Multiplication, Division, Magnitude comparison
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity ALU is 
    generic(num_bits : integer := 32);
    port(
        A       :   in      STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
        B       :   in      STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
        control :   in      STD_LOGIC_VECTOR ( 2 downto 0 );
        result  :   out     STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
        flags   :   out     STD_LOGIC_VECTOR ( 3 downto 0) 
    );
end ALU;

architecture structural_arch of ALU is 
    --internal signals
    signal b_mux_out            : STD_LOGIC_VECTOR ( num_bits - 1 downto 0 ) := (others => '0');
    signal r_mux_out            : STD_LOGIC_VECTOR ( num_bits - 1 downto 0 ) := (others => '0');
    signal adder_c_out          : STD_LOGIC                                  := '0';
    signal adder_sum_out        : STD_LOGIC_VECTOR ( num_bits - 1 downto 0 ) := (others => '0');
    signal ALUControl           : STD_LOGIC_VECTOR ( 2 downto 0 )            := (others => '0');
    signal SLT                  : STD_LOGIC_VECTOR ( num_bits - 1 downto 0)  := (others => '0');  
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
    
    component my_8t1_mux is 
        generic(num_bits : integer); -- defaults to 32 bit
        port(
            A       : in  STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
            B       : in  STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
            C       : in  STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
            D       : in  STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
            E       : in  STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
            F       : in  STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
            G       : in  STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
            H       : in  STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
            control : in STD_LOGIC_VECTOR ( 2 downto 0);
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
    -- 8t1 mux this selects the ALU operation that is sent the result
    my_8t1 : my_8t1_mux
        generic map (num_bits => num_bits)
            port map(
                A => adder_sum_out,     -- 000
                B => adder_sum_out,     -- 001
                C => A AND B,           -- 010
                D => A OR B,            -- 011
                E => (others => '0'),   -- 100 SPARE
                F => SLT,               -- 101
                G => (others => '0'),   -- 110 SPARE
                H => (others => '0'),   -- 111 SPARE
                control => ALUControl,
                result => r_mux_out
            );
    -- connect the output
    result <= r_mux_out;
    -- flags are as follows: NZCV where V is the LSB.
    -- compute overflow for when (only sum and subtraction and when A and B have oposite signs)
    -- AND the sign is incorrect 
    flags(0)<=(adder_sum_out(num_bits - 1) XOR A(num_bits - 1))
              AND
              (NOT(ALUControl(0) XOR A(num_bits - 1) XOR B(num_bits - 1)))
              AND
              (NOT (OR(ALUControl(2 downto 1))));
    -- compute carry only for sum and subtraction opperations only
    flags(1)<= adder_c_out AND (NOT (OR(ALUControl(2 downto 1))));
    -- compute the zero flag
    flags(2)<= AND (NOT r_mux_out);
    -- Negative Flag
    flags(3)<= r_mux_out(num_bits - 1); -- last bit

    -- calculate set less than result, the first bit is the resultant, and the rest of the vector is zero extended. 
    SLT <= (0 => flags(0) XOR adder_sum_out(num_bits - 1), others => '0'); 

end architecture structural_arch;