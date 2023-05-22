# 16 Bits micro controller

Here lays the description of a 16 bits micro controller in VHDL.

## Table of Contents

- [General Information](#general-information)
- [Technologies Used](#technologies-used)
- [Block diagrams of the design](#blocks-diagrams)
- [Processor instructions](#processor-instructions)
- [FPGA not detected in Quartus](#fpga-not-detected-in-quartus)


## General Information
    It's a 16 bits micro controller, meaning that the I/O ports (port A and port B) can be controlled bit by bit.
    The port A and B currently are buses of 8 bits.
    The CPU it's based on a states machine.

## Technologies Used

- [FPGA Cyclone IV EP4CE22F17C6](https://ark.intel.com/content/www/us/en/ark/products/210468/cyclone-iv-ep4ce22-fpga.html)
- [Intel® Quartus® II Web Edition Design Software Version 13.1](https://www.intel.com/content/www/us/en/software-kit/666221/intel-quartus-ii-web-edition-design-software-version-13-1-for-windows.html)

## Blocks diagrams
![Blocks diagram](./block_diagram.jpg)

## Processor Instructions
| Description                       | Pseudo name | HEX     | BINARY
| :-------------------------------- | :---------: | :-----: | -----:
| clears register RX                | CLR_RX      | 0000    | 0000000000000000
| increments by 1 RX                | INC_RX      | 0100    | 0000000100000000
| loads RX with the given data      | LDI_RX      | 0200    | 0000001000000000
| decrements by 1 RX                | DEC_RX      | 0300    | 0000001100000000
| no operation                      | NOP         | 0400    | 0000010000000000
| loads RX with data given a memory direction     | LDD_RX | 0500    | 0000010100000000
| stores RX data given a memory direction         | STR_RX | 0600    | 0000011000000000
| loads to RX the sum of RX and a memory | RX_MEM_SUM | 0708    | 0000011100001000 
| loads to RX the sum of RX and a memory and the carry | RX_MEM_C_SUM | 0709    | 0000011100001001 
| loads to RX the remainder of RX and a memory | RX_MEM_REM | 070A    | 0000011100001010 
| loads to RX the remainder of RX and a memory and the carry | RX_MEM_C_REM | 070B    | 0000011100001000 
| loads to RX with NOT RX | RX_MEM_SUM | 0711    | 0000011100010001 
| loads to RX the sum of RX and a memory | RX_MEM_SUM | 0708    | 0000011100001000 

##### all _'given data'_ it's thought to be given as the next 16 bits instruction.

## FPGA not detected in Quartus
If you get an error that the FPGA won't detect the FPGA you just have to install manually the driver found in the Quartus installation directory, inside the _'drivers'_ folder.

## Contact

Created by [@TomiVidal99](https://www.tomasvidal.xyz/) - feel free to contact me!

## License

This project is open source and available under the [MIT License](../LICENSE).
