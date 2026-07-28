-- July 23, 2026
-- Isaias M Ramirez
-- The circuit described within this file
-- is a sign extender that that extends
-- a 12 bit input to a 32 bit word.
-- sign extension means to copy the sign bit into 
-- the most significant bits.
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity sign_extender is 
    port (
        num_in   :   in  STD_LOGIC_VECTOR   ( 23 downto 0);
        ImmSrc   :   in STD_LOGIC;
        num_ext  :   out STD_LOGIC_VECTOR   ( 31 downto 0)
    );
end sign_extender;

architecture rtl of sign_extender is
    signal imm : STD_LOGIC_VECTOR ( 11 downto 0);
begin
    -- Replicate the input sign bit into the upper bits, then concatenate
    -- with the to form a 32-bit signed-extended result.
    -- shift all instruction format indecies to the right by 8 bits
    with(ImmSrc) select 
        imm <=  num_in(23 downto 12) when '0',                          -- lw
                (num_in(23 downto 17) & num_in(4 downto 0)) when '1',   -- sw
                (others => '0') when others;
    num_ext <=  ((31 downto 12 => imm(imm'high)) & imm);
end rtl;
