-- Special Registers:
--		0 - Paraula de estat en el moment de la excepcio o interrupcio (PSW on ex/int)
--		1 - Direccio de retorn de la rutina d'excepcio o interrupcio (PC on ex/int)
--		2 - Tipus de excepcio o interrupcio 
--		3 - Direccio feta servir quan s'ha produit una excepcio de acces mal alineat (PC on misaligned access)
--		4 - Variable temporal
--		5 - Direccio de memoria de RSG
--		6 - Futures ampliacions; Not used in this version
--		7 - Processor Status Word (PSW); 
										-- Bit M <0> Future ampliacions; Not used in this version
										-- Bit I <1> Interrupcions habilitades; Modificable per EI, DI
										-- Bit V <2> Overflow habilitat


-- Tipus de excepcio o interrupcio:
--		0 : Excepción de tipo ?Instrucción ilegal?.
--		1 : Excepción de tipo ?Acceso a memoria mal alineado?.
--		2 : Excepción de tipo ?Overflow en operación de coma flotante?.
--		3 : Excepción de tipo ?División por cero en coma flotante?
--		4 : Excepción de tipo ?División por cero en enteros o naturales?
--		5 ,...,14: No usadas en esta versión. Reservados para futuras ampliaciones.
--		15: Interrupción (externa)


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all; --Esta libreria sera necesaria si usais conversiones CONV_INTEGER
USE ieee.numeric_std.all;        --Esta libreria sera necesaria si usais conversiones TO_INTEGER
use work.all;

ENTITY sysregfile IS
    PORT (	clk			: IN  STD_LOGIC;
			wrd			: IN  STD_LOGIC;
			d			: IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			addr_a		: IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_d		: IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
		  	int_type	: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			a			: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
			);
END sysregfile;

ARCHITECTURE Structure OF sysregfile IS

signal reg_vector : reg.slv_array_t;


BEGIN
	-- lectura asinc
	a <= reg_vector(1) when int_type = "10" else reg_vector(conv_integer(addr_a));
	
	process (clk) begin
		-- escriptura sinc
		if rising_edge(clk) then
			if int_type = "00" then			-- EI
				reg_vector(7)(1) <= '1';
			elsif int_type = "01" then		-- DI
				reg_vector(7)(1) <= '0';
			elsif int_type = "10" then		-- RETI
				reg_vector(7) <= reg_vector(0);
			else							-- USUAL WRITE
				if wrd = '1' then
					reg_vector(conv_integer(addr_d)) <= d;
				end if;
			end if;
		end if;
	end process;

END Structure;