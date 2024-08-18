#include <iostream>
#include <fstream>    // per file processing
#include <filesystem> // per verifica esistenza file
#include <string>     // per manipolazione stringhe
#include <cstring>    // per manipolazione stringhe C-like
#include <cstdlib>    // per eseguire comandi shell

#include "Tools.hpp"
#include "Converter.hpp"

using namespace std;

int main(int argc, char **argv)
{
    int ret = 0;
    Converter c; // convertitore

    ofstream oF; // ofstream object per scrivere nel file dati da dare in pasto alla tb
    const string ofName = "input_data.txt";

    // 1. check esistenza file da scrivere
    if (filesystem::exists(ofName))
        system(("rm " + ofName).c_str());

    // 2. Apro file
    oF.open(ofName);

    // 3. Verifico che il file sia stato aperto correttamente
    if (!oF)
    {
        cerr << "Apertura fallita" << endl;
        ret = 1;
    }

    // test negativi
    for (int i = 0; i <= 7; i++)
    {
        oF << "1" << rand() % 2 << "1"; // MSB
        for (int j = 0; j < 23; j++)    // 23 don't care
        {
            oF << rand() % 2;
        }
        c.intToBin(to_string(i), 3, oF); // bit critici
        for (int j = 0; j < 21; j++)     // 21 don't care
        {
            oF << rand() % 2;
        }
        oF << endl; // fine riga
    }

    // test positivi
    for (int i = 0; i <= 7; i++)
    {
        oF << "0" << rand() % 2 << "0"; // MSB
        for (int j = 0; j < 23; j++)    // 23 don't care
        {
            oF << rand() % 2;
        }
        c.intToBin(to_string(i), 3, oF); // bit critici
        for (int j = 0; j < 21; j++)     // 21 don't care
        {
            oF << rand() % 2;
        }
        oF << endl; // fine riga
    }

    // chiudo file
    oF.close();

    return ret;
}