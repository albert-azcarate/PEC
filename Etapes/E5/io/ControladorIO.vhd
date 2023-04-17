library ieee;
use ieee.std_logic_1164.all;

package io_reg is
	type io_array_t is array (0 to 16) of std_logic_vector (15 downto 0);
  --type io_array_t is array (0 to 255) of std_logic_vector (15 downto 0);
end package;

package body io_reg is
end package body;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all; --Esta libreria sera necesaria si usais conversiones CONV_INTEGER
USE ieee.numeric_std.all;        --Esta libreria sera necesaria si usais conversiones TO_INTEGER
use work.all;

ENTITY controladores_IO IS
	PORT (
		boot 			: IN STD_LOGIC;
		CLOCK_50 	: IN std_logic;
		addr_io 		: IN std_logic_vector(7 downto 0);
		wr_io 		: in std_logic_vector(15 downto 0); 	-- Bus d'escriptura
		rd_io 		: out std_logic_vector(15 downto 0); 	-- Bus de lectura
		wr_out 		: in std_logic; 								-- Write enable
		rd_in 		: in std_logic; 								-- Read enable
		led_verdes 	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		led_rojos 	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		SW : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		KEY : IN STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
END controladores_IO;

ARCHITECTURE Structure OF controladores_IO IS
	
	signal io_registers : io_reg.io_array_t;
	signal adress_reg	: integer;
	signal input_disp	: std_logic_vector(15 downto 0);

--	signal reg_block : io_reg.io_array_t;
--	signal temp : std_logic_vector(3 downto 0); --pels 16 registres que tenim de moment a treure desprÃ©s
--	signal SWs : std_logic_vector(15 downto 0) := (others => '0');
--	signal KEys : std_logic_vector(15 downto 0) := (others => '0');
BEGIN

	-- Assignem els 8 bits de menor pers als leds corresponents
	led_rojos <= io_registers(6)(7 downto 0);
	led_verdes <= io_registers(5)(7 downto 0);
	
	-- Quin port IO volem accedir
	adress_reg <= conv_integer(addr_io(3 downto 0));

	--SW[9] == boot
	--puertos
   --5 leds verdes
	--6 leds rojos
	--7 4 pulsadores
	--8 8 switchs
	--10 hexa-7-seg
	
	process (CLOCK_50, wr_out) begin
		if rising_edge(CLOCK_50) then
			io_registers(8) <= "0000000"&SW;
			io_registers(7) <= x"000"&KEY;
		
			if wr_out = '1' and adress_reg /= 7 and adress_reg /= 8  then
				io_registers(adress_reg) <= wr_io;
			elsif rd_in = '1' then
				rd_io <=  io_registers(adress_reg);
			else 	
				rd_io <= (others => 'X'); 
			end if;
		end if;
	end process;
	
	input_disp(3 downto 0) 	 <= io_registers(10)(3 downto 0)   when io_registers(9)(0) = '1' else (others => 'X');
	input_disp(7 downto 4)   <= io_registers(10)(7 downto 4)   when io_registers(9)(1) = '1' else (others => 'X');
	input_disp(11 downto 8)  <= io_registers(10)(11 downto 8)  when io_registers(9)(2) = '1' else (others => 'X');
	input_disp(15 downto 12) <= io_registers(10)(15 downto 12) when io_registers(9)(3) = '1' else (others => 'X');
	
	
	driver : BCD port map(input => input_disp, out_HEX0 => HEX0, out_HEX1 => HEX1, out_HEX2 => HEX2, out_HEX3 => HEX3);
END Structure;