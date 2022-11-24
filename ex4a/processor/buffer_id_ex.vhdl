entity buffer_id_ex is
  port (
    clk: in bit; 
    rst: in bit; -- reset assincrono
    flush: in bit; -- reset sincrono
    enable: in bit;
    
    -- Control
    ID_alu_src: in bit;
    EX_alu_src: out bit;

    ID_alu_op: in bit_vector(1 downto 0);
    EX_alu_op: out bit_vector(1 downto 0);

    ID_branch: in bit;
    EX_branch: out bit;

    ID_mem_read: in bit;
    EX_mem_read: out bit;

    ID_mem_write: in bit;
    EX_mem_write: out bit;

    ID_reg_write: in bit;
    EX_reg_write: out bit;

    ID_mem_to_reg: in bit;
    EX_mem_to_reg: out bit;

    --- Data 
    ID_pc: in bit_vector(31 downto 0);
    EX_pc: out bit_vector(31 downto 0);

    ID_read_register_1: in bit_vector(4 downto 0);
    EX_read_register_1: out bit_vector(4 downto 0);

    ID_read_register_2: in bit_vector(4 downto 0);
    EX_read_register_2: out bit_vector(4 downto 0);

    ID_read_data_1: in bit_vector(31 downto 0);
    EX_read_data_1: out bit_vector(31 downto 0);

    ID_read_data_2:in bit_vector(31 downto 0);
    EX_read_data_2:out bit_vector(31 downto 0);

    ID_imm: in bit_vector(31 downto 0);
    EX_imm: out bit_vector(31 downto 0);

    ID_funct7: in bit_vector(6 downto 0);
    EX_funct7: out bit_vector(6 downto 0);

    ID_funct3: in bit_vector(2 downto 0);
    EX_funct3: out bit_vector(2 downto 0);

    ID_opcode: in bit_vector(6 downto 0);
    EX_opcode: out bit_vector(6 downto 0);

    ID_write_register: in bit_vector(4 downto 0);
    EX_write_register: out bit_vector(4 downto 0)
  );
end entity;

architecture arch of buffer_id_ex is
  component reg is
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
  end component;

  component reg1 is
    port(
      clk: in bit;
      rst: in bit; -- reset sincrono
      clr: in bit; -- reset assincrono
      en: in bit; -- enable
      d: in bit;
      q: out bit
    );
  end component;
begin
    buffer_alu_src: reg1
      port map(
        clk => clk,
        rst => flush,
        clr => rst,
        en => enable,
        d => ID_alu_src,
        q => EX_alu_src
      );

    buffer_alu_op: reg generic map(size => 2)
      port map(
        clk => clk,
        rst => flush,
        clr => rst,
        en => enable,
        d => ID_alu_op,
        q => EX_alu_op
      );

    buffer_branch: reg1
      port map(
        clk => clk,
        rst => flush,
        clr => rst,
        en => enable,
        d => ID_branch,
        q => EX_branch
      );

    buffer_mem_read: reg1
      port map(
        clk => clk,
        rst => flush,
        clr => rst,
        en => enable,
        d => ID_mem_read,
        q => EX_mem_read
      );

    buffer_mem_write: reg1
      port map(
        clk => clk,
        rst => flush,
        clr => rst,
        en => enable,
        d => ID_mem_write,
        q => EX_mem_write
      );

    buffer_reg_write: reg1
      port map(
        clk => clk,
        rst => flush,
        clr => rst,
        en => enable,
        d => ID_reg_write,
        q => EX_reg_write
      );

    buffer_mem_to_reg: reg1
      port map(
        clk => clk,
        rst => flush,
        clr => rst,
        en => enable,
        d => ID_mem_to_reg,
        q => EX_mem_to_reg
      );

    buffer_pc: reg generic map(size => 32)
      port map(
        clk => clk,
        rst => flush,
        clr => rst,
        en => enable,
        d => ID_pc,
        q => EX_pc
      );

    buffer_read_register_1: reg generic map(size => 5)
      port map(
        clk => clk,
        rst => flush,
        clr => rst,
        en => enable,
        d => ID_read_register_1,
        q => EX_read_register_1
      );

    buffer_read_register_2: reg generic map(size => 5)
      port map(
        clk => clk,
        rst => flush,
        clr => rst,
        en => enable,
        d => ID_read_register_2,
        q => EX_read_register_2
      );

    buffer_read_data_1: reg generic map(size => 32)
      port map(
        clk => clk,
        rst => flush,
        clr => rst,
        en => enable,
        d => ID_read_data_1,
        q => EX_read_data_1
      );

    buffer_read_data_2: reg generic map(size => 32)
      port map(
        clk => clk,
        rst => flush,
        clr => rst,
        en => enable,
        d => ID_read_data_2,
        q => EX_read_data_2
      );

    buffer_imm: reg generic map(size => 32)
      port map(
        clk => clk,
        rst => flush,
        clr => rst,
        en => enable,
        d => ID_imm,
        q => EX_imm
      );

    buffer_funct7: reg generic map(size => 7)
      port map(
        clk => clk,
        rst => flush,
        clr => rst,
        en => enable,
        d => ID_funct7,
        q => EX_funct7
      );

    buffer_funct3: reg generic map(size => 3)
      port map(
        clk => clk,
        rst => flush,
        clr => rst,
        en => enable,
        d => ID_funct3,
        q => EX_funct3
      );

    buffer_opcode: reg generic map(size => 7)
      port map(
        clk => clk,
        rst => flush,
        clr => rst,
        en => enable,
        d => ID_opcode,
        q => EX_opcode
      );

    buffer_write_register: reg generic map(size => 5)
      port map(
        clk => clk,
        rst => flush,
        clr => rst,
        en => enable,
        d => ID_write_register,
        q => EX_write_register
      );

end architecture;
