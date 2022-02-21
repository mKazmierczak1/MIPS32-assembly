# Æwiczenie 4

	.data

napis_tekst:	.asciiz "\nObliczanie przyblizonej wartosci liczby PI\nPodaj wartosc n (zaskres od 0 do 523774): "

napis_PI:	.asciiz "\nPI = "

	.text
	
main:	
	li $v0, 4		# Za³aduj do $v0 wartoœæ 4 (kod dla syscall: wyœwietl napis znajduj¹cy siê w $a0)
	
	la $a0, napis_tekst	# Za³aduj do $a0 adres napis_tekst
	
	syscall			# Wyœwietl napis_tekst na ekranie
	
	li $v0, 5		# Za³aduj do $v0 wartoœæ 5 (kod dla syscall: wczytaj licbê ca³kowit¹)
	
	syscall			# Wczytaj liczbê ca³kowit¹ z klawiatury i za³aduj do $v0
	
	
	bltz $v0, exit		#
				# Zakoñcz program, jeœli n jest spoza zakresu
	bgt $v0, 523774, exit	#
	
	
	move $t0, $v0		# Przenieœ zawartoœæ $v0 (wartoœæ n) do $t0

	add $t1, $t0, $zero	# Ustaw wartoœæ w $t1 na tak¹ sam¹ jak w $t0 (n)
	

	li $t2, 1		# $f4 i $f5 jako zmienna typu double bêdzie przechowywaæ licznik wyrazów ci¹gu
				#
	mtc1.d $t2, $f4		# Pocz¹tkowa wartoœæ licznika dla n = 0 to 1
				#
	cvt.d.w $f4, $f4	# Dlatego w $f4 ustawiamy wartoœæ na 1
	

	li $t2, 1		# $f6 i $f7 jako zmienna typu double bêdzie przechowywaæ mianownik wyrazów ci¹gu
				#
	mtc1.d $t2, $f6		# Pocz¹tkowa wartoœæ mianownika dla n = 0 to 1
				#
	cvt.d.w $f6, $f6	# Dlatego w $f6 ustawiamy wartoœæ na 1
	
	
	li $t2, -1		# Licznik wyrazu ci¹gu, to poprzedni licznik * -1
				#
	mtc1.d $t2, $f8		# Dlatego w $f8 ustawiamy wartoœæ na -1
				#
	cvt.d.w $f8, $f8	# Bêdzie on s³u¿y³ do zmieniania wartoœci licznika
	
	
	li $t2, 2		# Mianownik kolejnego wyrazu ci¹gu ró¿ni siê o 2 wzglêdem poprzedniego
				#
	mtc1.d $t2, $f10	# W $f10 ustawiamy wartoœæ na 2
				#
	cvt.d.w $f10, $f10	# Liczba w tym rejestrze bêdzie s³u¿y³a do zmiany mianownika

		
wyrazy_ci¹gu:			# Obliczamy kolejne wyrazy ci¹gu i k³adziemy je na stos, robimy to n razy
	div.d $f0, $f4, $f6	# Zapisz w $f0 wynik dzielenia pomiêdzy licznikiem i mianownikiem kolejnych wyrazów ci¹gu
	
	jal stack_push		# Cz¹stkowy wynik umieœæ na stosie
	
	mul.d $f4, $f4, $f8	# 
				# Zwiêkszamy mianownik o 2 i mno¿ymy licznik przez -1
	add.d $f6, $f6, $f10	#
	
	subi $t0, $t0, 1	# Zmiejsz o 1 warunek trwania pêtli
	
	bgez $t0, wyrazy_ci¹gu	# Powtarzaj pêtle n razy 
	
	
	li $t2, 0		# Po skoñczeniu obliczania n wyrazów ci¹gu
				#	
	mtc1.d $t2, $f4		# Chcemy odczytaæ ca³kowity wynik
				#
	cvt.d.w $f4, $f4	# W tym celu zerujemy zawartoœæ w $f4, gdzie zapiszemy ca³kowity wynik

obliczanie_PI:
	jal stack_pop		# Œci¹gnij czêœciowy wynik ze stosu
	
	add.d $f4, $f4, $f0	# Czêœciowy wynik dodaj do $f4, gdzie przechowywany jest ca³kowity wynik
	
	subi $t1, $t1, 1	#
				# Powtarzaj n razy	
	bgez $t1, obliczanie_PI	#
	
	
	li $t2, 4		# Za³aduj 4 do rejestru $f6
				#
	mtc1.d $t2, $f6		# W celu pomno¿enia wyniku o 4
				#
	cvt.d.w $f6, $f6	# I uzyskanie przybli¿onej wartoœci liczby PI
				#
	mul.d $f4, $f4, $f6	#
	

	li $v0, 4		# Za³aduj do $v0 wartoœæ 4 (kod dla syscall: wyœwietl napis znajduj¹cy siê w $a0)
	
	la $a0, napis_PI	# Za³aduj do $a0 adres napis_PI
	
	syscall			# Wyœwietl napis_PI na ekranie
	
	
	li $v0, 3		# Za³aduj do $v0 wartoœæ 3 (kod dla syscall: wyœwietl liczbê zmiennoprzecinkow¹ znajduj¹c¹ siê w $f12)
	
	mov.d $f12, $f4		# Przenieœ do $f12 wynik programu
	
	syscall			# Wyœwietl obliczon¹ liczbe PI na ekranie
	
	j exit			# PrzejdŸ do zakoñczenia programu
	

stack_push: 	
	addi $sp, $sp, -8	# Obniz $sp o dwa s³owa	
	
	#sdc1 $f0, 0($sp)	
	
	swc1 $f0, 0($sp)	# 
				# Zapisz $f0 na stosie
	swc1 $f1, 4($sp)	#
	
	jr $ra			# Wróæ do callera
	
	
stack_pop: 	
	#ldc1 $f0, 0($sp)	
	
	lwc1 $f0, 0($sp)	#
				# Za³aduj wartoœæ do $f0
	lwc1 $f1, 4($sp)	#

	addi $sp, $sp, 8	# Zwieksz $sp o podwójne s³owo
	
	jr $ra			# Wróæ do callera		

									
exit:	
	li $v0, 10 		# Za³aduj do $v0 wartoœæ 10 (kod dla syscall: koniec programu)

	syscall 		# Koniec programu 
