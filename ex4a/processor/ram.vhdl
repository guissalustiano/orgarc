library ieee;
use ieee.numeric_bit.all;

entity ram is
   port (
      clk: in bit;

      -- enable write
      mem_write: in bit;

      -- enable read
      mem_read: in bit;

      -- 32 bits de endereço:
      addr: in bit_vector(31 downto 0);

      -- dado de escrita
      write_data: in bit_vector(31 downto 0);

      -- 32 bits de tamanho de palavra de dados:
      read_data: out bit_vector(31 downto 0)
   );
end ram;

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
