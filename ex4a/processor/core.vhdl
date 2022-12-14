entity core is
  port(
    clk, rst: in bit
  );
end entity;

architecture arch of core is
component core_fetch is
   port (
      clk, rst: in bit;
      pc_enable: in bit;
      -- Input
      --- Control
      pc_src: in bit;
      --- Data
      branch_pc: in bit_vector(31 downto 0);

      -- Output
      pc: out bit_vector(31 downto 0);
      instruction: out bit_vector(31 downto 0)
   );
end component;

component buffer_if_id is
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
end component;

component hazard_detection_unit is
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
      read_register_1: out bit_vector(4 downto 0);
      read_register_2: out bit_vector(4 downto 0);
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
end component;

component core_execute is
   port (
      -- Inputs
      --- Control
      alu_src: in bit;
      alu_op: in bit_vector(1 downto 0);
      branch: in bit;
      --- Data 
      pc: in bit_vector(31 downto 0);
      read_data_1: in bit_vector(31 downto 0);
      read_data_2: in bit_vector(31 downto 0);
      imm: in bit_vector(31 downto 0);
      funct7: in bit_vector(6 downto 0);
      funct3: in bit_vector(2 downto 0);

      -- Output
      --- Control
      pc_src: out bit;
      --- Data
      branch_pc: out bit_vector(31 downto 0); -- soma do pc com o immediato para o calculo do branch
      alu_result: out bit_vector(31 downto 0)
   );
end component;

component buffer_ex_mem is
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
end component;

component core_memory_acess is
   port (
      clk: in bit;
      -- Input
      --- Control
      mem_read: in bit;
      mem_write: in bit;
      --- Data
      alu_result: in bit_vector(31 downto 0); -- address memory
      read_data_2: in bit_vector(31 downto 0); -- write data memory
      -- Output
      --- Data
      read_data: out bit_vector(31 downto 0)
   );
end component;

component buffer_mem_wb is
  port (
      clk: in bit; 
      rst: in bit; -- reset assincrono
      flush: in bit; -- reset sincrono
      enable: in bit;
    
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

component core_write_back is
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
end component;

component fowarding_unit is
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
end component;

-- IF
signal IF_pc: bit_vector(31 downto 0);
signal IF_instruction: bit_vector(31 downto 0);

-- ID
signal ID_pc: bit_vector(31 downto 0);
signal ID_instruction: bit_vector(31 downto 0);
signal ID_alu_src: bit;
signal ID_alu_op: bit_vector(1 downto 0);
signal ID_branch: bit;
signal ID_mem_read: bit;
signal ID_mem_write: bit;
signal ID_reg_write: bit;
signal ID_mem_to_reg: bit;
signal ID_read_register_1: bit_vector(4 downto 0);
signal ID_read_register_2: bit_vector(4 downto 0);
signal ID_read_data_1: bit_vector(31 downto 0);
signal ID_read_data_2:bit_vector(31 downto 0);
signal ID_imm: bit_vector(31 downto 0);
signal ID_funct7: bit_vector(6 downto 0);
signal ID_funct3: bit_vector(2 downto 0);
signal ID_write_register: bit_vector(4 downto 0);
signal ID_opcode: bit_vector(6 downto 0);


--- Uses
signal EX_alu_src: bit;
signal EX_alu_op: bit_vector(1 downto 0);
signal EX_pc: bit_vector(31 downto 0);
signal EX_read_data_1: bit_vector(31 downto 0);
signal EX_read_data_2: bit_vector(31 downto 0);
signal EX_imm: bit_vector(31 downto 0);
signal EX_funct7: bit_vector(6 downto 0);
signal EX_funct3: bit_vector(2 downto 0);
signal EX_branch_pc: bit_vector(31 downto 0);
signal EX_alu_result: bit_vector(31 downto 0);
signal EX_pc_src: bit;
signal EX_branch: bit;
--- Pass thrgouth
signal EX_read_register_1: bit_vector(4 downto 0);
signal EX_read_register_2: bit_vector(4 downto 0);
signal EX_mem_read: bit;
signal EX_mem_write: bit;
signal EX_reg_write: bit;
signal EX_mem_to_reg: bit;
signal EX_write_register: bit_vector(4 downto 0);
signal EX_opcode: bit_vector(6 downto 0);

-- MEM
--- Uses
signal MEM_mem_read: bit;
signal MEM_mem_write: bit;
signal MEM_alu_result: bit_vector(31 downto 0); -- address memory
signal MEM_read_data_2: bit_vector(31 downto 0); -- write data memory
signal MEM_pc_src: bit; -- branch & zero
signal MEM_read_data: bit_vector(31 downto 0);
--- Pass through
signal MEM_reg_write: bit;
signal MEM_to_reg: bit;
signal MEM_mem_to_reg: bit;
signal MEM_write_register: bit_vector(4 downto 0);
signal MEM_branch_pc: bit_vector(31 downto 0);

-- WB
--- Uses
signal WB_mem_to_reg: bit;
signal WB_read_data: bit_vector(31 downto 0);
signal WB_alu_result: bit_vector(31 downto 0);
signal WB_write_data: bit_vector(31 downto 0);
--- Pass through
signal WB_reg_write: bit;
signal WB_write_register: bit_vector(4 downto 0);

-- Fowarding
signal FW_src_ula_a: bit_vector(1 downto 0);
signal FW_src_ula_b: bit_vector(1 downto 0);
signal FW_ula_a: bit_vector(31 downto 0);
signal FW_ula_b: bit_vector(31 downto 0);

-- Hazard detection
signal HZ_pc_write: bit;
signal HZ_buffer_write_if_id: bit;
signal HZ_stall: bit;

--- Control unit
signal HZ_alu_src: bit;
signal HZ_alu_op: bit_vector(1 downto 0);
signal HZ_branch: bit;
signal HZ_mem_read: bit;
signal HZ_mem_write: bit;
signal HZ_reg_write: bit;
signal HZ_mem_to_reg: bit;

signal flush_wrong_branch: bit;

begin

core_fetch_inst: core_fetch
   port map(
      clk => clk,
      rst => rst,
      pc_enable => HZ_pc_write,
      -- Input
      --- Control
      pc_src => MEM_pc_src,
      --- Data
      branch_pc => MEM_branch_pc,

      -- Output
      pc => IF_pc,
      instruction => IF_instruction
   );

buffer_if_id_inst: buffer_if_id
  port map(
    clk => clk,
    rst => rst,
    flush => flush_wrong_branch,
    enable => HZ_buffer_write_if_id,
    
    IF_pc => IF_pc,
    ID_pc => ID_pc,

    IF_instruction => IF_instruction,
    ID_instruction => ID_instruction
  );

hazard_detection_unit_inst: hazard_detection_unit
  port map(
    -- Input
    EX_mem_read => EX_mem_read,
    EX_write_register => EX_write_register,
    ID_read_register_1 => ID_read_register_1,
    ID_read_register_2 => ID_read_register_1,

    -- Output
    pc_write => HZ_pc_write,
    buffer_write_if_id => HZ_buffer_write_if_id,
    stall => HZ_stall
  );

core_decode_inst: core_decode
   port map(
      clk => clk,
      rst => rst,
      --- Inputs
      instruction => ID_instruction,
      WB_write_register => WB_write_register,
      WB_write_data => WB_write_data,
      WB_reg_write => WB_reg_write,

      -- Output
      --- Control
      read_register_1 => ID_read_register_1,
      read_register_2 => ID_read_register_2,
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
      write_register => ID_write_register
   );

-- if has hazard then ground all control signals
 HZ_alu_src <= ID_alu_src when HZ_stall = '0' else '0';
 HZ_alu_op <= ID_alu_op when HZ_stall = '0' else "00";
 HZ_branch <= ID_branch when HZ_stall = '0' else '0';
 HZ_mem_read <= ID_mem_read when HZ_stall = '0' else '0';
 HZ_mem_write <= ID_mem_write when HZ_stall = '0' else '0';
 HZ_reg_write <= ID_reg_write when HZ_stall = '0' else '0';
 HZ_mem_to_reg <= ID_mem_to_reg when HZ_stall = '0' else '0';

buffer_id_ex_inst: buffer_id_ex
  port map(
    clk => clk,
    rst => rst,
    flush => flush_wrong_branch,
    enable => '1',
    
    -- Control
    ID_alu_src => HZ_alu_src,
    EX_alu_src => EX_alu_src,

    ID_alu_op => HZ_alu_op,
    EX_alu_op => EX_alu_op,

    ID_branch => HZ_branch,
    EX_branch => EX_branch,

    ID_mem_read => HZ_mem_read,
    EX_mem_read => EX_mem_read,

    ID_mem_write => HZ_mem_write,
    EX_mem_write => EX_mem_write,

    ID_reg_write => HZ_reg_write,
    EX_reg_write => EX_reg_write,

    ID_mem_to_reg => HZ_mem_to_reg,
    EX_mem_to_reg => EX_mem_to_reg,

    --- Data 
    ID_pc => ID_pc,
    EX_pc => EX_pc,

    ID_read_register_1 => ID_read_register_1,
    EX_read_register_1 => EX_read_register_1,

    ID_read_register_2 => ID_read_register_2,
    EX_read_register_2 => EX_read_register_2,

    ID_read_data_1 => ID_read_data_1,
    EX_read_data_1 => EX_read_data_1,

    ID_read_data_2 => ID_read_data_2,
    EX_read_data_2 => EX_read_data_2,

    ID_imm => ID_imm,
    EX_imm => EX_imm,

    ID_funct7 => ID_funct7,
    EX_funct7 => EX_funct7,

    ID_funct3 => ID_funct3,
    EX_funct3 => EX_funct3,

    -- useless
    ID_opcode => ID_opcode,
    EX_opcode => EX_opcode,

    ID_write_register => ID_write_register,
    EX_write_register => EX_write_register
  );

fowarding_unit_inst: fowarding_unit
  port map(
    -- Inputs
    EX_read_register_1 => EX_read_register_1,
    EX_read_register_2 => EX_read_register_2,
    MEM_reg_write => MEM_reg_write,
    MEM_write_register => MEM_write_register,
    WB_write_register => WB_write_register,

    -- Outputs
    foward_ula_input_a => FW_src_ula_a,
    foward_ula_input_b => FW_src_ula_b
  );

  FW_ula_a <= EX_read_data_1 when FW_src_ula_a = "00" else
              WB_write_data  when FW_src_ula_a = "01" else
              MEM_alu_result when FW_src_ula_a = "10" else -- address
              (others => '0');

  FW_ula_b <= EX_read_data_2 when FW_src_ula_b = "00" else
              WB_write_data  when FW_src_ula_b = "01" else
              MEM_alu_result when FW_src_ula_b = "10" else -- address
              (others => '0');

core_execute_inst: core_execute
   port map(
      alu_src => EX_alu_src,
      alu_op => EX_alu_op,
      branch => EX_branch,
      pc => EX_pc,
      read_data_1 => FW_ula_a,
      read_data_2 => FW_ula_b,
      imm => EX_imm,
      funct7 => EX_funct7,
      funct3 => EX_funct3,
      pc_src => EX_pc_src,
      branch_pc => EX_branch_pc,
      alu_result => EX_alu_result
   );

flush_wrong_branch <= '1' when EX_pc_src='1' else '0';

buffer_ex_mem_inst: buffer_ex_mem
  port map(
    clk => clk,
    rst => rst,
    flush => '0',
    enable => '1',
    
    EX_pc_src => EX_pc_src,
    MEM_pc_src => MEM_pc_src,

    EX_mem_read => EX_mem_read,
    MEM_mem_read => MEM_mem_read,

    EX_mem_write => EX_mem_write,
    MEM_mem_write => MEM_mem_write,

    EX_reg_write => EX_reg_write,
    MEM_reg_write => MEM_reg_write,

    EX_mem_to_reg => EX_mem_to_reg,
    MEM_mem_to_reg => MEM_mem_to_reg,

    EX_branch_pc => EX_branch_pc,
    MEM_branch_pc => MEM_branch_pc,

    EX_alu_result => EX_alu_result,
    MEM_alu_result => MEM_alu_result,

    EX_read_data_2 => EX_read_data_2,
    MEM_read_data_2 => MEM_read_data_2,

    EX_write_register => EX_write_register,
    MEM_write_register => MEM_write_register
  );

core_memory_acess_inst: core_memory_acess
   port map(
      clk => clk,
      -- Input
      --- Control
      mem_read => MEM_mem_read,
      mem_write => MEM_mem_write,
      --- Data
      alu_result => MEM_alu_result,
      read_data_2 => MEM_read_data_2,
      -- Output
      --- Data
      read_data => MEM_read_data
   );

buffer_mem_wb_inst: buffer_mem_wb
  port map(
    clk => clk,
    rst => rst,
    flush => '0',
    enable => '1',
    
    MEM_reg_write => MEM_reg_write,
    WB_reg_write => WB_reg_write,

    MEM_mem_to_reg => MEM_mem_to_reg,
    WB_mem_to_reg => WB_mem_to_reg,

    MEM_read_data => MEM_read_data,
    WB_read_data => WB_read_data,

    MEM_alu_result => MEM_alu_result,
    WB_alu_result => WB_alu_result,

    MEM_write_register => MEM_write_register,
    WB_write_register => WB_write_register
  );

core_write_back_inst: core_write_back
   port map(
    mem_to_reg => WB_mem_to_reg,
    read_data => WB_read_data,
    alu_result => WB_alu_result,
    write_data => WB_write_data
   );

end architecture;
