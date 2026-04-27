.global _start
.align 2

_start:
    adrp x1, mello@PAGE         // Finds the chunk the message is in
    add x1, x1, mello@PAGEOFF   // Adds the offset inside the chunk
    mov x2, #6                  // Sets num of characters in string

    mov x0, #1
    mov x16, #4
    svc #0x80
    
    b exit


// The exit label.
// Quits the program correctly
exit:
    mov x0, #0
    mov x16, #1
    svc #0x80


// Makes space in memory for your string and makes it accessable
mello:
    .ascii "Hello\n"