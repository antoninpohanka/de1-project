# Projekt: Digitální stopky s funkcí Lap (mezičas)

Tento projekt implementuje digitální stopky na desku Nexys A7-50T v jazyce VHDL. Stopky měří čas s přesností na setiny sekundy a umožňují zmrazení zobrazení (Lap) bez přerušení měření na pozadí.

# Členové týmu
- **Ondrej Kollár**
- **Lukáš Kosek**
- **Antonín Pohanka**

# Harmonogram
1. **týden**
  - blokové schéma logiky projektu, vytvoření github stránky
    
2. **týden**
  - vývoj jednotlivých bloků, simulace v programu Vivado
    
3. **týden**
  - spojení modulů do finálního celku, první testování programu na hardware
    
4. **týden**
  - funkční výrobek, optimalizace, debug; github dokumentace
    
5. **týden**
  - dokončení, prezentační video a plakát funkčního zařízení

# Blokové schéma projektu

![de1_2 drawio](stopwatch_top.png)
![Stopwatch_logic](stopwatch_logic.png)
<?xml version="1.0" encoding="UTF-8"?>

# Popis vstupů

- `btn_start_stop`: Tlačítko sloužící k zapnutí či pozastavení stopek (počítání času).
- `btn_rst`: Tlačítko sloužící k vyresetování stopek a nastavení času na nulu.
- `btn_lap`: Tlačítko sloužící pro zobrazení času kola. V podstatě zmrazení času na displeji, přičemž na pozadí se čas přičítá dále, pokud se nezastaví. Jakmile se tlačítko zmáčkne znovu, začne se opět zobrazovat běžící čas, který se zatím přičítal "na pozadí".
- `clk`: Hodinový vstup z desky Nexys A7-50T.
- `ce_100hz`: Upravený časový signál sloužící k přičítání času na stopkách.
- `(...)_d`: Ošetřené vstupy blokem debounce.
