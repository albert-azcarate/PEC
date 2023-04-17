library ieee;
use ieee.std_logic_1164.all;


package op_code is
  subtype op_code_t is std_logic_vector(3 downto 0);

  constant MOVI : op_code_t := "0101";
  constant MOVHI : op_code_t := "0101";
  constant LD : op_code_t := "0011";
  constant LDB : op_code_t := "1101";
  constant ST : op_code_t := "0100";
  constant STB : op_code_t := "1110";
  constant HALT : op_code_t := "1111";
  
end package op_code;