library ieee;
use ieee.std_logic_1164.all;


package op_code is
  subtype op_code_t is std_logic_vector(3 downto 0);

  constant AL 			: op_code_t := "0000";
  constant COMP 		: op_code_t := "0001";
  constant ADDI 		: op_code_t := "0010";
  constant LD 			: op_code_t := "0011";
  constant ST 			: op_code_t := "0100";
  constant MOVE 		: op_code_t := "0101";
  constant BZ	 		: op_code_t := "0110";
  constant IO			: op_code_t := "0111";
  constant MULDIV 		: op_code_t := "1000";
  constant FLOAT		: op_code_t := "1001";
  constant JMP	 		: op_code_t := "1010";
  constant LDF			: op_code_t := "1011";
  constant STF			: op_code_t := "1100";
  constant LDB 			: op_code_t := "1101";
  constant STB 			: op_code_t := "1110";
  constant HALT 		: op_code_t := "1111";
  constant NOP			: op_code_t := "0010"; -- NOP = ADDI R0 0

  
end package op_code;

library ieee;
use ieee.std_logic_1164.all;
package f_code is
  subtype f_code_t is std_logic_vector(2 downto 0);

  constant AND_OP 	: f_code_t := "000";
  constant OR_OP 		: f_code_t := "001";
  constant XOR_OP 	: f_code_t := "010";
  constant NOT_OP 	: f_code_t := "011";
  constant ADD_OP 	: f_code_t := "100";
  constant SUB_OP 	: f_code_t := "101";
  constant SHA_OP 	: f_code_t := "110";
  constant SHL_OP 	: f_code_t := "111";
  
  constant CMPLT_OP 	: f_code_t := "000";
  constant CMPLE_OP 	: f_code_t := "001";
  constant CMPEQ_OP 	: f_code_t := "011";
  constant CMPLTU_OP : f_code_t := "100";
  constant CMPLEU_OP : f_code_t := "101";

  constant MUL_OP 	: f_code_t := "000";
  constant MULH_OP 	: f_code_t := "001";
  constant MULHU_OP 	: f_code_t := "010";
  constant DIV_OP 	: f_code_t := "100";
  constant DIVU_OP 	: f_code_t := "101";
  
  constant MOVI 	: f_code_t := "000";
  constant MOVHI 	: f_code_t := "001";
  
 constant BZ_OP 	: f_code_t := "000";
 constant BNZ_OP 	: f_code_t := "001";
 
 constant JZ_OP 	: f_code_t := "000";
 constant JNZ_OP 	: f_code_t := "001";
 constant JMP_OP 	: f_code_t := "011";
 constant JAL_OP 	: f_code_t := "100";
 --constant CALLS_OP 	: f_code_t := "111";
 constant NOP_OP 	: f_code_t := "100";
 
 constant IN_OP 	: f_code_t := "000";
 constant OUT_OP 	: f_code_t := "001";
end package f_code;





