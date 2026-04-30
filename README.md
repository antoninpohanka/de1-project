# Projekt: Digitální stopky s funkcí Lap (mezičas)

Tento projekt implementuje digitální stopky na desku Nexys A7-50T v jazyce VHDL. Stopky měří čas s přesností na setiny sekundy do hodnoty `59:59.99` a umožňují zmrazení zobrazení (Lap) bez přerušení měření na pozadí.

# Hlavní funkce
**Start a Stop:** spuštění nebo pozastavení měření času.
**Lap (mezičas):** zmrazení aktuálního času na displeji. Pokud je funkce Lap aktivování, svítí na levém krajním displeji písmeno `L`. Vnitřní čítač stále běží a čítá dále.
**Reset:** Vynulování stopek.

### Ovládání
* `Horní tlačítko`: start/stop
* `Levé tlačítko`: LAP on/off
* `Prostřední tlačítko`: reset

### Barevná signalizace
* `červená`: stopky jsou zastaveny
* `zelená`: stopky normálně běží
* `modrá`: aktivován režim LAP a čítání na pozadí stále běží


---

# Členové týmu
- **Ondrej Kollár**
- **Lukáš Kosek**
- **Antonín Pohanka**

---

# Harmonogram
1. **týden**
  - blokové schéma logiky projektu, vytvoření github stránky
<br>
    
2. **týden**
  - vývoj jednotlivých bloků, simulace v programu Vivado
<br>
    
3. **týden**
  - spojení modulů do finálního celku, první testování programu na hardware
<br>
    
4. **týden**
  - funkční výrobek, optimalizace, debug; github dokumentace
<br>
    
5. **týden**
  - dokončení, prezentační video a plakát funkčního zařízení

---

# Blokové schéma projektu


### Schéma z pohledu stopwatch_top
![de1_2 drawio](images/stopwatch_top.svg)
### Časový diagram pro stopwatch_top
![Time_diagramLogic](images/wave_top1.svg)
<br>
<br>

### Vnitřní logické schéma stopwatch_logic
![Stopwatch_logic](images/stopwatch_logic.svg)
### Časový diagram pro stopwatch_logic
![Time_diagramLogic](images/wave_logic1.svg)
<?xml version="1.0" encoding="UTF-8"?>

---

## Popis vstupů

- `btn_start_stop`: Tlačítko sloužící k zapnutí či pozastavení stopek (počítání času).
- `btn_rst`: Tlačítko sloužící k vyresetování stopek a nastavení času na nulu.
- `btn_lap`: Tlačítko sloužící pro zobrazení času kola. V podstatě zmrazení času na displeji, přičemž na pozadí se čas přičítá dále, pokud se nezastaví. Jakmile se tlačítko zmáčkne znovu, začne se opět zobrazovat běžící čas, který se zatím přičítal "na pozadí".
- `clk`: Hodinový vstup z desky Nexys A7-50T.
- `ce_100hz`: Upravený časový signál sloužící k přičítání času na stopkách.
- `(...)_d`: Ošetřené vstupy blokem debounce.

---

## Popis jednotlivých modulů programu

* [`stopwatch_top.vhd`](https://github.com/antoninpohanka/de1-project/blob/main/stopwatch/stopwatch.srcs/sources_1/new/stopwatch_top.vhd) (_Top-Level_): Propojuje fyzické vstupy z tlačítek s debouncery a rozvádí signály do hlavní logiky a displeje.
* [`clk_en.vhd`](https://github.com/antoninpohanka/de1-project/blob/main/stopwatch/stopwatch.srcs/sources_1/imports/de1/counter/counter.srcs/sources_1/new/clk_en.vhd): Dělič frekvence. Ze 100MHz systémových hodin generuje pulz o frekvenci 100 Hz pro počítání setin sekundy.
* [`debounce.vhd`](https://github.com/antoninpohanka/de1-project/blob/main/stopwatch/stopwatch.srcs/sources_1/imports/de1/debounce/debounce.srcs/sources_1/new/debounce.vhd): Filtr mechanických zákmytů tlačítek. Na výstupu generuje čistý pulz o délce přesně jednoho hodinového taktu.
* [`display_driver.vhd`](https://github.com/antoninpohanka/de1-project/blob/main/stopwatch/stopwatch.srcs/sources_1/new/display_driver.vhd): Zpracovává 32bitový vstupní vektor. Obsahuje rychlý čítač pro multiplexování 8 anod, dekodér z BCD formátu na 7 segmentů (včetně znaku `L`) a logiku pro statické zobrazení desetinných teček.

**Submoduly hlavní logiky [`stopwatch_logic.vhd`](https://github.com/antoninpohanka/de1-project/blob/main/stopwatch/stopwatch.srcs/sources_1/new/stopwatch_logic.vhd):**
Tento modul slouží jako black box pro 4 menší logické bloky, které řídí běh stopek:
1. [`start_stop_latch.vhd`](https://github.com/antoninpohanka/de1-project/blob/main/stopwatch/stopwatch.srcs/sources_1/new/start_stop_latch.vhd): Klopný obvod uchovávající informaci, zda stopky aktuálně běží nebo jsou pozastaveny.
2. [`stopwatch_counter.vhd`](https://github.com/antoninpohanka/de1-project/blob/main/stopwatch/stopwatch.srcs/sources_1/new/stopwatch_counter.vhd): Samotný kaskádový BCD čítač. Počítá setiny, sekundy a minuty na základě 100Hz pulzu.
3. [`lap_run_latch.vhd`](https://github.com/antoninpohanka/de1-project/blob/main/stopwatch/stopwatch.srcs/sources_1/new/lap_run_latch.vhd): Řadič režimu Lap. Přepíná, zda se na displej posílá běžící čas, nebo zmrazený čas. Současně dává signál pro zobrazení písmene `L`.
4. [`lap_register.vhd`](https://github.com/antoninpohanka/de1-project/blob/main/stopwatch/stopwatch.srcs/sources_1/new/lap_register.vhd): Paměťový registr. Dokud není aktivní režim Lap, přepisuje se aktuálním časem. Jakmile se Lap aktivuje, hodnota v něm "zamrzne".

---

## Simulace

### [`stopwatch_top`](https://github.com/antoninpohanka/de1-project/blob/main/stopwatch/stopwatch.srcs/sim_1/new/tb_stopwatch_top.vhd)

<img width="1888" height="602" alt="tb_stopwatch_top" src="https://github.com/user-attachments/assets/2b6f7486-606c-469d-892c-58d02b553690" />

**Popis simulace:**
1. Počáteční reset vynuluje všechny registry.
2. Stisk `btn_start_stop` spustí hlavní čítač, čas začíná plynule narůstat (viditelné na signálu `sig_time_24b`).
3. Opětovný stisk `btn_start_stop` pozastaví čítání i zobrazování na displeji.
4. Stisk `btn_lap` aktivuje režim mezičasu. Na výstupu pro displej se čas zastaví na hodnotě `000104` (viditelné na `sig_lap_24b`), ale vnitřní čítač běží dál.
5. Následující stisk `btn_lap` vrátí na displej opět aktuálně běžící čas.
6. Stisk `btn_start_stop` stopky zcela zastaví.


### [`display_driver`](https://github.com/antoninpohanka/de1-project/blob/main/stopwatch/stopwatch.srcs/sim_1/new/tb_display_driver.vhd)

<img width="1811" height="745" alt="tb_display_driver" src="https://github.com/user-attachments/assets/a699b6fa-bd5c-4a41-b97e-597eeb4f2abf" />

**Popis simulace**

Testbench ukazuje funkčnost multiplexování a dekódování dat pro 7segmentový displej. V první části simulace je na vstup přivedena hodnota pro mezičas. Anodový signál `an_o` cyklicky vybírá jednotlivé pozice displeje, zatímco katodový signál `seg_o` generuje přislušné znaky.

### [`lap_register`](https://github.com/antoninpohanka/de1-project/blob/main/stopwatch/stopwatch.srcs/sim_1/new/tb_lap_register.vhd)

<img width="1340" height="460" alt="tb_lap_register" src="https://github.com/user-attachments/assets/db4ce318-1ed8-4b94-9467-47797d2ceed5" />

**Popis simulace**

Ověřuje schopnost paměťového registru uchovat hodnotu mezičasu. V normálním režimu výstupní signál `lap_24b` plynule kopíruje rostoucí vstupní čas. Jakmile je aktivován režim Lap, hodnota v registru se zmrazí.

### [`lap_run_latch`](https://github.com/antoninpohanka/de1-project/blob/main/stopwatch/stopwatch.srcs/sim_1/new/tb_lap_run_latch.vhd)

<img width="1116" height="493" alt="tb_lap_run_latch" src="https://github.com/user-attachments/assets/cb615d32-2600-422e-be23-2822303f1c3d" />

**Popis simulace**

Ukazuje funkci multiplexoru a paměťového obvodu pro přepínání datových cest. Pro přehlednost jsou v této simulaci na vstup přivedeny pro běžící čas samé jedničky a pro zmrazený samé devítky. Po příchodu ošetřeného pulzu `btn_lap_d` obvod změní stav a aktivuje `lap_mode_flag`. Sběrnice `stream_24b` se na základě toho přepne na zobrazení mezičasu.


### [`start_stop_latch`](https://github.com/antoninpohanka/de1-project/blob/main/stopwatch/stopwatch.srcs/sim_1/new/tb_start_stop_latch.vhd)

<img width="1167" height="353" alt="tb_start_stop_latch" src="https://github.com/user-attachments/assets/8e2ffcd8-2531-4ba2-a585-77670c1cef1b" />

**Popis simulace**

Potvrzuje správnou funkci hlavního řídícího obvodu stopek. Po úvodním resetu je výstupní signál `run_enable` v logické 0 (nepočítá se). Každý přicházející pulz z tlačítka `btn_start_stop_d` invertuje stav tohoto výstupu.


### [`stopwatch_counter`](https://github.com/antoninpohanka/de1-project/blob/main/stopwatch/stopwatch.srcs/sim_1/new/tb_stopwatch_counter.vhd)

<img width="2073" height="1295" alt="tb_stopwatch_counter" src="https://github.com/user-attachments/assets/a27dc3b2-23fe-413a-a308-88895bc6e36f" />

**Popis simulace**

Graf glavní počítací jednotky BCD čítače. Po aktivaci signálu `run_enable` čas na výstupní sběrnici plynule narůstá. Jakmile signál `run_enable` klesne do 0, čítač přestane reagovat na hodinové pulzy a drží si napočítanou hodnotu.

