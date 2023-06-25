LIBRARY ieee;
USE ieee.std_logic_1164.all;
--use work.all;
use work.op_code.all;
use work.f_code.all;

ENTITY control_l IS
	PORT (	ir				: IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			privilege_lvl_l : in std_LOGIC;
			boot			: IN  STD_LOGIC;
			clk				: IN  STD_LOGIC;
			estat_multi		: IN std_logic_vector(2 downto 0);
			op				: OUT op_code_t;
			f				: OUT f_code_t;
			wrd				: OUT STD_LOGIC;
			wrd_s			: OUT STD_LOGIC;
			wrd_f			: OUT STD_LOGIC;
			u_f_b			: OUT STD_LOGIC;
			wr_m			: OUT STD_LOGIC;
			immed_x2		: OUT STD_LOGIC;
			word_byte		: OUT STD_LOGIC;
			immed_or_reg	: OUT STD_LOGIC;
			halt_cont		: OUT STD_LOGIC;
			rd_in			: OUT STD_LOGIC;
			call			: OUT std_LOGIC; --exc signal
			ill_ins			: OUT STD_LOGIC; --exc signal
			protect 		: OUT std_LOGIC; --exc signal		
			wr_out			: OUT STD_LOGIC;
			float_add		: OUT std_logic;
			u_s_f			: OUT STD_LOGIC_VECTOR(1 downto 0);
			ldpc			: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			in_d			: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			addr_a			: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_b			: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_d			: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			int_type		: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			addr_io			: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			immed			: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			Instruccio		: OUT string(1 to 4); 	-- modelsim
			operacio		: OUT string(1 to 6)	-- modelsim
			);
END control_l;


ARCHITECTURE Structure OF control_l IS

	signal f_temp			: f_code_t;
	signal op_code_ir		: op_code_t;
	signal op_code_ir_pre	: op_code_t;
	signal ir_interna		: std_logic_vector(15 downto 0);
	signal halt_cont_b		: std_logic := '0';
		
BEGIN
	-- Mirem si IR conte X, si es el cas, fem una NOP
	process (ir) begin
		if is_X(ir) then
			ir_interna <= x"fffe";
		else
			ir_interna <= ir;
		end if;
	end process;
	
	-- Pasem l'input a un signal per mes easy of use per mirar els NOPS
	op_code_ir_pre <= ir_interna(15 downto 12);	
	
	-- Revisio per aplicar NOPS en operacions ilegals
	op_code_ir <= NOP when	
							 (op_code_ir_pre = HALT 
								and ir_interna(11 downto 0) /= x"fff"							-- SPECIAL(not HALT)
								and ir_interna(11 downto 0) /= x"020" 							-- SPECIAL(EI)
								and ir_interna(11 downto 0) /= x"021" 							-- SPECIAL(DI)
								and ir_interna(11 downto 0) /= x"024" 							-- SPECIAL(RETI)
								and ir_interna(5 downto 0) /= "101100"							-- SPECIAL(RDS)
								and ir_interna(5 downto 0) /= "110000"							-- SPECIAL(WRS)
								and ir_interna(5 downto 0) /= "101000")							-- SPECIAL (GETIID)
	
							or (op_code_ir_pre = COMP and ir_interna(5 downto 3) = "010")       -- NOP en operaciones COMP pero F_CODE no implementado
							or (op_code_ir_pre = COMP and ir_interna(5 downto 3) = "110")        
							or (op_code_ir_pre = COMP and ir_interna(5 downto 3) = "111")

							or (op_code_ir_pre = MULDIV and ir_interna(5 downto 3) = "011") 	-- NOP en operaciones MULDIV pero F_CODE no implementado
							or (op_code_ir_pre = MULDIV and ir_interna(5 downto 3) = "110")      
							or (op_code_ir_pre = MULDIV and ir_interna(5 downto 3) = "111") 
							    
							or (op_code_ir_pre = FLOAT and ir_interna(5 downto 3) = "110") 
							  
							or (op_code_ir_pre = JMP and ir_interna(5 downto 3) /= "000")			-- NOP en operaciones JMP pero F_CODE no implementado 
							or (op_code_ir_pre = JMP and ir_interna(5 downto 3) = "000" and ir_interna(2 downto 0) = "010")		
							or (op_code_ir_pre = JMP and ir_interna(5 downto 3) = "000" and ir_interna(2 downto 0) = "101") 
							or (op_code_ir_pre = JMP and ir_interna(5 downto 3) = "000" and ir_interna(2 downto 0) = "110")
							or (op_code_ir_pre = JMP and ir_interna(5 downto 3) = "000" and ir_interna(2 downto 0) = "011" and ir_interna(11 downto 9) /= "000") 
							or (op_code_ir_pre = JMP and ir_interna(5 downto 3) = "000" and ir_interna(2 downto 0) = "111" and ir_interna(11 downto 9) /= "000")-- NOP cuando hacemos CALLS con bits 11 a 9 NO zero

							or (op_code_ir_pre = IO and ir_interna(5 downto 0) > "100000") else	-- NOP en operaciones IO pero con puerto no accesible
					op_code_ir_pre;

	-- Assignem a la sortida de OP
	op <= op_code_ir;

	-- Assignem el port al que es vol fer IO
	-- En GETIID accedim al port 0 per indicar que es un get iid
	addr_io <=	ir_interna(7 downto 0) when op_code_ir /= HALT and f_temp /= GETIID_OP else
				x"00";
	
	-- Read IO enable quan ir(8) es 0
	rd_in <= not(ir_interna(8)) when op_code_ir = IO else '0';
	
	-- Write IO enable quan ir(8) es 1
	wr_out <= ir_interna(8) when op_code_ir = IO else '0';
	
	-- Signal Funcio_temporal ens permet definir dins de cada tipus de operacio general quina volem en concret
	f_temp 	<= 	ir_interna(5 downto 3) when op_code_ir /= MOVE 											-- Cas base: F esta als bits 5-3
											and op_code_ir /= BZ 
											and op_code_ir /= JMP 
											and op_code_ir/= IO 
											and op_code_ir /= HALT 
											and op_code_ir /= NOP 
				else	
					MOVHI when (op_code_ir = MOVE and ir_interna(8) = '1') else							-- Cas MOVE: F depen del bit 8
					MOVI when (op_code_ir = MOVE and ir_interna(8) = '0') else 					

					BZ_OP when (op_code_ir = BZ and ir_interna(8) = '0') else							-- Cas BN: F depen del bit 8 
					BNZ_OP when (op_code_ir = BZ and ir_interna(8) = '1') else

					IN_OP when (op_code_ir = IO and ir_interna(8) = '0') else							-- Cas IN/OUT: F depen del bit 8
					OUT_OP when (op_code_ir = IO and ir_interna(8) = '1') else

					JZ_OP when (op_code_ir = JMP and ir_interna(5 downto 3) = "000" and ir_interna(2 downto 0) = "000") else				-- Cas JMP: F depen dels bits 2-0
					JNZ_OP when (op_code_ir = JMP and ir_interna(5 downto 3) = "000" and ir_interna(2 downto 0) =  "001") else
					JMP_OP when (op_code_ir = JMP and ir_interna(5 downto 3) = "000" and ir_interna(2 downto 0) =  "011") else
					JAL_OP when (op_code_ir = JMP and ir_interna(5 downto 3) = "000" and ir_interna(2 downto 0) =  "100") else
					CALLS_OP when (op_code_ir = JMP and ir_interna(5 downto 3) = "000" and ir_interna(2 downto 0) =  "111") else			--Cas CALLS Produce una excepcion de tipo Ã¢â‚¬Å¡ instruccion ilegalgalÃ¢â‚¬Å¡si se ejecuta en modo sistema. Esta instruccion solo debepoderse ejecutar en modo usuario.

					RDS_OP when (op_code_ir = HALT and ir_interna(5 downto 0) = "101100") else			-- Cas R/W Sysreg: F depen dels bits 5-0
					WRS_OP when (op_code_ir = HALT and ir_interna(5 downto 0) = "110000") else
					GETIID_OP when (op_code_ir = HALT and ir_interna(5 downto 0) = "101000") else

					EI_OP when (op_code_ir = HALT and ir_interna(11 downto 0) = x"020") else			-- Cas EI/DI/RETI: F depen dels bits 11-0
					DI_OP when (op_code_ir = HALT and ir_interna(11 downto 0) = x"021") else
					RETI_OP when (op_code_ir = HALT and ir_interna(11 downto 0) = x"024") else
					HALT_OP when (op_code_ir = HALT and ir_interna(11 downto 0) = x"FFF") else
					NOP_OP when op_code_ir = NOP else

				NOP_OP;																					-- Else 0
	
	-- Assignem f
	f <= f_temp;
	
	--EXEPCION de la instruccions CALLS en decode. No hi ha conflictes amb ill_ins
	call <= '1' when (f_temp = CALLS_OP and op_code_ir = JMP and estat_multi = "001") else '0';
	
	--EXEPCION de proteccion
	protect <= 	'1' when (privilege_lvl_l = '0' and estat_multi = "001" and op_code_ir = HALT and f_temp = GETIID_OP) else
				'1' when (privilege_lvl_l = '0' and estat_multi = "001" and op_code_ir = HALT and f_temp = RDS_OP) else
				'1' when (privilege_lvl_l = '0' and estat_multi = "001" and op_code_ir = HALT and f_temp = WRS_OP) else
				'1' when (privilege_lvl_l = '0' and estat_multi = "001" and op_code_ir = HALT and f_temp = RETI_OP) else
				'1' when (privilege_lvl_l = '0' and estat_multi = "001" and op_code_ir = HALT and f_temp = EI_OP) else
				'1' when (privilege_lvl_l = '0' and estat_multi = "001" and op_code_ir = HALT and f_temp = DI_OP) else
				'0';
				-- Tecnicament, HALT, IN, OUT tambe pero ens deixen deixar-ho per fer els jocs de proba mes facils
				-- las operaciones {RDS, WRS, EI, DI, RETI y GETIID} solo se pueden ejecutar en modo SISTEMA
				
	--EXEPCION de instruccio ilegal si hem hagut de filtrar i posar un NOP o Call en Sysmode
	ill_ins <= 	'1' when op_code_ir /= op_code_ir_pre else
				'1' when (privilege_lvl_l = '1' and estat_multi = "001" and op_code_ir = JMP and f_temp = CALLS_OP) else -- INS que nomes es pot executar en mode user	
				'0';
	
	
	-- ldpc ens indica d'on carregar el nou PC
	-- Load next Pc or not (Fetch / Decode)
	-- En interrupcions no cal modificarho, perque ho controlem desde multi
	ldpc <= 	"011" when op_code_ir = HALT and ir_interna(11 downto 0) = x"fff" else	-- 011 HALT
				"010" when op_code_ir = BZ else											-- 010 BRANCH
				"111" when op_code_ir = JMP and f_temp = CALLS_OP else					-- 111 CALLS
				"001" when op_code_ir = JMP else										-- 001 JUMPS
				"100" when op_code_ir = HALT and ir_interna = x"f024" else				-- 100 RETI
				"000" ; 			 													-- 000 RUN;

	-- wrd habilita l'escriptura al banc de registres
	-- Sempre escrivim a reg_d excepte a HALT, STORES, JMPS(menys JAL), BRANCHES, OUT, NOP, EI, DI, RETI, WRS, CALLS
	wrd <= '0' when (op_code_ir = HALT and ir_interna(11 downto 0) = x"fff")
					or op_code_ir = ST 
					or op_code_ir = STB 
					or (op_code_ir = JMP and f_temp /= JAL_OP) 
					or op_code_ir = BZ 
					or (op_code_ir = NOP and op_code_ir_pre /= ADDI and f_temp /= GETIID_OP)
					or (op_code_ir = IO and f_temp = OUT_OP)
					or (op_code_ir = HALT and f_temp = EI_OP)
					or (op_code_ir = HALT and f_temp = DI_OP)
					or (op_code_ir = HALT and f_temp = RETI_OP)
					or (op_code_ir = HALT and f_temp = WRS_OP)
					or (op_code_ir = FLOAT)
					or (op_code_ir = LDF)
					or (op_code_ir = STF)
					else
		   '1';

	-- wrd_s habilita l'escriptura al banc de registres de sistema
	-- Nomes escribim a sysregfile en Interrupts, Exceptions, WRS, EI, DI, RETI, CALLS
	wrd_s <= '1' when 	(op_code_ir = HALT and f_temp = WRS_OP and privilege_lvl_l = '1')
						or (op_code_ir = HALT and f_temp = EI_OP and privilege_lvl_l = '1') 
						or (op_code_ir = HALT and f_temp = DI_OP and privilege_lvl_l = '1')
						or (op_code_ir = HALT and f_temp = RETI_OP and ir_interna = x"f024") -- Aixo es per evitar que en HALT, wrd_s = 1, ja que NOP i RETI tenen el mateix f_code
						or (op_code_ir = JMP and f_temp = CALLS_OP)
						else 
						'0';	
						
	-- wrd_f habilita l'escriptura al banc de registres de float		
	wrd_f <= '1' when (op_code_ir = FLOAT)
					  or (op_code_ir = LDF)
					  else 
			 '0';
			 
	
	
	-- u_s ens indica si llegim de user o system al banc de registres 
	-- Sempre user excepte RDS, RETI
	u_s_f <= 	"01" when (op_code_ir = HALT and f_temp = RDS_OP and privilege_lvl_l = '1')
			or (op_code_ir = HALT and f_temp = RETI_OP and ir_interna = x"f024") else -- Aixo es per evitar que en HALT, wrd_s = 1, ja que NOP i RETI tenen el mateix f_code
			"10" when (op_code_ir = FLOAT) else
			"00";
			
	u_f_b <= 	'1' when (op_code_ir = FLOAT or op_code_ir = STF) else
				'0';


	-- word_byte indica a la memora si accedim a nivell de word o byte; Sempre accedim a words excepte LDB i STB
	word_byte <= '1' when op_code_ir = LDB or op_code_ir = STB else '0';
	
	-- addr_a adreca A al banc de registres
	-- Sempre esta als 8-6 excepte als MOVE
	addr_a <=	"000" when 	(op_code_ir = NOP and op_code_ir_pre /= ADDI) else	-- Si es un NOP i el prefiltrat no era ADDI addr_a = 0; NOP i ADDI comparteixen OP_CODE aixi que ho detectem aixi
				ir_interna(11 downto 9) when op_code_ir = MOVE  else
				ir_interna(8 downto 6);
				
	-- addr_b adreca B al banc de registres
	with op_code_ir select
		addr_b <=	ir_interna(2 downto 0) when MULDIV,		-- Cas Multiplicacions o Divisions: addr_b esta als bits 2-0
					ir_interna(2 downto 0) when COMP,		-- Cas Comparacions: addr_b esta als bits 2-0
					ir_interna(2 downto 0) when AL,			-- Cas ALU: addr_b esta als bits 2-0
					ir_interna(2 downto 0) when FLOAT,
					"000" when NOP,							-- No cal posar lo de ADDI perque ADDI despres seleccionaria immed en comptes de reg
					ir_interna(11 downto 9) when others;	-- else addr_b als bits 11-9

	-- addr_d adreca D al banc de registres;				
	addr_d <= 	"000" when 	(op_code_ir = NOP and op_code_ir_pre /= ADDI and f_temp /= GETIID_OP) else -- Si es un NOP i el prefiltrat no era ADDI addr_d = 0; NOP i ADDI comparteixen OP_CODE aixi que ho detectem aixi
				"011" when op_code_ir = JMP and f_temp = CALLS_OP else
				ir_interna(11 downto 9);
	
	-- wr_m indica si escribim a memoria o no (1 si)
	with op_code_ir select
		wr_m <=	'1' when ST,
				'1' when STB,
				'1' when STF,
				'0' when others;
					
	-- in_d indica des d'on venen les dades que es guardaran a addr_d
	-- Desde memoria a LD i LDB, desde el PCup a JAL, desde io_reg en IN i la resta desde la ALU
	in_d <= "01" when (op_code_ir = LD or op_code_ir = LDB or op_code_ir = LDF) else 
			"10" when (op_code_ir = JMP and f_temp = JAL_OP) else 
			"11" when (op_code_ir = IO and f_temp = IN_OP) or (op_code_ir = HALT and f_temp = GETIID_OP) else
			"00";

	-- halt_cont indica si estem en HALT; REVISAR US
	--halt_cont <= '1' when op_code_ir = HALT and ir_interna(11 downto 0) = x"fff"  and estat_multi = "01" else 
	--			 '0';
	process (clk) begin
	-- halt_cont indica si estem en HALT; REVISAR US
		if boot = '1' then
			halt_cont <= '0';
			halt_cont_b <= '0';
		else
			if rising_edge(clk) then
				if halt_cont_b = '0' then
					if op_code_ir = HALT and ir_interna(11 downto 0) = x"fff" and estat_multi = "001" then
						halt_cont_b <= '1';
						halt_cont <= '1';
					else
						halt_cont_b <= '0';
						halt_cont <= '0';
					end if;
				end if;
			end if;
		end if;
	end process;
	
	-- immed_x2 indica si hem de multiplicar l'immediat x2 per accedir a memoria
	immed_x2 <= '1' when op_code_ir = LD or op_code_ir = ST or op_code_ir = LDF or op_code_ir = STF else 
				'0';
	
	-- immed_or_reg indica si entra a la Y l'immediat(0) o la sortida del banc de registres(1)
	-- Immediat en ST, STB, LD, LDB, ADDI o MOVES
	immed_or_reg <= '0' when 	op_code_ir = LD 
								or op_code_ir = ST 
								or op_code_ir = LDB 
								or op_code_ir = STB 
								or op_code_ir = LDF
								or op_code_ir = STF
								or op_code_ir = ADDI 
								or op_code_ir = MOVE else 
					'1' when (op_code_ir = NOP and op_code_ir_pre /= ADDI) else -- En cas de NOP entra a la ALU B, pero es indiferent perque el enable estara a 0
					'1';

	--immed depen de quina instruccio es esta codificat a llocs i tamanys diferents; Les dos seguents asignacions juguen amb com estan codificades
	immed(15 downto 8) <= 	(others => ir_interna(7)) when op_code_ir = MOVE or op_code_ir = BZ else	-- Cas MOVE o BZ: immed als 8 bits de menor pes (extenem el signe)
							--(others => ir_interna(5)) when op_code_ir = ADDI else						-- Cas ADDI: immed als 5 bits de menor pes (extenem el signe) --REV, es pot treure, perque ara tot son 6 bits; IDEM amb immed(7-0)
							(others => ir_interna(5)); 													-- Else: immed als 6 bits de menor pes (extenem el signe)

	immed(7 downto 0)  <= 	ir_interna(7 downto 0) when op_code_ir = MOVE or op_code_ir = BZ else 							-- Cas MOVE o BZ
							ir_interna(5)&ir_interna(5)&ir_interna(5 downto 0) when op_code_ir = ADDI else   				-- Cas ADDI: immed als 5 bits de menor pes; No pasa res si tambe es un NOP, perque els NOP pillen reg d'entrada a la alu
							ir_interna(5)&ir_interna(5)&ir_interna(5 downto 0);			                               		-- Else: immed als 6 bits de menor pes 

	
	-- int_type indica si la interrupcio es EI, DI, RETI
	-- El nom es una merda, perque no son Interrupcions, sino instruccions que tenen a veure amb interrupcions
	int_type <= "00" when (op_code_ir = HALT and f_temp = EI_OP and op_code_ir_pre /= ADDI) else
				"01" when (op_code_ir = HALT and f_temp = DI_OP and op_code_ir_pre /= ADDI) else
				"10" when (op_code_ir = HALT and f_temp = RETI_OP and op_code_ir_pre /= ADDI) else
				"11";	-- No es interrupcio, posem 11 de forma arbitraria
				
				
	float_add <= '1' when (op_code_ir = FLOAT and f_temp = ADDF_OP) or (op_code_ir = FLOAT and f_temp = SUBF_OP) else '0';


--MODELSIM SIGNALS	
Instruccio <=   "ALU " when op_code_ir = AL else 
				"COMP" when op_code_ir = COMP else 
				"ADDI" when op_code_ir_pre = ADDI else 
				"MUDI" when op_code_ir = MULDIV else 
				"MOVE" when op_code_ir = MOVE else 
				"LD  " when op_code_ir = LD else 
				"LDB " when op_code_ir = LDB else 
				"ST  " when op_code_ir = ST else 
				"LDF " when op_code_ir = LDF else 
				"STF " when op_code_ir = STF else 
				"FLOA" when op_code_ir = FLOAT else 
				"STB " when op_code_ir = STB else 
				"BN  " when op_code_ir = BZ else 
				"JMP " when op_code_ir = JMP else 
				"I/O " when op_code_ir = IO else
				"HALT" when (op_code_ir = HALT and ir_interna(11 downto 0) = x"fff") else
				"WRD " when (op_code_ir = HALT and f_temp = WRS_OP) else
				"RDS " when (op_code_ir = HALT and f_temp = RDS_OP) else
				"EI  " when (op_code_ir = HALT and f_temp = EI_OP) else
				"DI  " when (op_code_ir = HALT and f_temp = DI_OP) else	
				"RETI" when (op_code_ir = HALT and f_temp = RETI_OP) else
				"GETI" when (op_code_ir = HALT and f_temp = GETIID_OP) else
				"NOP ";
						 

operacio <= "AND   " when f_temp = AND_OP and op_code_ir = AL else 
			"OR    " when f_temp = OR_OP and op_code_ir = AL else 
			"XOR   " when f_temp = XOR_OP and op_code_ir = AL else 
			"NOT   " when f_temp = NOT_OP and op_code_ir = AL else 
			"ADD   " when f_temp = ADD_OP and op_code_ir = AL else 
			"SUB   " when f_temp = SUB_OP and op_code_ir = AL else 
			"SHA   " when f_temp = SHA_OP and op_code_ir = AL else 
			"SHL   " when f_temp = SHL_OP and op_code_ir = AL else 			
			"CMPLT " when f_temp = CMPLT_OP and op_code_ir = COMP else 
			"CMPLE " when f_temp = CMPLE_OP and op_code_ir = COMP else 
			"CMPEQ " when f_temp = CMPEQ_OP and op_code_ir = COMP else 
			"CMPLTU" when f_temp = CMPLTU_OP and op_code_ir = COMP else 
			"CMPLEU" when f_temp = CMPLEU_OP and op_code_ir = COMP else 
			"MUL   " when f_temp = MUL_OP and op_code_ir = MULDIV else 
			"MULH  " when f_temp = MULH_OP and op_code_ir = MULDIV else 
			"MULHU " when f_temp = MULHU_OP and op_code_ir = MULDIV else 
			"DIV   " when f_temp = DIV_OP and op_code_ir = MULDIV else 
			"DIVU  " when f_temp = DIVU_OP and op_code_ir = MULDIV else 
			"BZ    " when f_temp = BZ_OP and op_code_ir = BZ else 
			"BNZ   " when f_temp = BNZ_OP and op_code_ir = BZ else 
			"JZ    " when f_temp = JZ_OP and op_code_ir = JMP else 
			"JNZ   " when f_temp = JNZ_OP and op_code_ir = JMP else 
			"JMP   " when f_temp = JMP_OP and op_code_ir = JMP else 
			"JAL   " when f_temp = JAL_OP and op_code_ir = JMP else 
			"MOVHI " when f_temp = MOVHI and op_code_ir = MOVE else 
			"MOVI  " when f_temp = MOVI and op_code_ir = MOVE else 
			"LD    " when op_code_ir = LD else 
			"LDF   " when op_code_ir = LDF else 
			"LDB   " when op_code_ir = LDB else 
			"ST    " when op_code_ir = ST else 
			"STF   " when op_code_ir = STF else 
			"STB   " when op_code_ir = STB else 
			"ADDI  " when op_code_ir_pre = ADDI else
			"IN    " when f_temp = IN_OP and op_code_ir = IO else
			"OUT   " when f_temp = OUT_OP and op_code_ir = IO else
			"RDS   " when f_temp = RDS_OP and op_code_ir = HALT else
			"WRD   " when f_temp = WRS_OP and op_code_ir = HALT else
			"DI    " when f_temp = DI_OP and op_code_ir = HALT else
			"EI    " when f_temp = EI_OP and op_code_ir = HALT else
			"RETI  " when f_temp = RETI_OP and op_code_ir = HALT else
			"NOP   " when f_temp = NOP_OP and op_code_ir = NOP else
			"GETIID" when f_temp = GETIID_OP and op_code_ir = HALT else
			"MULF  " when f_temp = MULF_OP and op_code_ir = FLOAT else
			"DIVF  " when f_temp = DIVF_OP and op_code_ir = FLOAT else
			"CMPEQF" when f_temp = CMPEQF_OP and op_code_ir = FLOAT else
			"CMPLTF" when f_temp = CMPLTF_OP and op_code_ir = FLOAT else
			"CMPLEF" when f_temp = CMPLEF_OP and op_code_ir = FLOAT else
			"ADDF  " when f_temp = ADDF_OP and op_code_ir = FLOAT else
			"SUBF  " when f_temp = SUBF_OP and op_code_ir = FLOAT else
			"DEAD  ";
--END MODELSIM SIGNALS
	
END Structure;