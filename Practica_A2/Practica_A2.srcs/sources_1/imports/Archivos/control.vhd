LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;

ENTITY control IS 
  PORT (
     reset, clk    : in std_logic;
     validacion    : in std_logic;
     flags         : in  std_logic_vector(7 downto 0);
     c_m2c          : out std_logic_vector(3 downto 0); -- Control mux2 del multiplicador
     c_m1c          : out std_logic_vector(2 downto 0); -- Control mux1 del multiplicador
     c_s2c          : out std_logic_vector(2 downto 0); -- Control mux2 del RippleCarry
     c_s1c          : out std_logic_vector(2 downto 0); -- Control mux1 del RippleCarry
     r_modec        : out std_logic; -- Señal de control del modo del RippleCarry
     comandos      : out std_logic_vector(11 downto 0);
     fin           : out std_logic );
END control;

ARCHITECTURE behavior OF control IS
  CONSTANT ck0 : integer := 0;    CONSTANT ck1 : integer := 1;
  CONSTANT ck2 : integer := 2;    CONSTANT ck3 : integer := 3;
  CONSTANT ck4 : integer := 4;    CONSTANT ck5 : integer := 5;
  CONSTANT ck6 : integer := 6;    CONSTANT ck7 : integer := 7;
  CONSTANT ck8 : integer := 8;    CONSTANT ck9 : integer := 9;
  CONSTANT ck10 : integer := 10;  CONSTANT ck11 : integer := 11;  
  
  signal estado : integer;
BEGIN  

Proc_Estado : PROCESS (reset, clk)
BEGIN
     IF reset='0' THEN   estado <= 0;
     ELSIF (clk'event AND clk='1') THEN
          estado <= estado + 1;
          IF (validacion = '0') THEN estado <= ck0; else estado <= ck1; END IF;
          IF estado = ck11 THEN estado <= ck0; END IF;
          --IF flags = (...) THEN (...); END IF;
     END IF; 
END PROCESS;

Proc_Comandos : PROCESS (reset, estado)
BEGIN
     IF reset='0' THEN
          comandos <= "000000000000";
          c_m2c <= "0000";
          c_m1c <= "000";
          c_s2c <= "000";
          c_s1c <= "000";
          r_modec <= '0';
          fin <= '0';      
     ELSE   
          comandos <= "000000000000";
          c_m2c <= "0000";
          c_m1c <= "000";
          c_s2c <= "000";
          c_s1c <= "000";
          r_modec <= '0';
          fin <= '0';  
          
          CASE estado IS
               WHEN ck0 =>
                  comandos <= "000000000001";
                  c_m2c <= "0000";
                  c_m1c <= "000";
                  c_s2c <= "000"; 
                  c_s1c <= "000";
                  r_modec <= '0';   
               WHEN ck1 =>
                  comandos <= "000000000010";
                  c_m2c <= "0001";
                  c_m1c <= "001";
                  c_s2c <= "000"; 
                  c_s1c <= "000";
                  r_modec <= '0';  
               WHEN ck2 =>
                  comandos <= "000000000100";
                  c_m2c <= "0010";
                  c_m1c <= "001";
                  c_s2c <= "011"; 
                  c_s1c <= "010";
                  r_modec <= '0';
               WHEN ck3 =>
                  comandos <= "000000001000";
                  c_m2c <= "0011";
                  c_m1c <= "001";
                  c_s2c <= "100"; 
                  c_s1c <= "010";
                  r_modec <= '0';
               WHEN ck4 =>
                  comandos <= "000000010000";
                  c_m2c <= "0100";
                  c_m1c <= "001";
                  c_s2c <= "101"; 
                  c_s1c <= "010";
                  r_modec <= '0';
               WHEN ck5 =>
                  comandos <= "000000100000";
                  c_m2c <= "0101";
                  c_m1c <= "001";
                  c_s2c <= "110"; 
                  c_s1c <= "010";
                  r_modec <= '0';
               WHEN ck6 =>
                  comandos <= "000001000000";
                  c_m2c <= "0110";
                  c_m1c <= "011";
                  c_s2c <= "000"; 
                  c_s1c <= "000";
                  r_modec <= '0';
               WHEN ck7 =>
                  comandos <= "000010000000";
                  c_m2c <= "0111";
                  c_m1c <= "011";
                  c_s2c <= "000"; 
                  c_s1c <= "000";
                  r_modec <= '0';
               WHEN ck8 =>
                  comandos <= "000100000000";
                  c_m2c <= "1000";
                  c_m1c <= "110";
                  c_s2c <= "110"; 
                  c_s1c <= "100";
                  r_modec <= '0';
               WHEN ck9 =>
                  comandos <= "001000000000";
                  c_m2c <= "1001";
                  c_m1c <= "100";
                  c_s2c <= "100"; 
                  c_s1c <= "101";
                  r_modec <= '0';
               WHEN ck10 =>
                  comandos <= "010000000000";
                  c_m2c <= "1010";
                  c_m1c <= "100";
                  c_s2c <= "100"; 
                  c_s1c <= "001";
                  r_modec <= '0';
	           WHEN ck11 =>
	              comandos <= "100000000000";
	              c_m2c <= "0000";
                  c_m1c <= "000";
                  c_s2c <= "001"; 
                  c_s1c <= "010";
                  r_modec <= '0';
	              fin <= '1';
               WHEN others => 
         END CASE;
     END IF;
END PROCESS;

END behavior;