#ifndef SIMULATION_H // se il simbolo SIMULATION_H non è definito
#define SIMULATION_H // definisci il simbolo SIMULATION_H

using namespace std;

class Simulation
{
public:
    // Costruttore
    explicit Simulation(unsigned int = 0);

    // Metodi pubblici
    void changeTB(unsigned int implementazione, string tb);
    void run(string fileCompilazione);
    void restoreTB(string tb);
    unsigned int report(string vecFile, string resFile);

private:
    unsigned int correct; // flag per verificare la correttezza del file di input
};

#endif
