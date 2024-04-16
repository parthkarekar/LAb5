----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2024 05:16:00 PM
-- Design Name: 
-- Module Name: controls - Behavioral
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

entity controls is
    Port (
        --timing signals 

        clk, en, rst:in std_logic;

        --register file io 

        rID1, rID2:out       std_logic_vector(4 downto 0);
        wr_enR1, wr_enR2:out std_logic;
        regrD1, regrD2:in    std_logic_vector (15 downto 0);
        regwD1, regwD2:out   std_logic_vector (15 downto 0);
        
        --Framebuffer IO 
        fbRST: out std_logic; 
        fbADDR1: out std_logic_vector (11 downto 0);
        fbDin1: in std_logic_vector(15 downto 0);
        fbDout1: out std_logic_vector (15 downto 0); 
        fbWr_en: out std_logic;
        
        --Instruction Memory IO 
        irAddr :out std_logic_vector (13 downto 0);
        irWord: in std_logic_vector (31 downto 0);
        
        --Data Memory IO 
        dAddr :out std_logic_vector (14 downto 0);
        d_wr_en:out std_logic;
        dOut: out std_logic_vector (15 downto 0); 
        dIn: in std_logic_vector (15 downto 0);
        
        --Alu IO 
        aluA, aluB: out std_logic_vector (15 downto 0);
        aluOP: out std_logic_vector (3 downto 0);
        aluResult: in std_logic_vector (15 downto 0);
        
        --Uart IO 
        ready, newchar: in std_logic; 
        send: out std_logic;
        charRec: in std_logic_vector (7 downto 0); 
        charSend: out std_logic_vector (7 downto 0)
   

    );
end controls;

architecture Behavioral of controls is

type state_type is (fetch, decode,decode1,Rops, Iops, Jops, Calc, Calc1, 
                    store,jr, recv, rpix, wpix, send_state, equals, 
                    nequal, ori, lw, sw, jmp, jal, clrscr, finish, lw1, lw2, ori1, equals1);
                    
signal curr: state_type; 

signal PC: std_logic_vector (15 downto 0):= (others => '0');
signal irMem: std_logic_vector (31 downto 0):= (others => '0');
signal reg1, reg2, reg3: std_logic_vector (4 downto 0):= (others => '0'); 
signal imm: std_logic_vector (15 downto 0):= (others => '0');
signal result_val :std_logic_vector (15 downto 0):=(others => '0');
signal regrD1_temp:std_logic_vector (15 downto 0):=(others =>'0');

begin

process(clk)
begin

if(rising_edge(clk)) then 

    if( en = '1') then 
    
    
    case (curr) is  
    
    when fetch =>
    
    rID1 <= "00001";
    PC <= regrD1; 
    curr <= decode; 
    
    when decode => 
    irAddr <= PC(13 downto 0); 
    curr <= decode1;
    
    
    when decode1 =>
    
    irMem <= irWord; 
    PC <= std_logic_vector (unsigned (PC) +1); 
    
    wr_enR1 <= '1';
    regwD1 <= PC;
    
        if( irMem(31 downto 30) = "00" or irMem(31 downto 30) = "01" ) then 
        
            curr <= Rops;
            
        elsif( irMem(31 downto 30) = "10") then 
        
            curr <=Iops;
            
        else 
        
            curr <= Jops; 
            
        end if; 
    
    
    when Rops =>
    
        wr_enR1 <= '0';
        reg1 <= irMem(26 downto 22);
        reg2 <= irMem(21 downto 17);
        reg3 <= irMem(16 downto 12);
        
            if( irMem(31 downto 27) = "01101") then 
            
                curr <= jr; 
                
            elsif (irMem(31 downto 27) = "01100") then
            
                curr <= recv;
                
            elsif ( irMem(31 downto 27) = "01111") then 
            
                curr <= rpix; 
                
            elsif ( irMem(31 downto 27) = "01110") then
            
                curr <= wpix; 
                
            elsif ( irMem(31 downto 27) = "01011") then 
            
                curr <= send_state; 
                
            else 
            
                curr <= calc; 
                
            end if; 
   
    when Iops =>
    
        reg1 <= irMem(26 downto 22);
        reg2 <= irMem(21 downto 17);
        imm <= irMem(16 downto 1);
        
        
            if( irMem(29 downto 27) = "000") then 
            
                curr <= equals; 
                
            elsif(irMem(29 downto 27) = "001") then 
            
                curr <= nequal;
                
            elsif( irMem(29 downto 27) = "010") then 
            
                curr <= ori; 
                
            elsif( irMem(29 downto 27) = "011") then 
            
                curr <= lw;
                
            else 
            
                curr <= sw; 
                
            end if;
        
    
    when Jops =>
    
        imm <= irMem(26 downto 11);
        
            if( irMem(31 downto 27) = "11000") then
            
                curr <=   jmp; 
                
            elsif( irMem(31 downto 27) = "11001") then 
            
                curr <= jal; 
                
            else  
            
                curr <= clrscr;
                
            end if; 
          
    
    when Calc => 
    
        if(irMem(31 downto 27) = "00000") then 
        
            aluOP <= "0000";
            rID1 <= reg2;
            rID2 <= reg3;
            
            aluA <= regrD1; 
            aluB <= regrD2;
            
            curr <= Calc1;
       
        end if; 
    
    
    when Calc1 => 
    
            result_val <= aluResult;
            rID1 <= reg1;  
            curr <= store;
    
    when store => 
    
            wr_enR1 <= '1';
            regwD1 <= result_val;
            curr <= finish; 
            
    
    when jr => 
    --not used 
    when recv => 
            
            result_val <= "00000000" & charRec;
            
                if( newchar = '0') then 
                
                    curr <= recv;
                    
                else 
                
                    curr <= store;
                    
                end if; 
                
                
    when rpix => 
    --not used
    when wpix => 
    
        rID1 <= reg1;
        rID2 <= reg2; 
    
        fbADDR1 <= regrD1(11 downto 0);
        fbDout1 <= regrD2; 

        curr <= finish; 
    when send_state =>
    
    send <= '1'; 
        
    rID1 <= reg1;
    charSend <= regrD1(7 downto 0); 
    
        if(ready = '1') then 
        
            curr <= finish;
            
        else 
        
            curr <= send_state; 
            
        end if; 
     
    when equals => 
    aluop <= "1101";
    rID1 <= reg2;
    rID2 <= reg3;
    aluA <= regrD1;
    aluB <= regrD2;
    result_val <= aluResult;
    
    when equals1 =>
    rID1 <= reg1;
    wr_enR1 <= '1';
    regwD1 <= result_val;
    
    
    when nequal =>
    --not used
    when ori =>
    aluop <= "1001";
    rID1 <= reg2;
    rID2 <= reg3;
    aluA <= regrD1;
    aluB <= regrD2;
    result_val <= aluResult;
    
    curr <= ori1;
    
    when ori1 => 
    rID1 <= reg1;
    wr_enR1 <= '1';
    regwD1 <= result_val;
    
    curr <= store;
    
    when lw =>
    
    aluop <= "0000";
    rID1 <= reg1;
    rID2 <= reg2;
    aluA <= regrD2;
    aluB <= imm;
    result_val <= aluResult;
    
    curr <= lw1;
    
    when lw1 => 
    
    dOut <= result_val; 
    wr_enR1 <= '1';    
    curr <= lw2;
    
    when lw2 => 
    regwD1<= dIn;
    curr <= store; 
    
    when sw =>
    --not used
    when jmp => 
    
    PC <= imm;
    rID1 <= "00001";
    wr_enR1 <= '1';
    regwD1 <= PC;
    curr <= finish; 
    
    when jal => 
    --not used
    when clrscr =>
    --not used
    when finish => 
    wr_enR1 <= '0'; 
    wr_enR2 <= '0'; 
    
    end case; 
 
 end if;

end if;    
  
        
end process; 

end Behavioral;
