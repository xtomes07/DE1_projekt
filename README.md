# Terminál pro odemčení dveří

### Team members

Jiří Tomešek, Ivo Točený

[Link to GitHub project folder]( https://github.com/xtomes07/DE1_projekt)

### Project objectives

Tento projekt si klade za cíl především implementovat systém zámku dveří pomocí programovacího jazyka VHDL. Zadávání hodnot PINu bude realizováno pomocí 4x4 klávesnice, zadaný 
PIN se pak bude zobrazovat na čtyřech sedmi segmentových displejích. Pro pomocnou signalizaci, jestli byl zadán správný PIN je přidána RGB LED dioda, která bude měnit barvy na 
základě správnosti PINu. Uživatel bude mít na zadaní pinu jen omezený čas a když uživatel zadávání pinu přerušil a nevrátil se k zadávání, tak se po čase zadaný PIN resetuje, 
aby nemohl být zneužit.


## Hardware description

Pro tento případ by bylo vhodné zhotovit desku, která by obsahovala 4x Pmod konektory, pomocí kterých by byla propojena s Arty A7. Na této desce by byla 4x4 klávesnice s čísly 
0-9 a tlačítky Enter a Cancel pro zadávání pinu. Dále 4 sedmisegmentové displeje pro zobrazení zadávaných čísel, tyto segmentové displeje by měly charakter LOW a kvůli ušetření 
pinů na 4 Pmod konektorech, by byly připojeny přes PNP tranzistory, které by je v cyklu aktivovali a poté zas deaktivovali a to v takové rychlosti, aby to lidské oko 
nepostřehlo, že je vždy aktivní jen jeden sedmisegmentový diplej. Dále by na desce bylo relé, které by pak dále ovládalo samotný zámek dveří. Schéma zapojení desky by mohlo 
vypadat následovně:![Schema]( https://github.com/xtomes07/DE1_projekt/blob/main/Deska_schem.jpg)

## VHDL modules description and simulations

Write your text here.


## TOP module description and simulations

Write your text here.


## Video

*Write your text here*


## References

   1. Write your text here.
