entity buffer_if_id is
  port (
    clk: in bit; 
    rst: in bit; -- reset assincrono
    flush: in bit; -- reset sincrono
    enable: in bit;
    
    IF_pc: in bit_vector(31 downto 0);
    ID_pc: out bit_vector(31 downto 0);

    IF_instruction: in bit_vector(31 downto 0);
    ID_instruction: out bit_vector(31 downto 0)
  );
end entity;

architecture arch of buffer_if_id is
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
begin
  buffer_pc: reg generic map(size => 32)
    port map(
      clk => clk,
      rst => flush,
      clr => rst,
      en => enable,
      d => IF_pc,
      q => ID_pc
    );
  
  buffer_intruction: reg generic map(size => 32)
    port map(
      clk => clk,
      rst => flush,
      clr => rst,
      en => enable,
      d => IF_instruction,
      q => ID_instruction
    );
end architecture;
