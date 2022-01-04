#include <iostream>
#include <iomanip> 

extern "C" double resistance();

int main(){
	std::cout <<"Welcome to Parallel Circuits by Sasan Ejbari." << std::endl << "This program will automate finding the resistance in a large circuit." << std::endl << std::endl;
	double value = resistance();
	std::cout <<"Main received this number: " << std::fixed  << std::setprecision(10) << value << std::endl;
	std::cout <<"Main will now return 0 to the operating system." << std::endl;
	return 0;
}