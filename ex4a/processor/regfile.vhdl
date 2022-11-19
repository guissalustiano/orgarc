library ieee;
use ieee.math_real.ceil;
use ieee.math_real.log2;
use ieee.numeric_bit.all;

entity regfile is
  generic(
    regn: natural := 32;
    wordSize: natural := 32
  );
  port(
    clk, rst, regWrite: in bit;
    rr1, rr2, wr: in bit_vector(natural(ceil(log2(real(regn))))-1 downto 0);
    d: in bit_vector(wordSize-1 downto 0);
    q1, q2: out bit_vector(wordSize-1 downto 0)
  );
end entity;

architecture arch of regfile is
  subtype reg_t is bit_vector(wordSize-1 downto 0);
  type regbank_t is array (1 to regn-1) of reg_t;
  signal regbank : regbank_t;
  signal wr_i, rr1_i, rr2_i: natural;
begin
  wr_i  <= to_integer(unsigned(wr));
  rr1_i <= to_integer(unsigned(rr1));
  rr2_i <= to_integer(unsigned(rr2));

  q1 <= regbank(rr1_i) when rr1_i /= 0 else (others => '0');
  q2 <= regbank(rr2_i) when rr2_i /= 0 else (others => '0');

  process(clk, rst)
  begin
    if rst='1' then
        regbank <= (others => (others => '0'));
    elsif rising_edge(clk) then
      if regWrite='1' and wr_i <= regbank_t'high then
        regbank(wr_i) <= d;
      end if;
    end if;
  end process;
end architecture;
