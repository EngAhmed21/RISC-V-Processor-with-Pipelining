# RISC-V-Processor-with-Pipelining

Implementation of the pipelined RISC V processor with many useful features as fully bypassing, dynamic branch prediction, single and multi cycle instructions, ALU unit works in parallel with a multiplication unit, and Reorder Buffer to guarantee in-order termination.

For details about ISA and the supported instructions, check out my previous project: https://github.com/EngAhmed21/RISC-V-Single-Cycle-Processor/blob/main/README.md

This design is an extention to my last 2 projects: RISC V Single-Cycle and RISC V Multi-Cycle. This design uses pipelining to increase Throughput
of the system, How?                                                                                                                                                                                                                                

- Definition of Pipelining:                                                                                                                                                                                                                               
Pipelining is a technique used in computer science and computer architecture to improve the performance of instruction processing. In a pipelined architecture, the processing of instructions is divided into multiple stages, and each stage is executed concurrently with the others. This allows multiple instructions to be processed simultaneously, resulting in higher throughput and better overall performance. The basic idea behind pipelining is to break down the execution of a single instruction into multiple smaller tasks, each of which can be performed in a separate stage of the pipeline. These stages typically include instruction fetch, instruction decode, operand fetch, execute, and write back. By overlapping the execution of multiple instructions, pipelining reduces the overall time taken to execute a sequence of instructions.                                                                                                                                                                                                                            
![Screenshot (876)](https://github.com/EngAhmed21/RISC-V-Processor-with-Pipelining/assets/90782588/15bde22d-8181-491d-a3fc-175306286db0)

- Challenges in designing a pipelined processor:                                                                                                                                                                                                                            
Pipelining introduces some challenges, such as hazards, which are dependencies between instructions that can cause stalls or incorrect results if not handled properly. These hazards include data hazards (where an instruction depends on the result of a previous instruction that has not yet completed) and control hazards (where the control flow of the program changes, such as due to branches or jumps).

- Pipelined Processor with bypassing:                                                                                                                                                                                                                         
Bypassing, also known as forwarding, is a technique used in pipelined processors to reduce the performance impact of data hazards. Data hazards occur when an instruction depends on the result of a previous instruction that has not yet completed its execution. Without bypassing, the dependent instruction would need to wait until the result is written back to the register file or memory, causing pipeline stalls and reducing overall performance. Bypassing allows the result of an instruction to be forwarded directly from one pipeline stage to another, bypassing the need to wait for it to be written back to memory. This means that subsequent instructions that depend on the result can proceed with their execution without waiting for the dependent instruction to fully complete.                                                                                                                                                                                                                         
There are typically three types of bypassing:                                                                                                                                                                                                                         
1- Register Bypassing: In this type, the result of an instruction is forwarded directly from the execution stage to the input of an earlier stage (such as the decode stage), where it is needed by a subsequent instruction.                                                                                                                                                                                                                         
2- Memory Bypassing: This involves forwarding data directly from the memory stage to an earlier stage, bypassing the need to wait for the data to be written back to memory.                                                                                                                                                                                                                         
3- Execute-to-Execute Bypassing: In some processors, forwarding can occur directly from the execution stage of one instruction to the execution stage of another instruction, bypassing intermediate stages if they are not needed.                                                                                                                                                                                                                         
By implementing bypassing, pipelined processors can reduce stalls caused by data hazards and improve overall performance by allowing more instructions to be processed concurrently. It's an essential technique for maximizing the efficiency of pipelined architectures.

Pipelined Processor with bypassing implementation:                                                                                                                                                                                                                      
![Screenshot (873)](https://github.com/EngAhmed21/RISC-V-Processor-with-Pipelining/assets/90782588/bb79e947-61ce-47fe-af81-fe24461ac493)

- Control Hazards are handled by using Branch Target Buffer (BTB) which stores the target address of the branch/jump instruction at the last time it was taken. Also, Branch History Buffer which stores which the   condition of this branch was taken or not taken at the last time it was excuted.

- A multiplication unit is used to support 4 additional instructions: mul, mulh, mulhsu, mulhu. It works in parallel with the ALU unit and takes 4 clock cycles to complete excution stage.

- Re-order buffer is used to guarantee the in-order termination.

- Store Queue is used to store the address and data of store instructions untill they are committed (store their value in the register file) to handle dependent load instructions.

- Block Diagram of the design:                                                                                                                                                                                                                   
  ![Picture1](https://github.com/EngAhmed21/RISC-V-Processor-with-Pipelining/assets/90782588/7d282fa9-ee21-4750-bdbc-9bc23c19a94f)

- Flow of excuting an instruction:                                                                                                                                                                                                                 
  Cycle (1) Instruction is fetched from the instruction memory >> access BTB and BHB to get the history of the instruction.                                                                                                                                                                                                           
  Cycle (2) Instruction is decoded >> reserve an entity in the ROB (if not full) >> If it has a destination reg, access register file and invalid this register, and store the tag >> access SQ to reserve an entity if the 
  instruction is store.                                                                                                                                                                                                           
  Cycle (3) Instruction enters the execution stage >> if load, access SQ and get the value from it if found, if not found, enter the memory stage >> if not load enters ROB after excution.                                                                                                                                                                                                           
  Cycle (4) If there is a load instruction in the memory, store the value in ROB >> If there is a ready instruction commit it.                                                                                                                                                                                                           
  Cycle (5) If there is a valid instruction >> if store, enter mem_stage >> else enter WB_stage. 

- Simulation using QuestaSim:                                                                                                                                                                                                           
![Screenshot (879)](https://github.com/EngAhmed21/RISC-V-Processor-with-Pipelining/assets/90782588/91cfa442-97e6-4b02-b5f1-d0c50c855d9e)
![Screenshot (880)](https://github.com/EngAhmed21/RISC-V-Processor-with-Pipelining/assets/90782588/b59b529f-12ae-4303-86fd-c0cfadbe91c3)
![Screenshot (881)](https://github.com/EngAhmed21/RISC-V-Processor-with-Pipelining/assets/90782588/bcf84f03-80ed-45d1-8446-005722fa1978)
![Screenshot (882)](https://github.com/EngAhmed21/RISC-V-Processor-with-Pipelining/assets/90782588/ca427e63-b786-4291-85e5-295e0cc0f0ad)

- Elaboration Design using VIVADO:                                                                                                                                                                                                                                                                                                                                                            
![Screenshot (874)](https://github.com/EngAhmed21/RISC-V-Processor-with-Pipelining/assets/90782588/8b497f01-566c-4574-914d-9c17f45398c5)

- Synthesis using VIVADO:                                                                                                                                                                                                                                  
![Screenshot (875)](https://github.com/EngAhmed21/RISC-V-Processor-with-Pipelining/assets/90782588/8ecda920-49fe-46f8-b214-b06d096a294a)
