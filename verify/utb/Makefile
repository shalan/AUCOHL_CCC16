IP = AUCOHL_CCC16
RTL_PATH = ../../hdl/rtl
WRAPPER_PATH = $(RTL_PATH)/bus_wrappers
SOURCE = $(RTL_PATH)/$(IP).v $(WRAPPER_PATH)/$(IP)_APB.v $(WRAPPER_PATH)/$(IP)_AHBL.v
TESTBENCH_APB = $(IP)_APB_tb.v
TESTBENCH_AHBL = $(IP)_AHBL_tb.v
IP_UTIL_PATH = ../../IP_Utilities
AUCOHL_RTL_LIB_PATH = $(IP_UTIL_PATH)/rtl
AUCOHL_TB_LIB_PATH = $(IP_UTIL_PATH)/verify
AUCOHL_GEN_LIB_PATH = $(IP_UTIL_PATH)/generators

APB-RTL: 
	iverilog -o run-apb.vvp -I$(AUCOHL_TB_LIB_PATH) -I$(AUCOHL_RTL_LIB_PATH) -I$(AUCOHL_GEN_LIB_PATH) $(SOURCE) $(TESTBENCH_APB)
	./run-apb.vvp

AHBL-RTL: 
	iverilog -o run-ahbl.vvp -I$(AUCOHL_TB_LIB_PATH) -I$(AUCOHL_RTL_LIB_PATH) -I$(AUCOHL_GEN_LIB_PATH) $(SOURCE) $(TESTBENCH_AHBL)
	./run-ahbl.vvp

clean:
	rm -f *.vvp
	rm -f *.vcd

all: APB-RTL AHBL-RTL