library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Door_lock_system is
    Port (
        dp_i    : in  std_logic_vector(4 - 1 downto 0);
        -- Decimal point for specific digit
        dp_o    : out std_logic;
        -- Cathode values for individual segments
        seg_o   : out std_logic_vector(7 - 1 downto 0);
        -- Common anode signals to individual displays
        dig_o   : out std_logic_vector(4 - 1 downto 0);
        reset   : in  std_logic; 
        clk_disp: in  std_logic;
        -----------------------------------------------------------
        
        clk     : in  std_logic;
        BTN     : in std_logic_vector(12-1 downto 0);
        ---outputs
        dvere    : out std_logic;
        
        RGB_led : out std_logic_vector(3-1 downto 0)
        
     );
end Door_lock_system;

architecture Behavioral of Door_lock_system is
    -- Define the states
    type state_type is (eval,s0,s1,s2,s3,s4);
    signal present_state, next_state: state_type;
    
     -- Internal clock enable
    signal s_en  : std_logic;
    -- Internal 2-bit counter for multiplexing 4 digits
    signal s_cnt : std_logic_vector(2 - 1 downto 0);
    -- Internal 4-bit value for 7-segment decoder
    signal s_hex : std_logic_vector(4 - 1 downto 0);
    
    -- Specific values for local counter
    --do dat 0-3 se ukladaji hodnoty tlacite pro 7 seg a data prevod slouzi pro prevod z 
       signal data_prevod :   std_logic_vector(4 - 1 downto 0);
       signal data0_i     :   std_logic_vector(4 - 1 downto 0);
       signal data1_i     :   std_logic_vector(4 - 1 downto 0);
       signal data2_i     :   std_logic_vector(4 - 1 downto 0);
       signal data3_i     :   std_logic_vector(4 - 1 downto 0);
        --signaly pro vystupy
       signal s_pass      :   std_logic;
       signal s_fail      :   std_logic;
       -- Local delay counter                     
       signal   s_cnt_2     : unsigned(5 - 1 downto 0);--citac k casovaci door lock
       --zadefinovane barvypro led
       constant c_RED     : std_logic_vector(3 - 1 downto 0) := b"100";
       constant c_YELLOW  : std_logic_vector(3 - 1 downto 0) := b"110";
       constant c_GREEN   : std_logic_vector(3 - 1 downto 0) := b"010";
       --casovac
       constant c_DELAY   : unsigned(5 - 1 downto 0) := b"0_1000";      
       constant c_ZERO    : unsigned(5 - 1 downto 0) := b"0_0000";      
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
        

 
door_lock : process(BTN)      --pin je 5672 hlavni proces
begin
                         
        case next_state is
            when s0 =>
                
                present_state<=s0;
                s_pass <= '0';
                s_fail <= '0';
                if BTN = "010000000000" then
                next_state <= s0;
                else                                    --5
                next_state <= s1;
                end if;
                
            when s1 =>   
                present_state<=s1;                         --6
                if BTN = "010000000000" then
                next_state <= s0;
                else
                next_state <= s2;
                
                end if;
           when s2 =>
                present_state<=s2;                               --7
                if BTN = "010000000000" then
                next_state <= s0;
                else
                next_state <= s3;   
                end if;
           when s3 =>
                present_state<=s3;                              --2
                if BTN = "010000000000" then
                next_state <= s0;
                else
                next_state <= s4;           
                end if;
          when s4 =>
                present_state<=s4;
                next_state <= eval;
         when eval =>
                if (data3_i = "0101" and data2_i = "0110" and data1_i = "0111" and data0_i = "0010") then
                s_pass <= '1';
                next_state <= s0;
                else
                s_fail <= '1';
                next_state <= s0;
                end if; 
         end case; 
           
      
end process;

p_prevod_12btn_to_4digit : process(BTN) --tlacitko se prevede na hodnotu pro 7segmentovku
    begin
        case BTN is
            when "000000000000" =>          -- PRAZDNO NEBUDE ZADNE ZOBRAZENE CISLO
                data_prevod <= "1111"; 
            when "000000000001" =>
                data_prevod <= "0000";      -- 0
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
    
    p_ukladani : process(clk_disp) --ukladani tlacitka 
    begin
        case present_state is
            when s0 =>  
                data0_i <= "1111";
                data1_i <= "1111";
                data2_i <= "1111";
                data3_i <= "1111";
            when s1 =>
                data3_i <= data_prevod;      
            when s2 =>
                data2_i <= data_prevod;      
            when s3 =>
                data1_i <= data_prevod;      
            when s4 =>
                data0_i <= data_prevod;     
            when eval =>

        end case;
    end process ;
  
 p_vystupy : process(clk_disp) --ovladani RGB_ledky
    begin
        if (s_pass = '1') then
            RGB_led <= c_GREEN;
            dvere <= '1';
        elsif (s_pass = '0' and s_fail = '0')then
            RGB_led <= c_YELLOW;
            dvere <= '0';
        else
            RGB_led <= c_RED;
            dvere <= '0';
        end if;
    end process ;
    

   
end Behavioral;
