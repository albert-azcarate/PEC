-- Conversor de numeros de 16 bits a 7 segments
-- Input: Numero a fer display -> 16 bits
-- Output: 4 busos per enviar als displays -> 4 busos de 7 bits

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY Hex2Segment IS
	PORT(	input : in std_logic_vector(15 downto 0);
			OUT_HEX0 : OUT std_logic_vector(6 downto 0);
			OUT_HEX1 : OUT std_logic_vector(6 downto 0);
			OUT_HEX2 : OUT std_logic_vector(6 downto 0);
			OUT_HEX3 : OUT std_logic_vector(6 downto 0));
END Hex2Segment;

ARCHITECTURE Structure OF Hex2Segment IS

component driver7Segmentos4in is 
	PORT( codigoCaracter : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			bitsCaracter : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
end component;

BEGIN
	
	D0: driver7Segmentos4in port map(codigoCaracter => input(3 downto 0) , bitsCaracter => OUT_HEX0);
	D1: driver7Segmentos4in port map(codigoCaracter => input(7 downto 4) , bitsCaracter => OUT_HEX1);
	D2: driver7Segmentos4in port map(codigoCaracter => input(11 downto 8) , bitsCaracter => OUT_HEX2);
	D3: driver7Segmentos4in port map(codigoCaracter => input(15 downto 12) , bitsCaracter => OUT_HEX3);
	
END Structure;