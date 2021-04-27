
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity tb_door_lock is
--  Port ( );
end tb_door_lock;

architecture Behavioral of tb_door_lock is     
-- Local constants         
signal BTN_s     :  std_logic_vector(12 - 1 downto 0);       --button from panel                 
signal dvere_s   :  std_logic;   

--display
constant c_CLK_100MHZ_PERIOD_disp : time    := 2 ns;                              
signal s_clk_100MHz_disp : std_logic;                                      
signal s_reset : std_logic ;                    
                                                
                                                
 signal s_dp_i : std_logic_vector(4-1 downto 0);
 signal s_dp_o : std_logic;                     
 signal s_seg  : std_logic_vector(7-1 downto 0);
 signal s_dig  : std_logic_vector(4-1 downto 0);              
                     

begin
uut_Door_lock_system : entity work.Door_lock_system
        port map(
            BTN     =>  BTN_s, 

            dvere   => dvere_s,
            --displeje
           
            clk_disp     => s_clk_100MHz_disp,
            reset   => s_reset,    
                        
                       
            dp_i    => s_dp_i,     
            dp_o    => s_dp_o,     
            seg_o   => s_seg,      
            dig_o   => s_dig       
            
           
        );

--------------------------------------------------------------------
-- Clock generation process
--------------------------------------------------------------------
 p_clk_gen_disp : process
begin
        while now < 10000 ns loop   
            s_clk_100MHz_disp <= '0';
            wait for c_CLK_100MHZ_PERIOD_disp / 2;
            s_clk_100MHz_disp <= '1';
            wait for c_CLK_100MHZ_PERIOD_disp / 2;
        end loop;
        wait;
    end process p_clk_gen_disp;
-------------------------------------------------------------------- 
-- Reset generation process                                          
--------------------------------------------------------------------
p_reset_gen : process                                                
begin                                                                
    s_reset <= '0';                                                  
    wait for 0 ns;                                                   
    --reset activation                                               
    s_reset <= '1';                                                  
    wait for 10 ns;                                                  
    --Reset deactivated                                              
    s_reset <= '0';                                                  
    wait;                                                            
    end process p_reset_gen;                                         
                                                                     
 p_stimulus : process
    begin
    
        -- Report a note at the begining of stimulus process
        report "Stimulus process started" severity note;
    BTN_s <= "000000000000"; wait for 100 ns;
        BTN_s <= "000000100000"; wait for 100 ns;
    BTN_s <= "000000000000"; wait for 10 ns;
        BTN_s <= "000001000000"; wait for 100 ns;
   BTN_s <= "000000000000"; wait for 10 ns;
        BTN_s <= "000010000000"; wait for 100 ns; 
    BTN_s <= "000000000000"; wait for 10 ns;
        BTN_s <= "000000000100"; wait for 100 ns;
    BTN_s <= "000000000000"; wait for 10 ns;
        BTN_s <= "100000000000"; wait for 100 ns;
       
    BTN_s <= "000000000000"; wait for 300 ns;
  --------------------------------------------------------------------      
        BTN_s <= "000001000000"; wait for 100 ns;
BTN_s <= "000000000000"; wait for 10 ns;        
        BTN_s <= "000000001000"; wait for 100 ns;
BTN_s <= "000000000000"; wait for 10 ns;        
        BTN_s <= "000100000000"; wait for 100 ns;
BTN_s <= "000000000000"; wait for 100 ns;        
        BTN_s <= "000000001000"; wait for 100 ns;
BTN_s <= "000000000000"; wait for 10 ns;        
        BTN_s <= "100000000000"; wait for 100 ns;
     
BTN_s <= "000000000000"; wait for 300 ns;
---------------------------------------------------------- 
        BTN_s <= "000000100000"; wait for 100 ns;
BTN_s <= "000000000000"; wait for 10 ns;       
        BTN_s <= "000001000000"; wait for 100 ns;
 BTN_s <= "000000000000"; wait for 10 ns;       
        BTN_s <= "000010000000"; wait for 100 ns; 
BTN_s <= "000000000000"; wait for 10 ns;
        BTN_s <= "000000000100"; wait for 100 ns;
BTN_s <= "000000000000"; wait for 10 ns;        
        BTN_s <= "010000000000"; wait for 100 ns;
       
BTN_s <= "000000000000"; wait for 100 ns;
  --------------------------------------------------------------------   


        -- Report a note at the end of stimulus process
        report "Stimulus process finished" severity note;
        wait;
    end process p_stimulus;

end Behavioral;


