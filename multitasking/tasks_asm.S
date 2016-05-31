
/*
 * tasks_asm.S
 *
 * Created: 26/05/2016 14:45:34
 *  Author: paul.qureshi
 */ 

#include <avr/io.h>

.extern	task_enable_mask
.extern	task_stack_ptr
.extern	task_index
.extern	task_index_mask

 
.section .text

.global TASK_yield
.global TASK_load


/******************************************************************************
** Task switching
*/
TASK_yield:
	push	r19
	push	r18
	push	r17
	push	r16
	push	zl
	push	zh
	
	// sleep while no tasks enabled (must be enabled by interrupts)
	lds		r18, task_enable_mask
sleep_loop:
	tst		r18
	brne	no_sleep
	sleep
	rjmp	sleep_loop
no_sleep:

	// find next task
	lds		r17, task_index
	mov		r19, r17		// save for later
find_next_task:
	lds		r16, task_index_mask
	lsl		r16
	inc		r17
	cpi		r17, 8
	brlt	no_wrap
	ldi		r17, 0			// task_index
	ldi		r16, 1			// task_index_mask
no_wrap:
	sts		task_index, r17
	sts		task_index_mask, r16
	
	and		r16, r18		// & task_enable_mask
	breq	find_next_task	// not enabled

	// save current task's state to its stack
	in		r16, CPU_EIND
	push	r16
	in		r16, CPU_RAMPZ
	push	r16
	in		r16, CPU_RAMPY
	push	r16
	in		r16, CPU_RAMPX
	push	r16
	in		r16, CPU_RAMPD
	push	r16

	//push	r31		// zh
	//push	r30		// zl
	push	r29
	push	r28
	push	r27
	push	r26
	push	r25
	push	r24
	push	r23
	push	r22
	push	r21
	push	r20
	//push	r19
	//push	r18
	//push	r17
	//push	r16
	push	r15
	push	r14
	push	r13
	push	r12
	push	r11
	push	r10
	push	r9
	push	r8
	push	r7
	push	r6
	push	r5
	push	r4
	push	r3
	push	r2
	push	r1
	push	r0

	// save current task's stack pointer
	ldi		zl, lo8(task_stack_ptr)
	ldi		zh, hi8(task_stack_ptr)
	lsl		r19				// old task index * 2
	add		zl, r19
	adc		zh, r1			// GGC keeps r1 always 0
	in		r16, CPU_SPL
	st		Z+, r16
	in		r16, CPU_SPH
	st		Z, r16

	// load next tasks stack point into r16 and r18
	ldi		zl, lo8(task_stack_ptr)
	ldi		zh, hi8(task_stack_ptr)
	lsl		r17				// new task in index * 2
	add		zl, r17
	adc		zh, r1			// GGC keeps r1 always 0
	ld		r16, Z+
	out		CPU_SPL, r16
	ld		r16, Z
	out		CPU_SPH, r16

	pop		r0
	pop		r1
	pop		r2
	pop		r3
	pop		r4
	pop		r5
	pop		r6
	pop		r7
	pop		r8
	pop		r9
	pop		r10
	pop		r11
	pop		r12
	pop		r13
	pop		r14
	pop		r15
	//pop		r16
	//pop		r17
	//pop		r18
	//pop		r19
	pop		r20
	pop		r21
	pop		r22
	pop		r23
	pop		r24
	pop		r25
	pop		r26
	pop		r27
	pop		r28
	pop		r29
	//pop		r30	// zh
	//pop		r31	// zl
	
	pop		r16
	out		CPU_RAMPD, r16
	pop		r16
	out		CPU_RAMPX, r16
	pop		r16
	out		CPU_RAMPY, r16
	pop		r16
	out		CPU_RAMPZ, r16
	pop		r16
	out		CPU_EIND, r16

	pop		zh
	pop		zl
	pop		r16
	pop		r17
	pop		r18
	pop		r19
	ret


/******************************************************************************
** Task creation
** task pointer in r24:r25
** task index in 
*/
TASK_load:
	push	r22
	push	r17
	push	r16
	push	zh
	push	zl
	push	xh
	push	xl


	// load next tasks stack point into r16 and r18
	ldi		zl, lo8(task_stack_ptr)
	ldi		zh, hi8(task_stack_ptr)
							// task index in r22
	lsl		r22				// new task in index * 2
	add		zl, r22
	adc		zh, r1			// GGC keeps r1 always 0

	ld		xl, z			// load stack pointer in X
	ldd		xh, z+1

	// temporarily load new task's stack pointer
	in		r16, CPU_SPL
	in		r17, CPU_SPH
	out		CPU_SPL, xl
	out		CPU_SPH, xh

	//st		-x, r25			// push address of new task onto its stack
	//st		-x, r24			// so it is picked up by ret in TASK_yield
	push	r24
	push	r25
	push	r1				// 24 bit return address
	

	// clear all registers that will be reloaded from stack
	push	r1
	push	r1
	push	r1
	push	r1
	push	r1

	push	r1
	push	r1
	push	r1
	push	r1
	push	r1
	push	r1

	push	r1
	push	r1
	push	r1
	push	r1
	push	r1
	push	r1
	push	r1
	push	r1
	push	r1
	push	r1
	push	r1
	push	r1
	push	r1
	push	r1
	push	r1
	push	r1
	push	r1
	push	r1
	push	r1
	push	r1
	push	r1
	push	r1
	push	r1
	push	r1
	push	r1
	push	r1

	// save new task stack pointer
	in		xl, CPU_SPL
	in		xh, CPU_SPH
	st		z, xl
	std		z+1, xh

	// restore current task's stack pointer
	out		CPU_SPL, r16
	out		CPU_SPH, r17
	
	pop		xl
	pop		xh
	pop		zl
	pop		zh
	pop		r16
	pop		r17
	pop		r22
	ret