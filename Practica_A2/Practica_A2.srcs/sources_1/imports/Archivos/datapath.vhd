LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_signed.all;

entity datapath is 
  PORT (
     reset, clk    : in std_logic;
     c_m2d          : out std_logic_vector(3 downto 0); -- Control mux2 del multiplicador
     c_m1d          : out std_logic_vector(2 downto 0); -- Control mux1 del multiplicador
     c_s2d          : out std_logic_vector(2 downto 0); -- Control mux2 del RippleCarry
     c_s1d          : out std_logic_vector(2 downto 0); -- Control mux1 del RippleCarry
     r_moded        : out std_logic; -- Señal de control del modo del RippleCarry
     comandos      : in std_logic_vector(7 downto 0);
     entradas      : in std_logic_vector(23 downto 0);  
     salidas       : out std_logic_vector(23 downto 0);  
     flags         : out std_logic_vector(7 downto 0) );
end datapath;

architecture behavior OF datapath is
    
    signal r1, r2, r3, r4, r5, r6 : std_logic_vector (23 downto 0);
    signal r1_comb, r2_comb, r3_comb, r4_comb : std_logic_vector(23 downto 0);

--	signal tmp0 : std_logic_vector(23 downto 0); -- r1
--	signal tmp1, tmp2, tmp3, tmp4, tmp5 : std_logic_vector(23 downto 0); -- r2
--	signal tmp6 : std_logic_vector(23 downto 0); -- r1
--	signal tmp7 : std_logic_vector(23 downto 0); -- r5
--	signal tmp8 : std_logic_vector(23 downto 0); -- r4
--	signal tmp9, tmp10 : std_logic_vector(23 downto 0); -- r3
--	signal tmp11 : std_logic_vector(23 downto 0); -- r6
--	signal tmp12, tmp13 : std_logic_vector(23 downto 0); -- r4
--	signal tmp14 : std_logic_vector(23 downto 0); -- r1
--	signal tmp15 : std_logic_vector(23 downto 0); -- r6
--	signal tmp16 : std_logic_vector(23 downto 0); -- r5
--	signal tmp17 : std_logic_vector(23 downto 0); -- r4
--	signal tmp18 : std_logic_vector(23 downto 0); -- r1

--	signal m_tmp1, m_tmp2, m_tmp3, m_tmp4, m_tmp5 : std_logic_vector(47 downto 0);
--	signal m_tmp10, m_tmp11, m_tmp12, m_tmp13, m_tmp14: std_logic_vector(47 downto 0);

--	signal sv1 : std_logic_vector(23 downto 0); -- r3
--	signal sv2 : std_logic_vector(23 downto 0); -- r4
--	signal sv3 : std_logic_vector(23 downto 0); -- r5
--	signal sv4 : std_logic_vector(23 downto 0); -- r6
--	signal sv1_comb, sv2_comb, sv3_comb, sv4_comb : std_logic_vector(23 downto 0);

	constant b1 : std_logic_vector(23 downto 0) := "00000000" & "00000100" & "11000000";
	constant b2 : std_logic_vector(23 downto 0) := "00000000" & "00010011" & "00000010";
	constant b3 : std_logic_vector(23 downto 0) := "00000000" & "00011100" & "10000011";
	constant b4 : std_logic_vector(23 downto 0) := "00000000" & "00010011" & "00000010";
	constant b5 : std_logic_vector(23 downto 0) := "00000000" & "00000100" & "11000000";

	constant inv_a1 : std_logic_vector(23 downto 0) := "00000001" & "00000000" & "00000000";
	constant neg_a2 : std_logic_vector(23 downto 0) := "00000001" & "10010010" & "00000101";
	constant neg_a3 : std_logic_vector(23 downto 0) := "11111110" & "10111001" & "01110010";
	constant neg_a4 : std_logic_vector(23 downto 0) := "00000000" & "01111100" & "00000001";
	constant neg_a5 : std_logic_vector(23 downto 0) := "11111111" & "11101100" & "01111111";

	signal r_A, r_B, m_A, m_B : std_logic_vector(23 downto 0); -- Señales de entrada de los operadores
	signal r_out, m_out : std_logic_vector(23 downto 0); -- Señales de salida de los operadores
	signal r_cout : std_logic; -- Señal de Carry out (no usado).

    component RippleCarry is
        Port ( Ar : in STD_LOGIC_VECTOR(23 downto 0);
               Br : in STD_LOGIC_VECTOR(23 downto 0);
               Mode : in STD_LOGIC; -- 1 acciona el modo resta y 0 acciona modo suma
               Sr : out STD_LOGIC_VECTOR(23 downto 0);
               Coutr : out STD_LOGIC);
    end component;
    
    component Multiplicador is
        Port ( Am : in STD_LOGIC_VECTOR (23 downto 0);
               Bm : in STD_LOGIC_VECTOR (23 downto 0);
               Sm : out STD_LOGIC_VECTOR (23 downto 0));
    end component;

begin
    
    RippleCarry0 : RippleCarry
        port map ( Ar => r_A,
                   Br => r_B,
                   Mode => r_moded,
                   Sr => r_out,
                   Coutr => r_cout  
        );
    
    Multiplicador0 : Multiplicador
        port map ( Am => m_A,
                   Bm => m_B,
                   Sm => m_out
        );    
        
    Proc_seq : PROCESS (reset, clk)
    begin
           IF reset='0' THEN
		      sv1 <= (others => '0');		sv2 <= (others => '0');
		      sv3 <= (others => '0');		sv4 <= (others => '0');
           ELSIF (clk'event AND clk='1') THEN
		     IF comandos(0)='1' THEN
		        sv1 <= sv1_comb;		sv2 <= sv2_comb;
		        sv3 <= sv3_comb;		sv4 <= sv4_comb;
             END IF; 
           END IF; 
      END PROCESS;
	  
	flags <= (others => '0');

  	tmp0 <= entradas;
  	m_tmp1 <= tmp0 * b1;
  		tmp1 <= m_tmp1(39 downto 16);
  	m_tmp2 <= tmp0 * b2;
  		tmp2 <= m_tmp2(39 downto 16);
  	m_tmp3 <= tmp0 * b3;
  		tmp3 <= m_tmp3(39 downto 16);
  	m_tmp4 <= tmp0 * b4;
  		tmp4 <= m_tmp4(39 downto 16);
  	m_tmp5 <= tmp0 * b5;
  		tmp5 <= m_tmp5(39 downto 16);

  	tmp6 <= tmp4 + sv4;
  	tmp7 <= tmp3 + sv3;
  	tmp8 <= tmp2 + sv2;
  	tmp9 <= tmp1 + sv1;

  	m_tmp10 <= tmp9 * inv_a1;
  		tmp10 <= m_tmp10(39 downto 16);
  	m_tmp11 <= tmp10 * neg_a2;
  		tmp11 <= m_tmp11(39 downto 16);
  	m_tmp12 <= tmp10 * neg_a3;
  		tmp12 <= m_tmp12(39 downto 16);
  	m_tmp13 <= tmp10 * neg_a4;
  		tmp13 <= m_tmp13(39 downto 16);
  	m_tmp14 <= tmp10 * neg_a5;
  		tmp14 <= m_tmp14(39 downto 16);

  	tmp15 <= tmp8 + tmp11;
  	tmp16 <= tmp7 + tmp12;
  	tmp17 <= tmp6 + tmp13;
  	tmp18 <= tmp5 + tmp14;

	
	salidas <= tmp10;

  	sv4_comb <= tmp18;
  	sv3_comb <= tmp17;
  	sv2_comb <= tmp16;
  	sv1_comb <= tmp15;

-- dec2bin(floor(-1.275613*2^16)) OctaveOnline
END behavior;
