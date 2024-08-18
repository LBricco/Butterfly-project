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

// Costruttore esplicito
Simulation::Simulation(unsigned int c)
    : correct{c} {}

/***************************************************************************************
Modifica testbench
In totale ci sono 15 implementazioni:
Implementazioni 0, 1, 3, 7: W = W0
Implementazioni 2, 4, 8: W = W4
Implementazioni 5, 9: W = W2
Implementazioni 6, 10: W = W6
Implementazione 11: W = W1
Implementazione 12: W = W5
Implementazione 13: W = W3
Implementazione 14: W = W7
***************************************************************************************/
void Simulation::changeTB(unsigned int implementazione, string tb)
{
    string tFileName_iniziale;
    string iFileName_iniziale;
    string oFileName_iniziale;
    string tFileName_finale;
    string iFileName_finale;
    string oFileName_finale;

    switch (implementazione)
    {
    case 0: // L1 W0 (non sostituitsco nulla, i nomi dei file sono già corretti)
        break;
    case 1: // L2 W0 (non sostituisco file W, sostituisco file input, sostituisco file output)
        system(("sed -i -e 's/ingressi_L1_W0.txt/ingressi_L2_W0_W4.txt/' " + tb).c_str());
        system(("sed -i -e 's/risultati_L1_W0_tb.txt/risultati_L2_W0_tb.txt/' " + tb).c_str());
        break;
    case 2: // L2 W4 (sostituisco file W, non sostituisco file input, sostituisco file output)
        system(("sed -i -e 's/twiddle_W0.txt/twiddle_W4.txt/' " + tb).c_str());
        system(("sed -i -e 's/risultati_L2_W0_tb.txt/risultati_L2_W4_tb.txt/' " + tb).c_str());
        break;
    case 3: // L3 W0 (sostituisco file W, sostituisco file input, sostituisco file output)
        system(("sed -i -e 's/twiddle_W4.txt/twiddle_W0.txt/' " + tb).c_str());
        system(("sed -i -e 's/ingressi_L2_W0_W4.txt/ingressi_L3_W0_W4.txt/' " + tb).c_str());
        system(("sed -i -e 's/risultati_L2_W4_tb.txt/risultati_L3_W0_tb.txt/' " + tb).c_str());
        break;
    case 4: // L3 W4 (sostituisco file W, non sostituisco file input, sostituisco file output)
        system(("sed -i -e 's/twiddle_W0.txt/twiddle_W4.txt/' " + tb).c_str());
        system(("sed -i -e 's/risultati_L3_W0_tb.txt/risultati_L3_W4_tb.txt/' " + tb).c_str());
        break;
    case 5: // L3 W2 (sostituisco file W, sostituisco file input, sostituisco file output)
        system(("sed -i -e 's/twiddle_W4.txt/twiddle_W2.txt/' " + tb).c_str());
        system(("sed -i -e 's/ingressi_L3_W0_W4.txt/ingressi_L3_W2_W6.txt/' " + tb).c_str());
        system(("sed -i -e 's/risultati_L3_W4_tb.txt/risultati_L3_W2_tb.txt/' " + tb).c_str());
        break;
    case 6: // L3 W6 (sostituisco file W, non sostituisco file input, sostituisco file output)
        system(("sed -i -e 's/twiddle_W2.txt/twiddle_W6.txt/' " + tb).c_str());
        system(("sed -i -e 's/risultati_L3_W2_tb.txt/risultati_L3_W6_tb.txt/' " + tb).c_str());
        break;
    case 7: // L4 W0 (sostituisco file W, sostituisco file input, sostituisco file output)
        system(("sed -i -e 's/twiddle_W6.txt/twiddle_W0.txt/' " + tb).c_str());
        system(("sed -i -e 's/ingressi_L3_W2_W6.txt/ingressi_L4_W0_W4.txt/' " + tb).c_str());
        system(("sed -i -e 's/risultati_L3_W6_tb.txt/risultati_L4_W0_tb.txt/' " + tb).c_str());
        break;
    case 8: // L4 W4 (sostituisco file W, non sostituisco file input, sostituisco file output)
        system(("sed -i -e 's/twiddle_W0.txt/twiddle_W4.txt/' " + tb).c_str());
        system(("sed -i -e 's/risultati_L4_W0_tb.txt/risultati_L4_W4_tb.txt/' " + tb).c_str());
        break;
    case 9: // L4 W2 (sostituisco file W, sostituisco file input, sostituisco file output)
        system(("sed -i -e 's/twiddle_W4.txt/twiddle_W2.txt/' " + tb).c_str());
        system(("sed -i -e 's/ingressi_L4_W0_W4.txt/ingressi_L4_W2_W6.txt/' " + tb).c_str());
        system(("sed -i -e 's/risultati_L4_W4_tb.txt/risultati_L4_W2_tb.txt/' " + tb).c_str());
        break;
    case 10: // L4 W6 (sostituisco file W, non sostituisco file input, sostituisco file output)
        system(("sed -i -e 's/twiddle_W2.txt/twiddle_W6.txt/' " + tb).c_str());
        system(("sed -i -e 's/risultati_L4_W2_tb.txt/risultati_L4_W6_tb.txt/' " + tb).c_str());
        break;
    case 11: // L4 W1 (sostituisco file W, sostituisco file input, sostituisco file output)
        system(("sed -i -e 's/twiddle_W6.txt/twiddle_W1.txt/' " + tb).c_str());
        system(("sed -i -e 's/ingressi_L4_W2_W6.txt/ingressi_L4_W1_W5.txt/' " + tb).c_str());
        system(("sed -i -e 's/risultati_L4_W6_tb.txt/risultati_L4_W1_tb.txt/' " + tb).c_str());
        break;
    case 12: // L4 W5 (sostituisco file W, non sostituisco file input, sostituisco file output)
        system(("sed -i -e 's/twiddle_W1.txt/twiddle_W5.txt/' " + tb).c_str());
        system(("sed -i -e 's/risultati_L4_W1_tb.txt/risultati_L4_W5_tb.txt/' " + tb).c_str());
        break;
    case 13: // L4 W3 (sostituisco file W, sostituisco file input, sostituisco file output)
        system(("sed -i -e 's/twiddle_W5.txt/twiddle_W3.txt/' " + tb).c_str());
        system(("sed -i -e 's/ingressi_L4_W1_W5.txt/ingressi_L4_W3_W7.txt/' " + tb).c_str());
        system(("sed -i -e 's/risultati_L4_W5_tb.txt/risultati_L4_W3_tb.txt/' " + tb).c_str());
        break;
    case 14: // L4 W7 (sostituisco file W, non sostituisco file input, sostituisco file output)
        system(("sed -i -e 's/twiddle_W3.txt/twiddle_W7.txt/' " + tb).c_str());
        system(("sed -i -e 's/risultati_L4_W3_tb.txt/risultati_L4_W7_tb.txt/' " + tb).c_str());
        break;
    default:
        break;
    }
}

// Esecuzione simulazione
void Simulation::run(string fileCompilazione)
{
    system(("vsim -c -do " + fileCompilazione).c_str()); // lancio la simulazione
}

// Riporto la TB alle condizioni di partenza
void Simulation::restoreTB(string tb)
{
    system(("sed -i -e 's/twiddle_W7.txt/twiddle_W0.txt/' " + tb).c_str());
    system(("sed -i -e 's/ingressi_L4_W3_W7.txt/ingressi_L1_W0.txt/' " + tb).c_str());
    system(("sed -i -e 's/risultati_L4_W7_tb.txt/risultati_L1_W0_tb.txt/' " + tb).c_str());
}

// Controlla la correttezza dei risultati
unsigned int Simulation::report(string risultati_tb, string risultati_matlab)
{
    string line_tb, line_matlab; // righe dei due file
    int cnt_tb = 0;              // contatore di riga del file dei vettori di ingresso
    int cnt_matlab = 0;          // contatore di riga del file dei risultati
    int tot_correct = 0;         // numero totale di righe corrette

    // apro i file in lettura (niente controllo perché so che esistono)
    ifstream tbF(risultati_tb);
    ifstream matlabF(risultati_matlab);

    while ((tbF.good() && matlabF.good()))
    {
        // estraggo una riga da ognuno dei due file
        if (getline(tbF, line_tb) && getline(matlabF, line_matlab))
        {
            // separo i campi della riga della TB
            istringstream iss_tb(line_tb);
            vector<string> fields_tb;
            string field_tb;
            while (getline(iss_tb, field_tb, ' '))
            {
                fields_tb.push_back(field_tb);
            }

            // separo i campi della riga di MATLAB
            istringstream iss_matlab(line_matlab);
            vector<string> fields_matlab;
            string field_matlab;
            while (getline(iss_matlab, field_matlab, ' '))
            {
                fields_matlab.push_back(field_matlab);
            }

            // confronto i risultati
            float tolleranza = 1e-6;
            float diff_0 = abs(stof(fields_tb[0]) - stof(fields_matlab[0]));
            float diff_1 = abs(stof(fields_tb[1]) - stof(fields_matlab[1]));
            float diff_2 = abs(stof(fields_tb[2]) - stof(fields_matlab[2]));
            float diff_3 = abs(stof(fields_tb[3]) - stof(fields_matlab[3]));

            // se i risultati ottenuti sono uguali (a meno della tolleranza), incremento il numero di righe corrette
            if (diff_0 <= tolleranza && diff_1 <= tolleranza &&
                diff_2 <= tolleranza && diff_3 <= tolleranza)
            {
                tot_correct++;
            }
            // se i risultati sono diversi, esco dal ciclo (non ho più bisogno di controllare le righe restanti)
            else
            {
                break;
            }

            // incremento i contatori di riga
            cnt_tb++;
            cnt_matlab++;
        }
    }

    // chiudo i file
    tbF.close();
    matlabF.close();

    // stabilisco il valore del flag che mi dice se la simulazione è andata a buon fine
    if ((cnt_tb == cnt_matlab) && (tot_correct == cnt_matlab))
        correct = 1;
    else
        correct = 0;

    return correct;
}
