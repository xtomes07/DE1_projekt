library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    Port ( 
           CLK100MHZ : in  STD_LOGIC;
           BTNC      : in  STD_LOGIC;
           BTN        : in  STD_LOGIC_VECTOR (12 - 1 downto 0);
           CA        : out STD_LOGIC;
           CB        : out STD_LOGIC;
           CC        : out STD_LOGIC;
           CD        : out STD_LOGIC;
           CE        : out STD_LOGIC;
           CF        : out STD_LOGIC;
           CG        : out STD_LOGIC;
           DP        : out STD_LOGIC;
           AN        : out STD_LOGIC_VECTOR (4 - 1 downto 0);
           led0_b    : out STD_LOGIC;
           led0_g    : out STD_LOGIC;
           led0_r    : out STD_LOGIC;
           door_lock     : out STD_LOGIC
           );
end top;

architecture Behavioral of top is
    -- No internal signals
begin

    --------------------------------------------------------------------
    -- Instance (copy) of driver_7seg_4digits entity
    Door : entity work.Door_lock_system
        port map(
            reset      => BTNC,
            clk_disp   => CLK100MHZ,
            
            BTN(0)  => BTN(0),        --0    --vstupni klavesnice
            BTN(1)  => BTN(1),
            BTN(2)  => BTN(2),
            BTN(3)  => BTN(3),
            BTN(4)  => BTN(4),
            BTN(5)  => BTN(5),
            BTN(6)  => BTN(6),
            BTN(7)  => BTN(7),
            BTN(8)  => BTN(8),
            BTN(9)  => BTN(9),        --9
            BTN(10) => BTN(10),      --cancel
            BTN(11) => BTN(11),      --enter
            dp_i => "1111",         --decimal point

            
            seg_o(6) => CA,             --display segment
            seg_o(5) => CB,
            seg_o(4) => CC,
            seg_o(3) => CD,
            seg_o(2) => CE,
            seg_o(1) => CF,
            seg_o(0) => CG,
            dig_o => AN(4-1 downto 0),  --changing display
            
            RGB_led(0)  => led0_b,
            RGB_led(1)  => led0_g,
            RGB_led(2)  => led0_r,
            
            door       => door_lock
        );


end architecture Behavioral;