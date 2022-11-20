library ieee;
use ieee.numeric_bit.all;

entity controlunit is
  port (
    -- From Datapath
    opcode: in bit_vector(6 downto 0);
    -- To Datapath
    alu_src: out bit;
    alu_op: out bit_vector(1 downto 0);
    branch: out bit;
    mem_read: out bit;
    mem_write: out bit;
    reg_write: out bit;
    mem_to_reg: out bit
  );
end entity;

architecture arch of controlunit is
  type intruction_type is (iLW, iSW, iBEQ, itypeR);
  signal intruct: intruction_type;
begin
  intruct <= iLW  when opcode = "0000011" else
             iSW  when opcode = "0100011" else
             iBEQ when opcode = "1100011" else
             itypeR;

  branch <= '1' when intruct = iBEQ else
            '0';

  mem_read <= '1' when intruct = iLW else
             '0';

  mem_to_reg <= '1' when intruct = iLW else
                '0';

  alu_op <= "00" when intruct = iLW 
                   or intruct = iSW  else
            "01" when intruct = iBEQ   else
            "10" when intruct = itypeR else
            "11";

  mem_write <= '1' when intruct = iSW else
              '0';

  alu_src <= '1' when intruct = iLW 
                  or intruct = iSW else
            '0';

  reg_write <= '1' when intruct = itypeR
                    or intruct = iLW  else
              '0';
end architecture;
