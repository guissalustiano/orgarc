library ieee;
use ieee.numeric_bit.all;
use ieee.numeric_std.resize;

entity imm_gen is
  generic(
    word_size : natural := 32
  );
  port(
    intruction: in  bit_vector(31 downto 0);
    immediate: out bit_vector(word_size-1 downto 0)
  );
end entity;

architecture arch of imm_gen is
  signal opcode: bit_vector(6 downto 0);
  signal intr_sig: signed(31 downto 0);
  signal imm, imm_r, imm_i, imm_s, imm_sb, imm_u, imm_uj: signed(word_size-1 downto 0);
begin
  opcode <= intruction(6 downto 0);
  intr_sig <= signed(intruction);

  imm_r  <= resize("0", word_size);
  imm_i  <= resize(intr_sig(31 downto 20), word_size);
  imm_s  <= resize(intr_sig(31 downto 25) & intr_sig(11 downto 0), word_size);
  imm_sb <= resize(intr_sig(31) & intr_sig(7) & intr_sig(30 downto 25) & intr_sig(11 downto 8), word_size);
  imm_u  <= resize(intr_sig(31 downto 12), word_size);
  imm_uj <= resize(intr_sig(31) & intr_sig(19 downto 12) & intr_sig(20) & intr_sig(30 downto 20), word_size);

  -- seguindo os valores da figura 2.18 do Patterson e Hanersy
  imm <= imm_r  when opcode = "0110011" else
         imm_i  when opcode = "0000011" 
                  or opcode = "0010011"
                  or opcode = "1100111" else
         imm_s  when opcode = "0100011"  else
         imm_sb when opcode = "1100111" else
         imm_u  when opcode = "0110111" else
         imm_uj when opcode = "1101111" else
         (others => '0');

  immediate <= bit_vector(imm);
end architecture;
