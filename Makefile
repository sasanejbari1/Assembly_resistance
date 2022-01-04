# Compile and Link Variable
CC := gcc
CC_FLAGS := -Wall -m64 -gdwarf-2 -c
ASM := yasm
ASM_FLAGS := -f elf64 -gdwarf2
LINKER := gcc
LINKER_FLAGS := -Wall -m64 -gdwarf-2 -no-pie 


# Executable name
BIN_NAME := my-program
BIN := ./$(BIN_NAME)

run:	build
	@echo "Running program!"
	./my-program

build: $(BIN)
.PHONY: build

#
$(BIN): resistance.o compute_resistance.o get_resistance.o show_resistance.o ohm.o
	g++ -g -Wall -Wextra -Werror -std=c++17 -no-pie resistance.o compute_resistance.o get_resistance.o show_resistance.o ohm.o libPuhfessorP.v0.11.2.so -o my-program
	@echo "Done"

show_resistance.o: show_resistance.cpp
	g++ -g -Wall -Wextra -Werror -std=c++17 -c -o show_resistance.o show_resistance.cpp
	
compute_resistance.o: compute_resistance.cpp
	g++ -g -Wall -Wextra -Werror -std=c++17 -c -o compute_resistance.o compute_resistance.cpp

get_resistance.o: get_resistance.c
	$(CC) $(CC_FLAGS) get_resistance.c -o get_resistance.o	

resistance.o: resistance.asm
	$(ASM) $(ASM_FLAGS) resistance.asm -o resistance.o

ohm.o: ohm.cpp
	g++ -g -Wall -Wextra -Werror -std=c++17 -c -o ohm.o ohm.cpp

# ca make targets as many as want

clean: 
	-rm *.o
	-rm $(BIN)
