# Zámek dveří otevíraný heslem z 4x3 klávesnice

### Členové týmu
Ondřej Smola (217628), Jiří Tomešek (220785), Ivo Točený (222683), Jiří Vahalík (220490)

[Odkaz na naši GitHub složku projektu]( https://github.com/xtomes07/DE1_projekt)

### Cíl projektu

Tento projekt si klade za cíl především implementovat systém zámku dveří pomocí programovacího jazyka VHDL. Zadávání hodnot PINu bude realizováno pomocí 4x3 klávesnice, zadaný 
PIN se pak bude zobrazovat na čtyřech sedmi segmentových displejích. Pro pomocnou signalizaci, zda byl zadán správný PIN, je přidána RGB LED dioda, která bude měnit barvy na 
základě správnosti PINu. V případě správného PIN-kódu bude svítit zelenou barvou, při špatném červenou a v aktivním stavu bude svítit žlutě. Uživatel bude mít na zadaní pinu jen 
omezený čas a kdyby uživatel zadávání pinu přerušil a nevrátil se k zadávání, tak se po čase zadaný PIN resetuje, aby nemohl být zneužit. Zámek po zadání správného PINu je 
oděmčený po určitou dobu a uživatel bude muset v tomto okamžiku otevřít dveře. Po uplynutí doby se dveře zase zamknou a uživatel musí znovu zadat správný PIN.

## Popis hardwaru
- Arty A7-100T
- Externi ovládací panel s klávesnicí a displejem:

Pro tento případ by bylo vhodné zhotovit desku (externí ovládací panel), která by obsahovala 4x Pmod konektory, pomocí kterých by byla propojena s Arty A7. Na této desce by byla 
4x3 klávesnice s čísly 0-9 a tlačítky Enter a Cancel pro zadávání PINu. Dále 4 sedmisegmentové displeje pro zobrazení zadávaných čísel, tyto segmentové displeje by měly 
charakter LOW a kvůli ušetření pinů na 4 Pmod konektorech, by byly připojeny přes PNP tranzistory, které by je v cyklu aktivovaly a poté zas deaktivovaly a to v takové 
rychlosti, aby to lidské oko nepostřehlo, že je vždy aktivní jen jeden sedmisegmentový diplej. Dále by na desce bylo NC relé(normally close), které by pak dále ovládalo 
samotný zámek dveří. Kvůli bezpečnosti bude zámek v normálovém stavu zamčený a na jeho vstupu bude 0, kdyby to bylo naopak, tak třeba při výpadku elektřiny by se na zámku 
objevila 0 a zámek by se odemknul a to je nežádoucí.

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
kterém systém setrvává v době, kdy se uživatel nesnaží odemknout dveře. Jsou zde také čítače, čítač s_clk_cnt se spouští, když se začne zadávat PIN a omezuje dobu, po kterou 
uživatel můsí zvládnout zadat PIN. Když se uživateli nepodaří zadat PIN včas, čítač vynuluje paměť a vrátí se do čekacího stavu. Další čítač s_cnt_eval se spouští ve 
vyhodnocovacím stavu a slouží k tomu, že dveře zůstanou odemklé po námi zvolenou dobu a poté se zase zamknou. P_outputs slouží pro ovládání zámku a barvy led-diody.

[Odkaz na vhdl kód modulu driver_7seg_4digits]( https://github.com/xtomes07/DE1_projekt/blob/main/Projekt/Projekt.srcs/sources_1/new/river_7seg_4digits.vhd)

[Odkaz na vhdl kód modulu clock_enable]( https://github.com/xtomes07/DE1_projekt/blob/main/Projekt/Projekt.srcs/sources_1/new/clock_enable.vhd)

[Odkaz na vhdl kód modulu cnt_up_down]( https://github.com/xtomes07/DE1_projekt/blob/main/Projekt/Projekt.srcs/sources_1/new/cnt_up_down.vhd)

[Odkaz na vhdl kód modulu hex_7seg]( https://github.com/xtomes07/DE1_projekt/blob/main/Projekt/Projekt.srcs/sources_1/new/hex_7seg.vhd)

[Odkaz na vhdl kód modulu Door_lock_system]( https://github.com/xtomes07/DE1_projekt/blob/main/Projekt/Projekt.srcs/sources_1/new/Door_lock_system.vhd)

### Simulace modulu Door_lock system:
![Simulace]( https://github.com/xtomes07/DE1_projekt/blob/main/doorlock_modul.PNG)

V simulaci modulu můžeme vidět s_clk_10HZ_displ, pomocí kterého probíhá synchronizace. BTN vektor(11:0), který reprezentuje tlačítka na klávesnici. Pomocí present_state a 
next_state se řídí case pro ukládání hodnot a case pro stavy. Signály s_pass, s_fail jsou pomocné signály, pomocí kterých se dále vyhodnocuje jakou barvou má mít LED-dioda a 
jestli se odemkne zámek dveří. Do data_převod se nám převádí aktuální hodnoty z klávesnice a tyto hodnoty se dále ukládají do pamětí data0_i až data3_i, podle toho v jakém stavu 
se program nachazí a dále se posílají do displeje. S_set slouží k zaznamenání toho, že tlačítko bylo načteno, aby nedocházelo k opakovanému načítaní jednoho a toho samého 
tlačítka. Vektor seg_o zobrazuje segmenty sedmisegmentového displeje. Z počátku je ve všech segmentovkách nastavena hodnota "1111", aby jim nesvítil žádný segment. Při zadávaní 
se k daným segmentovkám dostávají data, kterou číslici mají zobrazit, takže při zadávání PINu se postupě všechny 4 sedmisegmentovky rozsvěcují na základe s_dig. S_clk_cnt je 
čítač pro časové okno zadávání PINu a s_cnt_eval je čítač pro časové okno vyhodnocovacího stavu eval_state, který podrží odemčený zámek po zadefinovaný čas. RGB_led je vektor, 
ve kterém je zapsaná hodnota pro barvu diody. Simulovaly jsme stavy: Uspěšné zadání PINu, vypršení časové relace pro zadání pinu, zrušení zadávání PINu, špatně zadaný PIN a 
předčastné vyhodnocení pinu, když nejsou zadány všechny 4 hodnoty.

## Popis TOP modulu a jejich simulace

TOP modul pracuje se vstupy CLK100MHZ, BTNC a se vstupy z 4x3 klávesnice. Modul Door_lock_sytem je hlavním modulem TOPu a v něm se nachází i ostatní použité moduly. TOP modul je 
připojen na výstupy sedmisegmentovek (výstupy CA:CG(7:0)) katod segmentů, DP desetinné tečky a AN(3:0) zapojení 4 sedmi segmentovek), výstup RGB led (LED(3:0)) a samotný zámek 
Lock.

[Odkaz na vhdl kód top modulu]( https://github.com/xtomes07/DE1_projekt/blob/main/Projekt/Projekt.srcs/sources_1/new/top.vhd)

Schéma TOP modulu:
![Schema](https://github.com/xtomes07/DE1_projekt/blob/main/top_schema.png)

Simulace top modulu:
![Simulace]( https://github.com/xtomes07/DE1_projekt/blob/main/top_simulace.PNG)
V simulaci jsou odsimulované stavy : Uspěšné zadání PINu, vypršení časové relace pro zadání pinu, zrušení zadávání PINu, špatně zadaný PIN a předčasné vyhodnocení 
pinu, když nejsou zadány všechny 4 hodnoty. Led0_r, led0_g, led0_b ovládají barvu RGB LED diody, AN udává jednu aktivní sedmisegmentovku ze čtyř, CA až CG jsou segmenty daných 
segmentovek a door_lock ovládá NC relé, které je připojeno k zámku.

## Stavový diagram

Stavový diagram obsahuje 6 stavů. Prvním je wait_state, ve kterém program čeká na instrukce, když se nezadává PIN. V případě zmáčknutí jakékoli číslice se program posune do 
stavu SetValue1 a tak dále přes stav SetValue2-4 až do vyhodnocovacího stavu eval_state. Pokud se při zadávání číslic omylem či úmyslně zmáčkne Cancel (BTN ="010000000000"), 
program se vrátí do wait_state. Dále se tak děje pokud signál s_clk_cnt překročí konstantu c_TIMEOUT, která definuje časové okno pro zadávaní jednoho pokusu PINu. Zmáčknutím 
klávesy Enter (BTN ="100000000000") při zadávání kódu, ať už v jakémkoli setValue stavu, program začne vyhodnocovat správnost hesla. Po vyhodnocení, úspěšném či neúspěšném, se 
program vrací do stavu wait_state.

![Stavový diagram]( https://github.com/xtomes07/DE1_projekt/blob/main/state_diagram.png)

## Video

Odkaz na naši video prezentaci:
[Video](https://youtu.be/mzR9EhjoeD8)

## Diskuse o výsledcích

- Funkčnost zámku nebylo možné ověřit "naživo" z důvodů toho, že nemáme hardware fyzicky u sebe. Avšak z výše uvedených simulací vyplývá, že by zámek měl fungovat.
- Pokusili jsme se navrhnout vlastní desku v softwaru Fritzing, ale to se nám nepovedlo, protože knihovna se součástkama neobsahuje Pmod konektor, který má 6 pinů ve dvou 
řadách (6x2), proto jsme ve schematu pouzili jiny 12 pinový konektor, ale tento konektor by nešel připojit do naší Arty A7-100T, proto je to pouze návrh zapojení, ale není to 
kompletní realizace.
- Při porgramování jsme se setkali i s problémy, které se nám následně podařilo vyřešit. Jeden z větších problému byl, že hlavní proces Door_lock, byl z počátku synchronizován 
s tlačítky na klávesnici a nebylo možné dodělat časovače. Při předělání na synchronizaci pomocí hodinového impulzu, nastal problém s tím ,že když se tlačítko s hodnotou drželo 
delší dobu, tak v tom okamžiku na něm proběhlo víc hodinových impulzů, tak to náš program bral jako další zmáčknutí tlačítka a začal to ukládat do dalších pamětí. To se 
vyřešilo přidáním setovacího signálu, který když je nastupná hrana hodinového signálu a zároveň je zmáčklé některé z tlačítek, nastaví do 1, aby nedošlo k vícenásobnému uložení 
té sáme hodnoty do paměti. 
- Implementace: První nápad implementace byl použít stavový diagram, hlavně kvůli jeho intuitivnímu použití a jeho funkcionalitě, protože ve více částech programu je třeba čekat 
na uživatele a jeho zadané vstupy a na základe toho konat. Na základě toho přemýšlet, jaké stavy by byly vhodné. Další postup byl přemýšlet, jak bude vypadat top modul a 
všechny potřebné hardwarové součásti.
 - Program by mohl obsahovat vylepšení, které by zahrnovalo to, že si uživatel může zvolit svůj vlastní PIN nebo jej změnit. Problém s realizací nastavéní/změny PINu nastal 
kvůli tomu, že je pro tento účel potřebná paměť, ve které bude PIN stále uložený i když bude program vypnutý a po zapnutí si sám bez přítomnosti uživatelského zásahu PIN načte z 
paměti a nevyresetuje se.
- Podařilo se nám vytvořit fukční ovládací prvek pro ovládaní zámku dveří. Otestovali jsme ho na případech, které by v praxi mohli nastat. Na úspěšné zadání pinu, na zrušení 
zadávaní pinu, na zadání nesprávného PINu, na předčasné potvzení PINu, když nebyla zadána všechna 4 čísla a také na vypršení časové relace v průběhu zadávaní. Také nám 
funguje signalizace pomocí RGB led diody a také časovače pro časové okno pro zadávaní PINu a také pro podržení odemknutého zámku.
 
## Zdroje

   1. [VHDL_Door_pin](https://youtu.be/b-DL3LiJrOk)
   2. [Ukoly spacovávané v hodinách Digitalní elektroniky 1](https://github.com/xtomes07/Digital_elektronics_1/tree/main/Labs)
   
