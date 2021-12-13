.PHONY: all clean run
all: # The default target

CPU.out: $(wildcard *.v)
	iverilog -o CPU.out *.v

# phony rules
all: CPU.out

run: CPU.out
	./CPU.out

clean:
	rm -f *.out *.vcd output.txt
