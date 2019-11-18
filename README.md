# PPI-8255A-Programmable-Peripheral-Interface
An implementation of the 8255 PPI chip in verilog.
The 8255 chip has two modes of operation, BSR mode and I/O mode.
Inside the I/O Mode, there are three modes of operation. This is an implementation of only
(Mode 0 - simple I/O) and the BSR mode.

Bit Set/Reset (BSR) mode

The Bit Set/Reset (BSR) mode is available on port C only. Each line of port C (PC7 - PC0) can be set or reset by writing a suitable value to the control word register. BSR mode and I/O mode are independent and selection of BSR mode does not affect the operation of other ports in I/O mode
8255 BSR mode

    D7 bit is always 0 for BSR mode.
    Bits D6, D5 and D4 are don't care bits.
    Bits D3, D2 and D1 are used to select the pin of Port C.
    Bit D0 is used to set/reset the selected pin of Port C.
    
    Selection of port C pin is determined as follows:
D3 	D2 	D1 	Bit/pin of port C selected
0 	0 	0 	PC0
0 	0 	1 	PC1
0 	1 	0 	PC2
0 	1 	1 	PC3
1 	0 	0 	PC4
1 	0 	1 	PC5
1 	1 	0 	PC6
1 	1 	1 	PC7

As an example, if it is needed that PC5 be set, then in the control word,

    Since it is BSR mode, D7 = '0'.
    Since D4, D5, D6 are not used, assume them to be '0'.
    PC5 has to be selected, hence, D3 = '1', D2 = '0', D1 = '1'.
    PC5 has to be set, hence, D0 = '1'.

Thus, as per the above values, 0B (Hex) will be loaded into the Control Word Register (CWR).
D7 	D6 	D5 	D4 	D3 	D2 	D1 	D0
0 	0 	0 	0 	1 	0 	1 	1 

Input/Output mode

This mode is selected when D7 bit of the Control Word Register is 1. There are three I/O modes:[11]

    Mode 0 - Simple I/O
    Mode 1 - Strobed I/O
    Mode 2 - Strobed Bi-directional I/O

Control Word format
I/O Control Word Format

    D0, D1, D3, D4 are assigned for port C lower, port B, port C upper and port A respectively. When these bits are 1, the corresponding port acts as an input port. For e.g., if D0 = D4 = 1, then lower port C and port A act as input ports. If these bits are 0, then the corresponding port acts as an output port. For e.g., if D1 = D3 = 0, then port B and upper port C act as output ports.
    D2 is used for mode selection of Group B (port B and lower port C). When D2 = 0, mode 0 is selected and when D2 = 1, mode 1 is selected.
    D5 & D6 are used for mode selection of Group A ( port A and upper port C). The selection is done as follows:

D6 	D5 	Mode
0 	0 	0
0 	1 	1
1 	X 	2

    As it is I/O mode, D7 = 1.

For example, if port B and upper port C have to be initialized as input ports and lower port C and port A as output ports (all in mode 0):

    Since it is an I/O mode, D7 = 1.
    Mode selection bits, D2, D5, D6 are all 0 for mode 0 operation.
    Port B and upper port C should operate as Input ports, hence, D1 = D3 = 1.
    Port A and lower port C should operate as Output ports, hence, D4 = D0 = 0.

Hence, for the desired operation, the control word register will have to be loaded with "10001010" = 8A (hex).
Mode 0 - simple I/O

In this mode, the ports can be used for simple I/O operations without handshaking signals. Port A, port B provide simple I/O operation. The two halves of port C can be either used together as an additional 8-bit port, or they can be used as individual 4-bit ports. Since the two halves of port C are independent, they may be used such that one-half is initialized as an input port while the other half is initialized as an output port.

The input/output features in mode 0 are as follows:

    Output ports are latched.
    Input ports are buffered, not latched.
    Ports do not have handshake or interrupt capability.
    With 4 ports, 16 different combinations of I/O are possible.

'Latched' means the bits are put into a storage register (array of flip-flops) which holds its output constant even if the inputs change after being latched.

The 8255's outputs are latched to hold the last data written to them. This is required because the data only stays on the bus for one cycle. So, without latching, the outputs would become invalid as soon as the write cycle finishes.

The inputs are not latched because the CPU only has to read their current values, then store the data in a CPU register or memory if it needs to be referenced at a later time. If an input changes while the port is being read then the result may be indeterminate.
Mode 0 – input mode

    In the input mode, the 8255 gets data from the external peripheral ports and the CPU reads the received data via its data bus.
    The CPU first selects the 8255 chip by making ¬ {\displaystyle {\neg }} {\neg }CS low. Then it selects the desired port using A0 and A1 lines.
    The CPU then issues an ¬ {\displaystyle {\neg }} {\neg }RD signal to read the data from the external peripheral device via the system data bus.

Mode 0 - output mode

    In the output mode, the CPU sends data to 8255 via system data bus and then the external peripheral ports receive this data via 8255 port.
    CPU first selects the 8255 chip by making ¬ {\displaystyle {\neg }} {\neg }CS low. It then selects the desired port using A0 and A1 lines.
    CPU then issues a ¬ {\displaystyle {\neg }} {\neg }WR signal to write data to the selected port via the system data bus. This data is then received by the external peripheral device connected to the selected port.
