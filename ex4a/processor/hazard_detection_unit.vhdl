library ieee;
use ieee.numeric_bit.all;

entity hazard_detection_unit is
  port(
    -- Input
    EX_mem_read: in bit;
    EX_write_register: in bit_vector(4 downto 0);
    ID_read_register_1: in bit_vector(4 downto 0);
    ID_read_register_2: in bit_vector(4 downto 0);

    -- Output
    pc_write: out bit;
    buffer_write_if_id: out bit;
    stall: out bit
  );
end entity;

architecture arch of hazard_detection_unit is
  signal is_hazard: boolean;
begin
  is_hazard <= (EX_mem_read = '1') and ((EX_write_register = ID_read_register_1) or (EX_write_register = ID_read_register_2));

  pc_write <= '0' when is_hazard else '1';

  buffer_write_if_id <= '0' when is_hazard else '1';

  stall <= '1' when is_hazard else '0';
end architecture;
