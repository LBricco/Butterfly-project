#include <iostream>
#include <fstream>    // per file processing
#include <sstream>    // per trattare le stringhe come stream di dati
#include <filesystem> // per verificare l'esistenza dei file
#include <cstdlib>    // per usare comandi shell
#include <string>     // per manipolazione stringhe
#include <cstring>    // per manipolazione stringhe C-like
#include <vector>     // per manipolazione vettori
#include <cmath>      // per funzioni matematiche
#include <iomanip>    // per formattazione I/O

#include "Tools.hpp"
#include "Simulation.hpp"

using namespace std;

int main(int argc, char **argv)
{

    int ret = 0;          // variabile per il return
    Simulation Simulator; // oggetto della classe Simulation per l'automatizzazione della simulazione

    /**********************************************************************************/
    /******** Inizializzazione degli oggetti necessari alla gestione dei file *********/

    const string tbFileName = "tb_butterfly.vhd"; // testbench
    const string compileFileName = "compile.do";  // file con le info per la simulazione

    /**********************************************************************************/

    // check esistenza testbench
    if (!filesystem::exists(tbFileName))
    {
        cerr << "Errore! La testbench " << tbFileName << " non esiste." << endl;
        ret = 1;
    }

    // check esistenza file per la compilazione
    if (!filesystem::exists(compileFileName))
    {
        cerr << "Errore! Il file per la compilazione " << compileFileName << " non esiste." << endl;
        ret = 1;
    }

    // simulazione automatizzata
    for (int i = 0; i < 15; i++)
    {
        cout << endl
             << "*********************************************************************" << endl;
        cout << "Inizio Iterazione " << i + 1 << endl
             << endl;
        Simulator.changeTB(i, tbFileName);
        Simulator.run(compileFileName);
        cout << endl
             << "Fine Iterazione " << i + 1 << endl;
        cout << "*********************************************************************" << endl
             << endl;
    }

    // ripristino della testbench di partenza
    Simulator.restoreTB(tbFileName);

    // confronto TB e MATLAB
    int w; // twiddle factor
    int l; // livello
    string matlab;
    string testbench;
    int simulazioni_corrette = 0;
    for (w = 0; w < 8; w++)
    {
        if (w == 0)
        {
            for (l = 1; l <= 4; l++)
            {
                matlab = "risultati_L" + to_string(l) + "_W" + to_string(w) + "_matlab.txt";
                testbench = "risultati_L" + to_string(l) + "_W" + to_string(w) + "_tb.txt";
                if (Simulator.report(testbench, matlab))
                    simulazioni_corrette++;
            }
        }
        else if (w == 4)
        {
            for (l = 2; l <= 4; l++)
            {
                matlab = "risultati_L" + to_string(l) + "_W" + to_string(w) + "_matlab.txt";
                testbench = "risultati_L" + to_string(l) + "_W" + to_string(w) + "_tb.txt";
                if (Simulator.report(testbench, matlab))
                    simulazioni_corrette++;
            }
        }
        else if (w == 2 || w == 6)
        {
            for (l = 3; l <= 4; l++)
            {
                matlab = "risultati_L" + to_string(l) + "_W" + to_string(w) + "_matlab.txt";
                testbench = "risultati_L" + to_string(l) + "_W" + to_string(w) + "_tb.txt";
                if (Simulator.report(testbench, matlab))
                    simulazioni_corrette++;
            }
        }
        else
        {
            l = 4;
            matlab = "risultati_L" + to_string(l) + "_W" + to_string(w) + "_matlab.txt";
            testbench = "risultati_L" + to_string(l) + "_W" + to_string(w) + "_tb.txt";
            if (Simulator.report(testbench, matlab))
                simulazioni_corrette++;
        }
    }

    if (simulazioni_corrette == 15)
    {
        cout << endl
             << "OK! Tutte le simulazioni Modelsim hanno prodotto gli stessi risultati previsti da MATLAB." << endl;
        cout << "Verosimilmente il processore Butterfly funziona! :)" << endl
             << endl;
    }
    else
    {
        cout << endl
             << "Non tutte le simulazioni Modelsim hanno prodotto gli stessi risultati previsti da MATLAB." << endl;
        cout << "Il processore Butterfly non funziona. :(" << endl
             << endl;
    }

    return ret; // punto di uscita dal programma
}