#include <iostream>
#include <iomanip> 

extern "C" void show_resistance(long tickcount, double totalresistance, double elapsedtime){
	std::cout <<"The total resistance of the system is " << std::fixed  << std::setprecision(10) << totalresistance << " Ohms, which required " << tickcount << " ticks (" << std::fixed  << std::setprecision(10) << elapsedtime << "ns) to complete." << std::endl << std::endl;
}