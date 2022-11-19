library ieee;
use ieee.numeric_bit.all;

entity monocycle is
   port (
      clk: in bit;
      rst: in bit;
   );
end monocycle;

architecture monocycle_arch of monocycle is
  component rom is
     port (
        addr: in bit_vector(31 downto 0);
        data: out bit_vector(31 downto 0)
     );
   end component;

  component regfile is
    generic(
      regn: natural := 32;
      wordSize: natural := 32
    );
    port(
      clk, rst, regWrite: in bit;
      rr1, rr2, wr: in bit_vector(natural(ceil(log2(real(regn))))-1 downto 0);
      d: in bit_vector(wordSize-1 downto 0);
      q1, q2: out bit_vector(wordSize-1 downto 0)
    );
  end component;

  component alu is
    generic(
      size: natural := 32
    );
    port (
      A, B: in bit_vector(size-1 downto 0);
      F   : out bit_vector(size-1 downto 0);
      S   : in  bit_vector(3 downto 0);
      Z, Ov, Co: out bit
    );
  end component;

  component signExtend is
    port(
    i: in  bit_vector(31 downto 0); -- input
    o: out bit_vector(63 downto 0) -- output
    );
  end component;

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

  component reg is
    port(
      clk, rst: in bit;
      d: in bit_vector(31 downto 0);
      q: out bit_vector(31 downto 0)
    );
  end component;

  component controlunit is
    port (
      -- To Datapath
      aluSrc: out bit;
      aluOp: out bit_vector(1 downto 0);
      branch: out bit;
      memRead: out bit;
      memWrite: out bit;
      regWrite: out bit;
      memToReg: out bit;
      -- From Datapath
      opcode: in bit_vector(6 downto 0)
    );
  end component;

  component alucontrol is
    port (
      aluop: in bit_vector(1 downto 0);
      funct7: in bit_vector(6 downto 0);
      funct3: in bit_vector(2 downto 0);
      aluCtrl: out bit_vector(3 downto 0)
     );
  end component;

  -- Program counter
  signal next_pc, pc_plus_4, pc_plus_imm, pc: bit_vector(31 downto 0);

  signal instruction, alu_input_2, imm_extended, alu_result, ram_data: bit_vector(31 downto 0);

  -- Tem q ligar
  signal write_data, read_data_1, read_data_2: bit_vector(31 downto 0);
  -- control signals
  signal reg_write, zero, mem_read, mem_write: bit;
  signal alu_src: bit_vector(1 downto 0);
  signal alu_ctrl: bit_vector(3 downto 0);
begin
  process(clk)
  begin
    reg_pc: reg(
      clk => clk, 
      rst => rst,
      d => next_pc,
      q => pc,
    );

    pc_plus_4 <= bit_vector(unsigned(pc) + to_unsiged(4, 32));
    pc_plus_imm <= bit_vector(unsigned(pc) + unsigned(imm_extended));

    pc_src <= zero and branch;
    next_pc <= pc_plus_4 when pc_src = '0' else pc_plus_imm;

    intr_mem: rom(
      addr => pc,
      data => instruction,
    );

    opcode <= instruction(6 downto 0);
    funct7 <= instruction(31 downto 25);
    funct3 <= instruction(14 downto 12);

    read_register_1 <= instruction(19 downto 15);
    read_register_2 <= instruction(24 downto 20);
    write_register <= instruction(11 downto 7);

    registers: regfile(
      clk => clk,
      rst => rst,
      regWrite => reg_write,
      rr1 => read_register_1,
      rr2 => read_register_2,
      wr => write_register,
      d => write_data,
      q1 => read_data_1,
      q2 => read_data_2
    );

    signExtend(
      i => instruction,
      o => imm_extended
    );

    alu_input_2 <= read_data_2 when alu_src = '0' else imm_extended;

  main_alu: alu is
    port (
      A => read_data_1,
      B => alu_input_2,
      F => alu_result,
      S => alu_ctrl,
      Z => zero,
    );

  data_mem: ram(
        clk => clk,
        mem_write => mem_write,
        mem_read => mem_read,
        addr => alu_result,
        write_data => read_data_2,
        read_data => read_data,
     );

   write_data <= alu_result when mem_to_reg = '0' else read_data;

  cu => ,
      -- To Datapath
      aluSrc => alu_src,
      aluOp => alu_op,
      branch => branch,
      memRead => mem_read,
      memWrite => mem_write,
      regWrite => reg_write,
      memToReg => mem_to_reg,
      -- From Datapath
      opcode => opcode,
    );

  acu => ,
      aluop => alu_op,
      funct7 => funct7,
      funct3 => funct3,
      aluCtrl => alu_ctrl,
   );

end monocycle_arch; 
