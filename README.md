# Zámek dveří otevíraný na heslo ovládaný 4x3 klávesnicí

### Členové týmu
Ondřej Smola (217628), Jiří Tomešek (220785), Ivo Točený (222683), Jiří Vahalík (220490)

[Odkaz na naši GitHub složku projektu]( https://github.com/xtomes07/DE1_projekt)

### Cíl projektu

Tento projekt si klade za cíl především implementovat systém zámku dveří pomocí programovacího jazyka VHDL. Zadávání hodnot PINu bude realizováno pomocí 4x3 klávesnice, zadaný 
PIN se pak bude zobrazovat na čtyřech sedmi segmentových displejích. Pro pomocnou signalizaci, jestli byl zadán správný PIN, je přidána RGB LED dioda, která bude měnit barvy na 
základě správnosti PINu. V případě správného PIN-kódu bude svítit zelenou barvou, při špatném červenou a v aktivním stavu bude svítit žlutě. Uživatel bude mít na zadaní pinu jen 
omezený čas a kdyby uživatel zadávání pinu přerušil a nevrátil se k zadávání, tak se po čase zadaný PIN resetuje, aby nemohl být zneužit. Zámek po zadání správného PINu je 
oděmčený po určitou dobu a uživatel bude muset v tomto okamžiku otevřít dveře. Po uplynutí doby se dveře zase zamknou a uživatel musí znovu zadat správný PIN.

## Popis hardwaru
- Arty A7-100T
- Externi ovládací panel s klávesnicí a displejem:

Pro tento případ by bylo vhodné zhotovit desku (externí ovládací panel), která by obsahovala 4x Pmod konektory, pomocí kterých by byla propojena s Arty A7. Na této desce by byla 
4x3 klávesnice s čísly 0-9 a tlačítky Enter a Cancel pro zadávání PINu. Dále 4 sedmisegmentové displeje pro zobrazení zadávaných čísel, tyto segmentové displeje by měly 
charakter LOW a kvůli ušetření pinů na 4 Pmod konektorech, by byly připojeny přes PNP tranzistory, které by je v cyklu aktivovaly a poté zas deaktivovaly a to v takové 
rychlosti, aby to lidské oko nepostřehlo, že je vždy aktivní jen jeden sedmisegmentový diplej. Dále by na desce bylo NC relé(normally close), které by pak dále ovládalo samotný 
zámek dveří, kvuli bezpečnosti bude zámek v normálovem stavu zamčeny a na jeho vstupu bude 0, kdyby to bylo naopak, tak třeba při výpadku elektřiny by se na zamku objevila 0 a 
zámek by se odemknul a to je nežádoucí.

Schéma zapojení desky by mohlo vypadat následovně:
![Schema]( https://github.com/xtomes07/DE1_projekt/blob/main/Deska_schem.jpg)
Přiřazení k pinům:
![Zapojeni]( https://github.com/xtomes07/DE1_projekt/blob/main/ZAPOJENI.png)
Pmod konektory na desce Arty A7 a jejich piny:
![Piny]( https://github.com/xtomes07/DE1_projekt/blob/main/piny_na_arty.PNG)

## Popis VHDL modulů a jejich simulace
Pro ovládání displejů byly použity moduly, které jsme vytvářeli v hodinách DE1 (Driver 7seg 4digits, clock enable, cnt up down, hex 7seg). Dále jsme vytvořili vlastní modul 
Door_lock_system, který obsahuje proces p_saveValue na setování tlačítek z klávesnice do pamětí data0_i až data3_i. Dále obsahuje proces p_transfer_12btn_to_4digit, který nám 
převadí 12bitový vektor BTN, který interpretuje tlačítka z klávesnice na 4 bitovou hodnotu, která se poté využívá k zobrazení PINu na displeji a vyhodnocení, jestli byl PIN 
spárvný nebo ne. Hlavní proces door_lock je tvořen 6 stavy. 4 stavy jsou pro ukádaní hodnot(setValue_state1-4), jeden vyhodnocovací (eval_state) a čekací stav(wait_state),ve 
kterém systém setrvává v době, když se uživatel nesnaží odemknout dveře. Jsou zde také čítače, čítač s_clk_cnt se spouští, když se začne zadávat PIN a omezuje dobu, po kterou 
uživatel můsí zvládnout zadat PIN, když se uživali nepodaří zadat včat PIN, čítač vynuluje paměti a vrátí se do čekacího stavu. Další čítač s_cnt_eval se spouští ve 
vyhodnocovacím stavu a slouží k tomu, že dveře zůstanou odemklé po námi zvolenou dobu a poté se zase zamknou. P_outputs slouží pro ovládání zámku a barvy led-diody.

[Odkaz na vhdl kód modulu driver_7seg_4digits]( https://github.com/xtomes07/DE1_projekt/blob/main/Projekt/Projekt.srcs/sources_1/new/river_7seg_4digits.vhd)

[Odkaz na vhdl kód modulu clock_enable]( https://github.com/xtomes07/DE1_projekt/blob/main/Projekt/Projekt.srcs/sources_1/new/clock_enable.vhd)

[Odkaz na vhdl kód modulu cnt_up_down]( https://github.com/xtomes07/DE1_projekt/blob/main/Projekt/Projekt.srcs/sources_1/new/cnt_up_down.vhd)

[Odkaz na vhdl kód modulu hex_7seg]( https://github.com/xtomes07/DE1_projekt/blob/main/Projekt/Projekt.srcs/sources_1/new/hex_7seg.vhd)

[Odkaz na vhdl kód modulu Door_lock_system]( https://github.com/xtomes07/DE1_projekt/blob/main/Projekt/Projekt.srcs/sources_1/new/Door_lock_system.vhd)

Simulace modulu Door_lock system:
![Simulace]( https://github.com/xtomes07/DE1_projekt/blob/main/doorlock_modul.PNG)


## Popis TOP modulu a jejich simulace

TOP modul pracuje se vstupy CLK100MHZ, BTNC a vstupu z 4x3 klávesnice. Modul Door_lock_sytem je hlavním modulem TOPu a v něm se nachází i ostatní použité moduly. TOP modul je 
připojen na výstupy sedmi segmentovek (výstupy CA:CG(7:0)) katod segmentů, DP desetinné tečky a AN(3:0) zapojení 4 sedmi segmentovek), výstup RGB led (LED(3:0)) a samotný zámek 
Lock.

[Odkaz na vhdl kód top modulu]( https://github.com/xtomes07/DE1_projekt/blob/main/Projekt/Projekt.srcs/sources_1/new/top.vhd)

Schéma TOP modulu:
![Schema](https://github.com/xtomes07/DE1_projekt/blob/main/top_schema.png)

Simulace top modulu:
![Simulace]( https://github.com/xtomes07/DE1_projekt/blob/main/top_simulace.PNG)

## Stavový diagram

Stavový diagram obsahuje 6 stavů. Prvním je wait_state, ve kterém program čeká na instrukce a případně se do něj program vrací v případě neúspěchu zadávání kódu. V případě
zmáčknutí jakékoli číslice se program posune do stavu SetValue1 a tak dále přes stav SetValue2-4 až do vyhodonovacího stavu eval_state. Pokud se při zadávání číslic omylem či
úmyslně zmáčkne Cancel (BTN ="010000000000"), program se vrátí do wait_state. Dále se tak děje pokud signál s_clk_cnt překročí konstantu c_TIMEOUT, což je 10s. Zmáčknutím 
klávesy Enter (BTN ="100000000000") při zadávání kódu, ať už v jakémkoli setValue stavu, program začne vyhodnocovat správnost hesla. Po vyhodnocení, úspěšném či neúspěšném, se 
program vrací do wait_state.

![Stavový diagram]( https://github.com/xtomes07/DE1_projekt/blob/main/state_diagram.png)

## Video

Odkaz na naši video prezentaci:
![Video]()

## Diskuze výsledků

Funkčnost zámku nebylo možné ověřit "naživo" z důvodů toho, že nemáme hardware fyzicky u sebe. Avšak z výše uvedených simulací, schémat a kódů vyplývá, že by zámek měl fungovat 
bez sebemenších problémů.

## Zdroje

   1. Write your text here.
