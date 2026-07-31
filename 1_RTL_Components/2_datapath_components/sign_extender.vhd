-- July 23, 2026
-- Isaias M Ramirez
-- The circuit described within this file
-- is a sign extender that that extends
-- a 12 bit input to a 32 bit word.
-- sign extension means to copy the sign bit into 
-- the most significant bits.
-- additionally, it passes through a branch offset for the beq
-- function
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity sign_extender is 
    port (
        num_in   :   in  STD_LOGIC_VECTOR   ( 23 downto 0);
        imm_src  :   in STD_LOGIC_VECTOR    ( 1  downto 0);
        num_ext  :   out STD_LOGIC_VECTOR   ( 31 downto 0)
    );
end sign_extender;

architecture rtl of sign_extender is
    signal imm12 : STD_LOGIC_VECTOR ( 11 downto 0); -- 12 bit imm
    signal imm13 : STD_LOGIC_VECTOR ( 12 downto 0); -- 13 bit imm
begin
    -- Replicate the input sign bit into the upper bits, then concatenate
    -- with the to form a 32-bit signed-extended result.
    -- shift all instruction format indecies to the right by 8 bits
    with(imm_src) select 
        imm12 <=num_in(23 downto 12)                                          when "00",   -- lw
                (num_in(23 downto 17) & num_in(4 downto 0))                   when "01",   -- sw
                (others => '0') when others;
    with(imm_src) select
        imm13 <=(num_in(7) & num_in(23 downto 17) & num_in(4 downto 1) & '0') when "10",   -- B-type                
                (others => '0') when others;

    with(imm_src) select
        num_ext <= ((31 downto 12 => imm12(imm12'high)) & imm12) when ("00" | "01"), -- sign extend
                   ((31 downto 13 => '0') & imm13)               when "10",          -- pad with zeros
                   (others => '0')                               when others;

end rtl;
