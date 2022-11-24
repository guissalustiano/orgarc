library ieee;
use ieee.numeric_bit.all;

entity reg is
  generic(
    size: natural := 32
  );
  port(
    clk: in bit;
    rst: in bit; -- reset sincrono
    clr: in bit; -- reset assincrono
    en: in bit; -- enable
    d: in bit_vector(size-1 downto 0);
    q: out bit_vector(size-1 downto 0)
  );
end entity;

architecture arch of reg is
  signal value: bit_vector(size-1 downto 0);
begin
  process(clk, rst)
  begin
    if clr='1' then
        value <= (others => '0');
    elsif rising_edge(clk) then
        if rst='1' then
          value <= (others => '0');
        elsif en='1' then
          value <= d;
        end if;
    end if;
  end process;
  q <= value;
end architecture;
