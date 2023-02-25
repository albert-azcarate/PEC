library ieee;
use ieee.std_logic_1164.all;

package EstatsMorse is
  subtype estatsmorse_t is std_logic_vector(1 downto 0);

  constant IDLE : estatsmorse_t := "00";
  constant START :estatsmorse_t := "01";
  constant WORKING : estatsmorse_t := "10";
  constant RESET : estatsmorse_t := "11";
end package EstatsMorse;
