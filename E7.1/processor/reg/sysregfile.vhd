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
--		0 : Excepci�n de tipo ?Instrucci�n ilegal?.
--		1 : Excepci�n de tipo ?Acceso a memoria mal alineado?.
--		2 : Excepci�n de tipo ?Overflow en operaci�n de coma flotante?.
--		3 : Excepci�n de tipo ?Divisi�n por cero en coma flotante?
--		4 : Excepci�n de tipo ?Divisi�n por cero en enteros o naturales?
--		5 ,...,14: No usadas en esta versi�n. Reservados para futuras ampliaciones.
--		15: Interrupci�n (externa)


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all; --Esta libreria sera necesaria si usais conversiones CONV_INTEGER
USE ieee.numeric_std.all;        --Esta libreria sera necesaria si usais conversiones TO_INTEGER
use work.all;

ENTITY sysregfile IS
    PORT (	clk			: IN  STD_LOGIC;
			wrd			: IN  STD_LOGIC;
		  intr		: IN STD_LOGIC;	
		  inta		: IN STD_LOGIC;
			d			: IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			PCup			: IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			addr_a		: IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_d		: IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
		  	int_type	: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			a			: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			int_e : OUT STD_LOGIC
			);
END sysregfile;

ARCHITECTURE Structure OF sysregfile IS

signal reg_vector : reg.slv_array_t;


BEGIN
	-- lectura asinc
	a <= 	reg_vector(1) when int_type = "10" else 
			reg_vector(5) when intr = '1' and reg_vector(7)(1) = '1' else
			reg_vector(conv_integer(addr_a));
			
	int_e <= reg_vector(7)(1);
	
	process (clk) begin
		-- escriptura sinc
		if rising_edge(clk) then
			if intr = '1' and inta = '1' and reg_vector(7)(1) = '1' then
				reg_vector(0) <= reg_vector(7);
				reg_vector(1) <= PCup;
				reg_vector(2) <= x"000F";
				reg_vector(7)(1) <= '0';
			else
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
		end if;
	end process;

END Structure;