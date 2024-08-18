#ifndef CONVERTER_H // se il simbolo CONVERTER_H non è definito
#define CONVERTER_H // definisci il simbolo CONVERTER_H

#include <string>
using namespace std;

class Converter {
    public:
        // Construttore esplicito
        explicit Converter(int = 0);
        // Metodi pubblici
        void intToBin(string conv_number, unsigned int n, ofstream &outFile); // converte da intero a binario e scrive su file
        int binToInt(string conv_number); // converte da binario a intero
        float fixedToFloat(string conv_number, int F); // converte da signed fixed point (C2) a float

    private:
        int number;
};

#endif