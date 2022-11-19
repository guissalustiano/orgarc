library ieee;
use ieee.numeric_bit.all;

entity controlunit is
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

  memRead <= '1' when intruct = iLW else
             '0';

  memToReg <= '1' when intruct = iLW else
              '0';

  aluOp <= "00" when intruct = iLW 
                  or intruct = iSW  else
           "01" when intruct = iBEQ   else
           "10" when intruct = itypeR else
           "11";

  memWrite <= '1' when intruct = iSW else
              '0';

  aluSrc <= '1' when intruct = iLW 
                  or intruct = iSW else
            '0';

  regWrite <= '1' when intruct = itypeR
                    or intruct = iLW  else
              '0';
end architecture;
