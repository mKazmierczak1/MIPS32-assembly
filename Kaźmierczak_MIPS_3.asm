# �wiczenie 3

	.data

tekst1: .space 51

tekst2: .space 51

wynik: .space 51

napis_tekst1:	.asciiz "\nPodaj pierwszy tekst: "

napis_tekst2:	.asciiz "\nPodaj drugi tekst: "

napis_b��dna_warto��:	.asciiz "\nWpisane teksty maja rozne dlugosci. Czy chcesz powtorzyc operacje? (Jesli TAK - wpisz jeden, NIE - wprowadz liczbe rozna od 1) "

napis_jednakowe_znaki:	.asciiz "\nIlosc jednakowych znakow: "

napis_r�ne_znaki:	.asciiz "\nIlosc roznych znakow: "

napis_stos:	.asciiz "\nZawartosc stosu: "

	.text


main:	
	li $v0, 4		# Za�aduj do $v0 warto�� 4 (kod dla syscall: wy�wietl napis znajduj�cy si� w $a0)
	
	la $a0, napis_tekst1	# Za�aduj do $a0 adres napis_tekst1
	
	syscall			# Wy�wietl napis_tekst1 na ekranie
	
	li $v0, 8		# Za�aduj do $v0 warto�� 8 (kod dla syscall: wczytaj napis)
	
	la $a0, tekst1		# Wczytaj adres tekst1 do rejestru $a0
	
	li $a1, 51		# Ustaw warto�� rejestru $a1 na 51 (w celu ustalenia d�ugo�ci tekstu na 50 znak�w)
	
	syscall			# Wczytaj napis z klawiatury i za�aduj do $a0
	
	
	li $v0, 4		# Za�aduj do $v0 warto�� 4 (kod dla syscall: wy�wietl napis znajduj�cy si� w $a0)
	
	la $a0, napis_tekst2	# Za�aduj do $a0 adres napis_tekst2
	
	syscall			# Wy�wietl napis_tekst2 na ekranie
	
	li $v0, 8		# Za�aduj do $v0 warto�� 8 (kod dla syscall: wczytaj napis)
	
	la $a0, tekst2		# Wczytaj adres tekst2 do rejestru $a0
	
	li $a1, 51		# Ustaw warto�� rejestru $a1 na 51 (w celu ustalenia d�ugo�ci tekstu na 50 znak�w)
	
	syscall			# Wczytaj napis z klawiatury i za�aduj do $a0
	
	
	la $a0, tekst1		# Wczytaj adres tekst1 do rejestru $a0
	
	jal d�ugo��_tekstu	# Przejd� do wyznaczania d�ugo�ci wpisnaego tekstu
	
	addu $t0, $zero, $v0	# Zapisz d�ugo�� tekstu pierwszego w $t0
	
	
	la $a0, tekst2		# Wczytaj adres tekst2 do rejestru $a0
	
	jal d�ugo��_tekstu	# Przejd� do wyznaczania d�ugo�ci wpisnaego tekstu
	
	addu $t1, $zero, $v0	# Zapisz d�ugo�� tekstu drugiego w $t1
	
	
	beq $t0, $t1, por�wnaj_znaki	# Je�li d�ugo�ci s� sobie r�wne, to przejd� do por�wnywania znak�w
	
	
	li $v0, 4		# Za�aduj do $v0 warto�� 4 (kod dla syscall: wy�wietl napis znajduj�cy si� w $a0)
	
	la $a0, napis_b��dna_warto��	# Za�aduj do $a0 adres napis_b��dna_warto��
	
	syscall			# Wy�wietl napis_b��dna_warto�� na ekranie
	
	li $v0, 5		# Za�aduj do $v0 warto�� 5 (kod dla syscall: wczytaj licb� ca�kowit�)
	
	syscall			# Wczytaj liczb� ca�kowit� z klawiatury i za�aduj do $v0
	
	beq $v0, 1, main	# Je�eli wpisano 1 to wykonaj program od pocz�tku
	
	j exit			# W przeciwnym wypadku zako�cz dzia�anie programu
	

d�ugo��_tekstu:
	
	addu $v0, $zero, $zero	# Zerowanie zawarto�ci $v0
	
	d�ugo��_tekstu_p�tla:
		lb $s0, ($a0)		# Do $s0 �adujemy znak kolejne znaki napisu znajduj�cego si� w $a0
					
		beqz $s0, koniec_s�owa	# Je�li $s0 == 0 to koniec p�tli

		addu $a0, $a0, 1 	# Zwi�ksz o 1 $a0 w celu uzyskania adresu do nast�pnego znaku
	
		addu $v0, $v0, 1	# Zwi�ksz o 1 $v0 (d�ugo�� tekstu)
	
		j d�ugo��_tekstu_p�tla 	# Powtarzaj p�tle
	
	koniec_s�owa:					# Pomijamy znak nowej lini i zero na ko�cu
		beq $v0, 50, pomi�_znak_nowej_linii	# Je�li d�ugo�� s�owa jest maksymalna to pomi� jedno zmniejszanie
		
		subu $v0, $v0, 1 			# Zmiejsz o 1 d�ugo�� s�owa 
		
	pomi�_znak_nowej_linii:	subu $v0, $v0, 1 	# Zmiejsz o 1 d�ugo�� s�owa 
	
		jr $ra					# Wr�� do callera
		
	
stack_push: 	
	addi $sp, $sp, -4	# Obniz $sp o s�owo

	sw $v0, 0($sp)		# Zapisz $v0 na stosie
	
	jr $ra			# Wr�� do callera
	
	
stack_pop: 	
	lw $v0, 0($sp)		# Za�aduj wartosc do $v0

	addi $sp, $sp, 4	# Zwieksz $sp o s�owo
	
	jr $ra			# Wr�� do callera


por�wnaj_znaki:		
	la $t2, tekst1		# Za�aduj adres pocz�tku tekst1 do $t2
	
	la $t3, tekst2		# Za�aduj adres pocz�tku tekst2 do $t3							
	
	addu $t2, $t2, $t0	# Przejd� na koniec tekst1
	
	addu $t3, $t3, $t0	# Przejd� na koniec tekst2
	
	li $t6, 0		# Za�duj do $t6 0 (rejestr b�dzie przechowywa� informacje o ilo�ci jednakowych znak�w)
	
	li $t7, 0		# Za�duj do $t6 0 (rejestr b�dzie przechowywa� informacje o ilo�ci r�nych znak�w)
	
	por�wnaj_znaki_p�tla:	
		lb $t4, ($t2)	# Za�aduj kolejny znak tekst1 do $t4
	
		lb $t5, ($t3)	# Za�aduj kolejny znak tekst2 do $t5
	
		beq $t4, $t5, r�wne_znaki	# Je�li znaki s� r�wne to przejd� do r�wne_znaki
		
		j r�ne_znaki			# W przeciwnym wypadku przejd� do r�ne_znaki
	
	
r�wne_znaki:
	move $v0, $t4		# Przenie� znak do $v0
	
	jal stack_push		# Umie�� znak na stosie
	
	addi $t6, $t6, 1	# Zwi�ksz o 1 liczb� jednakowych znak�w
	
	j warunek		# Przejd� do warunku 
	
	
r�ne_znaki:
	li $v0, 36		# Za�aduj 36 do $v0 (36 to w kodzie ASCII '$')
	
	jal stack_push		# Umie�� '$' na stosie 
	
	addi $t7, $t7, 1	# Zwi�ksz o 1 liczb� r�nych znak�w
	

warunek:
	subi $t1, $t1, 1		# Zmiejsz o 1 warto�� w rejestrze $t1
	
	bltz $t1, wy�wietl_wyniki	# Je�li #t1 mniejsze ni� zero to przejd� do wy�wietlania wynik�w
	
	subi $t2, $t2, 1		# Odejmij 1 od $t2 w celu uzyskania kolejnego znaku
	
	subi $t3, $t3, 1		# Odejmij 1 od $t3 w celu uzyskania kolejnego znaku
	
	j por�wnaj_znaki_p�tla		# P�tla
	

wy�wietl_wyniki:		
	li $v0, 4			# Za�aduj do $v0 warto�� 4 (kod dla syscall: wy�wietl napis znajduj�cy si� w $a0)
	
	la $a0, napis_jednakowe_znaki	# Za�aduj do $a0 adres napis_jednakowe_znaki
	
	syscall				# Wy�wietl napis_jednakowe_znaki na ekranie
	
	add $a0, $zero, $t6		# Za�aduj do $a0 ilo�� jednakowych znak�w
	
	li $v0, 1			# Za�aduj do $v0 warto�� 1 (kod dla syscall: wy�wietl liczb� ca�kowit� znajduj�c� si� w $a0)
	
	syscall				# Wypisanie ilo�ci jednakowych znak�w
	
	li $v0, 4			# Za�aduj do $v0 warto�� 4 (kod dla syscall: wy�wietl napis znajduj�cy si� w $a0)
	
	la $a0, napis_r�ne_znaki	# Za�aduj do $a0 adres napis_r�ne_znaki
	
	syscall				# Wy�wietl napis_tekst1 na ekranie
	
	add $a0, $zero, $t7		# Za�aduj do $a0 ilo�� r�nych znak�w
					
	li $v0, 1			# Za�aduj do $v0 warto�� 1 (kod dla syscall: wy�wietl liczb� ca�kowit� znajduj�c� si� w $a0)
	
	syscall				# Wypisanie ilo�ci r�nych znak�w


	li $t1, 0	
			
	wy�wietl_stos:
		jal stack_pop		# Wykonaj stack_pop
	
		sb $v0, wynik($t1)	# Znak ze stosu zapisz w napisie wynikowym
	
		addi $t1, $t1, 1	# Zwi�ksz o 1 "iterator" po napisie 
	
		ble $t1, $t0, wy�wietl_stos	# Je�li iterator mniejszy ni� lub r�wny to powtarzaj p�tle
		

	sb $zero, wynik($t1)
			
	li $v0, 4		# Za�aduj do $v0 warto�� 4 (kod dla syscall: wy�wietl napis znajduj�cy si� w $a0)
	
	la $a0, napis_stos	# Za�aduj do $a0 adres napis_stos
	
	syscall			# Wy�wietl napis_stos na ekranie
	
	la $a0, wynik		# Za�aduj do $a0 adres wynik
	
	syscall			# Wy�wietl wynik na ekranie


exit:	li $v0, 10 		# Za�aduj do $v0 warto�� 10 (kod dla syscall: koniec programu)

	syscall 		# Koniec programu 
