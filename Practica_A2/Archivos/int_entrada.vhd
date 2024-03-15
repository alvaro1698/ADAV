LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;

ENTITY interfaz_entrada IS 
  PORT (
     reset, clk      : in std_logic;
     validacion      : in std_logic;
     data_in         : in std_logic_vector(23 downto 0); 
     ack             : out std_logic;
     entradas        : out std_logic_vector(23 downto 0) ); 
END interfaz_entrada;

ARCHITECTURE behavior OF interfaz_entrada IS
BEGIN  
      Proc_Captura : PROCESS (reset, validacion, data_in)
      BEGIN
           IF reset='0' THEN
                entradas <= (others => '0');
           ELSIF validacion = '1' THEN
               entradas <= data_in;
               ack <= '1';
           ELSE
               ack <= '0';
           END IF; 
      END PROCESS;
END behavior;
