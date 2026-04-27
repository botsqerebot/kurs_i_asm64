# Calls

## mov

Moves the last value into the first register.

```asm
mov reg1, value
mov x0, #1 //Stdout
```

## Read address, adr

`x1 = address of msg`. It puts the address of the `msg` string into `x1` (the second syscall argument).

```asm
adr register, value
adr x1, msg
```
More futher down.

## Read address page

Loads the page address of the value

```asm
adrp reg, pageOfValue

//Example
adrp x7, num@PAGE
```

You'll also need the `num@PAGEOFF` to find the final value.
```asm
add, x7, x7, num@PAGEOFF
```
More futher down.

## Addision

```asm
add x0, x0, #1 // x0 = x0 + 1
```

## Subtract

```asm
sub x1, x1, #2 // x1 = x1 - 2
```

## Muliply

```asm
mul x0, x1, x2 // x0 = x1 * x2
```

## sdiv

```asm
sdiv x0, x1, x2 // x0 = x1 / x2 (signed)
```

## Compare

```asm
cmp x0, #0 //compares register x0 with 0
```

Flags:
* Z (zero) -> equal
* N (negative) 
* C (carry)
* V (overflow)

## Branchings (if / loops)

```asm
// Without knowing where they came from
// branch
b label     // jump always
b.eq label  // jump if equal
b.ne label  // jump if not equal
b.gt label  // greater than
b.lt label  // less than

// Remembers where it came from
// branck link
bl label     // jump always
bl.eq label  // jump if equal
bl.ne label  // jump if not equal
bl.gt label  // greater than
bl.lt label  // less than

```

### Example If

```asm
cmp #10, #15    // compare 10 to 15
b.lt loop       // if 10 is less than 15, jump to loop without link
```

### Example Loop

```asm
mov x0, #0

loop:
    add x0, x0, #1
    cmp x0, #5
    b.lt loop
```
Counts form 0 to 4

## Compare and branch if true

```asm
cbz w3, label // if w3 == 0, go to label
cbnz w3, label // if w3 != 0, go to label
```

## Read memory

Loads a value from memory
Reads memory

```asm
ldr x0, [x1]
```

* Reads the memory in address x1
* Stores it in x0

Can also have a offset
```asm
ldr x0, [x1, #8]
```

* Reads variables
* Reads arrays

## Load memory byte
```asm
ldrb w3, [x1, x2] 
```
[x1, x2] means we are at register x1 but add the the offset from x2. If x2 is 4 it moves 4 bytes futher
"Load register byte" 
Loads the single byte from a memory into a register

## Store memory

Stores value to memory
Write memory

```asm
str x0, [x1] //Value in x0 goes into memory x1
```

* Value in x0 -> stores in x1

With offset
```asm 
str x0, [x1, #8]
```

## Address loading

```asm
adrp x0, label@PAGE
add x0, x0, label@PAGEOFF
```
Loads address of label into x0
ARM64 cant load full addresses in one instruction

* Page is a 4KB-aligned chunk
* add adds the offset inside that page

* x0 = address of label

Arm cant loat a full 64-bit address in one instruction
So it splits it:
* adrp -> big chunk (page)
* add -> small offset

### Mental model

The memory is a book:
* adrp -> opens the correct page
* add -> points to the exact word on that page

Example:
```asm
adrp x1, message@PAGE
add x1, x1, message@PAGEOFF
```

* x1 now points to the message, example "Hello world"


## Stack operation

```asm
sub sp, sp, #16     ; allocate stack space
str x0, [sp]        ; push
ldr x0, [sp]        ; pop
add sp, sp, #16     ; free stack
```

Saving values
Function calls

Moves the stack pointer down -> reserves 16 bytes:
```asm 
sub sp, sp, #16
```

Store value in stack:
```asm
str x0, [sp]
```

Get the value back:
```asm
ldr x0, [sp]
```

Free up the space used:
```asm
add sp, sp, #16
```

### Mental model

Think of stack like a pile of plates:
* sub sp → add space (push area)
* str → place plate
* ldr → take plate
* add sp → remove space

# ALWAYS undo what you allocate

```asm
sub sp, sp, #16
...
add spp, sp, #16
```



## Function return

```asm
ret
```
Returns to the caller

## Function call with link

Using `bl` branches you to a label with the link to go back. Needed if wanting to return.
```asm
bl label
```

## System call trigger

```asm
mov x16, #4
svc #0x80
```

## Usefull patterns

Zero a trigger
```asm
mov x0, xzr
```

Copy pointer
```asm
mov x1, x0
```

Increment pointer
```asm
add x1, x1, #1
```

## Register sizes

* x0 = 64-bit
* w0 = 32-bit (lower half)

## Syscall 

* x16 for mac, not x8 like linux

What your program tells the OS to do:
* print text
* read files
* exit