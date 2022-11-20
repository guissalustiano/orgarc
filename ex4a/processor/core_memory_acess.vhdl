entity core_memory_acess is
   port (
      clk: in bit;
      -- Input
      --- Control
      branch: in bit;
      zero: in bit;
      mem_read: in bit;
      mem_write: in bit;
      --- Data
      alu_result: in bit_vector(31 downto 0); -- address memory
      read_data_2: in bit_vector(31 downto 0); -- write data memory
      -- Output
      --- Control
      branch_happens: out bit; -- branch & zero
      --- Data
      read_data: out bit_vector(31 downto 0)
   );
end entity;

architecture arch of core_memory_acess is
  component ram is
     port (
        clk: in bit;
        mem_write: in bit;
        mem_read: in bit;
        addr: in bit_vector(31 downto 0);
        write_data: in bit_vector(31 downto 0);
        read_data: out bit_vector(31 downto 0)
     );
   end component;
begin
  branch_happens <= branch and zero;

  ram_inst: ram 
    port map(
        clk => clk,
        mem_write => mem_write,
        mem_read => mem_read,
        addr => alu_result,
        write_data => read_data_2,
        read_data => read_data
      );
end architecture;
