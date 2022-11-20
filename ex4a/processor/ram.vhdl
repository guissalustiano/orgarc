library ieee;
use ieee.numeric_bit.all;

entity ram is
   port (
      clk: in bit;
      mem_write: in bit;
      mem_read: in bit;
      addr: in bit_vector(31 downto 0);
      write_data: in bit_vector(31 downto 0);
      read_data: out bit_vector(31 downto 0)
   );
end entity;

architecture ram_arch of ram is
  type mem_type is array (0 to 2**32-1) of bit_vector(31 downto 0);
  signal mem: mem_type;
begin
  process(clk)
  begin
    if (rising_edge(clk)) then
      if (mem_write='1') then
        mem(to_integer(unsigned(addr))) <= write_data;
      end if;
    end if;
  end process;
    
  read_data <= mem(to_integer(unsigned(addr))) when mem_read = '1' 
               else (others => '0');
end ram_arch;
