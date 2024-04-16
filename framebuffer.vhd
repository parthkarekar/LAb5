----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/08/2024 05:39:05 PM
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
--library UNISIM;
--use UNISIM.VComponents.all;

entity framebuffer is
    Port ( clk1, en1, en2, ld : in STD_LOGIC;
           addr1, addr2 : in STD_LOGIC_VECTOR (11 downto 0);
           wr_en1 : in STD_LOGIC;
           din : in STD_LOGIC_VECTOR (15 downto 0);
           dout1, dout2 : out STD_LOGIC_VECTOR (15 downto 0));
end framebuffer;

architecture Behavioral of framebuffer is

type mem_array is array (0 to 4095) of std_logic_vector (15 downto 0);
signal memory: mem_array;

begin

process(clk1)
begin  

  if (rising_edge (clk1) ) then 
    
        if ( en1 = '1') then 
        
            if (wr_en1 = '1') then 
            
                memory(to_integer(unsigned(addr1))) <= din;
         
            end if;
            
            dout1 <= memory(to_integer(unsigned(addr1)));
            
        elsif (en2 = '1') then 
        
            if(wr_en1 = '1') then 
            
                memory(to_integer(unsigned(addr2))) <= din;
                
            end if; 
            
            dout2 <= memory(to_integer(unsigned(addr2)));
            
        end if;
        
    end if; 
    
 end process; 
 

end Behavioral;
