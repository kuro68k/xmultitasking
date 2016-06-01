/*
 * tasks.c
 *
 * Created: 26/05/2016 13:57:20
 *  Author: paul.qureshi
 */ 

#include <avr/io.h>
#include <avr/pgmspace.h>
#include <avr/sleep.h>
#include <avr/interrupt.h>
#include <stdbool.h>
#include "tasks.h"


#define STACK_SIZE	200
#define NUM_TASKS	8

uint8_t		task_enable_mask = 0;
uint8_t		task_sleep_mask = 0;
uint16_t	task_stack_ptr[NUM_TASKS];
uint8_t		task_index = 0;
uint8_t		task_index_mask = 1;


/******************************************************************************
** Set up task switching system
*/
void TASK_init(void)
{
	for (uint8_t i = 0; i < NUM_TASKS; i++)
		task_stack_ptr[i] = RAMEND - (STACK_SIZE * i);

	task_enable_mask |= 1;
}

/******************************************************************************
** Create a new task
*/
void TASK_create(uint16_t task_pointer, uint8_t task_number)
{
	cli();
	task_stack_ptr[task_number] = RAMEND - (STACK_SIZE * task_number);
	TASK_load(task_pointer, task_number);
	task_enable_mask |= 1 << task_number;
	sei();
}

/******************************************************************************
** Enable a task
*/
void TASK_enable(uint8_t task_number)
{
	cli();
	task_enable_mask |= 1 << task_number;
	sei();
}

/******************************************************************************
** Enable a task
*/
void TASK_disable(uint8_t task_number)
{
	cli();
	task_enable_mask &= ~(1 << task_number);
	sei();
}

/******************************************************************************
** Sleep task
*/
