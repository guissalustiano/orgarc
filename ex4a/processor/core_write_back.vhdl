entity core_write_back is
   port (
    -- Input
    --- Control
    mem_to_reg: in bit;
    --- Data
    read_data: in bit_vector(31 downto 0);
    alu_result: in bit_vector(31 downto 0);

    -- Output
    --- Data
    write_data: out bit_vector(31 downto 0)
   );
end entity;

architecture arch of core_write_back is
begin
  write_data <= alu_result when mem_to_reg = '0' else read_data;
end architecture
