# xmultitasking
Cooperative multitasking for XMEGA micros, easily adaptable to others.

Tasks run with their own stacks, and perfom a context switch to change between them. Tasks must yeild control themselves, context switches are not pre-emptive.

TODO: sleep support for low power operation.
