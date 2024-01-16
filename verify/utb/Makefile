IP = AUCOHL_CCC16
RTL_PATH = ../../hdl/rtl
WRAPPER_PATH = $(RTL_PATH)/bus_wrappers
SOURCE = $(RTL_PATH)/$(IP).v $(WRAPPER_PATH)/$(IP)_APB.v
TESTBENCH = $(IP)_APB_tb.v
IP_UTIL_PATH = ../../IP_Utilities
AUCOHL_RTL_LIB_PATH = $(IP_UTIL_PATH)/rtl
AUCOHL_TB_LIB_PATH = $(IP_UTIL_PATH)/verify
AUCOHL_GEN_LIB_PATH = $(IP_UTIL_PATH)/generators

APB-RTL: 
	iverilog -o run.vvp -I$(AUCOHL_TB_LIB_PATH) -I$(AUCOHL_RTL_LIB_PATH) -I$(AUCOHL_GEN_LIB_PATH) $(SOURCE) $(TESTBENCH)
	./run.vvp

clean:
	rm -f *.vvp
	rm -f *.vcd

all: APB-RTL