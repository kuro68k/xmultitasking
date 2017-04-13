/*
 * multitasking.c
 *
 * Created: 26/05/2016 13:55:47
 * Author : paul.qureshi
 */ 

#include <avr/io.h>
#include "tasks.h"


void task0(void) __attribute__ ((noreturn));
void task1(void) __attribute__ ((noreturn));
void task2(void) __attribute__ ((noreturn));


/******************************************************************************
** Task 0, replaces the main()'s stack.
*/
void task0(void)
{
	uint8_t count = 0;

	for(;;)
	{
		count++;
		if (count == 0)
		{
			PORTA.OUTTGL = PIN0_bm;
			TASK_yield();
		}
	}
}


/******************************************************************************
** Task 1
*/
void task1(void)
{
	uint8_t count = 0;

	for(;;)
	{
		count++;
		if (count == 1)
		{
			PORTA.OUTTGL = PIN1_bm;
			TASK_yield();
		}
	}
}


/******************************************************************************
** Task 2
*/
void task2(void)
{
	uint8_t count = 0;

	for(;;)
	{
		count++;
		if (count == 2)
		{
			PORTA.OUTTGL = PIN2_bm;
			TASK_yield();
		}
	}
}


/******************************************************************************
** Main entry point, also task 0
*/
int main(void)
{
	TASK_init();
	TASK_create((uint16_t)task1, 1);
	TASK_create((uint16_t)task2, 2);
	TASK_yield();

	uint8_t count = 0;
	for(;;)
	{
		count++;
		if (count == 2)
		{
			PORTA.OUTTGL = PIN0_bm;
			TASK_yield();
		}
	}
}
