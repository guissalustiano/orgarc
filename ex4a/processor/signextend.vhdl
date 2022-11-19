library IEEE;
use IEEE.numeric_bit.all;
use IEEE.numeric_std.resize;

entity signExtend is
  port(
  i: in  bit_vector(31 downto 0); -- input
  o: out bit_vector(63 downto 0) -- output
  );
end signExtend;

architecture arch of signExtend is
  signal opcode: natural;
  signal i_sig: signed(31 downto 0);
  signal o_sig: signed(63 downto 0);
begin
  opcode <= i(6 downto 0)
  opcode_int <= to_integer(unsigned(opcode));
  i_sig <= signed(i);
  o <= bit_vector(o_sig);

  -- lw
  -- sw
  -- beq
  -- intr tipo r (and, sub, add, or)
  imm_r  <= resize("0", 64);
  imm_i  <= resize(i_sig(31 downto 20), 64);
  imm_s  <= resize(i_sig(31 downto 25) & i_sig(11 downto 0), 64);
  imm_sb <= resize(i_sig(31) & i_sig(7) & i_sig(30 downto 25) & i_sig(11 downto 8), 64);
  imm_u  <= resize(i_sig(31 downto 12), 64);
  imm_uj <= resize(i_sig(31) & i_sig(19 downto 12) & i_sig(20) & i_sig(30 downto 20), 64);

  -- seguindo os valores da figura 2.18 do Patterson e Hanersy
  o_sig <= imm_r  when opcode = "0110011" else
           imm_i  when opcode = "0000011" 
                    or opcode = "0010011"
                    or opcode = "1100111" else
           imm_s  when opcode = "0100011"  else
           imm_sb when opcode = "1100111" else
           imm_u  when opcode = "0110111" else
           imm_uj when opcode = "1101111" else
           (others => "0");
end architecture;
