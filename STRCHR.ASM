.model tiny
.code
org 100h
LOCALS @@

start:

        jmp realstart

        include STRLEN.ASM

;--------------------------------------------------
;STRCHR
;Entry:
;       bx -- symbol for searching
;       si -- addr of array
;Destr: cx, ax, di
;
;Output: cx - address of the first occurrence of the character in string
;--------------------------------------------------

strchr  proc

        push    si              ; Preparing for SCAS
        pop     di              ; now have actual si value

        call    strlen          ; now in cx we have amount of symbols

        mov     ax, bx

        mov     bx, cx          ; actual length in bx
        
        inc     cx              ; for searching last symb in string

        repne   scasb           ; searching symb
                                ; cx now have position from the end or 0
        
        test    cx, cx
        jz      @@end

        sub     bx, cx
        mov     cx, bx
             
        jmp     @@ret

@@end:  
        dec     cx

@@ret:
        ret
        
endp


realstart:

        mov     bx, 'q'
        mov     dx, offset string
        mov     si, dx

        call    strchr

        mov     dx, 0b800h
        mov     es, dx

        mov     dx, offset string
        add     dx, cx
        mov     si, dx

        xor     di, di

        mov     ah, 4eh
        mov     al, [si]

        mov     es:[di], ax

        mov     ax, 4c00h
        int     21h

.data
string  db      'Abcd$'
end start