LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_signed.all;

entity datapath is 
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
end datapath;

architecture behavior OF datapath is
    
    signal r1, r2, r3, r4, r5, r6 : std_logic_vector (23 downto 0);
    signal r1_comb, r2_comb, r3_comb, r4_comb, r5_comb, r6_comb : std_logic_vector(23 downto 0); -- Señales de entrada de los FFs

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
    
Proc_Muxes_com : PROCESS (reset, comandos, c_m2d, c_m1d, c_s2d, c_s1d, r_moded, c_sd)
BEGIN
     IF reset='0' THEN
          m_A <= (others => '0');
          m_B <= (others => '0');
          r_A <= (others => '0');
          r_B <= (others => '0');
          r1_comb <= (others => '0');
          r2_comb <= (others => '0');
          r3_comb <= (others => '0');
          r4_comb <= (others => '0');
          r5_comb <= (others => '0');
          r6_comb <= (others => '0');
          salidas <= (others => '0');
     ELSE   
          m_A <= (others => '0');
          m_B <= (others => '0');
          r_A <= (others => '0');
          r_B <= (others => '0');
          r1_comb <= (others => '0');
          r2_comb <= (others => '0');
          r3_comb <= (others => '0');
          r4_comb <= (others => '0');
          r5_comb <= (others => '0');
          salidas <= (others => '0');         
          
          CASE c_m1d IS
               WHEN "000" => m_B <= (others => '0');
               
               WHEN "001" => m_B <= r1;
               
               WHEN "011" => m_B <= r3;
               
               WHEN "100" => m_B <= r4;
               
               WHEN "110" => m_B <= r6;
               
               WHEN others => 
          END CASE;
          
          CASE c_m2d IS
               WHEN "0000" => m_A <= (others => '0');
               
               WHEN "0001" => m_A <= b1;
               
               WHEN "0010" => m_A <= b2;
               
               WHEN "0011" => m_A <= b3;
               
               WHEN "0100" => m_A <= b4;
               
               WHEN "0101" => m_A <= b5;
               
               WHEN "0110" => m_A <= inv_a1;
               
               WHEN "0111" => m_A <= neg_a2;
               
               WHEN "1000" => m_A <= neg_a3;
               
               WHEN "1001" => m_A <= neg_a4;
               
               WHEN "1010" => m_A <= neg_a5;
               
               WHEN others => 
          END CASE;
          
          CASE c_s1d IS
               WHEN "000" => r_B <= (others => '0');
               
               WHEN "001" => r_B <= r1;
               
               WHEN "010" => r_B <= r2;
               
               WHEN "100" => r_B <= r4;
               
               WHEN "101" => r_B <= r5;
               
               WHEN others => 
          END CASE;
          
          CASE c_s2d IS
               WHEN "000" => r_A <= (others => '0');
               
               WHEN "001" => r_A <= r1;
               
               WHEN "011" => r_A <= r3;
               
               WHEN "100" => r_A <= r4;
               
               WHEN "101" => r_A <= r5;
               
               WHEN "110" => r_A <= r6;
               
               WHEN others => 
          END CASE;
          
          CASE comandos IS
               WHEN "000000000001" =>
                  r1_comb <= entradas;
                  r2_comb <= (others => '0');
                  r3_comb <= (others => '0');
                  r4_comb <= (others => '0');
                  r5_comb <= (others => '0');
                  r6_comb <= (others => '0');
               WHEN "000000000010" =>
                  r1_comb <= entradas;
                  r2_comb <= m_out;
                  r3_comb <= (others => '0');
                  r4_comb <= (others => '0');
                  r5_comb <= (others => '0');
                  r6_comb <= (others => '0');
               WHEN "000000000100" =>
                  r1_comb <= entradas;
                  r2_comb <= m_out;
                  r3_comb <= r_out;
                  r4_comb <= (others => '0');
                  r5_comb <= (others => '0');
                  r6_comb <= (others => '0');
               WHEN "000000001000" =>
                  r1_comb <= entradas;
                  r2_comb <= m_out;
                  r3_comb <= (others => '0');
                  r4_comb <= r_out;
                  r5_comb <= (others => '0');
                  r6_comb <= (others => '0');
               WHEN "000000010000" =>
                  r1_comb <= entradas;
                  r2_comb <= m_out;
                  r3_comb <= (others => '0');
                  r4_comb <= (others => '0');
                  r5_comb <= r_out;
                  r6_comb <= (others => '0');
               WHEN "000000100000" =>
                  r1_comb <= r_out;
                  r2_comb <= m_out;
                  r3_comb <= (others => '0');
                  r4_comb <= (others => '0');
                  r5_comb <= (others => '0');
                  r6_comb <= (others => '0');
               WHEN "000001000000" =>
                  r1_comb <= (others => '0');
                  r2_comb <= (others => '0');
                  r3_comb <= m_out;
                  r4_comb <= (others => '0');
                  r5_comb <= (others => '0');
                  r6_comb <= (others => '0');
               WHEN "000010000000" =>
                  r1_comb <= (others => '0');
                  r2_comb <= (others => '0');
                  r3_comb <= (others => '0');
                  r4_comb <= (others => '0');
                  r5_comb <= (others => '0');
                  r6_comb <= m_out;
               WHEN "000100000000" =>
                  r1_comb <= (others => '0');
                  r2_comb <= (others => '0');
                  r3_comb <= (others => '0');
                  r4_comb <= m_out;
                  r5_comb <= (others => '0');
                  r6_comb <= r_out;
               WHEN "001000000000" =>
                  r1_comb <= (others => '0');
                  r2_comb <= (others => '0');
                  r3_comb <= (others => '0');
                  r4_comb <= m_out;
                  r5_comb <= r_out;
                  r6_comb <= (others => '0');
               WHEN "010000000000" =>
                  r1_comb <= m_out;
                  r2_comb <= (others => '0');
                  r3_comb <= (others => '0');
                  r4_comb <= r_out;
                  r5_comb <= (others => '0');
                  r6_comb <= (others => '0');
               WHEN "100000000000" =>
                  r1_comb <= r_out;
                  r2_comb <= (others => '0');
                  r3_comb <= (others => '0');
                  r4_comb <= (others => '0');
                  r5_comb <= (others => '0');
                  r6_comb <= (others => '0');
               WHEN others => 
         END CASE;
         
          CASE c_sd IS
               WHEN '0' => salidas <= (others => '0');
               
               WHEN '1' => salidas <= r3;
               
               WHEN others => 
          END CASE;         
          
     END IF;
END PROCESS;

Proc_seq : PROCESS (reset, clk)
BEGIN
     IF reset='0' THEN   
        r1 <= (others => '0');
        r2 <= (others => '0');
        r3 <= (others => '0');
        r4 <= (others => '0');
        r5 <= (others => '0');
        r6 <= (others => '0');
     ELSIF (clk'event AND clk='1') THEN
        r1 <= r1_comb;
        r2 <= r2_comb;
        r3 <= r3_comb;
        r4 <= r4_comb;
        r5 <= r5_comb;
        r6 <= r6_comb;
     END IF; 
END PROCESS;   

-- dec2bin(floor(-1.275613*2^16)) OctaveOnline
END behavior;
