#include <iostream>
#include <iomanip> 

extern "C" double compute_resistance(double r1, double r2, double r3, double r4){
	if (r1 <=0 || r2 <=0 || r3 <=0 || r4 <=0)
		return 0.0;
	return 1/(1/r1 + 1/r2 + 1/r3 + 1/r4);
}