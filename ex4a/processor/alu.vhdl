library ieee;
use ieee.numeric_bit.all;

entity alu1 is
  port (
    A, B, Ci, Less: in bit;
    Ainv, Binv: in bit;
    F   : out bit;
    S   : in  bit_vector(1 downto 0);
    Ov, Co, Set: out bit
  );
end entity;

architecture arch of alu1 is
  signal F_0, F_1, F_2, F_3: bit;
  signal Aloc, Bloc: bit;
  signal Coloc, Ovloc: bit;
begin
  Aloc <= A when Ainv='0' else not A;
  Bloc <= B when Binv='0' else not B;

  F_0 <= Aloc and Bloc;
  F_1 <= Aloc or  Bloc;
  F_2 <= Aloc xor Bloc xor Ci;
  F_3 <= Less;

  F <= F_0 when S="00" else
       F_1 when S="01" else
       F_2 when S="10" else
       F_3;

  Coloc <= (Aloc and Bloc) or (Aloc and Ci) or (Ci and Bloc);
  Ovloc <= Coloc xor Ci;

  Ov <= Ovloc;
  Co <= Coloc;
  Set <= F_2 xor Ovloc;

end architecture;

-------------------------------------------------------------

library ieee;
use ieee.numeric_bit.all;

entity alu is
  generic(
    size: natural := 32
  );
  port (
    A, B: in bit_vector(size-1 downto 0);
    F   : out bit_vector(size-1 downto 0);
    S   : in  bit_vector(3 downto 0);
    Z, Ov, Co: out bit
  );
end entity;


-- based in https://stackoverflow.com/questions/42189877/implementing-overflow-checking-in-4-bit-adder-subtractor-vhdl#42368859
architecture arch of alu is
  component alu1 is
    port (
      A, B, Ci, Less: in bit;
      Ainv, Binv: in bit;
      F   : out bit;
      S   : in  bit_vector(1 downto 0);
      Ov, Co, Set: out bit
    );
  end component;

  constant ZERO: bit_vector(size-1 downto 0) := (others => '0');
  constant ONE: bit_vector(size-1 downto 0) := ZERO(size-1 downto 1) & "1";
  signal c, Ovloc, Less, SetLoc: bit_vector(size downto 0);
  signal Floc: bit_vector(size-1 downto 0);
  signal Ainv, Binv: bit;
  signal Smini: bit_vector(1 downto 0);
begin
  Less <= ZERO & SetLoc(size-1);
  Ainv <= S(3);
  Binv <= S(2);
  Smini <= S(1 downto 0);

  c(0) <= S(2);
  gen: for i in F'reverse_range generate
      inst: alu1 port map(A(i), B(i), c(i), B(i),
                    Ainv, Binv,
                    Floc(i),
                    Smini,
                    Ovloc(i), c(i+1), SetLoc(i));
  end generate;

  F <= Floc;
  Z <= '1' when Floc = ZERO else '0';
  Ov <= Ovloc(size-1);
  Co <= c(size);
end architecture;
