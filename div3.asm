extern io_get_udec, io_print_char, io_newline
section .data
    n dd 0; 
    cnt dd 0;
section .text
; функция проверки делимости числа на 3
; Число делится на 3 тогда и только тогда, когда 
; сумма его цифр стоящих на четных местах отличается от суммы цифр,
; стоящих на нечетных местах, на число, делящееся на 3
div3:
    mov edx, 0x80000000; кладём число с единицей в первом разряде слева
    xor ebx, ebx; флаг 
    xor ecx, ecx; счётчик 
.del:
    cmp edx, 0; если дошли до нуля - на выход
    je .val; 
    
    test edx, eax; равен ли данный разряд числа 1 
    jnz .one; есои равен - к счётчику прибавляем 1
    
    shr edx, 2; сдвигаем на 2 вправо
    jmp .del; 
 
.one:
    inc ecx; 
    shr edx, 2;
    jmp .del;  

; валидация - если посчитали только на нечётных местах, считаем на счётных, иначе идём дальше
.val:
    cmp ebx, 1;
    je .out
    
    mov edx, 0x40000000; второй бит слева
    mov [cnt], ecx; сохраняем счётчик
    xor ecx, ecx; 
    inc ebx; поднимаем флаг
    
    jmp .del; 
    
.out:
    mov edx, 0; 
    cmp [cnt], ecx; нудна разность по модулю
    ja .outa
    
    sub ecx, [cnt];  
    
.L:
    cmp edx, 18; макс разность счётчиков = 15. иначе число на 3 не делится
    je .looser; 
    
    cmp ecx, edx; если нашли совпадение - число делится на 3 
    je .winner; 
    
    add edx, 3;
    jmp .L
   
.outa:
    sub [cnt], ecx;
    mov ecx, [cnt];
    jmp .L
        
.looser:
    mov al, "N"; вывод NO
    call io_print_char; 
    mov al, "O"; 
    call io_print_char; 
    call io_newline; 
    ret; 
    
.winner:
    mov al, "Y"; вывод YES
    call io_print_char; 
    mov al, "E"; 
    call io_print_char; 
    mov al, "S"; 
    call io_print_char;
    call io_newline; 
    ret; 
       
global main
main:
    mov ebp, esp; for correct debugging
    
    call io_get_udec; считываем количество чисел
    mov [n], eax; сохраняем в переменную
    
    
.lop:
    cmp dword[n], 0; пока n != 0
    je .exit
    
    call io_get_udec; считываем числа
    call div3; проверяем на делимость
    
    dec dword[n]; n--
    jmp .lop; 
    
.exit:
    xor eax, eax; выход
    ret