#include <iostream>
#include <fstream>   // per il file processing
#include <cstring>   // per manipolazione di stringhe e array di char
#include <string>    // per creazione e manipolazione stringhe
#include <algorithm> // per la funzione reverse
#include <cmath>     // per l'elevazione a potenza con pow(a,b)

#include "Converter.hpp"

using namespace std;

// Costruttore che assegna all'attributo privato un valore di default per evitare conversioni non volute
Converter::Converter(int default_number)
    : number{default_number} {}

// Converte un numero da intero a binario (con parallelismo a n bit) e scrive il risultato in un file
void Converter::intToBin(string conv_number, unsigned int n, ofstream &outFile)
{
    int digit;                  // singola cifra del numero da convertire
    number = stoi(conv_number); // numero (intero) da convertire

    // Sfruttiamo l'overloading dell'operatore >> (shift right)
    // Ad ogni iterazione shiftiamo number a dx di i posizioni (ovvero calcoliamo number % 2^i) e mettiamo il risultato in bitwise and con 1
    for (int i = n - 1; i >= 0; i--)
    {
        digit = (number >> (i)) & 1; // digit vale 1 se
        outFile << digit;
    }
}

// Converte un numero da binario a intero
int Converter::binToInt(string conv_number)
{
    int i = 0;
    int result = 0;
    number = stoi(conv_number);
    while (number > 0)
    {
        if (number % 10 != 0)
        {
            result += pow(2, i);
        }
        number /= 10;
        i++;
    }
    return result;
}

// Converte un numero da signed fixed point a intero
float Converter::fixedToFloat(string conv_number, int F)
{
    int i = 0;
    float result = 0;
    number = stoi(conv_number);
    while (number > 0)
    {
        if (number % 10 != 0)
        {
            if (i == conv_number.length() - 1)
                result -= pow(2, i - F);
            else
                result += pow(2, i - F);
        }
        number /= 10;
        i++;
    }
    return result;
}