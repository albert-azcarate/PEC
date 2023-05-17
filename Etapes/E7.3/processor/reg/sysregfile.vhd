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
--		0 : Excepcion de tipo ?Instruccion ilegal?.
--		1 : Excepcion de tipo ?Acceso a memoria mal alineado?.
--		2 : Excepcion de tipo ?Overflow en operacion de coma flotante?.
--		3 : Excepcion de tipo ?Division por cero en coma flotante?
--		4 : Excepcion de tipo ?Division por cero en enteros o naturales?
--		5 ,...,14: No usadas en esta version. Reservados para futuras ampliaciones.
--		15: Interrupcion (externa)


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all; --Esta libreria sera necesaria si usais conversiones CONV_INTEGER
USE ieee.numeric_std.all;        --Esta libreria sera necesaria si usais conversiones TO_INTEGER
use work.reg.all;
use work.exc_code.all;

ENTITY sysregfile IS
    PORT (	clk			: IN  STD_LOGIC;
			boot		: IN  STD_LOGIC;
			wrd			: IN  STD_LOGIC;
			intr		: IN  STD_LOGIC;	
			inta		: IN  STD_LOGIC;
			exca		: IN STd_LOGIC;
			priv_lvl	: IN STd_LOGIC;
			exc_code	: IN  exc_code_t;
		  	int_type	: IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
			addr_a		: IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_d		: IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			d			: IN  STD_LOGIC_VECTOR(15 DOWNTO 0); --from REGfile std
			PCup		: IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			addr_m		: IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			int_e 		: OUT STD_LOGIC;
			sys_priv_lvl: OUT std_logic;
			a			: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
			);
END sysregfile;

ARCHITECTURE Structure OF sysregfile IS

signal reg_vector : slv_array_t := (others => x"0000");


BEGIN
	-- lectura asinc
	a <= 	reg_vector(5) when exca = '1' and reg_vector(7)(1) = '1' else
			reg_vector(5) when inta = '1' and reg_vector(7)(1) = '1' else
			reg_vector(1) when int_type = "10" else
			reg_vector(5) when exca = '1' and exc_code = call_c else --PC<-S5
			reg_vector(conv_integer(addr_a));
			
	int_e <= reg_vector(7)(1);
	sys_priv_lvl <= reg_vector(7)(0);
	
	process (clk, inta, boot, exca) begin
	
		if boot = '1' then
			-- Posem tots els registres a 0 (others => (others => '0'))
			reg_vector <= (others => (others => '0'));
			reg_vector(7)(0) <= '1'; -- System_Mode
		else 
			-- escriptura sinc
			if rising_edge(clk) then
				
			
				-- exc i int separats per discriminar millor
				if exc_code /= no_exc_c and exc_code /= interrupt_c and exca = '1' then -- Si es una excepcio i estan enabled
					
					-- Marquem que estem en una excepcio recursiva; Nomes passa en Calls en mode System
					if reg_vector(7)(0) = '1' then
						reg_vector(7)(15) <= '1';
					else 	
						reg_vector(7)(15) <= '0';		-- Else no hi ha recursivitat
					end if;
					
					reg_vector(0) <= reg_vector(7);
					reg_vector(1) <= PCup;
					reg_vector(7)(0) <= '1';	-- SystemMode
					reg_vector(7)(1) <= '0';	-- DI
					
					
					--En ppi tot aixo es pot unificar REVISAR
					if exc_code = call_c and reg_vector(7)(0) = '0' then -- Si CALL, guardem el codi de CALL, i al seguent cicle(priv = 1) guardem la resta
						reg_vector(2) <= x"000E";
					elsif exc_code /= call_c then
						reg_vector(2) <= x"000"&exc_code;
						reg_vector(3) <= addr_m;
					else		-- Aqui nomes entra CALLS en el 2n cicle de systema --REVISAR, aixo diria que es useless
						reg_vector(2) <= x"000"&exc_code;
					end if;
					
				elsif inta = '1'and reg_vector(7)(1) = '1' then -- Es una interrupcio i estan enabled
					reg_vector(0) <= reg_vector(7);
					reg_vector(1) <= PCup;
					reg_vector(2) <= x"000F";
					reg_vector(7)(0) <= '1';	-- SystemMode
					reg_vector(7)(1) <= '0';
				else
					if int_type = "00" then			-- EI
						reg_vector(7)(1) <= '1';
					elsif int_type = "01" then		-- DI
						reg_vector(7)(1) <= '0';
					elsif int_type = "10" then		-- RETI
						if reg_vector(7)(15) = '0'  then	-- Cas general, restaurem la PSW
							reg_vector(7) <= reg_vector(0);	
						elsif reg_vector(7)(15) = '1' then	-- Cas Call recursiu, posem la PSW en mode sistema i restaurem sys0 a com estaba
							reg_vector(7)(1 downto 0) <= "01";
							reg_vector(0)(1 downto 0) <= "10";
						end if;
						reg_vector(7)(15) <= '0';	-- Desmarquem que era recursiu, en cas general no passa res, en cas recursiu, el 1r reti ens retorna a on estavem
					else							-- USUAL WRITE
						if wrd = '1' then
							reg_vector(conv_integer(addr_d)) <= d;
						end if;
					end if;
				end if;
			end if;
		end if;
	end process;

END Structure;