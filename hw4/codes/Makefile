.PHONY: all clean run wave
all: # The default target

CPU.out: $(wildcard *.v)
	iverilog -o CPU.out *.v

CPU.vcd: CPU.out
	./CPU.out | tee output.txt

# phony rules
all: CPU.out

run: CPU.out

wave: CPU.vcd
	gtkwave CPU.vcd

clean:
	rm -f *.out *.vcd output.txt
