----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/26/2024 03:09:43 PM
-- Design Name: 
-- Module Name: my_alu - Behavioral
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

entity my_alu is
    Port ( A : in STD_LOGIC_VECTOR (15 downto 0);
           B : in STD_LOGIC_VECTOR (15 downto 0);
           C : out STD_LOGIC_VECTOR (15 downto 0);
           opcode: in std_logic_vector (3 downto 0);
           lda : in STD_LOGIC;
           ldb : in STD_LOGIC;
           ldop : in STD_LOGIC;
           clk: in std_logic;
           en: std_logic; 
           rst: in std_logic
           
           );
end my_alu;

architecture Behavioral of my_alu is

signal Atemp, Btemp, op :std_logic_vector (3 downto 0) := (others => '0');

begin



process( A, B, opcode,clk,rst,en)
begin 

if (rising_edge(clk)) then 

  if(en = '1') then 

    if (lda = '1') then 

        Atemp <= A;

    end if; 

    if (ldb = '1') then 

        Btemp <= B; 

    end if;


    if (ldop = '1') then 

        op <= opcode; 
    
    end if; 



if (rst = '1') then 

    C <= (others => '0');
    Atemp <= (others => '0');
    Btemp <= (others => '0');
    op <= (others => '0');
    
    
end if; 



    

case (op) is 

    when "0000" =>   
    
    C <= std_logic_vector ( unsigned (Atemp) + unsigned(Btemp));
    
    when "0001" =>
    
    C <= std_logic_vector ( unsigned (Atemp) - unsigned(Btemp));
    
    when "0010" => 
    
    C <= std_logic_vector ( unsigned (Atemp) + 1 );
    
    when "0011" =>
    
    C <= std_logic_vector (unsigned( Atemp)-1);
    
    when "0100" =>
    
    C <= std_logic_vector ( 0 - unsigned( Atemp));
    
    
    when "0101" => 
       
    C <= std_logic_vector(unsigned(Atemp) sll 1); 
        
        
    when "0110" => 
    
    C <= std_logic_vector(unsigned(Atemp) srl 1);
        
    when "0111" =>  
    
    C <= std_logic_vector (shift_right(signed(Atemp ),1));
        
    when "1000" => 
    
    C <= Atemp and Btemp;
        
    when "1001" => 
    
    C <= Atemp or Btemp;
        
    when "1010" =>
    
    C <= Atemp xor Btemp;
        
    when "1011" => --11
    
        if( to_integer(signed(Atemp)) < to_integer(signed(Btemp))) then 
        
            C <= (others => '0');
            
        else 
        
            C <= std_logic_vector(1);
            
        end if; 
    
    
        
    when "1100" => --12
    
        if( to_integer(signed(Atemp)) > to_integer(signed(Btemp))) then 
        
            C <= (others => '0');
            
        else 
        
            C <= std_logic_vector(1);
            
        end if; 
    
    
        
        
    when "1101" => --13
    
       if ( Atemp = Btemp) then 
            
            C <= (others => '0');
            
       else 
       
            C <= std_logic_vector(1);
            
       end if; 
            
        
    when "1110" => 
    
        if (unsigned(Atemp) < unsigned(Btemp)) then 
            
            C <= (others => '0');
                
        else 
             
            C <= std_logic_vector(1);
    
        end if; 
        
    when "1111" =>
    
        if(unsigned(Atemp) > unsigned(Btemp)) then 
            
            C <= (others => '0');
            
        else 
        
            C <= std_logic_vector(1);
            
        end if; 
    
        
        
    when others =>
    
        C <= "0000";
        
        
end case;

end if;  
 
end if; 
      
end process;    
        
   

end Behavioral;
