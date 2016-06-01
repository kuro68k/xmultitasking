# xmultitasking
Cooperative multitasking for XMEGA micros, easily adaptable to others.

Tasks run with their own stacks, and perfom a context switch to change between them. Tasks must yeild control themselves, context switches are not pre-emptive.

### Power saving and sleep

There are two sleep states, automatically entered when possible.

#### Power saving mode

When all tasks are disabled and the last tasks yields, the scheduler enables XMEGA power saving sleep mode and waits for at least one task to be enabled again. Tasks have to be enabled by interrupts as no other code will run. This is the lowest power possible mode and tasks should ensure that they set any hardware they use to low power state before being disabled.

#### Idle sleep mode

Tasks can be set marked as sleeping. When all tasks are sleeping the scheduler sets the XMEGA to idle sleep mode and executes a sleep instruction once every time it loops through all tasks. This is ideal for short delays while waiting for peripherals and off-chip activity, where the peripheral clock needs to keep running.
