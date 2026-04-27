mov x0, #1
; x0 = 1

add x0, x0, #4
; x0 = x0 + 4

adrp x1, msg@PAGE
; pointer til msg inn i x1

svc #0x80
; sudo ish. Utfører kommandoer 
; som ellers ikke er tillatt

printing:
; starten av en funksjon