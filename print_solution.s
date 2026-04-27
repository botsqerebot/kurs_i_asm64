.global _start 
.align 2

_start:
    /* mov x0, #1 */
    adr x1, mello
    mov x2, #13
    bl print
    /* mov x16, #4
    svc #0x80 */

    b exit

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
    .ascii "Hello World!\n"

