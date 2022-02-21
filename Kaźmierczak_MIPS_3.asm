# Æwiczenie 3

	.data

tekst1: .space 51

tekst2: .space 51

wynik: .space 51

napis_tekst1:	.asciiz "\nPodaj pierwszy tekst: "

napis_tekst2:	.asciiz "\nPodaj drugi tekst: "

napis_b³êdna_wartoœæ:	.asciiz "\nWpisane teksty maja rozne dlugosci. Czy chcesz powtorzyc operacje? (Jesli TAK - wpisz jeden, NIE - wprowadz liczbe rozna od 1) "

napis_jednakowe_znaki:	.asciiz "\nIlosc jednakowych znakow: "

napis_ró¿ne_znaki:	.asciiz "\nIlosc roznych znakow: "

napis_stos:	.asciiz "\nZawartosc stosu: "

	.text


main:	
	li $v0, 4		# Za³aduj do $v0 wartoœæ 4 (kod dla syscall: wyœwietl napis znajduj¹cy siê w $a0)
	
	la $a0, napis_tekst1	# Za³aduj do $a0 adres napis_tekst1
	
	syscall			# Wyœwietl napis_tekst1 na ekranie
	
	li $v0, 8		# Za³aduj do $v0 wartoœæ 8 (kod dla syscall: wczytaj napis)
	
	la $a0, tekst1		# Wczytaj adres tekst1 do rejestru $a0
	
	li $a1, 51		# Ustaw wartoœæ rejestru $a1 na 51 (w celu ustalenia d³ugoœci tekstu na 50 znaków)
	
	syscall			# Wczytaj napis z klawiatury i za³aduj do $a0
	
	
	li $v0, 4		# Za³aduj do $v0 wartoœæ 4 (kod dla syscall: wyœwietl napis znajduj¹cy siê w $a0)
	
	la $a0, napis_tekst2	# Za³aduj do $a0 adres napis_tekst2
	
	syscall			# Wyœwietl napis_tekst2 na ekranie
	
	li $v0, 8		# Za³aduj do $v0 wartoœæ 8 (kod dla syscall: wczytaj napis)
	
	la $a0, tekst2		# Wczytaj adres tekst2 do rejestru $a0
	
	li $a1, 51		# Ustaw wartoœæ rejestru $a1 na 51 (w celu ustalenia d³ugoœci tekstu na 50 znaków)
	
	syscall			# Wczytaj napis z klawiatury i za³aduj do $a0
	
	
	la $a0, tekst1		# Wczytaj adres tekst1 do rejestru $a0
	
	jal d³ugoœæ_tekstu	# PrzejdŸ do wyznaczania d³ugoœci wpisnaego tekstu
	
	addu $t0, $zero, $v0	# Zapisz d³ugoœæ tekstu pierwszego w $t0
	
	
	la $a0, tekst2		# Wczytaj adres tekst2 do rejestru $a0
	
	jal d³ugoœæ_tekstu	# PrzejdŸ do wyznaczania d³ugoœci wpisnaego tekstu
	
	addu $t1, $zero, $v0	# Zapisz d³ugoœæ tekstu drugiego w $t1
	
	
	beq $t0, $t1, porównaj_znaki	# Jeœli d³ugoœci s¹ sobie równe, to przejdŸ do porównywania znaków
	
	
	li $v0, 4		# Za³aduj do $v0 wartoœæ 4 (kod dla syscall: wyœwietl napis znajduj¹cy siê w $a0)
	
	la $a0, napis_b³êdna_wartoœæ	# Za³aduj do $a0 adres napis_b³êdna_wartoœæ
	
	syscall			# Wyœwietl napis_b³êdna_wartoœæ na ekranie
	
	li $v0, 5		# Za³aduj do $v0 wartoœæ 5 (kod dla syscall: wczytaj licbê ca³kowit¹)
	
	syscall			# Wczytaj liczbê ca³kowit¹ z klawiatury i za³aduj do $v0
	
	beq $v0, 1, main	# Je¿eli wpisano 1 to wykonaj program od pocz¹tku
	
	j exit			# W przeciwnym wypadku zakoñcz dzia³anie programu
	

d³ugoœæ_tekstu:
	
	addu $v0, $zero, $zero	# Zerowanie zawartoœci $v0
	
	d³ugoœæ_tekstu_pêtla:
		lb $s0, ($a0)		# Do $s0 ³adujemy znak kolejne znaki napisu znajduj¹cego siê w $a0
					
		beqz $s0, koniec_s³owa	# Jeœli $s0 == 0 to koniec pêtli

		addu $a0, $a0, 1 	# Zwiêksz o 1 $a0 w celu uzyskania adresu do nastêpnego znaku
	
		addu $v0, $v0, 1	# Zwiêksz o 1 $v0 (d³ugoœæ tekstu)
	
		j d³ugoœæ_tekstu_pêtla 	# Powtarzaj pêtle
	
	koniec_s³owa:					# Pomijamy znak nowej lini i zero na koñcu
		beq $v0, 50, pomiñ_znak_nowej_linii	# Jeœli d³ugoœæ s³owa jest maksymalna to pomiñ jedno zmniejszanie
		
		subu $v0, $v0, 1 			# Zmiejsz o 1 d³ugoœæ s³owa 
		
	pomiñ_znak_nowej_linii:	subu $v0, $v0, 1 	# Zmiejsz o 1 d³ugoœæ s³owa 
	
		jr $ra					# Wróæ do callera
		
	
stack_push: 	
	addi $sp, $sp, -4	# Obniz $sp o s³owo

	sw $v0, 0($sp)		# Zapisz $v0 na stosie
	
	jr $ra			# Wróæ do callera
	
	
stack_pop: 	
	lw $v0, 0($sp)		# Za³aduj wartosc do $v0

	addi $sp, $sp, 4	# Zwieksz $sp o s³owo
	
	jr $ra			# Wróæ do callera


porównaj_znaki:		
	la $t2, tekst1		# Za³aduj adres pocz¹tku tekst1 do $t2
	
	la $t3, tekst2		# Za³aduj adres pocz¹tku tekst2 do $t3							
	
	addu $t2, $t2, $t0	# PrzejdŸ na koniec tekst1
	
	addu $t3, $t3, $t0	# PrzejdŸ na koniec tekst2
	
	li $t6, 0		# Za³duj do $t6 0 (rejestr bêdzie przechowywa³ informacje o iloœci jednakowych znaków)
	
	li $t7, 0		# Za³duj do $t6 0 (rejestr bêdzie przechowywa³ informacje o iloœci ró¿nych znaków)
	
	porównaj_znaki_pêtla:	
		lb $t4, ($t2)	# Za³aduj kolejny znak tekst1 do $t4
	
		lb $t5, ($t3)	# Za³aduj kolejny znak tekst2 do $t5
	
		beq $t4, $t5, równe_znaki	# Jeœli znaki s¹ równe to przejdŸ do równe_znaki
		
		j ró¿ne_znaki			# W przeciwnym wypadku przejdŸ do ró¿ne_znaki
	
	
równe_znaki:
	move $v0, $t4		# Przenieœ znak do $v0
	
	jal stack_push		# Umieœæ znak na stosie
	
	addi $t6, $t6, 1	# Zwiêksz o 1 liczbê jednakowych znaków
	
	j warunek		# PrzejdŸ do warunku 
	
	
ró¿ne_znaki:
	li $v0, 36		# Za³aduj 36 do $v0 (36 to w kodzie ASCII '$')
	
	jal stack_push		# Umieœæ '$' na stosie 
	
	addi $t7, $t7, 1	# Zwiêksz o 1 liczbê ró¿nych znaków
	

warunek:
	subi $t1, $t1, 1		# Zmiejsz o 1 wartoœæ w rejestrze $t1
	
	bltz $t1, wyœwietl_wyniki	# Jeœli #t1 mniejsze ni¿ zero to przejdŸ do wyœwietlania wyników
	
	subi $t2, $t2, 1		# Odejmij 1 od $t2 w celu uzyskania kolejnego znaku
	
	subi $t3, $t3, 1		# Odejmij 1 od $t3 w celu uzyskania kolejnego znaku
	
	j porównaj_znaki_pêtla		# Pêtla
	

wyœwietl_wyniki:		
	li $v0, 4			# Za³aduj do $v0 wartoœæ 4 (kod dla syscall: wyœwietl napis znajduj¹cy siê w $a0)
	
	la $a0, napis_jednakowe_znaki	# Za³aduj do $a0 adres napis_jednakowe_znaki
	
	syscall				# Wyœwietl napis_jednakowe_znaki na ekranie
	
	add $a0, $zero, $t6		# Za³aduj do $a0 iloœæ jednakowych znaków
	
	li $v0, 1			# Za³aduj do $v0 wartoœæ 1 (kod dla syscall: wyœwietl liczbê ca³kowit¹ znajduj¹c¹ siê w $a0)
	
	syscall				# Wypisanie iloœci jednakowych znaków
	
	li $v0, 4			# Za³aduj do $v0 wartoœæ 4 (kod dla syscall: wyœwietl napis znajduj¹cy siê w $a0)
	
	la $a0, napis_ró¿ne_znaki	# Za³aduj do $a0 adres napis_ró¿ne_znaki
	
	syscall				# Wyœwietl napis_tekst1 na ekranie
	
	add $a0, $zero, $t7		# Za³aduj do $a0 iloœæ ró¿nych znaków
					
	li $v0, 1			# Za³aduj do $v0 wartoœæ 1 (kod dla syscall: wyœwietl liczbê ca³kowit¹ znajduj¹c¹ siê w $a0)
	
	syscall				# Wypisanie iloœci ró¿nych znaków


	li $t1, 0	
			
	wyœwietl_stos:
		jal stack_pop		# Wykonaj stack_pop
	
		sb $v0, wynik($t1)	# Znak ze stosu zapisz w napisie wynikowym
	
		addi $t1, $t1, 1	# Zwiêksz o 1 "iterator" po napisie 
	
		ble $t1, $t0, wyœwietl_stos	# Jeœli iterator mniejszy ni¿ lub równy to powtarzaj pêtle
		

	sb $zero, wynik($t1)
			
	li $v0, 4		# Za³aduj do $v0 wartoœæ 4 (kod dla syscall: wyœwietl napis znajduj¹cy siê w $a0)
	
	la $a0, napis_stos	# Za³aduj do $a0 adres napis_stos
	
	syscall			# Wyœwietl napis_stos na ekranie
	
	la $a0, wynik		# Za³aduj do $a0 adres wynik
	
	syscall			# Wyœwietl wynik na ekranie


exit:	li $v0, 10 		# Za³aduj do $v0 wartoœæ 10 (kod dla syscall: koniec programu)

	syscall 		# Koniec programu 
