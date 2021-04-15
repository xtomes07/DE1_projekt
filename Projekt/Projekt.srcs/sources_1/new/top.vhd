library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    Port ( 
           CLK100MHZ : in  STD_LOGIC;
           BTNC      : in  STD_LOGIC;
           SW        : in  STD_LOGIC_VECTOR (16 - 1 downto 0);
           CA        : out STD_LOGIC;
           CB        : out STD_LOGIC;
           CC        : out STD_LOGIC;
           CD        : out STD_LOGIC;
           CE        : out STD_LOGIC;
           CF        : out STD_LOGIC;
           CG        : out STD_LOGIC;
           DP        : out STD_LOGIC;
           AN        : out STD_LOGIC_VECTOR (8 - 1 downto 0);
           led0_b    : out STD_LOGIC;
           led0_g    : out STD_LOGIC;
           led0_r    : out STD_LOGIC;
           zamek     : out STD_LOGIC
           );
end top;

architecture Behavioral of top is
    -- No internal signals
begin

    --------------------------------------------------------------------
    -- Instance (copy) of driver_7seg_4digits entity
    Door : entity work.Door_lock_system
        port map(
            clk        => CLK100MHZ,
            reset      => BTNC,
            clk_disp   => CLK100MHZ,
            
            BTN(0) => SW(0),        --0    --vstupni klavesnice
            BTN(1) => SW(1),
            BTN(2) => SW(2),
            BTN(3) => SW(3),
            BTN(4) => SW(4),
            BTN(5) => SW(5),
            BTN(6) => SW(6),
            BTN(7) => SW(7),
            BTN(8) => SW(8),
            BTN(9) => SW(9),        --9
            BTN(10) => SW(10),      --cancel
            BTN(11) => SW(11),      --enter
            dp_i => "1111",

            
            seg_o(6) => CA,             --segmenty displeju
            seg_o(5) => CB,
            seg_o(4) => CC,
            seg_o(3) => CD,
            seg_o(2) => CE,
            seg_o(1) => CF,
            seg_o(0) => CG,
            dig_o => AN(4-1 downto 0),  --prepinani displeju
            
            RGB_led(0)  => led0_b,
            RGB_led(1)  => led0_g,
            RGB_led(2)  => led0_r,
            
            dvere       => zamek
        );


end architecture Behavioral;