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
BEGIN
	op_code_ir <= ir(15 downto 12);
	op <= op_code_ir;
	f 	<= ir(5 downto 3) when op_code_ir /= MOVE and op_code_ir /= BZ else
			MOVHI when (op_code_ir = MOVE and ir(8) = '1') else 
			MOVI when (op_code_ir = MOVE and ir(8) = '0') else 
			BZ_OP when (op_code_ir = BZ and ir(8) = '0') else
			BNZ_OP when (op_code_ir = BZ and ir(8) = '1')else
			JZ_OP when op_code_ir = JMP and ir(2 downto 0) = "000" else
			JNZ_OP when op_code_ir = JMP and ir(2 downto 0) =  "001" else
			JMP_OP when op_code_ir = JMP and ir(2 downto 0) =  "011" else
			JAL_OP when op_code_ir = JMP and ir(2 downto 0) =  "100";

	with op_code_ir select		-- Load next Pc or not (Fetch / Decode)
		ldpc <= 	"11" when HALT, 
					"10" when BZ,
					"01" when JMP,
					"00" when others; --falta CALLS
					
	with op_code_ir select 		-- Enable register write; We always write to reg_d excepto on HALT or STORES
		wrd <=	'0' when HALT,
					'0' when ST,
					'0' when STB,
					'1' when others;
					
	word_byte <= '1' when op_code_ir = LDB or op_code_ir = STB else '0' ;	-- Notify the memory to use byte access
	
	with op_code_ir select 		-- Addres A
		addr_a <=	ir(11 downto 9) when MOVE, -- MOVI & MOVHI
						ir(8 downto 6) when others;
	
	with op_code_ir select 		-- Addres B
		addr_b <=	ir(2 downto 0) when MULDIV,
						ir(2 downto 0) when COMP,
						ir(2 downto 0) when AL,
						ir(11 downto 9) when others;
						
	addr_d <= ir(11 downto 9);	-- Adress D
						
	with op_code_ir select		-- Write data to memory(1)
		wr_m <=	'1' when ST,
					'1' when STB,
					'0' when others;
					
	with op_code_ir select 		-- Read data from memory(01) or ALU(00) or PC(10)
		in_d <=	"01" when LD,
					"01" when LDB,
					"10" when JMP,
					"00" when others;

	halt_cont <= '1' when op_code_ir = HALT else '0';
	
	immed_x2 <= '1' when op_code_ir=LD or op_code_ir=ST else '0'; -- Immediate x2 to access words in Loads or Stores
	
	immed_or_reg <= '0' when op_code_ir = LD or op_code_ir = ST or op_code_ir = LDB or op_code_ir = STB or op_code_ir = ADDI or op_code_ir = MOVE or op_code_ir = BZ or op_code_ir = JMP else '1';

	--Faltaran Branch jumps
	immed(15 downto 8) <= (others => ir(7)) when op_code_ir = MOVE or op_code_ir = BZ else (others => ir(4)) when op_code_ir = ADDI else (others => ir(5)); -- extenem singe --revisar LD and ST neg
	immed(7 downto 0)  <= ir(7 downto 0) when op_code_ir = MOVE or op_code_ir = BZ else ir(4)&ir(4)&ir(4)&ir(4 downto 0) when op_code_ir = ADDI else ir(5)&ir(5)&ir(5 downto 0); -- copiem
		
	
-- MODELSIM SIGNALS
	with op_code_ir select
		 Instruccio <=  "ALU " when AL,
							 "COMP" when COMP,
							 "ADDI" when ADDI,
							 "MUDI" when MULDIV,
							 "MOVE" when MOVE,
							 "LD  " when LD,
							 "LDB " when LDB,
							 "ST  " when ST,
							 "STB " when STB,
							 "BN  " when BZ,
							 "JMP " when JMP,
							 "HALT" when HALT,
							 "NONE" 	when others;
							 
	with ir(5 downto 3) & op_code_ir select
		operacio <= "AND   " when "000"&AL,
						"OR    "	when "001"&AL,
						"XOR   " when "010"&AL,
						"NOT   " when "011"&AL,
						"ADD   " when "100"&AL,
						"SUB   " when "101"&AL,
						"SHA   " when "110"&AL,
						"SHL   " when "111"&AL,			
						"CMPLT " when "000"&COMP,
						"CMPLE " when "001"&COMP,
						"CMPEQ " when "011"&COMP,
						"CMPLTU" when "100"&COMP,
						"CMPLEU" when "101"&COMP,
						"MUL   "	when "000"&MULDIV,
						"MULH  "	when "001"&MULDIV,
						"MULHU "	when "010"&MULDIV,
						"BZ    "	when "000"&BZ,
						"BNZ   "	when "001"&BZ,
						"JZ    "	when "000"&JMP,
						"JNZ   "	when "001"&JMP,
						"JMP   "	when "011"&JMP,
						"JAL   "	when "101"&JMP,
						"MOVE  "	when "XXX"&MOVE,
						"LD    "	when "XXX"&LD,
						"LDB   "	when "XXX"&LDB,
						"ST    "	when "XXX"&ST,
						"STB   "	when "XXX"&STB,
						"-     " when others;

	
END Structure;