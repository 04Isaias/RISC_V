-- July 23, 2026
-- Isaias M Ramirez
-- The circuit described within this file
-- is a sign extender that that extends
-- a <32 bit input to a 32 bit word.
-- sign extension means to copy the sign bit into 
-- the most significant bits.
-- additionally, it passes through a branch offset for the beq
-- function
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity sign_extender is 
    port (
        num_in   :   in  STD_LOGIC_VECTOR   ( 24 downto 0);
        imm_src  :   in STD_LOGIC_VECTOR    ( 1  downto 0);
        num_ext  :   out STD_LOGIC_VECTOR   ( 31 downto 0)
    );
end sign_extender;

architecture rtl of sign_extender is
    signal imm12 : STD_LOGIC_VECTOR ( 11 downto 0); -- 12 bit imm
    signal imm13 : STD_LOGIC_VECTOR ( 12 downto 0); -- 13 bit imm
    signal imm21 : STD_LOGIC_VECTOR ( 20 downto 0); -- 21 bit imm
begin
    -- Replicate the input sign bit into the upper bits, then concatenate
    -- with the to form a 32-bit signed-extended result.
    -- shift all instruction format indecies to the right by 7 bits
    -- concatenate bits into 12 bit immediate
    with(imm_src) select 
        imm12 <=num_in(24 downto 13)                                          when "00",   -- lw
                (num_in(24 downto 18) & num_in(4 downto 0))                   when "01",   -- sw
                (others => '0') when others;
    -- concatenate bits into 13 bit immediate
    with(imm_src) select
        imm13 <=( num_in(24) & num_in(0) & num_in(23 downto 18) & num_in(4 downto 1) & '0') when "10",   -- B-type 
                (others => '0') when others;
    -- concatenate bits into 21 bit immediate
    with(imm_src) select
        imm21 <=( num_in(24) & num_in(12 downto 5) & num_in(13) & num_in (23 downto 14) & '0') when "11", -- J-type
                (others => '0') when others;
    -- form appropriate output for given instruction and sign extend the immediate to achieve 32 bits.
    with(imm_src) select
        num_ext <= ((31 downto 12 => imm12(imm12'high)) & imm12) when "00" | "01", -- lw,sw
                   ((31 downto 13 => imm13(imm13'high)) & imm13) when "10", -- B-type
                   ((31 downto 21 => imm21(imm21'high)) & imm21) when "11", -- J-type
                   (others => '0')                               when others;

end rtl;
