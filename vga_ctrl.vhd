----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/27/2024 04:27:31 PM
-- Design Name: 
-- Module Name: vga_ctrl - Behavioral
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

entity vga_ctrl is
Port ( 

clk, en: in std_logic; 
HS, VS, Vid: out std_logic;
hcount: out std_logic_vector (9 downto 0);
vcount: out std_logic_vector (9 downto 0)

);
end vga_ctrl;

architecture Behavioral of vga_ctrl is

signal hcountt :std_logic_vector (9 downto 0) := (others => '0');
signal vcountt :std_logic_vector (9 downto 0) := (others => '0');


begin

process(clk)
begin 
    if(rising_edge(clk)) then 
    
        if( en = '1' ) then 
            
            if ( unsigned(hcountt) < 63) then 
            
                hcountt <= std_logic_vector ( unsigned(hcountt) +1); 
                
            else 
            
                hcountt <= (others => '0');
                 
                if( unsigned(vcountt) < 63) then 
                
                    vcountt <= std_logic_vector ( unsigned(vcountt) +1); 
                    
                else 
                
                    vcountt <= (others => '0');
                    
                    
                end if; 
                
            end if;
            
       end if; 
       
   end if; 
       
 end process; 
 
 
 HS_checker: process(clk,hcountt)
 begin 
 
    if ( unsigned(hcountt) > 655 and unsigned(hcountt)<752) then 
    
        HS <= '0';
        
    else 
    
        HS <= '1';
        
    end if; 
    
end process; 

VS_checker: process(clk,vcountt)
begin 

    if( unsigned(vcountt) > 489 and unsigned(vcountt) < 492) then 
    
        VS <= '0';
        
    else 
    
        VS <= '1';
        
    end if; 
    
end process; 


Vid_checker: process(clk,vcountt,hcountt) 
begin 

    if( unsigned(hcountt) < 640 and unsigned(vcountt) < 480) then 
    
        vid <= '1';
        
    else 
    
        vid <= '0';
        
    end if;
    
 end process; 
 
 hcount <= hcountt;
 vcount <= vcountt;
 
 end Behavioral; 
                
                
