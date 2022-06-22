# RISCV-core-in-sytemverilog
This project is an implementation of the RISCV RV32I base integer instruction set in systemverilog. 

The ISA implementation includes
* a five stage pipeline with forwarding and hazard detection implemented
* branch prediction 
* L1 instruction and data caches

A simplified block diagram of the implementation can be seen bellow.

The RTL sytemverilog source code for the project is located in the rtl_src folder.

Testbenches for the RTL source modules are located in the tb folder. 

I have also included the vsim_comp.sh and vsim_sim.sh bash scripts used to compile and run test bench simulations using ModelSim.

FENCE,ECALL and EBREAK as well as interupt handling have not been implemented yet.


!
![Screenshot from 2022-06-21 18-16-46](https://user-images.githubusercontent.com/39601174/175173986-f24b9b7a-71ce-4e1f-8f3c-85d1fe79549f.png)
