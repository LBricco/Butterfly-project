PREFIX=
ARMLINK=
CC=g++
SIZE=size

### eseguibile con elenco file oggetto ###
main: main.o Simulation.o Tools.o
	$(CC) -o main main.o Simulation.o Tools.o

### elenco file oggetto con relativo file sorgente ed elenco file header ###
main.o: main.cpp Tools.hpp Simulation.hpp
	$(CC) -c main.cpp

Simulation.o: Simulation.cpp Simulation.hpp Tools.hpp
	$(CC) -c Simulation.cpp

Tools.o: Tools.cpp Tools.hpp
	$(CC) -c Tools.cpp