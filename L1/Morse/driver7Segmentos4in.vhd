-- Driver per display 7 segmetns.
-- Input: Caracter que es vol representar -> 4 bits
-- Output: Bits de disable al 7-Segments -> 7 bits

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY driver7Segmentos4in IS
	PORT( codigoCaracter : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			bitsCaracter : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
END driver7Segmentos4in;

ARCHITECTURE Structure OF driver7Segmentos4in IS
BEGIN

	with codigoCaracter select
		bitsCaracter <= 	"0001000" when "0000", -- a
								"0000011" when "0001", -- b
								"1000110" when "0010", -- c
								"0100001" when "0011", -- d
								"0000110" when "0100", -- e
								"0001110" when "0101", -- f
								"0010000" when "0110", -- g
								"0001001" when "0111", -- h
								"0111111" when others; -- -
	
END Structure; 
