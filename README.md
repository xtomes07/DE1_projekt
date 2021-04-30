# Door lock with 4x3 matrix keyboard

### Team members
Ondřej Smola (217628), Jiří Tomešek (220785), Ivo Točený (222683), Jiří Vahalík (220490)

[Link to our GitHub project folder]( https://github.com/xtomes07/DE1_projekt)

### Project objectives

Tento projekt si klade za cíl především implementovat systém zámku dveří pomocí programovacího jazyka VHDL. Zadávání hodnot PINu bude realizováno pomocí 4x4 klávesnice, zadaný 
PIN se pak bude zobrazovat na čtyřech sedmi segmentových displejích. Pro pomocnou signalizaci, jestli byl zadán správný PIN je přidána RGB LED dioda, která bude měnit barvy na 
základě správnosti PINu. V případě správného PIN-kódu bude svítit zelenou barvou, při špatném červenou a v aktivním stavu bude svítit žlutě. Uživatel bude mít na zadaní pinu jen 
omezený čas a kdyby uživatel zadávání pinu přerušil a nevrátil se k zadávání, tak se po čase zadaný PIN resetuje, 
aby nemohl být zneužit.

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
Pro ovládání displejů byly použity moduly, které jsme vytvářeli v hodinách DE1(Driver 7seg 4digits, clock enable, cnt up down, hex 7seg). Dále jsme vytvoři vlastní modul 
Door_lock_system, který obsahuje proces na setování tlačítek z klávesnice do pamětí data0_i až data3_i. Dále obsahuje proces, který nám převadí 12bitový vektor BTN, který 
interpretuje tlačítka z klávesnice na 4 bitovou hodnotu, která se poté využívá k zobrazení PINu na displej a vyhodnoceni jestli byl PIN spárvný nebo ne. Hlavní proces je tvořen
6 stavy. 4 stavy jsou pro ukádaní hodnot(setValue_state0-3), jeden vyhodnocovací (eval_state) a čekací stav(wait_state),ve kterém systém setrvává v době, když se uživatel 
nesnaží odemknout dveře. Jsou zde také čítače, čítač c_Door
[Odkaz na vhdl kód modulu driver_7seg_4digits]( https://github.com/xtomes07/DE1_projekt/blob/main/Projekt/Projekt.srcs/sources_1/new/river_7seg_4digits.vhd)

[Odkaz na vhdl kód modulu clock_enable]( https://github.com/xtomes07/DE1_projekt/blob/main/Projekt/Projekt.srcs/sources_1/new/clock_enable.vhd)

[Odkaz na vhdl kód modulu cnt_up_down]( https://github.com/xtomes07/DE1_projekt/blob/main/Projekt/Projekt.srcs/sources_1/new/cnt_up_down.vhd)

[Odkaz na vhdl kód modulu hex_7seg]( https://github.com/xtomes07/DE1_projekt/blob/main/Projekt/Projekt.srcs/sources_1/new/hex_7seg.vhd)

[Odkaz na vhdl kód modulu Door_lock_system]( https://github.com/xtomes07/DE1_projekt/blob/main/Projekt/Projekt.srcs/sources_1/new/Door_lock_system.vhd)

Simulace modulu Door_lock system:
![Simulace]( https://github.com/xtomes07/DE1_projekt/blob/main/doorlock_modul.PNG)


## TOP module description and simulations

Odkaz na vhdl kód top modulu:
[top]( https://github.com/xtomes07/DE1_projekt/Projekt/Projekt.srcs/sources_1/new/top.vhd)

Schéma TOP modulu:
![Schema](https://github.com/xtomes07/DE1_projekt/blob/main/top_schema.png)

Simulace top modulu:
![Simulace]( https://github.com/xtomes07/DE1_projekt/blob/main/top_simulace.PNG)

## State diagram

![Stavový diagram]( https://github.com/xtomes07/DE1_projekt/blob/main/state_diagram.png)

## Video

Odkaz na naši video prezentaci:
![Video]()

## Discussion of results

Vokec...

## References

   1. Write your text here.
