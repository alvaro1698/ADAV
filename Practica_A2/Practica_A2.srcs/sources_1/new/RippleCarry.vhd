----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.03.2024 17:29:44
-- Design Name: 
-- Module Name: RippleCarry - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RippleCarry is
    Port ( Ar : in STD_LOGIC_VECTOR(23 downto 0);
           Br : in STD_LOGIC_VECTOR(23 downto 0);
           Mode : in STD_LOGIC; -- 1 acciona el modo resta y 0 acciona modo suma
           Sr : out STD_LOGIC_VECTOR(23 downto 0);
           Coutr : out STD_LOGIC);
end RippleCarry;

architecture Behavioral of RippleCarry is
    signal Carry : std_logic_vector(21 downto 0);
    signal Bs : std_logic_vector(23 downto 0);
    signal C : std_logic;
    
    component FullAdder is
        Port ( Af : in STD_LOGIC;
               Bf : in STD_LOGIC;
               Cinf : in STD_LOGIC;
               Sf : out STD_LOGIC;
               Coutf : out STD_LOGIC);
    end component;
    
begin

    Bs <= not(Br) when Mode = '1' else Br;
    C <= '1' when Mode = '1' else '0';
    
    FullAdder_Start: FullAdder
        port map(  Af => Ar(0),
                   Bf => Bs(0),
                   Cinf => C,
                   Sf => Sr(0),
                   Coutf => Carry(0)  
        );
        
    FullAdder_1_21: for i in 1 to 21 generate
    FullAdder_N: FullAdder
        port map ( Af => Ar(i),
                   Bf => Bs(i),
                   Cinf => Carry(i-1),
                   Sf => Sr(i),
                   Coutf => Carry(i)  
        );
   end generate;
   
    FullAdder_Finish: FullAdder
        port map ( Af => Ar(23),
                   Bf => Bs(23),
                   Cinf => Carry(21),
                   Sf => Sr(23),
                   Coutf => Coutr
        );

end Behavioral;
