----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.03.2024 17:20:57
-- Design Name: 
-- Module Name: FullAdder - Behavioral
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

entity FullAdder is
    Port ( Af : in STD_LOGIC;
           Bf : in STD_LOGIC;
           Cinf : in STD_LOGIC;
           Sf : out STD_LOGIC;
           Coutf : out STD_LOGIC);
end FullAdder;

architecture Behavioral of FullAdder is

begin

    Sf <= (Af xor Bf) xor Cinf;
    Coutf <= (Af and Bf) or ((Af xor Bf) and Cinf);
    
end Behavioral;
