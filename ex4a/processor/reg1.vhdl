library ieee;
use ieee.numeric_bit.all;

entity reg1 is
  port(
    clk, rst: in bit;
    d: in bit;
    q: out bit
  );
end entity;

architecture arch of reg1 is
  signal value: bit;
begin
  process(clk, rst)
  begin
    if rst='1' then
        value <= '0';
    elsif rising_edge(clk) then
        value <= d;
    end if;
  end process;
  q <= value;
end architecture;
