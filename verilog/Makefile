VV=iverilog
VFLAGS=
SOURCES=hypiu.v program_counter.v register_file.v alu.v program_control.v \
	program_ram.v
EXECUTABLE=hypiu
DUMPFILE=hypiu.vcd

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(SOURCES)
	$(VV) $(VFLAGS) -o $(EXECUTABLE) $(SOURCES)

clean:
	rm -rf $(EXECUTABLE) $(DUMPFILE)
