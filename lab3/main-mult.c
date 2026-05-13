/*
 * main.c
 *
 *  Created on: Apr 15, 2026
 *      Author: Student
 */

#include "xil_printf.h"
#include "xparameters.h"
#include "xuartlite_l.h"
#include "xgpio.h"

#define CR 13
#define LF 10
void getline_uart(u8 *buffer, u32 buffer_len){
    int index = 0;
    u8 byte;

    while (index < buffer_len - 1){
        byte = XUartLite_RecvByte(XPAR_UARTLITE_0_BASEADDR);

        if (byte == CR || byte == LF){
            while (!XUartLite_IsReceiveEmpty(XPAR_UARTLITE_0_BASEADDR)){
                u8 next = XUartLite_RecvByte(XPAR_UARTLITE_0_BASEADDR);
                if (next != CR && next != LF){
                    break;
                }
            }
            break;
        }

        XUartLite_SendByte(XPAR_UARTLITE_0_BASEADDR, byte);
        buffer[index++] = byte;
    }

    buffer[index] = '\0';
}

u32 atoi(u8 *buffer){
	u32 index = 0;
	u32 val = 0;
	while(buffer[index] != '\0'){
		val = val * 10 + (buffer[index] - 48);
		index++;
	}

	return val;
}

u32 mult(u8 *buffer){
	// Parse the first num
	u8 num1[12] = {0};
	u8 num2[12] = {0};
	u8 num1_index, num2_index, g_index;
	num1_index = num2_index = g_index = 0;

	while (buffer[g_index] != '*' && buffer[g_index] != '\0' && num1_index < sizeof(num1) - 1){
	    num1[num1_index++] = buffer[g_index++];
	}
	num1[num1_index] = '\0';

	g_index += 1; // Skip delimiter

	while (buffer[g_index] != '\0' && num2_index < sizeof(num2) - 1){
	    num2[num2_index++] = buffer[g_index++];
	}
	num2[num2_index] = '\0';

	u32 v1, v2;

	v1 = atoi(num1);
	v2 = atoi(num2);


	xil_printf("\r\nNUM1: %d\n\r", v1);
	xil_printf("NUM2: %d\n\r", v2);
	xil_printf("PRODUCT: %d\n\r", v1 * v2);


	return v1 * v2;
}


#define BUFFER_LEN 32
int main(){
	u8 line[BUFFER_LEN];
	u32 product;

	XGpio gpio;
		u32 led;

		XGpio_Initialize(&gpio, 0);
		XGpio_SetDataDirection(&gpio, 2, 0x00000000);
	while(1){
		led = 0x00000000;
		xil_printf("Please enter the numbers you wish to multiply in the following format (a*b)\n\r");
		getline_uart(line, BUFFER_LEN);

		product = mult(line);

		if (product > 100){
			led = 0xFFFFFFFF;
		}

		XGpio_DiscreteWrite(&gpio, 2, led);
	}
}

