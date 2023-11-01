section .data
	name0 db "AUTHOR: Samson GBEVOU_SYSTEM", 10,0
	text db "Hello World! REARRANGED PROGRAM", 10,0
	text1 db "What is your name? "
	text2 db "Hello Mr/Mrs "
	digit db 0, 10

section .bss
	name resb 16

section .text
	global _start

_start:
	call _printText1
	call _getName
	call _printText2
	call _printName
	;print any digit between 0 and 9
	mov rax, 7
	call _printRAXDigit

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; LET\'S DO SOME MATHS OPERATIONS
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	;;NOT WORKING YET I WILL FIX AFTER
;	mov rax, 6
;	mov rbx, 2
;	div rbx;; Result of rax = 6 / 2
;	call _printRAXDigit
	mov rax, 1
	add rax, 4;; Result of rax = 1 + 4
	call _printRAXDigit

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; STACK OPERATIONS
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	push 4
	push 8
	push 3

	pop rax
	call _printRAXDigit
	pop rax
	call _printRAXDigit
	pop rax
	call _printRAXDigit

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;UNE AUTRE FACON D'AFFICHER DU TEXTE A L'ECRAN SANS
	;;NECESSAIREMENT CONNAITRE LA VALEUR EN OCTET DE LA CHAINE
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov rax, text
	call _print

	mov rax, name0
	call _print

	;sys_exit
	mov rax, 60
	mov rdi, 0
	syscall

_getName:
	;sys_read
	mov rax, 0
	mov rdi, 0
	mov rsi, name
	mov rdx, 16
	syscall
	ret

_printText1:
	;sys_write
	mov rax, 1
	mov rdi, 1
	mov rsi, text1
	mov rdx, 19
	syscall
	ret

_printText2:
	;sys_write
	mov rax, 1
	mov rdi, 1
	mov rsi, text2
	mov rdx, 13
	syscall
	ret

_printName:
	;sys_write
	mov rax, 1
	mov rdi, 1
	mov rsi, name
	mov rdx, 16
	syscall
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Subroutine to Output the
;;Digit Value of rax register
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_printRAXDigit:
	add rax, 48
	mov [digit], al;;al is the 8-bits version of rax
	;sys_write
	mov rax, 1
	mov rdi, 1
	mov rsi, digit
	mov rdx, 2
	syscall
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Subroutine to output the length of the string
;;INPUT: rax as pointer to string
;;OUTPUT: print string at rax
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Initialisation du compteur du nombre de chaine de caractere rbx
_print:
	push rax;;On Met rax dans la pile
	mov rbx, 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;C'est une Subroutine qui permet de stocker dans cl en se deplacant
;;dans les caracteres d'une chaine qui a ete loadee le registre rax
;;jusqu'a ce qu'on ait un octet non-usuelle ici qui est 0 a la fin
;;
;;METHODOLOGIE DANS CHAQUE TOUR DE BOUCLE
;;la constante text est dans [rax]
;;On incremente  rax(c'est ou on a stocker l'adresse de la chaine) et
;;;;;;;;;ce qui ce passe c'est que a chaque incrementation on charge 
;;;;;le caractere suivant dans [rax] et par exemple rax++ => [rax]='e'
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;encore rax++ => [rax]='l'
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;encore un autre rax++ => [rax]='l'
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;encore un autre rax++ => [rax]='o'
;;On incremente rbx: car on utilise rbx pour compter le nombre de char
;;Ensuite on passe par reference la valeur de l'octer numero rbx dans
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;la chaine d'adresse a rax
;;On compare la valeur avec 0
;;On fait le saut en boucle si valeur n'est pas egale (jne) jusqu'a 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_printLoop:
	inc rax,
	inc rbx
	mov cl, [rax];;cl is the 8-bits version of rcx
	cmp cl, 0
	jne _printLoop
	
	;;notre fameux sys_write de toujours
	mov rax, 1
	mov rdi, 1
	pop rsi
	mov rdx, rbx
	syscall

	ret;;notre retour qui retourne vers la ligne d'appel
