library ieee;
use ieee.numeric_bit.all;
use std.textio.all;

entity rom is
   generic(
     file_name: string := "rom.dat";
     address_size : natural := 32;
     word_size    : natural := 32
   );
   port (
      address   : in  bit_vector(address_size-1 downto 0);
      read_data : out bit_vector(word_size-1 downto 0)
   );
 end entity;

architecture de_arquivo of rom is
  constant depth : natural := 2**address_size;
  type mem_t is array (0 to depth-1) of bit_vector(word_size-1 downto 0);

  --! Funcao que le o arquivo e preenche uma matriz temporaria
  --! Saida: matriz identica ao mem_t, preenchida com os valores do arquivo
  impure function inicializa(nome_do_arquivo : in string) return mem_t is
    file     arquivo  : text open read_mode is nome_do_arquivo;
    variable linha    : line;
    variable temp_bv  : bit_vector(3 downto 0);
    variable temp_mem : mem_t;
    begin
      --! Itera sobre o tamanho do tipo de dados (profundidade da matriz)
      for i in mem_t'range loop
        --! Le uma linha inteira do arquivo e coloca em "linha"
        readline(arquivo, linha);
        --! Interpreta a linha com um unico bit_vector e coloca em "temp_bv"
        read(linha, temp_bv);
        --! Atribui o valor lido para a matriz
        temp_mem(i) := temp_bv;
      end loop;
      return temp_mem;
    end;
  --! Delaracao da matriz de memoria em si, note que foi chamada a funcao para preenche-la.  
  constant mem : mem_t := inicializa(file_name);
begin
  read_data <= mem(to_integer(unsigned(address)));
end de_arquivo;
