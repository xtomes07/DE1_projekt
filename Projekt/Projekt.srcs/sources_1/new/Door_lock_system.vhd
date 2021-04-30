library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Door_lock_system is
    Port (
        dp_i    : in  std_logic_vector(4 - 1 downto 0);     -- Decimal point for specific digit
        dp_o    : out std_logic;
        seg_o   : out std_logic_vector(7 - 1 downto 0);     -- Cathode values for individual segments
        dig_o   : out std_logic_vector(4 - 1 downto 0);     -- Common anode signals to individual displays
        reset   : in  std_logic; 
        clk_disp: in  std_logic;
        BTN     : in std_logic_vector(12-1 downto 0);       --button from keyboard
        ---outputs
        door    : out std_logic;                            --opening door if set to 1
        RGB_led : out std_logic_vector(3-1 downto 0)        
        
     );
end Door_lock_system;

architecture Behavioral of Door_lock_system is
    -- Define the states
    type state_type is (wait_state,  --reseting/nulling state
                        setValue1,   --states for user inputs for specific pin values
                        setValue2,
                        setValue3,
                        setValue4,
                        eval_state);
    signal present_state, next_state: state_type;
    
     -- Internal clock enable
    signal s_en  : std_logic;
    -- Internal 2-bit counter for multiplexing 4 digits
    signal s_cnt : std_logic_vector(2 - 1 downto 0);
    -- Internal 4-bit value for 7-segment decoder
    signal s_hex : std_logic_vector(4 - 1 downto 0);
    
    --Signals for data storage from buttons
    signal data_prevod :   std_logic_vector(4 - 1 downto 0):= b"1111";
    signal data0_i     :   std_logic_vector(4 - 1 downto 0):= b"1111";
    signal data1_i     :   std_logic_vector(4 - 1 downto 0):= b"1111";
    signal data2_i     :   std_logic_vector(4 - 1 downto 0):= b"1111";
    signal data3_i     :   std_logic_vector(4 - 1 downto 0):= b"1111";
    --auxiliary signals for outputs
    signal s_pass      :   std_logic;
    signal s_fail      :   std_logic;
    signal s_set      :   std_logic := '0';
    -- Local delay counter                     
    signal   s_clk_cnt   : unsigned(12 - 1 downto 0):=b"0000_0000_0000";
    signal   s_cnt_eval   : unsigned(12 - 1 downto 0):=b"0000_0000_0000";
    --Constants for LED-colours
    constant c_RED     : std_logic_vector(3 - 1 downto 0) := b"100";
    constant c_YELLOW  : std_logic_vector(3 - 1 downto 0) := b"110";
    constant c_GREEN   : std_logic_vector(3 - 1 downto 0) := b"010";
    -- Specific values for local counter
    constant c_TIMEOUT  : unsigned(12 - 1 downto 0) := b"0001_0010_1100";   
    constant c_DOORLOCK : unsigned(12 - 1 downto 0) := b"0000_0111_1101";    
    constant c_ZERO     : unsigned(12 - 1 downto 0) := b"0000_0000_0000";
    constant c_DOORFAIL : unsigned(12 - 1 downto 0) := b"0000_0010_0000";     
begin

driver_seg_4 : entity work.driver_7seg_4digits
port map(
data0_i => data0_i,
data1_i => data1_i,
data2_i => data2_i,
data3_i => data3_i,
dp_i    => dp_i   ,
dp_o    => dp_o   ,
seg_o   => seg_o  ,
dig_o   => dig_o  ,
reset   => reset  ,
clk => clk_disp
    
);      
        

 --Main implementation process based on state diagram
door_lock : process(clk_disp)      --Hard set pin : 5672 
begin   
if rising_edge (clk_disp) then
    if present_state /= wait_state then
    s_clk_cnt <= s_clk_cnt + 1;
    end if;

    if s_clk_cnt > C_TIMEOUT then
    s_clk_cnt <= c_ZERO;
    next_state <= eval_state;
    end if;
  -----------------------------------------------  
    if present_state = eval_state then
    s_cnt_eval <= s_cnt_eval + 1;
    end if;
    if s_pass = '1' then
        if s_cnt_eval > c_DOORLOCK then
        next_state <= wait_state;
        end if;
    elsif  s_fail = '1' then
        if s_cnt_eval > c_DOORFAIL then
        next_state <= wait_state;
        end if;
   end if; 
        
        if s_set='0' then  
             case next_state is 
                 when setValue1 =>      
                     present_state<=setValue1;
                     if s_set='0' then
                         if (BTN /="000000000000") and (BTN /="010000000000") and (BTN /="100000000000") then
                             s_set <= '1';
                             next_state<=setValue2;
                         elsif (BTN = "010000000000") then
                             next_state <=wait_state;
                             s_set <= '1';
                         elsif (BTN = "100000000000") then
                             next_state <=eval_state;
                             s_set <= '1';
                         end if;
                     end if;
                 when setValue2 => 
                         present_state<=setValue2;
                         if s_set='0' then
                         if (BTN /="000000000000") and (BTN /="010000000000") and (BTN /="100000000000") then
                             s_set <= '1';
                             next_state<=setValue3;
                         elsif (BTN = "010000000000") then
                             next_state <=wait_state;
                             s_set <= '1';
                         elsif (BTN = "100000000000") then
                             next_state <=eval_state;
                             s_set <= '1';
                         end if;
                  end if;        
                 when setValue3 =>
                 if s_set='0' then 
                         present_state<=setValue3;
                         if (BTN /="000000000000") and (BTN /="010000000000") and (BTN /="100000000000") then
                             s_set <= '1';
                             next_state<=setValue4;
                         elsif (BTN = "010000000000") then
                             next_state <=wait_state;
                             s_set <= '1';
                         elsif (BTN = "100000000000") then
                             next_state <=eval_state;
                             s_set <= '1';                  
                         end if;
                  end if;
                 when setValue4 =>
                 if s_set='0' then 
                         present_state<=setValue4;
                         if (BTN /="000000000000") and (BTN /="010000000000") and (BTN /="100000000000") then
                             s_set <= '1';
                             next_state<=eval_state;
                         elsif (BTN = "010000000000") then
                             next_state <=wait_state;
                             s_set <= '1';
                         elsif (BTN = "100000000000") then
                             next_state <=eval_state;
                             s_set <= '1';
                         end if;
                 end if;
                 when eval_state =>
                 present_state<=eval_state;
                 if s_set='0' then
                     if (BTN ="100000000000") then
                         if (data3_i = "0101" and data2_i = "0110" and data1_i = "0111" and data0_i = "0010") then
                             s_set <= '1';
                             s_pass <= '1';
                         else
                             s_set <= '1';
                             s_fail <= '1';
                         end if;
                     elsif (BTN = "010000000000") then
                         s_set <= '1';
                         s_fail <= '1';
                         s_pass <= '0';
                     elsif (BTN /= "100000000000") and (BTN /= "010000000000")and (BTN /= "000000000000") then
                         s_set <= '1';
                         s_fail <= '1';
                         s_pass <= '0';
                    elsif (data3_i = "1111" or data2_i = "1111" or data1_i = "1111" or data0_i = "1111") then
                         s_set <='1';
                         s_fail <= '1';
                         s_pass <= '0';
                        end if;
                     end if;
                 
                 when wait_state =>
                     s_cnt_eval <= c_ZERO;   
                     s_clk_cnt <= c_ZERO;
                     s_fail <= '0';
                     s_pass <= '0';
                     s_set<= '0';
                     present_state <= wait_state;
                     if (BTN /= "000000000000") and data_prevod /= "1111" then
                     next_state <= setValue1; 
                     end if;           
                end case; 
         elsif BTN = "000000000000" then
              s_set <= '0';        
         end if;      
end if;
end process;


p_transfer_12btn_to_4digit : process(clk_disp, BTN) --button is converted to the value for 7segmet display
begin
    
        case BTN is
            when "000000000000" =>          
               data_prevod <= "1111";       --empty display
            when "000000000001" =>
                data_prevod <= "0000";      --0
            when "000000000010" =>
                data_prevod <= "0001";      --1
            when "000000000100" =>
                data_prevod <= "0010";      --2
            when "000000001000" =>
                data_prevod <= "0011";      --3
            when "000000010000" =>
                data_prevod <= "0100";      --4
            when "000000100000" =>
                data_prevod <= "0101";      --5
            when "000001000000" =>
                data_prevod <= "0110";      --6
            when "000010000000" =>
                data_prevod <= "0111";      --7
            when "000100000000" =>
                data_prevod <= "1000";      --8
            when "001000000000" =>
                data_prevod <= "1001";      --9
            when others =>
        end case;
end process ;
    
p_saveValue : process(clk_disp) -- save value from button to memories
begin
        if rising_edge(clk_disp)  then
            case present_state is
                when setValue1 =>  
                    if BTN /= "000000000000" then
                        data3_i <= data_prevod;
                    end if;
                when setValue2 =>
                    if BTN /= "000000000000" then                       
                        data2_i <= data_prevod;  
                    end if;    
                when setValue3 =>
                    if BTN /= "000000000000" then
                        data1_i <= data_prevod; 
                    end if;   
                when setValue4 =>
                    if BTN /= "000000000000" then
                        data0_i <= data_prevod; 
                    end if;   
                when eval_state =>   
                when wait_state =>
                    data3_i <= "1111";
                    data2_i <= "1111";
                    data1_i <= "1111";
                    data0_i <= "1111";            
            end case;
       end if;
    end process ;

--  LEDs popup and Door unlock/lock
 p_outputs : process(clk_disp) --control outputs         
    begin
        if (s_pass = '1') then          
            RGB_led <= c_GREEN;
            door <= '1';
        elsif (s_pass = '0' and s_fail = '0')then
            RGB_led <= c_YELLOW;
            door <= '0';
        else
            RGB_led <= c_RED;
            door <= '0';
        end if;
    end process ;
    

   
end Behavioral;
