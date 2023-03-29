LIBRARY ieee;
USE ieee.std_logic_1164.all;
use work.all;
use work.op_code.all;
use work.f_code.all;


ENTITY control_l IS
    PORT (ir        : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          op 		  : out  op_code_t;
          f         : out  f_code_t;
          ldpc      : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
          wrd       : OUT STD_LOGIC;
          addr_a    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          immed     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          wr_m      : OUT STD_LOGIC;
          in_d      : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
          immed_x2  : OUT STD_LOGIC;
          word_byte : OUT STD_LOGIC;
			 immed_or_reg : OUT STD_LOGIC;
			 halt_cont	 : out  STD_LOGIC;
			 Instruccio: out string(1 to 4); -- modELSIM
			 operacio: out string(1 to 6));	--modELSIM
END control_l;


ARCHITECTURE Structure OF control_l IS
	signal op_code_ir : op_code_t;
	signal op_code_ir_pre : op_code_t;
	signal f_temp : f_code_t;
BEGIN

	-- Pasem l'input a un signal per mes easy of use; REVISAR?
	op_code_ir_pre <= ir(15 downto 12);
	
	-- Assignem directament aquest singal a la sortida OP, que indica la operacio a fer
	op_code_ir <= 	NOP when op_code_ir_pre = IO 	-- I/O
						or op_code_ir_pre = FLOAT 	-- FLOAT
						or op_code_ir_pre = STF  -- STF
						or op_code_ir_pre = LDF 	-- LDF
						or (op_code_ir_pre = HALT and ir(11 downto 0) /= x"fff") else -- NOP(ADDI ro,0) when I/O, FLOAT, STF, LDF and SPECIAL(not HALT)
					op_code_ir_pre;
	op <= op_code_ir;
	
	-- Signal Funcio_temporal ens permet definir dins de cada tipus de operacio general quina vole en concret
	f_temp 	<= ir(5 downto 3) when op_code_ir /= MOVE and op_code_ir /= BZ and op_code_ir /= JMP and op_code_ir /= NOP else	-- Cas base: F esta als bits 5-3
			MOVHI when (op_code_ir = MOVE and ir(8) = '1') else 										-- Cas MOVE: F depen del bit 8
			MOVI when (op_code_ir = MOVE and ir(8) = '0') else 
			BZ_OP when (op_code_ir = BZ and ir(8) = '0') else											-- Cas BN: F depen del bit 8 
			BNZ_OP when (op_code_ir = BZ and ir(8) = '1') else
			JZ_OP when (op_code_ir = JMP and ir(2 downto 0) = "000") else								-- Cas JMP: F depen dels bits 2-0
			JNZ_OP when (op_code_ir = JMP and ir(2 downto 0) =  "001") else
			JMP_OP when (op_code_ir = JMP and ir(2 downto 0) =  "011") else
			JAL_OP when (op_code_ir = JMP and ir(2 downto 0) =  "100") else
			NOP_OP when op_code_ir = NOP else
			NOP_OP;																			-- Else 0
	
	-- Assignem f
	f <= f_temp;

	-- ldpc ens indica si d'on carregar el nou PC
	-- Load next Pc or not (Fetch / Decode)
	ldpc <= 	"11" when op_code_ir = HALT and ir(11 downto 0) = x"fff" else	-- 11 HALT
				"10" when op_code_ir = BZ else									-- 10 BRANCH
				"01" when op_code_ir = JMP else									-- 01 JUMPS
				"00";			 									-- 00 RUN; falta CALLS

	-- wrd habilita l'escriptura al banc de registres
	-- Sempre escrivim a reg_d excepte a HALT, STORES, JMPS(menys JAL) i BRANCHES 
	wrd <= '0' when (op_code_ir = HALT and ir(11 downto 0) = x"fff")
					or op_code_ir = ST 
					or op_code_ir = STB 
					or (op_code_ir = JMP and f_temp /= JAL_OP)
					or op_code_ir = BZ 
					or (op_code_ir = NOP and op_code_ir_pre /= ADDI) else
		   '1';
	
	-- word_byte indica a la memora si accedim a nivell de word o byte; Sempre accedim a words excepte LDB i STB
	word_byte <= '1' when op_code_ir = LDB or op_code_ir = STB else '0';
	
	-- addr_a adreca A al banc de registres
	-- Sempre esta als 8-6 excepte als MOVE
	addr_a <=	"000" when (op_code_ir = NOP and op_code_ir_pre /= ADDI) else
				ir(11 downto 9) when op_code_ir = MOVE else
				ir(8 downto 6);
				
	-- addr_b adreca B al banc de registres
	with op_code_ir select
		addr_b <=	ir(2 downto 0) when MULDIV,		-- Cas Multiplicacions o Divisions: addr_b esta als bits 2-0
					ir(2 downto 0) when COMP,		-- Cas Comparacions: addr_b esta als bits 2-0
					ir(2 downto 0) when AL,			-- Cas ALU: addr_b esta als bits 2-0
					"000" when NOP,
					ir(11 downto 9) when others;	-- else addr_b als bits 11-9

	-- addr_d adreca D al banc de registres;				
	addr_d <= 	"000" when (op_code_ir = NOP and op_code_ir_pre /= ADDI) else --useless
				ir(11 downto 9);
	
	-- wr_m indica si escribim a memoria o no (1 si)
	with op_code_ir select
		wr_m <=	'1' when ST,
				'1' when STB,
				'0' when others;
					
	-- in_d indica des d'on venen les dades que es guardaran a addr_d
	-- Desde memoria a LD i LDB, desde el PCup a JAL i la resta desde la ALU
	in_d <= "01" when op_code_ir = LD or op_code_ir = LDB else "10" when (op_code_ir = JMP and f_temp = JAL_OP) else "00";

	-- halt_cont indica si estem en HALT; REVISAR US
	halt_cont <= '1' when op_code_ir = HALT and ir(11 downto 0) = x"fff" else '0';
	
	-- immed_x2 indica si hem de multiplicar l'immediar x2 per accedir a memoria; Ho fem en ST i LB
	immed_x2 <= '1' when op_code_ir=LD or op_code_ir=ST else '0';
	
	-- immed_or_reg indica si entra a la Y l'immediat(0) o la sortida del banc de registres(1)
	-- Immediat en ST, STB, LD, LDB, ADDI o MOVES
	immed_or_reg <= '0' when op_code_ir = LD or op_code_ir = ST or op_code_ir = LDB or op_code_ir = STB or op_code_ir = ADDI or op_code_ir = MOVE else 
					'1' when (op_code_ir = NOP and op_code_ir_pre /= ADDI) else
					'1';

	--immed depen de quina instruccio es esta codificat a llocs i tamanys diferents; Les dos seguents asignacions juguen amb com estan codificades
	immed(15 downto 8) <= 	(others => ir(7)) when op_code_ir = MOVE or op_code_ir = BZ else	-- Cas MOVE: [BZ(REVISAR)] immed als 8 bits de menor pes (extenem el signe)
							(others => ir(4)) when op_code_ir = ADDI else						-- Cas ADDI: immed als 5 bits de menor pes (extenem el signe)
							(others => ir(5)); 													-- Else: immed als 6 bits de menor pes (extenem el signe)
							
	immed(7 downto 0)  <= 	ir(7 downto 0) when op_code_ir = MOVE or op_code_ir = BZ else 		-- Cas MOVE: [BZ(REVISAR)] immed als 8 bits de menor pes
							ir(4)&ir(4)&ir(4)&ir(4 downto 0) when op_code_ir = ADDI else        -- Cas ADDI: immed als 5 bits de menor pes
							ir(5)&ir(5)&ir(5 downto 0);			                               	-- Else: immed als 6 bits de menor pes 
	
	
-- MODELSIM SIGNALS
	
	Instruccio <=   "ALU " when op_code_ir = AL else 
					"COMP" when op_code_ir = COMP else 
					"ADDI" when op_code_ir_pre = ADDI else 
					"MUDI" when op_code_ir = MULDIV else 
					"MOVE" when op_code_ir = MOVE else 
					"LD  " when op_code_ir = LD else 
					"LDB " when op_code_ir = LDB else 
					"ST  " when op_code_ir = ST else 
					"STB " when op_code_ir = STB else 
					"BN  " when op_code_ir = BZ else 
					"JMP " when op_code_ir = JMP else 
					"HALT" when (op_code_ir = HALT and ir(11 downto 0) = x"fff") else 
					"NOP ";
							 
	with f_temp & op_code_ir select
		operacio <= "AND   " when AND_OP&AL,
					"OR    " when OR_OP&AL,
					"XOR   " when XOR_OP&AL,
					"NOT   " when NOT_OP&AL,
					"ADD   " when ADD_OP&AL,
					"SUB   " when SUB_OP&AL,
					"SHA   " when SHA_OP&AL,
					"SHL   " when SHL_OP&AL,			
					"CMPLT " when CMPLT_OP&COMP,
					"CMPLE " when CMPLE_OP&COMP,
					"CMPEQ " when CMPEQ_OP&COMP,
					"CMPLTU" when CMPLTU_OP&COMP,
					"CMPLEU" when CMPLEU_OP&COMP,
					"MUL   " when MUL_OP&MULDIV,
					"MULH  " when MULH_OP&MULDIV,
					"MULHU " when MULHU_OP&MULDIV,
					"BZ    " when BZ_OP&BZ,
					"BNZ   " when BNZ_OP&BZ,
					"JZ    " when JZ_OP&JMP,
					"JNZ   " when JNZ_OP&JMP,
					"JMP   " when JMP_OP&JMP,
					"JAL   " when JAL_OP&JMP,
					"MOVHI " when MOVHI&MOVE,
					"MOVI  " when MOVI&MOVE,
					"LD    " when "XXX"&LD,
					"LDB   " when "XXX"&LDB,
					"ST    " when "XXX"&ST,
					"STB   " when "XXX"&STB,
					"NOP   " when NOP_OP&NOP,
					"-     " when others;

	
END Structure;