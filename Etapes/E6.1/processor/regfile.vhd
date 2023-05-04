-- Banc de 8 registres de 16 bits
-- Input: clock -> 1 bit; wrd enable -> 1 bit; data -> 16 bit; addr_a (read) -> 3 bit; addr_d (write) -> 3 bit ; addr_b (store) -> 3 bit
-- Output: a -> 16 bit b -> 16 bits

library ieee;
use ieee.std_logic_1164.all;

package reg is
  type slv_array_t is array (0 to 7) of std_logic_vector (15 downto 0);
end package;

package body reg is
end package body;


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all; --Esta libreria sera necesaria si usais conversiones CONV_INTEGER
USE ieee.numeric_std.all;        --Esta libreria sera necesaria si usais conversiones TO_INTEGER
use work.all;

ENTITY regfile IS
    PORT (clk    : IN  STD_LOGIC;
          wrd    : IN  STD_LOGIC;
          d      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          addr_a : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          a      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          b      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END regfile;

ARCHITECTURE Structure OF regfile IS

signal reg_vector : reg.slv_array_t;


BEGIN
	-- lectura asinc
	a <= reg_vector(conv_integer(addr_a));
	b <= reg_vector(conv_integer(addr_b));
	
	process (clk) begin
		-- escriptura sinc
		if rising_edge(clk) then
			if wrd = '1' then
				reg_vector(conv_integer(addr_d)) <= d;
			end if;
		end if;
	end process;

END Structure;