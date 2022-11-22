entity fowarding_unit is
  port(
    -- Inputs
    EX_read_register_1: in bit_vector(4 downto 0);
    EX_read_register_2: in bit_vector(4 downto 0);
    MEM_reg_write: in bit;
    MEM_write_register: in bit_vector(4 downto 0);
    WB_write_register: in bit_vector(4 downto 0);

    -- Outputs
    foward_ula_input_a: out bit_vector(1 downto 0);
    foward_ula_input_b: out bit_vector(1 downto 0)
  );
end entity;

architecture arch of fowarding_unit is
begin
  foward_ula_input_a <= "00" when MEM_reg_write = '0' else
                        "10" when MEM_write_register /= "00000" and MEM_write_register = EX_read_register_1 else
                        "01" when WB_write_register /= "00000" and WB_write_register = EX_read_register_1 else
                        "00";

  foward_ula_input_b <= "00" when MEM_reg_write = '0' else
                        "10" when MEM_write_register /= "00000" and MEM_write_register = EX_read_register_2 else
                        "01" when WB_write_register /= "00000" and WB_write_register = EX_read_register_2 else
                        "00";
end architecture;
