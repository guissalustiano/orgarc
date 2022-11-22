library ieee;
use ieee.math_real.ceil;
use ieee.math_real.log2;
use ieee.numeric_bit.all;

entity core_decode is
   port (
      clk, rst: in bit;
      --- Inputs
      instruction: in bit_vector(31 downto 0);
      WB_write_register: in bit_vector(4 downto 0);
      WB_write_data: in bit_vector(31 downto 0);
      WB_reg_write: in bit;

      -- Output
      --- Control
      alu_src: out bit;
      alu_op: out bit_vector(1 downto 0);
      branch: out bit;
      mem_read: out bit;
      mem_write: out bit;
      reg_write: out bit;
      mem_to_reg: out bit;
      --- Data 
      read_register_1: out bit_vector(4 downto 0);
      read_register_2: out bit_vector(4 downto 0);
      read_data_1: out bit_vector(31 downto 0);
      read_data_2:out bit_vector(31 downto 0);
      imm: out bit_vector(31 downto 0);
      funct7: out bit_vector(6 downto 0);
      funct3: out bit_vector(2 downto 0);
      write_register: out bit_vector(4 downto 0)
   );
end entity;

architecture arch of core_decode is
  component controlunit is
    port (
      -- From Datapath
      opcode: in bit_vector(6 downto 0);
      -- To Datapath
      alu_src: out bit;
      alu_op: out bit_vector(1 downto 0);
      branch: out bit;
      mem_read: out bit;
      mem_write: out bit;
      reg_write: out bit;
      mem_to_reg: out bit
    );
  end component;

  component regfile is
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
  end component;

  component imm_gen is
    generic(
      word_size : natural := 32
    );
    port(
      instruction: in  bit_vector(31 downto 0);
      immediate: out bit_vector(word_size-1 downto 0)
    );
  end component;


  signal opcode: bit_vector(6 downto 0);
  signal read_register_1_internal, read_register_2_internal: bit_vector(4 downto 0);
begin
    opcode <= instruction(6 downto 0);
    funct7 <= instruction(31 downto 25);
    funct3 <= instruction(14 downto 12);

    controlunit_inst: controlunit
      port map(
        opcode => opcode,
        alu_src => alu_src,
        alu_op => alu_op,
        branch => branch,
        mem_read => mem_read,
        mem_write => mem_write,
        reg_write => reg_write,
        mem_to_reg => mem_to_reg
      );

    read_register_1_internal <= instruction(19 downto 15);
    read_register_2_internal <= instruction(24 downto 20);
    -- sera propagado para os proximos estados
    write_register  <= instruction(11 downto 7);

   regfile_inst: regfile generic map(regn => 32, word_size => 32)
    port map(
      clk => clk,
      rst => rst,
      rr1 => read_register_1_internal,
      rr2 => read_register_2_internal,
      q1 => read_data_1,
      q2 => read_data_2,
      -- utiliza o estado de write back
      reg_write => WB_reg_write,
      wr => WB_write_register,
      d => WB_write_data
    );
  read_register_1 <= read_register_1_internal;
  read_register_2 <= read_register_2_internal;

  imm_gen_inst: imm_gen  generic map(word_size => 32)
    port map(
      instruction => instruction,
      immediate => imm
    );
end architecture;
