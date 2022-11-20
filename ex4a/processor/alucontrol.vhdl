entity alucontrol is
  port (
    aluop: in bit_vector(1 downto 0);
    funct7: in bit_vector(6 downto 0);
    funct3: in bit_vector(2 downto 0);
    alu_ctrl: out bit_vector(3 downto 0)
   );
end entity;

architecture arch of alucontrol is
begin
  -- Seguindo a tabela 4.12
  alu_ctrl <= "0010" when aluop = "00" else -- lw e sw
             "0110" when aluop = "01" else -- beq
             "0010" when aluop = "10" and funct7 = "0000000" and funct3 = "000" else -- add
             "0110" when aluop = "10" and funct7 = "0100000" and funct3 = "000" else -- sub
             "0000" when aluop = "10" and funct7 = "0000000" and funct3 = "111" else -- and
             "0001" when aluop = "10" and funct7 = "0000000" and funct3 = "110" else -- or
             (others => '1');

end architecture;
