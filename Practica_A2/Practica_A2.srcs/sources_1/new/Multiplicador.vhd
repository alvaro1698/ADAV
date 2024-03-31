----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.03.2024 18:24:59
-- Design Name: 
-- Module Name: Multiplicador - Behavioral
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

entity Multiplicador is
    Port ( Am : in STD_LOGIC_VECTOR (23 downto 0);
           Bm : in STD_LOGIC_VECTOR (23 downto 0);
           Sm : out STD_LOGIC_VECTOR (23 downto 0));
end Multiplicador;

architecture Behavioral of Multiplicador is
    
    signal m : std_logic_vector(47 downto 0);

begin
    
    m <= Am * Bm;
    Sm <= m(39 downto 0);

end Behavioral;
