.model tiny
.code
org 100h
LOCALS @@



start:

        jmp     realstart

        include STRLEN.ASM

;------------------------------------------------
;ITOA
;Entry:
;       AX - number
;       DI - addr of res array
;       BX - radix
;Destr: AX, DX, DI
;Ret:
;------------------------------------------------

itoa    proc

        push    di              ; addr of res arr in stack
                                ; for reverse

@@Next:

        xor     dx, dx

        div     bx              ; in dx the remainder of the division
                                ; in ax quotient of division

        push    ax              ; now quotient in stack
        mov     ax, dx          ; preparing before hex2ascii

        call    hex2ascii       ; in ax now ascii of number

        mov     ah, 4eh

        stosb                   ; now we have last number at first place in 

        pop     ax              ; now quotient in ax

        test    ax, ax

        ja      @@Next

        mov     dx, '$'         ; creating end-symb
        mov     [di], dx


        pop     si              ; addr of res arr in si
                                ; for strlen
        push    si

        call    strlen          ; length of string in cx now

        pop     si              ; si have head of array

        mov     dx, si
        add     dx, cx
        dec     dx              ; addr of last symb in dx 

        mov     di, dx          ; di have tail of array


@@Reverse:

        mov     al, [si]
        mov     bl, [di]

        mov     [si], bl
        mov     [di], al

        inc     si
        dec     di

        cmp     si, di
        jb      @@Reverse

        ret

itoa    endp


;------------------------------------------------
;------------------------------------------------
hex2ascii       proc
        cmp     al, 10
        sbb     al, 69h
        das

        ret
endp



realstart:

        mov     ax, 0ABCDh
        mov     dx, offset res
        mov     di, dx
        mov     bx, 16d

        call    itoa
  
        xor     ax, ax
        mov     ah, 09h
        mov     dx, offset res
        int     21h

        mov     ah, 4eh
        mov     dx, 0b800h
        mov     es, dx
        mov     dx, offset res
        add     dx, 3
        mov     si, dx
        xor     di, di
        lodsb
        stosb

        mov     ax, 4c00h
        int     21h

.data
res     db      4 dup('$')

end     start