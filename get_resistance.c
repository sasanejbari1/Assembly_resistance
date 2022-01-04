#include <stdio.h>
#include <stdlib.h>

extern long get_resistance(double* array){
	char str[100];
	printf("Please enter the resistance for each of the 4 devices.\n\n");
	printf("Enter the resistance for device 1 (Ohms): ");
	scanf("%s", str);
	array[0] = atof(str);
	if (array[0]==0.0){
		printf("\n");
		return -1;
	}
	printf("You entered: %lf\n\n", array[0]);
	printf("Enter the resistance for device 2 (Ohms): ");
	scanf("%s", str);
	array[1] = atof(str);
	if (array[1]==0.0){
		printf("\n");
		return -1;
	}
	printf("You entered: %lf\n\n", array[1]);
	printf("Enter the resistance for device 3 (Ohms): ");
	scanf("%s", str);
	array[2] = atof(str);
	if (array[2]==0.0){
		printf("\n");
		return -1;
	}
	printf("You entered: %lf\n\n", array[2]);
	printf("Enter the resistance for device 4 (Ohms): ");
	scanf("%s", str);
	array[3] = atof(str);
	if (array[3]==0.0){
		printf("\n");
		return -1;
	}
	printf("You entered: %lf\n\n", array[3]);
	return 1;
}