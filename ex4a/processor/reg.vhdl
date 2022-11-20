library ieee;
use ieee.numeric_bit.all;

entity reg is
  generic(
    size: natural := 32
  );
  port(
    clk, rst: in bit;
    d: in bit_vector(size-1 downto 0);
    q: out bit_vector(size-1 downto 0)
  );
end entity;

architecture arch of reg is
  signal value: bit_vector(size-1 downto 0);
begin
  process(clk, rst)
  begin
    if rst='1' then
        value <= (others => '0');
    elsif rising_edge(clk) then
        value <= d;
    end if;
  end process;
  q <= value;
end architecture;
