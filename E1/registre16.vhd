library ieee;
use ieee.std_logic_1164.all;

entity registre16 is
	port(	data_in : in  std_logic_vector (15 downto 0);
			clock : in std_logic;
			enable : in  std_logic;
			data_out : out std_logic_vector (15 downto 0));

end registre16;

architecture Structure of registre16 is

  signal data_latch : std_logic_vector(data_in'range) := (others  => '0');

begin

	data_out <= data_latch;

	process (clock) begin
		if rising_edge(clock) then
			if enable = '1' then
				data_latch <= data_in;
			end if;
		end if;
	end process;
  
end Structure;