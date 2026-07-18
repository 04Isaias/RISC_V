-- July 18, 2026
-- Isaias M Ramirez
-- The circuit described within this file
-- is a generic register file block that defaults to 32-bits input/outputs and 32 32-bit registers
-- it has two read address inputs and two read data output
-- register 0 is hardwired to 0 
-- data is placed onto the read data outputs immediately based on the read addresses.
-- if the write enable is is asserted, then the regiter file writes data from the wrtie data 
-- input into the register specifed by write_addr_3 on the rising edge of the clock
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD_UNSIGNED.ALL;

entity register_file is
    generic( 
        num_bits         : integer := 32;-- width
        num_register     : integer := 32;-- depth
        address_var_size : integer := 5
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
end register_file;

architecture hybrid_arch of register_file is
    type mem_array is array ( num_register - 1 downto 0)
        of STD_LOGIC_VECTOR ( num_bits - 1 downto 0);
    signal register_arr: mem_array;
begin
    -- process ot handle writing to a register
    process(clk) begin
        if rising_edge(clk) then
            if write_enable then register_arr(TO_INTEGER(write_addr_3)) <= write_data;
            end if;
        end if;
    end process;
    -- process to handle reading from a register
    -- wondering if this would be better as two seperate processes.
    process (read_addr_1, read_addr_2) begin
        if(TO_INTEGER(read_addr_1) = 0) then read_data_1 <= (others => '0');
        else read_data_1 <= register_arr(TO_INTEGER(read_addr_1));
        end if;
        if(TO_INTEGER(read_addr_2) = 0) then read_data_2 <= (others => '0');
        else read_data_2 <= register_arr(TO_INTEGER(read_addr_2));
        end if;
    end process; 

end architecture hybrid_arch;