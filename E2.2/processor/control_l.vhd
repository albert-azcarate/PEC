LIBRARY ieee;
USE ieee.std_logic_1164.all;
use work.all;
use work.op_code.all;


ENTITY control_l IS
    PORT (ir        : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          op        : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
          ldpc      : OUT STD_LOGIC;
          wrd       : OUT STD_LOGIC;
          addr_a    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          immed     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          wr_m      : OUT STD_LOGIC;
          in_d      : OUT STD_LOGIC;
          immed_x2  : OUT STD_LOGIC;
          word_byte : OUT STD_LOGIC); 
END control_l;


ARCHITECTURE Structure OF control_l IS
	signal op_code_ir : op_code_t;
BEGIN
	op_code_ir <= ir(15 downto 12);

	with op_code_ir select
		ldpc <= 	'0' when HALT, -- HALT
					'1' when others; --not ldpc when others; -- FETCH - DECODE
					
	with op_code_ir select 
		wrd <=	'1' when MOVI, -- MOVI & MOVHI
					'1' when LD, -- LOAD
					'1' when LDB, -- LOAD
					'0' when others;
	
	with op_code_ir select 
		addr_a <=	ir(11 downto 9) when MOVI, -- MOVI & MOVHI
						ir(8 downto 6) when LD, -- LOAD
						ir(8 downto 6) when LDB, -- LOADB
						ir(8 downto 6) when ST, -- LOADB
						ir(8 downto 6) when STB, -- LOADB
						ir(11 downto 9) when others;
						
	with op_code_ir select 
		op <=	"0"&ir(8) when MOVI, -- MOVI & MOVHI
				"10" when others;
	
	with op_code_ir select 
		wr_m <=	'1' when ST, -- ST
					'1' when STB, -- STB
					'0' when others;
					
	with op_code_ir select 
		in_d <=	'1' when LD, -- LD
					'1' when LDB, -- LDB
					'0' when others;
					
	word_byte <= '1' when op_code_ir=LDB or op_code_ir=STB else '0' ;
		
--	immed(15 downto 8) <= (others => ir(7)); -- extenem singe
--	immed(7 downto 0) <= ir(7 downto 0); -- copiem

	immed(15 downto 8) <= (others => ir(7)) when op_code_ir=MOVI else (others => ir(5)); -- extenem singe
	immed(7 downto 0)  <= ir(7 downto 0) when op_code_ir=MOVI else ir(5)&ir(5)&ir(5 downto 0); -- copiem

	
	addr_d <= ir(11 downto 9);
	addr_b <= ir(11 downto 9);
	immed_x2 <= '1' when op_code_ir=LD or op_code_ir=ST else '0';


END Structure;