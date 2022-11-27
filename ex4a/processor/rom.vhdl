library ieee;
use ieee.numeric_bit.all;
use std.textio.all;

entity rom is
   generic(
     file_name: string := "rom.dat";
     address_size : natural := 32;
     word_size    : natural := 32
   );
   port (
      address   : in  bit_vector(address_size-1 downto 0);
      read_data : out bit_vector(word_size-1 downto 0)
   );
 end entity;

architecture arch of rom is
  constant depth : natural := 2**address_size;
  type mem_t is array (0 to depth-1) of bit_vector(word_size-1 downto 0);

  constant mem : mem_t := (
    others => x"00000000"
  );
begin
  read_data <= x"00000000"; -- mem(to_integer(unsigned(address)));
end architecture;
