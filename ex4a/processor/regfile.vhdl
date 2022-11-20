library ieee;
use ieee.math_real.ceil;
use ieee.math_real.log2;
use ieee.numeric_bit.all;

entity regfile is
  generic(
    regn: natural := 32;
    word_size : natural := 32
  );
  port(
    clk, rst, reg_write: in bit;
    rr1, rr2, wr: in bit_vector(natural(ceil(log2(real(regn))))-1 downto 0);
    d: in bit_vector(word_size-1 downto 0);
    q1, q2: out bit_vector(word_size-1 downto 0)
  );
end entity;

architecture arch of regfile is
  subtype reg_t is bit_vector(word_size-1 downto 0);
  type regbank_t is array (1 to regn-1) of reg_t;
  signal regbank : regbank_t;
  signal wr_int, rr1_int, rr2_int: natural;
begin
  wr_int  <= to_integer(unsigned(wr));
  rr1_int <= to_integer(unsigned(rr1));
  rr2_int <= to_integer(unsigned(rr2));

  q1 <= regbank(rr1_int) when rr1_int /= 0 else (others => '0');
  q2 <= regbank(rr2_int) when rr2_int /= 0 else (others => '0');

  process(clk, rst)
  begin
    if rst='1' then
        regbank <= (others => (others => '0'));
    elsif rising_edge(clk) then
      if reg_write='1' and wr_int > 0 then
        regbank(wr_int) <= d;
      end if;
    end if;
  end process;
end architecture;
