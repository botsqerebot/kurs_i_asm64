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

<br>
<h1 style="
    background-image: linear-gradient(to right, red, orange, yellow, green, blue, indigo, violet);
    -webkit-background-clip: text;
    background-clip: text;
    color: transparent;
    font-weight: bold;
">
    Tasks
</h1>

- Click [here](instruksjonsListe.md) to see all instructions you'll need for this crash course pluss more. 

## Setup / tools needed

You'll need an installation of xcode dependencies to compile an assembly file. 
If you already have xcode tools installed you can skip this but i reccomend verifying install first.

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

## Task 1 : compile your first asm code

<details>
<summary>Some helpfull descriptions</summary>

* The `.s` extention is used for assembly. It is also possible to use `.asm`.
* A `compiler` takes your code and makes it into a binary that the computer understands
* A `binary` is reffering to an executable made of 1's and 0's (machine code)
* The `.o` file is an object file with your programs machine code. It's whats used before a `linker` links it with other files. The `.o` file is an uncompleted program with loose strings if reffering to other files.
* A `linker` is used to combine multible `.o` files together to make the final program executable
</details> <br>

In your first task you'll compile your first assembly code for arm64 on macOS. 

Steps:
* Create a folder on your mac
* Open vs code in that folder
* Create a `main.s` file inside the folder
* Paste the assembly code under into your file
* Run the command under the code to make it into a runnable file


The assembly script under is your start point.
```asm
.global _start
.align 2

_start:
    mov x0, #1                  // Set to stdio
    adrp x1, mello@PAGE         // ponting to the string
    add x1, x1, mello@PAGEOFF
    mov x2, #6                  // length of the string, from 1 -> inf
    mov x16, #4                 // system call to print out
    svc #0x80                   // execute command

    b exit                      // branch to exit label

exit:
    mov x0, #0
    mov x16, #1
    svc #0x80

mello:                          // allocating space for our string inside the data section
    .ascii "Hello\n"
```

To run/compile the code, run following command in the terminal inside the folder:

```bash
as -o print.o main.s
ld -o print print.o -lSystem -syslibroot $(xcrun -sdk macosx --show-sdk-path) -e _start 
```

To run the code, use the following comand. 
```bash
./print
```

* The `./` runs an executable file where the file at the end is the one thats ran
* 


## Task 2 : minimal print function
Your task is to make a label/function that starts the stdio mode, sets the system call, execute the command and return to the caller.

<details>
<summary>Usefull terms</summary>

* A `label` is another word for a function and is used to separate logic in your `.s` file.
<details>
<summary>How to make a label</summary>

```asm
labelName:
    ; Your logic
    ; if you want to return to the caller end with:
    ret
    ; else it'll just keep running your program from there and you might crash. 
    ; Unless it's intentional
```

</details>

* A `system call` is just a command that tells the computer to do something
* `STDIO` stands for 'Standard Input Output'. While in this mode you tell the computer to be ready for outputting or getting an input. Also used in `.c` and `.cpp` languages. 

</details>


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

## Task 3 : automate the string length

Your task is to make the print call easier by automating the string length calculation instead of passing it down every time. You can search it up or use AI to try to understand the consept. <br>
The string is supposed to be passed down into register `x1` and the print function will use that to determine the length of the string.

Continue in the label/function you made in the previous task to make it so you only need to pass the string you want to display and call the print function.

<details>
<summary>Hint 1</summary>

Youll need to create a loop that loops over every character.
Use `.asciz` since it adds a zero byte at the end of the string.
Loop through the loop til you hit the zero byte
</details>

<details>
<summary>Hint 2 (usefull instructions)</summary>

```asm
ldrb x3, [x1, x2]

// Loads byte at [x1 + x2]
// if your counter is x2 it means 
// youll start at the string and go x2 into the string

// x1 : where the string is
// x2 : counter (we'll set it to 2)

// "hello\n" : [x1, x2] becomes "l"
```

```asm
cbz x3, label

//Compare to zero/ zerobyte.
// If (x3 == zero):
//      label()
```

</details>

<details>
<summary>Hint 3 (structure)</summary>
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
</details>


## Task 4 : print out a number

Here you'll create a function that converts a number in a register into a string that can be written out. Use the web or AI to research. 
I reccomend starting from scratch and only focus on printing out a number.

<details>
<summary>Hint</summary>

* Use `.asciz` 
* Use the built in `_printf` function 

</details>

<details>
<summary>Example solution</summary>

```asm
.global _main
.align 2

_main:
    mov x1, #321
    bl printNum
    ret

printNum:
    stp x29, x30, [sp, #-16]!  ; Save frame pointer and link register
    
    //mov x1, #4932               ; The number to print
    str x1, [sp, #-16]!        ; Push number onto stack (macOS variadic convention)
    
    adrp x0, .fmt1@PAGE          ; Load address of format string
    add x0, x0, .fmt1@PAGEOFF
    bl _printf                 ; Call C printf
    
    add sp, sp, #16            ; Clean up the stack
    ldp x29, x30, [sp], #16    ; Restore pointers
    mov x0, #0                 ; Return 0
    ret

.fmt1:
    .asciz "%ld\n"
    .align 2

```

</details>


## Task 5 : counting

Use the script from the last task to make a counter that can count from 0 to 10. 

When done experiment with only printing every other number or starting from 5 and counting to 10.