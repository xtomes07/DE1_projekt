# Door lock with 4x3 matrix keyboard

### Team members
Ondřej Smola (217628), Jiří Tomešek (220785), Ivo Točený (222683), Jiří Vahalík (220490)

[Link to our GitHub project folder]( https://github.com/xtomes07/DE1_projekt)

### Project objectives

Vokecání projektu...

## Hardware description

Pro tento případ by bylo vhodné zhotovit desku, která by obsahovala 4x Pmod konektory, pomocí kterých by byla propojena s Arty A7. Na této desce by byla 4x4 klávesnice s čísly 
0-9 a tlačítky Enter a Cancel pro zadávání PINu. Dále 4 sedmisegmentové displeje pro zobrazení zadávaných čísel, tyto segmentové displeje by měly charakter LOW a kvůli ušetření 
pinů na 4 Pmod konektorech, by byly připojeny přes PNP tranzistory, které by je v cyklu aktivovaly a poté zas deaktivovaly a to v takové rychlosti, aby to lidské oko 
nepostřehlo, že je vždy aktivní jen jeden sedmisegmentový diplej. Dále by na desce bylo NC relé(normally close), které by pak dále ovládalo samotný zámek dveří. Schéma zapojení desky by mohlo vypadat následovně:
![Schema]( https://github.com/xtomes07/DE1_projekt/blob/main/Deska_schem.jpg)
Přiřazení k pinům:
![Zapojeni]( https://github.com/xtomes07/DE1_projekt/blob/main/ZAPOJENI.png)
Pmod konektory na desce Arty A7 a jejich piny:
![Piny]( https://github.com/xtomes07/DE1_projekt/blob/main/piny_na_arty.PNG)

## VHDL modules description and simulations

Odkaz na vhdl kód modulu driver_7seg_4digits:
[driver_7seg_4digits]( https://github.com/xtomes07/DE1_projekt/Projekt/Projekt.srcs/sources_1/new/river_7seg_4digits.vhd)

Odkaz na vhdl kód modulu clock_enable:
[clock_enable]( https://github.com/xtomes07/DE1_projekt/Projekt/Projekt.srcs/sources_1/new/clock_enable.vhd)

Odkaz na vhdl kód modulu cnt_up_down:
[cnt_up_down]( https://github.com/xtomes07/DE1_projekt/Projekt/Projekt.srcs/sources_1/new/cnt_up_down.vhd)

Odkaz na vhdl kód modulu hex_7seg:
[cnt_up_down]( https://github.com/xtomes07/DE1_projekt/Projekt/Projekt.srcs/sources_1/new/hex_7seg.vhd)

Odkaz na vhdl kód modulu Door_lock_system:
[cnt_up_down]( https://github.com/xtomes07/DE1_projekt/Projekt/Projekt.srcs/sources_1/new/Door_lock_system.vhd)

Simulace modulu Door_lock system:
![Simulace]( https://github.com/xtomes07/DE1_projekt/blob/main/doorlock_modul.PNG)


## TOP module description and simulations

Schéma TOP modulu:
![Schema](https://github.com/xtomes07/DE1_projekt/blob/main/top_schema.png)


## Video

Odkaz na naši video prezentaci:
![Video]()


## References

   1. Write your text here.
