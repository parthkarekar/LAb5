----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/04/2024 08:46:49 PM
-- Design Name: 
-- Module Name: framebuffer - Behavioral
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity framebuffer is
    
    generic (
    
        DATA : integer := 72;
        ADDR : integer := 10
    
    );


    Port ( clk1, en1, en2 : in STD_LOGIC;
           addr1, addr2 : out STD_LOGIC_VECTOR (11 downto 0);
           wr_en1 : in STD_LOGIC;
           din1 : in STD_LOGIC_VECTOR (15 downto 0);
           dout1, dout2 : out STD_LOGIC_VECTOR (15 downto 0));
end framebuffer;

architecture Behavioral of framebuffer is

begin




end Behavioral;
