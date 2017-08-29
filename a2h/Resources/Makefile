PROJECT=ste_tb
# vhdl files
FILES = ste_sim.vhd
# testbench
SIMTOP = ste_tb
SIMFILES = test_ste_sim.vhd
# Simu break condition
GHDL_SIM_OPT    = --assert-level=error
#GHDL_SIM_OPT    = --stop-time=500ns

SIMDIR = simu
SYNTHFILES = bin/bus_led_ise/netgen/synthesis

GHDL_CMD        = ghdl
GHDL_FLAGS      = --ieee=synopsys --warn-no-vital-generic

VIEW_CMD        = /usr/bin/gtkwave

ghdl-compile :
	mkdir -p simu
	$(GHDL_CMD) -i $(GHDL_FLAGS) --workdir=simu --work=work $(SIMFILES) $(FILES)
	$(GHDL_CMD) -m $(GHDL_FLAGS) --workdir=simu --work=work $(SIMTOP)
	@mv $(SIMTOP) simu/$(SIMTOP)                                   
ghdl-run :
	@$(SIMDIR)/$(SIMTOP) $(GHDL_SIM_OPT) --vcdgz=$(SIMDIR)/$(SIMTOP).vcdgz
ghdl-view:
	gunzip --stdout $(SIMDIR)/$(SIMTOP).vcdgz | $(VIEW_CMD) --vcd
ghdl-clean :
	$(GHDL_CMD) --clean --workdir=simu

clean:
	rm -rf *.o simu
