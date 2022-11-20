library ieee;
use ieee.numeric_bit.all;

entity core_fetch is
   port (
      clk, rst: in bit;
      -- Input
      --- Control
      pc_src: in bit;
      --- Data
      branch_pc: in bit_vector(31 downto 0);

      -- Output
      pc: out bit_vector(31 downto 0);
      instruction: out bit_vector(31 downto 0)
   );
end entity;

architecture arch of core_fetch is
component reg is
  generic(
    size: natural := 32
  );
  port(
    clk, rst: in bit;
    d: in bit_vector(size-1 downto 0);
    q: out bit_vector(size-1 downto 0)
  );
end component;

component rom is
   generic(
     file_name: string := "rom.dat";
     address_size : natural := 32;
     word_size    : natural := 32
   );
   port (
      address   : in  bit_vector(address_size-1 downto 0);
      read_data : out bit_vector(word_size-1 downto 0)
   );
end component;

signal internal_pc, pc_plus_4, next_pc: bit_vector(31 downto 0);
begin
    reg_pc: reg
      port map(
        clk => clk, 
        rst => rst,
        d => next_pc,
        q => internal_pc
      );
    pc_plus_4 <= bit_vector(unsigned(internal_pc) + to_unsigned(4, 32));
    next_pc <= pc_plus_4 when pc_src = '0' else branch_pc;

    rom_inst: rom
      port map(
        address => internal_pc,
        read_data => instruction
      );
    pc <= internal_pc;
end architecture;
