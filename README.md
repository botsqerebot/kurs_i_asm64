# Basic Assembly Terms

This repo is about assembly language. Here are some of the most common terms in simple words.

## Label
A label is a name for a spot in the code.

It is often used for jumps and branches:

```asm
start:
	mov x0, #1
	b done

done:
	ret
```

## Register
A register is a tiny, very fast storage place inside the CPU.

Registers hold values the program is using right now. Examples are `x0` and `x1`.

## Instruction
An instruction is one CPU command, like `mov`, `add`, `sub`, or `bl`.

## Operand
An operand is the thing an instruction works on.

For example, in `mov x0, #1`, the operands are `x0` and `#1`.

## Immediate value
An immediate value is a number written directly in the instruction.

Example: `#1` in `mov x0, #1`.



# Task

## Tools needed

Xcode:
```bash
xcode-select --install
```
Verify install:
```bash
clang --version
as -v
ld -v
```

## Task 1 : minimal print function
Your task is to make a label/function that starts the stdio mode, sets the system call, execute the command and return to the caller.

To run/compile the code run following command:

```bash
as -o print.o name-of-asmFile.s
ld -o print print.o -lSystem -syslibroot $(xcrun -sdk macosx --show-sdk-path) -e _start 
./print
```


The assembly script under is your start point. Use it to make your print call.
```asm
.global _start
.align 2

_start:
    adrp x1, mello@PAGE
    add x1, x1, mello@PAGEOFF
    mov x2, #6

    mov x0, #1
    mov x16, #4
    svc #0x80
    
    b exit

exit:
    mov x0, #0
    mov x16, #1
    svc #0x80

mello:
    .ascii "Hello\n"
```

<details>
<summary>Hint</summary>

```asm
print:
    set to stdio mode
    set system to print out
    execute the command
    return
```

</details>



<details>
<summary>Example Solution</summary>

```asm
.global _main 
.align 2

_main:
    /* mov x0, #1 */
    adr x1, mello
    mov x2, #6
    bl print
    /* mov x16, #4
    svc #0x80 */

    b exit

//THis is the required function
print:
    mov x0, #1
    mov x16, #4
    svc #0x80
    ret

exit:
    mov x0, #0
    mov x16, #1
    svc #0x80


mello:
    .ascii "Hello\n"
```

</details>

## Task 2 : automate the string length

Your task is to make the print call easier by automating the string length calculation instead of passing it down every time. You can search it up or use AI to try to understand the consept.
Youll first pass down the function in `x1`

<details>
<summary>Hint (Structure)</summary>

Youll need to create a loop that loops over every character.
Use `.asciz` since it adds a zero byte at the end of the string.
Loop through the loop til you hit the zero byte

Structure of the loop:

```asm
strlen:
    init of the function
    set counter to zero

strlen_loop:
    loop through the string
    look for zero byte
    if zero byte branch to end
    branch to loop again

strlen_end
    return to the caller
```

Instructions that can help:

```asm
// Loads byte at [x1 + x2]
ldrb x3, [x1, x2]
```

```asm
cbz x3, label
```

</details>

<details>
<summary>Solution</summary>

```asm
//Sets the length in x2
// pointer to string needs to be in x1
strLen:
    // x1 = pointer to string (passed in)
    // returns lenght in x2
    mov x2, #0 // Set the counter to zero
strlen_Loop:
    ldrb w3, [x1, x2] // load byte at x1 + counter
    cbz w3, strlen_done // if byte == zero, were done
    add x2, x2, #1 //counter ++
    b strlen_Loop
strlen_done:
    ret
```