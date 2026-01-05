-- January 2, 2026
-- Isaias M Ramirez
-- The circuit described within this file defaults to a 32-bit comparator.
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity gen_comparator is 
    generic(num_bits : integer := 32);
    port(
        A   : in    STD_LOGIC_VECTOR (num_bits - 1 downto 0); 
        B   : in    STD_LOGIC_VECTOR (num_bits - 1 downto 0);
        eq  : out   STD_LOGIC;
        neq : out   STD_LOGIC;
        lt  : out   STD_LOGIC;
        lte : out   STD_LOGIC;
        gt  : out   STD_LOGIC;
        gte : out   STD_LOGIC
    );
end gen_comparator;

-- There isn't much room for alterations from what is taught in the harris and harris book
-- this design is based on that literature.
architecture compare_arch of gen_comparator is 
begin
    eq  <= '1' when (A = B)     else '0';
    neq <= '1' when (A /= B)    else '0'; 
    lt  <= '1' when (A < B)     else '0';   
    lte <= '1' when (A <= B)    else '0';
    gt  <= '1' when (A > B)     else '0';
    gte  <= '1' when (A >= B)    else '0';
end compare_arch;