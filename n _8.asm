extern io_get_udec, io_print_udec
section .bss
    mas resd 2; резервируем память под массив
section .data
    k dd 10
    cnt dd 0
section .text

; в eax -  число
trans:
    cmp dword[k], 0;
    je .out
    
    div dword[k]; 
    add dword[cnt], edx; 
    
    call trans; 

.out:
    ret
    
global main
main:
    mov ebp, esp; for correct debugging
    call io_get_udec; 
    call trans
    
    mov eax, [cnt]
    call io_print_udec;
    
    xor eax, eax
    ret