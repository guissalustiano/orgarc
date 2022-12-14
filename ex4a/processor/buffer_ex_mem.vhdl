entity buffer_ex_mem is
  port (
    clk: in bit; 
    rst: in bit; -- reset assincrono
    flush: in bit; -- reset sincrono
    enable: in bit;
    
    EX_pc_src: in bit;
    MEM_pc_src: out bit;

    EX_mem_read: in bit;
    MEM_mem_read: out bit;

    EX_mem_write: in bit;
    MEM_mem_write: out bit;

    EX_reg_write: in bit;
    MEM_reg_write: out bit;

    EX_mem_to_reg: in bit;
    MEM_mem_to_reg: out bit;

    EX_branch_pc: in bit_vector(31 downto 0);
    MEM_branch_pc: out bit_vector(31 downto 0);

    EX_alu_result: in bit_vector(31 downto 0);
    MEM_alu_result: out bit_vector(31 downto 0);

    EX_read_data_2:in bit_vector(31 downto 0);
    MEM_read_data_2:out bit_vector(31 downto 0);

    EX_write_register: in bit_vector(4 downto 0);
    MEM_write_register: out bit_vector(4 downto 0)
  );
end entity;

architecture arch of buffer_ex_mem is
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
    buffer_pc_src: reg1
      port map(
        clk => clk,
        rst => flush,
        clr => rst,
        en => enable,
        d => EX_pc_src,
        q => MEM_pc_src
      );

    buffer_mem_read: reg1
      port map(
        clk => clk,
        rst => flush,
        clr => rst,
        en => enable,
        d => EX_mem_read,
        q => MEM_mem_read
      );

    buffer_mem_write: reg1 
      port map(
        clk => clk,
        rst => flush,
        clr => rst,
        en => enable,
        d => EX_mem_write,
        q => MEM_mem_write
      );

    buffer_reg_write:reg1 
      port map(
        clk => clk,
        rst => flush,
        clr => rst,
        en => enable,
        d => EX_reg_write,
        q => MEM_reg_write
      );

    buffer_mem_to_reg: reg1 
      port map(
        clk => clk,
        rst => flush,
        clr => rst,
        en => enable,
        d => EX_mem_to_reg,
        q => MEM_mem_to_reg
      );

    buffer_branch_pc: reg generic map(size => 32)
    port map(
      clk => clk,
      rst => flush,
      clr => rst,
      en => enable,
      d => EX_branch_pc,
      q => MEM_branch_pc
    );

    buffer_alu_result: reg generic map(size => 32)
      port map(
        clk => clk,
        rst => flush,
        clr => rst,
        en => enable,
        d => EX_alu_result,
        q => MEM_alu_result
      );

    buffer_read_data_2: reg generic map(size => 32)
      port map(
        clk => clk,
        rst => flush,
        clr => rst,
        en => enable,
        d => EX_read_data_2,
        q => MEM_read_data_2
      );

    buffer_write_register: reg generic map(size => 5)
      port map(
        clk => clk,
        rst => flush,
        clr => rst,
        en => enable,
        d => EX_write_register,
        q => MEM_write_register
      );
end architecture;
