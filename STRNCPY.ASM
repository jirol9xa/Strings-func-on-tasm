.model tiny
.code
org 100h
LOCALS @@

start:
        jmp     realstart

        include STRLEN.ASM
;------------------------------------------------
;STRNCPY func 
;Entry: AX - addr of srs string 
;       BX - addr of dest string 
;       CX - amount of bytes to copy
;Destr: AX DX, CX
;------------------------------------------------


strncpy proc

        push    ax
        push    cx

        mov     si, ax          ; preparing for strlen of srs string     

        call    strlen          ; cx now have length of strlen 

        pop     dx              ; amount of bytes to copy in dx
        pop     ax

        cmp     cx, dx
        jbe     @@Next          ; need take min 

        mov     cx, dx

@@Next: 
        mov     si, ax          ; si have srs addr
        mov     di, bx          ; di have dest addr

        repne   movsb           ; copy symbols

        ret
endp


realstart:

        mov     ax, offset first
        mov     bx, offset second
        mov     cx, 100

        call    strncpy 

        mov     cx, 10
        mov     bx, offset second
        mov     si, bx
        mov     bx, 0b800h
        mov     es, bx   

        xor     di, di

@@Next:
        lodsb
        stosw
        loop    @@Next

        mov     ax, 4c00h
        int     21h

.data
first   db      'QUQUQQ$'
second  db      'HAHAHAHA$'
end     start
