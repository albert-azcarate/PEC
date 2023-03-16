-- 
-- Input: addr_a -> 3 bits, wrd -> 1 bit (enable)
-- Output: out_bit -> 1 bit


LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.all;

package mux_p is
	type slv_array_t is array (natural range <>) of std_logic_vector;

		component Mux is
			generic(
				bus_size : natural;
				num_inputs : natural
			);

			PORT( input_bus : in mux_p.slv_array_t(0 to num_inputs - 1)(bus_size - 1 downto 0);
					selector : in natural range 0 to num_inputs - 1;
					output: out std_logic_vector(bus_size - 1 downto 0)
					);
		end component;
end package mux_p;


LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.all;

ENTITY Mux IS

-- generics
	generic(
		bus_size : natural;
		num_inputs : natural
	);

-- ports
	PORT( input_bus : in mux_p.slv_array_t(0 to num_inputs - 1)(bus_size - 1 downto 0);
			selector : in natural range 0 to num_inputs - 1;
			output: out std_logic_vector (bus_size - 1 downto 0) 
			);
			
END entity;

ARCHITECTURE Structure OF Mux IS


BEGIN
	output <= input_bus(selector);
END Structure;
