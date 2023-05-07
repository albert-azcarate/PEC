library ieee;
use ieee.std_logic_1164.all;


package op_code is
  subtype op_code_t is std_logic_vector(3 downto 0);

  constant AL 			: op_code_t := "0000"; -- 0
  constant COMP 		: op_code_t := "0001"; -- 1
  constant ADDI 		: op_code_t := "0010"; -- 2
  constant LD 			: op_code_t := "0011"; -- 3
  constant ST 			: op_code_t := "0100"; -- 4
  constant MOVE 		: op_code_t := "0101"; -- 5
  constant BZ	 		: op_code_t := "0110"; -- 6
  constant IO			: op_code_t := "0111"; -- 7
  constant MULDIV 		: op_code_t := "1000"; -- 8
  constant FLOAT		: op_code_t := "1001"; -- 9
  constant JMP	 		: op_code_t := "1010"; -- A
  constant LDF			: op_code_t := "1011"; -- B
  constant STF			: op_code_t := "1100"; -- C
  constant LDB 			: op_code_t := "1101"; -- D
  constant STB 			: op_code_t := "1110"; -- E
  constant HALT 		: op_code_t := "1111"; -- F; RDS, WRS, EI, DI, RETI, HALT = HALT, diferenciem per el f_code
  constant NOP			: op_code_t := "0010"; -- 2; NOP = ADDI R0 0
  
  
end package op_code;

library ieee;
use ieee.std_logic_1164.all;
package f_code is
 subtype f_code_t is std_logic_vector(2 downto 0); 

 constant AND_OP    : f_code_t := "000";
 constant OR_OP     : f_code_t := "001";
 constant XOR_OP    : f_code_t := "010";
 constant NOT_OP    : f_code_t := "011";
 constant ADD_OP    : f_code_t := "100";
 constant SUB_OP    : f_code_t := "101";
 constant SHA_OP    : f_code_t := "110";
 constant SHL_OP    : f_code_t := "111";
 
 constant CMPLT_OP  : f_code_t := "000";
 constant CMPLE_OP  : f_code_t := "001";
 constant CMPEQ_OP  : f_code_t := "011";
 constant CMPLTU_OP : f_code_t := "100";
 constant CMPLEU_OP : f_code_t := "101"; 
 constant MUL_OP    : f_code_t := "000";
 constant MULH_OP   : f_code_t := "001";
 constant MULHU_OP  : f_code_t := "010";
 constant DIV_OP    : f_code_t := "100";
 constant DIVU_OP   : f_code_t := "101";
 
 constant MOVI      : f_code_t := "000";
 constant MOVHI     : f_code_t := "001";
 
 constant BZ_OP     : f_code_t := "000";
 constant BNZ_OP    : f_code_t := "001";
 
 constant JZ_OP     : f_code_t := "000";
 constant JNZ_OP    : f_code_t := "001";
 constant JMP_OP    : f_code_t := "011";
 constant JAL_OP    : f_code_t := "100";
 --constant CALLS_OP 	: f_code_t := "111";
 constant NOP_OP    : f_code_t := "100";
 
 constant IN_OP     : f_code_t := "000";
 constant OUT_OP    : f_code_t := "001";
 
 constant RDS_OP    : f_code_t := "000";
 constant WRS_OP    : f_code_t := "001";
 constant EI_OP     : f_code_t := "010";
 constant DI_OP     : f_code_t := "011";
 constant RETI_OP   : f_code_t := "100";
 constant HALT_OP   : f_code_t := "111";
 constant GETIID_OP : f_code_t := "101";
 
end package f_code;

library ieee;
use ieee.std_logic_1164.all;


package exc_code is
  subtype exc_code_t is std_logic_vector(3 downto 0);

  constant ill_ins_c	: exc_code_t := "0000"; -- 0
  constant no_al_c		: exc_code_t := "0001"; -- 1
  constant ovf_f_c		: exc_code_t := "0010"; -- 2
  constant div_z_f_c	: exc_code_t := "0011"; -- 3
  constant div_z_c		: exc_code_t := "0100"; -- 4
  constant no_exc_c		: exc_code_t := "0101"; -- 5
  constant m_tlb_i_c	: exc_code_t := "0110"; -- 6
  constant m_tlb_d_c	: exc_code_t := "0111"; -- 7
  constant i_tlb_i_c	: exc_code_t := "1000"; -- 8
  constant i_tlb_d_c	: exc_code_t := "1001"; -- 9
  constant pp_tlb_i_c	: exc_code_t := "1010"; -- A
  constant pp_tlb_d_c	: exc_code_t := "1011"; -- B
  constant lec_tlb_c	: exc_code_t := "1100"; -- C
  constant protec_c		: exc_code_t := "1101"; -- D
  constant call_c		: exc_code_t := "1110"; -- E
  constant interrupt_c	: exc_code_t := "1111"; -- F;
  
  
end package exc_code;





