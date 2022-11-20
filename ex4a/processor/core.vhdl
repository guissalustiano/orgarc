entity core is
  port(
    clk, rst: in bit
  );
end entity;

architecture arch of core is
component buffer_if_id is
  port (
    clk, rst: in bit;
    
    IF_pc: in bit_vector(31 downto 0);
    ID_pc: out bit_vector(31 downto 0);

    IF_instruction: in bit_vector(31 downto 0);
    ID_instruction: out bit_vector(31 downto 0)
  );
end component;

component core_decode is
   port (
      clk, rst: in bit;
      --- Inputs
      instruction: in bit_vector(31 downto 0);
      WB_write_register: in bit_vector(4 downto 0);
      WB_write_data: in bit_vector(31 downto 0);
      WB_reg_write: in bit;

      -- Output
      --- Control
      alu_src: out bit;
      alu_op: out bit_vector(1 downto 0);
      branch: out bit;
      mem_read: out bit;
      mem_write: out bit;
      reg_write: out bit;
      mem_to_reg: out bit;
      --- Data 
      read_data_1: out bit_vector(31 downto 0);
      read_data_2:out bit_vector(31 downto 0);
      imm: out bit_vector(31 downto 0);
      funct7: out bit_vector(6 downto 0);
      funct3: out bit_vector(2 downto 0);
      write_register: out bit_vector(4 downto 0)
   );
end component;

component buffer_id_ex is
  port (
    clk, rst: in bit;
    
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
end component;

component buffer_ex_mem is
  port (
    clk, rst: in bit;
    
    EX_branch: in bit;
    MEM_branch: out bit;

    EX_mem_read: in bit;
    MEM_mem_read: out bit;

    EX_mem_write: in bit;
    MEM_mem_write: out bit;

    EX_reg_write: in bit;
    MEM_reg_write: out bit;

    EX_mem_to_reg: in bit;
    MEM_mem_to_reg: out bit;

    EX_zero: in bit;
    MEM_zero: out bit;

    EX_branch_pc: in bit_vector(31 downto 0);
    MEM_branch_pc: out bit_vector(31 downto 0);

    EX_alu_result: in bit_vector(31 downto 0);
    MEM_alu_result: out bit_vector(31 downto 0);

    EX_read_data_2:in bit_vector(31 downto 0);
    MEM_read_data_2:out bit_vector(31 downto 0);

    EX_write_register: in bit_vector(4 downto 0);
    MEM_write_register: out bit_vector(4 downto 0)
  );
end component;

component buffer_mem_wb is
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
end component;

signal ID_pc: bit_vector(31 downto 0);
signal ID_instruction: bit_vector(31 downto 0);
signal ID_alu_src: bit;
signal ID_alu_op: bit_vector(1 downto 0);
signal ID_branch: bit;
signal ID_mem_read: bit;
signal ID_mem_write: bit;
signal ID_reg_write: bit;
signal ID_mem_to_reg: bit;
signal ID_read_data_1: bit_vector(31 downto 0);
signal ID_read_data_2:bit_vector(31 downto 0);
signal ID_imm: bit_vector(31 downto 0);
signal ID_funct7: bit_vector(6 downto 0);
signal ID_funct3: bit_vector(2 downto 0);
signal ID_write_register: bit_vector(4 downto 0)

begin
buffer_if_id_inst: buffer_if_id
  port map(
    clk => clk,
    rst => rst,
    
    IF_pc => ,
    ID_pc => ID_pc,

    IF_instruction => ,
    ID_instruction => ID_instruction,
  );

core_decode_inst: core_decode
   port map(
      clk => clk,
      rst => rst,
      --- Inputs
      instruction => ID_instruction,
      WB_write_register => ,
      WB_write_data => ,
      WB_reg_write => ,

      -- Output
      --- Control
      alu_src => ID_alu_src,
      alu_op => ID_alu_op,
      branch => ID_branch,
      mem_read => ID_mem_read,
      mem_write => ID_mem_write,
      reg_write => ID_reg_write,
      mem_to_reg => ID_mem_to_reg,
      --- Data 
      read_data_1 => ID_read_data_1,
      read_data_2 => ID_read_data_2,
      imm => ID_imm,
      funct7 => ID_funct7,
      funct3 => ID_funct3,
      write_register => ID_write_register,
   );

buffer_id_ex_inst: buffer_id_ex
  port map(
    clk => clk,
    rst => rst,
    
    -- Control
    ID_alu_src => ID_alu_src,
    EX_alu_src => ,

    ID_alu_op => ID_alu_op,
    EX_alu_op => ,

    ID_branch => ID_branch,
    EX_branch => ,

    ID_mem_read => ID_mem_read,
    EX_mem_read => ,

    ID_mem_write => ID_mem_write,
    EX_mem_write => ,

    ID_reg_write => ID_reg_write,
    EX_reg_write => ,

    ID_mem_to_reg => ID_mem_to_reg,
    EX_mem_to_reg => ,

    --- Data 
    ID_pc => ID_pc,
    EX_pc => ,

    ID_read_data_1 => ID_read_data_1,
    EX_read_data_1 => ,

    ID_read_data_2 => ID_read_data_2,
    EX_read_data_2 => ,

    ID_imm => ID_imm,
    EX_imm => ,

    ID_funct7 => ID_funct7,
    EX_funct7 => ,

    ID_funct3 => ID_funct3,
    EX_funct3 => ,

    ID_opcode => ID_opcode,
    EX_opcode => ,

    ID_write_register => ID_write_register,
    EX_write_register => ,
  );

buffer_ex_mem_inst: buffer_ex_mem
  port map(
    clk => clk,
    rst => rst,
    
    EX_branch => ,
    MEM_branch => ,

    EX_mem_read => ,
    MEM_mem_read => ,

    EX_mem_write => ,
    MEM_mem_write => ,

    EX_reg_write => ,
    MEM_reg_write => ,

    EX_mem_to_reg => ,
    MEM_mem_to_reg => ,

    EX_zero => ,
    MEM_zero => ,

    EX_branch_pc => ,
    MEM_branch_pc => ,

    EX_alu_result => ,
    MEM_alu_result => ,

    EX_read_data_2 => ,
    MEM_read_data_2 => ,

    EX_write_register => ,
    MEM_write_register => ,
  );

buffer_mem_wb_inst: buffer_mem_wb
  port map(
    clk => clk,
    rst => rst,
    
    MEM_reg_write => ,
    WB_reg_write => ,

    MEM_mem_to_reg => ,
    WB_mem_to_reg => ,

    MEM_read_data => ,
    WB_read_data => ,

    MEM_alu_result => ,
    WB_alu_result => ,

    MEM_write_register => ,
    WB_write_register => ,
  );

end architecture;
