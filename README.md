# RISCV-core-in-sytemverilog
This project is an implementation of the RISCV RV32I base integer instruction set in systemverilog. 

The ISA implementation includes
* A five stage pipeline with forwarding and hazard detection implemented
* Dynamic branch prediction 
* L1 instruction and data caches

A simplified block diagram of the implementation can be seen bellow.

The RTL sytemverilog source code for the project is located in the rtl_src folder.

Testbenches for the RTL source modules are located in the tb folder. 

I have also included the vsim_comp.sh and vsim_sim.sh bash scripts used to compile and run test bench simulations using ModelSim.

FENCE,ECALL and EBREAK as well as interupt handling have not been implemented yet.


![Screenshot from 2022-06-22 16-31-50](https://user-images.githubusercontent.com/39601174/175176486-51b217d5-0bff-4e21-95a0-01430b750c64.png)
