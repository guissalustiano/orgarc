entity buffer_mem_wb is
  port (
    clk, rst: in bit;
    
      MEM_reg_write: in bit;
      WB_reg_write: out bit;

      MEM_mem_to_reg: in bit;
      WB_mem_to_reg: out bit;

      MEM_read_data: in bit_vector(31 downto 0);
      WB_read_data: out bit_vector(31 downto 0);

      MEM_alu_result: in bit_vector(31 downto 0);
      WB_alu_result: out bit_vector(31 downto 0);

      MEM_write_register: in bit_vector(4 downto 0);
      WB_write_register: out bit_vector(4 downto 0)
  );
end entity;

architecture arch of buffer_mem_wb is
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

  component reg1 is
    port(
      clk, rst: in bit;
      d: in bit;
      q: out bit
    );
  end component;
begin
      buffer_reg_write: reg1
      port map(
        clk => clk,
        rst => rst,
        d => MEM_reg_write,
        q => WB_reg_write
      );

      buffer_mem_to_reg: reg1
      port map(
        clk => clk,
        rst => rst,
        d => MEM_mem_to_reg,
        q => WB_mem_to_reg
      );

      buffer_read_data: reg generic map(size => 32)
      port map(
        clk => clk,
        rst => rst,
        d => MEM_read_data,
        q => WB_read_data
      );

      buffer_alu_result: reg generic map(size => 32)
      port map(
        clk => clk,
        rst => rst,
        d => MEM_alu_result,
        q => WB_alu_result
      );

      buffer_write_register: reg generic map(size => 5)
      port map(
        clk => clk,
        rst => rst,
        d => MEM_write_register,
        q => WB_write_register
      );

end architecture;
