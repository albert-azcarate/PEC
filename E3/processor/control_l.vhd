LIBRARY ieee;
USE ieee.std_logic_1164.all;
use work.all;
use work.op_code.all;
use work.f_code.all;


ENTITY control_l IS
    PORT (ir        : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          op 		  : out  op_code_t;
          f         : out  f_code_t;
          ldpc      : OUT STD_LOGIC;
          wrd       : OUT STD_LOGIC;
          addr_a    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          immed     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          wr_m      : OUT STD_LOGIC;
          in_d      : OUT STD_LOGIC;
          immed_x2  : OUT STD_LOGIC;
          word_byte : OUT STD_LOGIC;
			 Instruccio: out string(1 to 4); 
			 operacio: out string(1 to 6));
END control_l;


ARCHITECTURE Structure OF control_l IS
	signal op_code_ir : op_code_t;
BEGIN
	op_code_ir <= ir(15 downto 12);
	op <= op_code_ir;
	f 	<= ir(5 downto 3);

	with op_code_ir select		-- Load next Pc or not (Fetch / Decode)
		ldpc <= 	'0' when HALT, 
					'1' when others;
					
	with op_code_ir select 		-- Enable register write; We always write to reg_d excepto on HALT or STORES
		wrd <=	'0' when HALT,
					'0' when ST,
					'0' when STB,
					'1' when others;
					
	word_byte <= '1' when op_code_ir= LDB or op_code_ir = STB else '0' ;	-- Notify the memory to use byte access
	
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
					
	with op_code_ir select 		-- Read data from memory(1) or ALU(0)
		in_d <=	'1' when LD,
					'1' when LDB,
					'0' when others;

					
	immed_x2 <= '1' when op_code_ir=LD or op_code_ir=ST else '0'; -- Immediate x2 to access words in Loads or Stores

	--FAlta
	immed(15 downto 8) <= (others => ir(7)) when op_code_ir=MOVE else (others => ir(5)); -- extenem singe
	immed(7 downto 0)  <= ir(7 downto 0) when op_code_ir=MOVE else ir(5)&ir(5)&ir(5 downto 0); -- copiem


	
	
	
	
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
						"MOVE  "	when "XXX"&MOVE,
						"LD    "	when "XXX"&LD,
						"LDB   "	when "XXX"&LDB,
						"ST    "	when "XXX"&ST,
						"STB   "	when "XXX"&STB,
						"-     " when others;

	
END Structure;