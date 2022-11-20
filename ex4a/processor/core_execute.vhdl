entity core_execute is
   port (
      -- Inputs
      --- Control
      alu_src: in bit;
      alu_op: in bit_vector(1 downto 0);
      --- Data 
      pc: in bit_vector(31 downto 0);
      read_data_1: in bit_vector(31 downto 0);
      read_data_2: in bit_vector(31 downto 0);
      imm: in bit_vector(31 downto 0);
      funct7: in bit_vector(6 downto 0);
      funct3: in bit_vector(2 downto 0);

      -- Output
      --- Control
      zero: out bit;
      --- Data
      branch_pc: out bit_vector(31 downto 0); -- soma do pc com o immediato para o calculo do branch
      alu_result: out bit_vector(31 downto 0);
   );
end entity;

architecture arch of core_execute is
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

  entity alucontrol is
    port (
      aluop: in bit_vector(1 downto 0);
      funct7: in bit_vector(6 downto 0);
      funct3: in bit_vector(2 downto 0);
      alu_ctrl: out bit_vector(3 downto 0)
     );
  end entity;

  signal alu_input_2: bit_vector(31 downto 0);
  signal alu_ctrl: bit_vector(3 downto 0)
begin
  branch_pc <= unsigned(pc) + unsigned(imm);

  alu_input_2 <= read_data_2 when alu_src = '0' else imm;

  alu_inst: alu generic map(32)
    port map(
      A => read_data_1,
      B => read_data_2,
      F => alu_result,
      S => alu_ctrl,
      Z => zero,
      Ov => open,
      Co => open,
    );
      
  alucontrol_inst: alucontrol
    port map(
      aluop => alu_op,
      funct7 => funct7,
      funct3 => funct3,
      alu_ctrl => alu_ctrl,
     );
end architecture
