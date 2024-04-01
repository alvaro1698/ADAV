LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;

ENTITY top IS 
  PORT (
     reset, clk      : in std_logic;
     validacion      : in std_logic;
     data_in         : in std_logic_vector(23 downto 0);
     ack_out         : in std_logic; 
     data_out        : out std_logic_vector(23 downto 0);  
     valid_out       : out std_logic;
     ack_in          : out std_logic );
END top;


ARCHITECTURE behavior OF top IS

COMPONENT datapath IS 
  PORT (
     reset, clk    : in std_logic;
     c_m2d          : in std_logic_vector(3 downto 0); -- Control mux2 del multiplicador
     c_m1d          : in std_logic_vector(2 downto 0); -- Control mux1 del multiplicador
     c_s2d          : in std_logic_vector(2 downto 0); -- Control mux2 del RippleCarry
     c_s1d          : in std_logic_vector(2 downto 0); -- Control mux1 del RippleCarry
     r_moded        : in std_logic; -- Señal de control del modo del RippleCarry
     c_sd           : in std_logic; -- Señal de control de la salida 
     comandos      : in std_logic_vector(11 downto 0);
     entradas      : in std_logic_vector(23 downto 0);  
     salidas       : out std_logic_vector(23 downto 0);  
     flags         : out std_logic_vector(7 downto 0) );
END component;

COMPONENT control IS 
  PORT (
     reset, clk    : in std_logic;
     validacion    : in std_logic;
     flags         : in  std_logic_vector(7 downto 0);
     c_m2c          : out std_logic_vector(3 downto 0); -- Control mux2 del multiplicador
     c_m1c          : out std_logic_vector(2 downto 0); -- Control mux1 del multiplicador
     c_s2c          : out std_logic_vector(2 downto 0); -- Control mux2 del RippleCarry
     c_s1c          : out std_logic_vector(2 downto 0); -- Control mux1 del RippleCarry
     r_modec        : out std_logic; -- Señal de control del modo del RippleCarry
     c_sc           : out std_logic; -- Señal de control de la salida     
     comandos      : out std_logic_vector(11 downto 0);
     fin           : out std_logic );
END component;

COMPONENT interfaz_entrada IS 
  PORT (
     reset, clk      : in std_logic;
     validacion      : in std_logic;
     data_in         : in std_logic_vector(23 downto 0); 
     entradas        : out std_logic_vector(23 downto 0);
     ack_in          : out std_logic ); 
END component;

COMPONENT interfaz_salida IS 
  PORT (
     reset, clk      : in std_logic;
     fin             : in std_logic;
     salidas         : in std_logic_vector(23 downto 0);
     ack_out         : in std_logic;  
     data_out        : out std_logic_vector(23 downto 0);  
     valid_out       : out std_logic );
END component;


  SIGNAL entradas, salidas : std_logic_vector(23 downto 0);
  SIGNAL flags : std_logic_vector(7 downto 0);
  SIGNAL comandos : std_logic_vector(11 downto 0);
  SIGNAL fin, mode : std_logic;
  signal c_m2 : std_logic_vector(3 downto 0);
  signal c_m1, c_s2, c_s1 : std_logic_vector(2 downto 0);
  signal r_mode, c_s : std_logic;

  
BEGIN  


U1 : datapath 
     PORT MAP (reset => reset,
               clk => clk, 
               c_m2d => c_m2,
               c_m1d => c_m1,
               c_s2d => c_s2, 
               c_s1d => c_s1, 
               r_moded => r_mode,
               c_sd => c_s,
               comandos => comandos, 
               entradas => entradas, 
               salidas => salidas, 
               flags => flags );

U2 : control 
     PORT MAP (reset => reset, 
               clk => clk, 
               validacion => validacion,
               c_m2c => c_m2,
               c_m1c => c_m1,
               c_s2c => c_s2, 
               c_s1c => c_s1, 
               r_modec => r_mode,
               c_sc => c_s,
               comandos => comandos, 
               flags => flags, 
               fin => fin );

U3 : interfaz_entrada  
     PORT MAP (reset => reset, 
               clk => clk, 
               validacion => validacion, 
               data_in => data_in,
               ack_in => ack_in,
               entradas => entradas );

U4 : interfaz_salida  
     PORT MAP (reset => reset, 
               clk => clk, 
               fin => fin,
               ack_out => ack_out,
               salidas => salidas, 
               data_out => data_out, 
               valid_out => valid_out );

	 
END behavior;
