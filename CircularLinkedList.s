################################## GESTIONE LISTE CIRCOLARI #################################

.data
listInput: .string "ADD(1) ~ SSX ~ ADD(a) ~ add(B) ~ ADD(B) ~ ADD ~ ADD(9) ~PRINT~SORT(a)~PRINT~DEL(bb) ~DEL(B) ~PRINT~REV~SDX~PRINT"
newline: .string "\n"
HeadPointer: .word 0

.text
la s0,HeadPointer # s0 = Puntatore testa
la s1,listInput # s1 = Posizione stringa input
la s4, newline
addi s2,s4,-1 # s2 = Fine Stringa
li s3,0 # s3 = Dimensione della lista
li s10,1 # s10 = Boolean per confronto comando valido

Main:
    mv a0,s1
    mv a1,s2
    bgt a0,a1,end_string  
    lb t0,0(a0) #t0 = current char
    li t1,32 #white_space
    bne t0,t1,No_Space
    addi s1,s1,1
    j Main
    No_Space:       
        li t1,65 #A
        bne t0,t1,no_ADD # if (t0 != A)
        addi a0,a0,1
        jal check_ADD
        mv s1,a0
        bne a1,s10,Main #if (ADD not valid)
        jal find_char
        mv a1,s0
        mv a2,s3
        jal ADD
        mv s3,a0
        j Main
    no_ADD:
        mv a1,s2
        li t1,68 #D
        bne t0,t1,no_DEL # if (t0 != D)
        addi a0,a0,1
        jal check_DEL
        mv s1,a0
        bne a1,s10,Main  #if (DEL not valid)
        jal find_char
        mv a1,s0
        mv a2,s3
        jal DEL
        mv s3,a0
        j Main
    no_DEL:
        mv a1,s2
        li t1,80 #P
        bne t0,t1,no_PRINT # if (t0 != P)
        addi a0,a0,1
        jal check_PRINT
        mv s1,a0
        bne a1,s10,Main #if (PRINT not valid)
        mv a0,s0
        mv a1,s3
        mv a2,s4
        jal PRINT
        j Main
    no_PRINT:
        mv a1,s2
        li t1,82 #R
        bne t0,t1,no_REV # if (t0 != R)
        addi a0,a0,1
        jal check_REV
        mv s1,a0
        bne a1,s10,Main #if (REV not valid)
        mv a0,s0
        mv a1,s3
        jal REV
        j Main
    no_REV:
        mv a1,s2
        li t1,83 #S
        bne t0,t1,no_S # if (t0 != S)
        lb t0,1(a0)
        li t1,79 #O
        bne t0,t1,no_SORT # if (t0 != O)
        addi a0,a0,2
        jal check_SORT
        mv s1,a0
        bne a1,s10,Main #if (SORT not valid)
        mv a0,s0
        mv a1,s3
        jal SORT
        j Main
    no_SORT:
        li t1,83  #S
        bne t0,t1,no_SSX # if (t0 != S)
        addi a0,a0,2
        jal check_SXX
        mv s1,a0
        bne a1,s10,Main #if (SSX not valid)
        mv a0,s0
        mv a1,s3
        jal SSX
        j Main
    no_SSX:
        li t1,68 #D
        bne t0,t1,no_S # if (t0 != D)
        addi a0,a0,2
        jal check_SXX
        mv s1,a0
        bne a1,s10,Main #if (SDX not valid)
        mv a0,s0
        mv a1,s2
        jal SDX
        j Main
    no_S:
        li a2,0
        mv s1,a0
        mv a1,s2
        bge s1,s2,end_string # if (Posizione Stringa == Posizione di fine stringa)
        li a2,0
        jal find_tilde 
        mv s1,a0
        j Main  
end_string:
    li a7,10
    ecall 
    
################################# FUNZIONI RICHIESTE PROGETTO ###############################
#Input: a0: Carattere da aggiungere // a1: Puntatore testa // a2: Dimensione lista
#output: a0: Nuova dimensione lista

ADD:
    beq a2,zero,add_empty_list
    addi a2,a2,1
    lw t0,0(a1)
    mv t3,t0
    mv t1,t0 #t1 = indirizzo di memoria più grande tra gli elementi della lista
    
    #Ciclo in cui cerco l'indirizzo di memoria più grande per eseguire la add
    Loop_ADD: 
        lw t2,1(t0) #t2 = PAHEAD dell'elemento corrente
        blt t2,t1,no_updated_address 
        addi t1,t2,0
        no_updated_address:
            beq t2,t3,finish_ADD
            add t0,t2,zero
            j Loop_ADD
    
    finish_ADD:
        addi t2,t1,5 #t2 = indirizzo di memoria in cui andare a scrivere il nuovo elemento
        sb a0,0(t2)
        sw t3,1(t2)
        sw t2,1(t0)
        mv a0,a2
        jr ra                  
    add_empty_list:
        addi a2,a2,1
        addi t2,a1,4
        sw t2,0(a1)
        sb a0,0(t2)
        sw t2,1(t2)
        mv a0,a2
        jr ra
#############################################################################################
#Input: a0: Carattere da rimuovere // a1: Puntatore testa // a2: Dimensione lista
#output: a0: Nuova dimensione lista

DEL:
    bne a2,zero,go_DEL
    li a0,0
    jr ra
        
    go_DEL:
        addi sp,sp,-16
        sw ra,0(sp)
        sw a0,4(sp)
        sw a1,8(sp)
        sw a2,12(sp)
        mv a0,a1
        #Cerco l'ultimo elemento della lista per poter tenere aggiornato il suo PAHEAD
        #nel caso ci sia un cambio di testa
        jal find_last_element
        mv t6,a0 # t6 = indirizzo ultimo nodo della lista
        lw ra,0(sp)
        lw a0,4(sp)
        lw a1,8(sp)
        lw a2,12(sp)
        addi sp,sp,16           
        add t0,a1,zero #t0 = nodo precedente a quello corrente
        lw t1,0(t0) #t1 = nodo corrente
        li t5,1
        Loop_DEL:
            lb t2,0(t1) #t2 = carattere del nodo corrente
            lw t3,1(t1) #t3 = nodo successivo al nodo corrente
            bne t2,a0,go_Next 
            beq a2,t5,DEL_one_element 
            beq t1,t6,DEL_last_element 
            sw t3,0(t0)
            mv t1,t3
            addi a2,a2,-1
            j Loop_DEL
            go_Next:
                beq t1,t6,update_last_element_PAHEAD 
                #Aggiorno i registri per la prossima iterazione
                addi t1,t1,1          
                mv t0,t1
                mv t1,t3
                j Loop_DEL 
            DEL_last_element:
                addi a2,a2,-1
                lw t4,0(a1)
                sw t4,0(t0) 
                j end_DEL                                                              
            update_last_element_PAHEAD:
                lw t4,0(a1)
                sw t4,1(t1)
                j end_DEL
            DEL_one_element:
                sw zero,0(a1)
                li a0,0
                jr ra
            end_DEL:
                mv a0,a2
                jr ra    
#############################################################################################
#input: a0: Puntatore testa // a1: Dimensione lista // a2: newline

PRINT:
    bne a1,zero,go_PRINT
    jr ra
    go_PRINT:
        lw t0,0(a0)
        mv t1,t0
        li a7,11  
        Loop_PRINT:
            lb a0,0(t1)
            ecall
            lw t2,1(t1)
            beq t2,t0,PRINT_done
            mv t1,t2  
            j Loop_PRINT    
        PRINT_done:
            lb a0,0(a2)
            ecall
            jr ra
#############################################################################################
#input: a0: Puntatore testa // a1: Dimensione lista
#output: a0: Nuovo puntatore testa

REV:
    li t0,0
    bne a1,t0,go_REV
    jr ra
    go_REV:
        lw t6,0(a0)
        mv t0,t6 # t0 = nodo corrente
        lw t1,1(t0) # t1 = nodo successivo al corrente
        Loop_REV:
            lw t2,1(t1) # t2 = nodo successivo a t1
            sw t0,1(t1)
            beq t2,t6, REV_last_element
            mv t0,t1
            mv t1,t2
            j Loop_REV
            REV_last_element:
                sw t1,1(t6)
                sw t1,0(a0)
                jr ra
    
#############################################################################################
#input: a0: Puntatore testa // a1: Dimensione lista

SSX:
    li t0,0
    bne a1,t0,go_SSX
    jr ra
    go_SSX:
        lw t0,0(a0)
        lw t1,1(t0)
        sw t1,0(a0)
        jr ra
         
#############################################################################################
#input: a0: Puntatore testa // a1: Dimensione lista

SDX:
    li t0,0
    bne a1,t0,go_SDX
    jr ra
    go_SDX:
        addi sp,sp,-8
        sw ra,0(sp)
        sw a0,4(sp)
        jal find_last_element
        mv t1,a0
        lw ra,0(sp)
        lw a0,4(sp)
        addi sp,sp,4
        sw t1,0(a0)
        jr ra
        
#############################################################################################
#input: a0:Puntatore testa // a1: Dimensione lista

SORT:
    li t0,1
    bgt a1,t0,go_SORT
    jr ra
    go_SORT:
        addi sp,sp,-8
        sw a0,0(sp)
        sw ra,4(sp)
        jal find_biggest_memory_address
        addi a1,a0,5 # t0 = indizzo di memoria da cui creare l'array
        lw a0,0(sp)
        addi sp,sp,-4
        sw a1,0(sp)
        jal linked_list_to_array
        jal QuickSort
        end_sort:
            lw a0,4(sp) # a0 = Puntatore testa lista
            lw a1,0(sp) # a1 = Indirizzo primo elemento array
            addi sp,sp,8
            jal array_to_sorted_list
            lw ra,0(sp)
            addi sp,sp,4
            jr ra
        
 
    
#############################################################################################
#input: a0: Left address // a1: Right address

QuickSort:
    bge a0,a1,end_quickSort
    addi sp,sp,-12
    sw ra,0(sp)
    sw a0,4(sp)
    sw a1,8(sp)
    jal partition
    addi sp,sp,-4
    sw a0,0(sp) # a0 = indirizzo di i = posizione finale del perno
    addi a1,a0,-1 
    lw a0,8(sp) 
    jal QuickSort
    lw a0,0(sp)
    addi a0,a0,1
    lw a1,12(sp)
    jal QuickSort
    lw ra,4(sp)
    addi sp,sp,16    
    jr ra       
end_quickSort: 
    jr ra
    
    
#############################################################################################
#input: a0:left address , a1: right address
#Output: a0: posizione finale perno


# i = indice che scorre da left a right-1
# j = indice che scorre da right-1 a left

partition:
    addi sp,sp,-12
    sw a1,0(sp)
    sw ra,4(sp) 
    sw a0,8(sp)
    lb a0,0(a1) 
    jal give_prio
    mv t3,a0 # t3 = Classe di priorità del perno
    lw a1,0(sp)
    lw a0,8(sp) 
    lb t2,0(a1) # a0 = carattere Pivot
    mv t0,a0  # t0 = indice i
    mv t1,a1 
    addi t1,t1,-1  # t1 = indice J = right-1
    
    partition_loop:
        addi sp,sp,-4
        sw t1,0(sp)
        
        #Cerco con l'indice i il carattere con classe di priorità maggiore del perno
        loop_lower:
            lb t4,0(t0) # t4 = carattere in posizione i
            addi sp,sp,-16
            sw t3,0(sp)
            sw t2,4(sp)
            sw t0,8(sp)
            sw t4,12(sp)
            mv a0,t4
            jal give_prio
            mv t5,a0 # t5 = Classe di priorità del carattere in posizione i
            lw t3,0(sp)
            lw t2,4(sp)
            lw t0,8(sp)
            lw t4,12(sp)
            addi sp,sp,16
            bne t5,t3,not_equals_lower 
            bge t4,t2,end_lower 
            addi t0,t0,1
            j loop_lower  
            not_equals_lower:
                bgt t5,t3,end_lower
                addi t0,t0,1
                j loop_lower   
        end_lower:
            lw t1,0(sp)  # t1 = j
            addi sp,sp,-4
            sw t0,0(sp)
            lw t0,16(sp) # t0 = Left
            
            #Cerco con l'indice j carattere con classe di priorità minore del perno
            loop_higher:
                ble t1,t0,end_higher
                lb t4,0(t1) # t4 = carattere in posizione J
                addi sp,sp,-16
                sw t3,0(sp)
                sw t2,4(sp)
                sw t1,8(sp)
                sw t4,12(sp)
                mv a0,t4
                jal give_prio
                mv t5,a0 # t5 = Classe di priorità del carattere in posizione J
                lw t3,0(sp)
                lw t2,4(sp)
                lw t1,8(sp)
                lw t4,12(sp)  
                addi sp,sp,16
                bne t5,t3,not_equals_higher
                ble t4,t2,end_higher
                addi t1,t1,-1
                lw t0,16(sp) # t0 = Left
                j loop_higher 
                not_equals_higher:
                    blt t5,t3,end_higher
                    addi t1,t1,-1
                    lw t0,16(sp)                
                    j loop_higher
        end_higher:
            lw t0,0(sp) # t0 = i
            addi sp,sp,8
            lb t6,0(t0) # t6 = Carattere in posizione i
            bge t0,t1,end_partition # if (i>=j) end
            sb t6,0(t1)
            sb t4,0(t0)
            addi t0,t0,1
            addi t1,t1,-1 
            j partition_loop
        end_partition:
            lw a1,0(sp) # a1 = Right
            sb t6,0(a1) 
            sb t2,0(t0) # t2 = Carattere perno
            lw ra,4(sp)
            addi sp,sp,12
            mv a0,t0        
            jr ra 
#############################################################################################
#input: a0: Carattere
#output: a0: Classe di priorità di a0

give_prio:
    li t0,65 #lower bound classe 4
    li t1,90 #upper bound classe 4
    blt a0,t0,test_3
    bgt a0,t1,test_3
    li a0,4
    jr ra
    test_3:
        li t0,97 #lower bound classe 3
        li t1,122 #upper bound classe 3
        blt a0,t0,test_2
        bgt a0,t1,test_2
        li a0,3
        jr ra
    test_2:
        li t0,48  #lower bound classe 2
        li t1,57 #upper bound classe 2
        blt a0,t0,test_1
        bgt a0,t1,test_1
        li a0,2
        jr ra
    test_1:
        li a0,1
        jr ra
    
################################### FUNZIONI PARSING INPUT ##################################
#Input check_XXX: a0: Posizione corrente nella Stringa // a1: Fine stringa
#Output check_XXX a0: Posizione Stringa dopo Tilde // a1: Boolean Istruzione Valida

check_ADD:
    li a2,0 # a2 = Boolean Valido
    li t0,68 #D
    lb t2,0(a0)
    bne t2,t0,ADD_not_valid 
    addi a0,a0,1
    lb t2,0(a0)
    bne t2,t0,ADD_not_valid 
    addi a0,a0,1
    lb t2,0(a0)
    li t0,40 # parentesi aperta 
    bne t2,t0,ADD_not_valid
    addi a0,a0,1
    lb t2,0(a0)
    li t0,32 #lower bound caratteri validi
    li t1,125 #upper bound caratteri validi
    bgt t2,t1,ADD_not_valid
    blt t2,t0,ADD_not_valid
    addi a0,a0,1
    lb t2,0(a0)
    li t0,41 # parentesi chiusa 
    bne t2,t0,ADD_not_valid 
    addi a0,a0,1
    li a2,1
    ADD_not_valid:
        addi sp,sp,-4
        sw ra,0(sp)  
        jal find_tilde
        lw ra,0(sp)
        addi sp,sp,4
        jr ra 
          
#############################################################################################

check_DEL:
    li t0,69 #E
    li a2,0 
    lb t2,0(a0)
    bne t2,t0,DEL_not_valid 
    addi a0,a0,1
    lb t2,0(a0)
    li t0,76 #L
    bne t2,t0,DEL_not_valid 
    addi a0,a0,1
    lb t2,0(a0)
    li t0,40 #parentesi aperta
    bne t2,t0,DEL_not_valid 
    addi a0,a0,1
    lb t2,0(a0)
    li t0,32 #lower bound caratteri validi
    li t1,125
    bgt t2,t1,DEL_not_valid
    blt t2,t0,DEL_not_valid
    addi a0,a0,1
    lb t2,0(a0)
    li t0,41 #parentesi chiusa
    bne t2,t0,DEL_not_valid
    addi a0,a0,1
    li a2,1  
    DEL_not_valid:
        addi sp,sp,-4
        sw ra,0(sp)  
        jal find_tilde
        lw ra,0(sp)
        addi sp,sp,4
        jr ra
        
##############################################################################################

check_PRINT:   
    li a2,0
    li t0,82 #R
    lb t1,0(a0)
    bne t1,t0,PRINT_not_valid 
    addi a0,a0,1
    lb t1,0(a0)
    li t0,73 #I
    bne t1,t0,PRINT_not_valid 
    addi a0,a0,1
    lb t1,0(a0)
    li t0,78 #N
    bne t1,t0,PRINT_not_valid 
    addi a0,a0,1
    lb t1,0(a0)
    li t0,84 #T
    bne t1,t0,PRINT_not_valid 
    addi a0,a0,1
    li a2,1
    PRINT_not_valid: 
        addi sp,sp,-4
        sw ra,0(sp)  
        jal find_tilde
        lw ra,0(sp)
        addi sp,sp,4
        jr ra
            
#############################################################################################

check_REV:
    li a2,0
    li t0,69 #E
    lb t1,0(a0)
    bne t1,t0,REV_not_valid 
    addi a0,a0,1
    lb t1,0(a0)
    li t0,86 #V
    bne t1,t0,REV_not_valid 
    li a2,1
    addi a0,a0,1   
    REV_not_valid:
        addi sp,sp,-4
        sw ra,0(sp)  
        jal find_tilde
        lw ra,0(sp)
        addi sp,sp,4
        jr ra

#############################################################################################

check_SORT:
    li a2,0                  
    li t0,82  #R
    lb t1,0(a0)
    bne t1,t0,SORT_not_valid
    addi a0,a0,1
    li t0,84 #T
    lb t1,0(a0)  
    bne t1,t0,SORT_not_valid
    li a2,1
    addi a0,a0,1
    SORT_not_valid:
        addi sp,sp,-4
        sw ra,0(sp)  
        jal find_tilde
        lw ra,0(sp)
        addi sp,sp,4 
        jr ra
      
############################################################################################# 

check_SXX:
    li a2,0
    li t0,88 #X
    lb t1,0(a0)
    bne t1,t0,SXX_not_valid
    li a2,1
    addi a0,a0,1
    SXX_not_valid:
        addi sp,sp,-4
        sw ra,0(sp)  
        jal find_tilde
        lw ra,0(sp)
        addi sp,sp,4
        jr ra
              
################################# FUNZIONI DI SUPPORTO ######################################

#Input:  a0: Posizione Corrente Stringa 
#        a1: Fine stringa 
#        a2: Boolean Istruzione Valida
#Output: a0:Posizione Stringa dopo tilde // a1: Boolean Istruzione valida  

find_tilde:
    bge a0,a1,cmd_finished
    addi sp,sp,-12
    sw a2,8(sp)
    sw a1,4(sp)
    sw ra,0(sp)
    #Rimuovo gli spazi bianchi prima della prossima tilde     
    jal whitespace_eater
    lw a2,8(sp)
    lw a1,4(sp)
    lw ra,0(sp)
    addi sp,sp,12
    bge a0,a1,cmd_finished 
    li t0,126
    lb t2,0(a0)
    beq t2,t0,cmd_finished
    loop_find:
        lb t2,0(a0)    
        addi a0,a0,1
        beq t2,t0,cmd_not_valid  
        bge a0,a1,cmd_not_valid
        j loop_find
    cmd_not_valid:     
        li a1,0
        jr ra 
    cmd_finished:
        mv a1,a2 
        addi a0,a0,1 
        jr ra           
#############################################################################################

#Input: a0: Posizione stringa da cui controllare gli spazi bianchi // a1: Fine stringa
#Output: a0: Posizione senza whitespace

whitespace_eater:
    li t0,32
    whitespace_Loop:
        lb t2,0(a0)
        bne t2,t0,end_whitespace  
        addi a0,a0,1
        bge a0,a1,end_whitespace 
        j whitespace_Loop
    end_whitespace:
        jr ra
        
#############################################################################################

#Input: a0: posizione nella stringa
#Output: a0: Carattere da aggiungere/rimuovere

find_char:
    li t0,41
    Loop_find_char:
        lb t1,0(a0)
        beq t1,t0,char_found
        addi a0,a0,-1
        j Loop_find_char
    char_found:
        addi a0,a0,-1
        lb t0,0(a0)
        mv a0,t0
        jr ra
        
#############################################################################################        

#Input: a0: Puntatore testa
#Output: a0: Indirizzo memoria ultimo nodo

find_last_element:
    lw t0,0(a0)
    mv t1,t0
    Loop_last_element:
        lw t2,1(t1)
        beq t2,t0,end_last_element
        mv t1,t2
        j Loop_last_element
end_last_element:
        mv a0,t1
        jr ra
        
#############################################################################################

#Input: a0: Puntatore testa
#Output: a0: Indirizzo memoria più grande nella lista

find_biggest_memory_address:
    lw t0,0(a0)
    mv t1,t0  # t1 = MAX
    mv t2,t0
    loop_big_address:
        lw t3,1(t2)
        ble t3,t1,no_new_max 
        addi t1,t3,0
        no_new_max:
            beq t3,t0,end_MAX
            mv t2,t3
            j loop_big_address
    end_MAX:
        mv a0,t1
        jr ra
           
#############################################################################################

#Input: a0: Puntatore testa // a1: Indirizzo da cui costruire array
#Output: a0: Indirizzo inizio array // a1:Indirizzo fine array

linked_list_to_array:
    lw t0,0(a0)
    mv t1,t0
    mv t2,a1
    copy_loop:
        lb t3,0(t1)
        sb t3,0(t2)
        addi t2,t2,1
        lw t1,1(t1)
        beq t1,t0,end_copy
        j copy_loop
    end_copy:
        mv a0,a1
        addi a1,t2,-1
        jr ra
        
#############################################################################################
#Input: a0: Puntatore testa // a1: Indirizzo array

array_to_sorted_list:
    lw t0,0(a0) #testa della lista
    mv t1,t0
    loop_atsl:
        lb t2,0(a1)
        sb t2,0(t1)
        addi a1,a1,1
        lw t1,1(t1)
        beq t1,t0,end_atsl
        j loop_atsl  
    end_atsl:        
        jr ra

     
        
        
            
