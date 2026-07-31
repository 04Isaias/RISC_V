-- July 18, 2026
-- Isaias M Ramirez
-- The circuit described within this file
-- is a generic Data Memory component that defaults to 32-bit inputs/outputs and memory.
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD_UNSIGNED.ALL;

entity data_memory is
    generic (
        num_bits      : integer := 32; -- width 
        num_registers : integer := 32 -- depth
    );
    port(
        address      : in STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
        write_data   : in STD_LOGIC_VECTOR ( num_bits - 1 downto 0 );
        write_enable : in STD_LOGIC; 
        clk          : in STD_LOGIC; 
        
        read_data    : out STD_LOGIC_VECTOR ( num_bits - 1 downto 0 )
    );
end data_memory;

architecture hybrid_arch of data_memory is
    type mem_array is array (num_registers - 1 downto 0)
        of STD_LOGIC_VECTOR (num_bits - 1 downto 0 );
    signal mem_arr: mem_array; 
begin 
    --process handling a write operation
    process ( clk, address) begin
        if rising_edge(clk) then
            if write_enable then mem_arr(TO_INTEGER(address)) <= write_data;
            end if;
        end if;
    end process;

    --reading is combinational when write enable is not set
    process (address) begin 
        if (write_enable = '0') then
            read_data <= mem_arr(TO_INTEGER(address));
        end if;
    end process;
    
end architecture hybrid_arch;

