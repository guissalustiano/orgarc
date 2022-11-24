library ieee;
use ieee.numeric_bit.all;

entity reg1 is
  port(
    clk: in bit;
    rst: in bit; -- reset sincrono
    clr: in bit; -- reset assincrono
    en: in bit; -- enable
    d: in bit;
    q: out bit
  );
end entity;

architecture arch of reg1 is
  signal value: bit;
begin
  process(clk, rst)
  begin
    if clr='1' then
      value <= '0';
    elsif rising_edge(clk) then
      if rst='1' then
        value <= '0';
      else
        value <= d;
      end if;
    end if;
  end process;
  q <= value;
end architecture;
