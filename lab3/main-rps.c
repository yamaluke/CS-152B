/******************************************************************************/
/*                                                                            */
/* PmodKYPD.c -- Demo for the use of the Pmod Keypad IP core                  */
/*                                                                            */
/******************************************************************************/
/* Author:   Mikel Skreen                                                     */
/* Copyright 2016, Digilent Inc.                                              */
/******************************************************************************/
/* File Description:                                                          */
/*                                                                            */
/* This demo continuously captures keypad data and prints a message to an     */
/* attached serial terminal whenever a positive edge is detected on any of    */
/* the sixteen keys. In order to receive messages, a serial terminal          */
/* application on your PC should be connected to the appropriate COM port for */
/* the micro-USB cable connection to your board's USBUART port. The terminal  */
/* should be configured with 8-bit data, no parity bit, 1 stop bit, and the   */
/* the appropriate Baud rate for your application. If you are using a Zynq    */
/* board, use a baud rate of 115200, if you are using a MicroBlaze system,    */
/* use the Baud rate specified in the AXI UARTLITE IP, typically 115200 or    */
/* 9600 Baud.                                                                 */
/*                                                                            */
/******************************************************************************/
/* Revision History:                                                          */
/*                                                                            */
/*    06/08/2016(MikelS):   Created                                           */
/*    08/17/2017(artvvb):   Validated for Vivado 2015.4                       */
/*    08/30/2017(artvvb):   Validated for Vivado 2016.4                       */
/*                          Added Multiple keypress error detection           */
/*    01/27/2018(atangzwj): Validated for Vivado 2017.4                       */
/*                                                                            */
/******************************************************************************/

#include "PmodKYPD.h"
#include "sleep.h"
#include "xil_cache.h"
#include "xparameters.h"
#include "xuartlite_l.h"

void Initialize();
void Cleanup();
void DisableCaches();
void EnableCaches();
void Play();

PmodKYPD myDevice;

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

int main(void) {
   Initialize();
   Play();
   Cleanup();
   return 0;
}

// keytable is determined as follows (indices shown in Keypad position below)
// 12 13 14 15
// 8  9  10 11
// 4  5  6  7
// 0  1  2  3
#define DEFAULT_KEYTABLE "0FED789C456B123A"

void Initialize() {
   EnableCaches();
   KYPD_begin(&myDevice, XPAR_PMODKYPD_0_AXI_LITE_GPIO_BASEADDR);
   KYPD_loadKeyTable(&myDevice, (u8*) DEFAULT_KEYTABLE);
}

#define BUFFER_LEN 12
#define ROCK '0'
#define PAPER '1'
#define SCISSORS '2'
void Play() {
   u16 keystate;
   XStatus status = KYPD_NO_KEY;
   u8 key = 'x';

   Xil_Out32(myDevice.GPIO_addr, 0xF);
   u8 line[BUFFER_LEN];
   while (1) {
	   memset(line,'\0', BUFFER_LEN);
	   xil_printf("PC input (0: Rock, 1: Paper, 2: Scissors): .\r\n");
	   getline_uart(line, BUFFER_LEN);
	   while ((char)line[0] != ROCK && (char)line[0] != PAPER && (char)line[0] != SCISSORS){
		   xil_printf("\r\nRECIEVED: %d\r\n", line[0]);
		   xil_printf("PC Input must be 0, 1, or 2: \r\n");
		   getline_uart(line, BUFFER_LEN);
	   }
	   xil_printf("\r\nKeypad Input: ");

	   while (status == KYPD_NO_KEY){
		   keystate = KYPD_getKeyStates(&myDevice);
		   status = KYPD_getKeyPressed(&myDevice, keystate, &key);
	   }

	   XUartLite_SendByte(XPAR_UARTLITE_0_BASEADDR, key);
	   XUartLite_SendByte(XPAR_UARTLITE_0_BASEADDR, '\r');
	   XUartLite_SendByte(XPAR_UARTLITE_0_BASEADDR, '\n');

	   xil_printf("PC: %c, FGPA: %c\r\n", line[0], key);

	   if (line[0] == ROCK && key == PAPER){
		   xil_printf("FPGA Wins, Paper Beats Rock\r\n");
	   } else if (line[0] == ROCK && key == SCISSORS){
		   xil_printf("PC Wins, Rock beats Scissors\r\n");
	   }else if (line[0] == ROCK && key == ROCK){
		   xil_printf("Tie\r\n");
	   }else if (line[0] == PAPER && key == ROCK){
		   xil_printf("PC Wins, Paper beats Rock\r\n");
	   }else if (line[0] == PAPER && key == PAPER){
		   xil_printf("Tie\r\n");
	   }else if (line[0] == PAPER && key == SCISSORS){
		   xil_printf("FPGA Wins, Scissors beats Paper\r\n");
	   }else if (line[0] == SCISSORS && key == ROCK){
		   xil_printf("FPGA Wins, Rock beats Scissors\r\n");
	   }else if (line[0] == SCISSORS && key == PAPER){
		   xil_printf("PC Wins, Scissors beats Paper\r\n");
	   }else if (line[0] == SCISSORS && key == SCISSORS){
		   xil_printf("Tie\r\n");
	   }

	   status = KYPD_NO_KEY;
   }
}

void Cleanup() {
   DisableCaches();
}

void EnableCaches() {
#ifdef __MICROBLAZE__
#ifdef XPAR_MICROBLAZE_USE_ICACHE
   Xil_ICacheEnable();
#endif
#ifdef XPAR_MICROBLAZE_USE_DCACHE
   Xil_DCacheEnable();
#endif
#endif
}

void DisableCaches() {
#ifdef __MICROBLAZE__
#ifdef XPAR_MICROBLAZE_USE_DCACHE
   Xil_DCacheDisable();
#endif
#ifdef XPAR_MICROBLAZE_USE_ICACHE
   Xil_ICacheDisable();
#endif
#endif
}
