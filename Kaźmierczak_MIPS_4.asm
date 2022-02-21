# �wiczenie 4

	.data

napis_tekst:	.asciiz "\nObliczanie przyblizonej wartosci liczby PI\nPodaj wartosc n (zaskres od 0 do 523774): "

napis_PI:	.asciiz "\nPI = "

	.text
	
main:	
	li $v0, 4		# Za�aduj do $v0 warto�� 4 (kod dla syscall: wy�wietl napis znajduj�cy si� w $a0)
	
	la $a0, napis_tekst	# Za�aduj do $a0 adres napis_tekst
	
	syscall			# Wy�wietl napis_tekst na ekranie
	
	li $v0, 5		# Za�aduj do $v0 warto�� 5 (kod dla syscall: wczytaj licb� ca�kowit�)
	
	syscall			# Wczytaj liczb� ca�kowit� z klawiatury i za�aduj do $v0
	
	
	bltz $v0, exit		#
				# Zako�cz program, je�li n jest spoza zakresu
	bgt $v0, 523774, exit	#
	
	
	move $t0, $v0		# Przenie� zawarto�� $v0 (warto�� n) do $t0

	add $t1, $t0, $zero	# Ustaw warto�� w $t1 na tak� sam� jak w $t0 (n)
	

	li $t2, 1		# $f4 i $f5 jako zmienna typu double b�dzie przechowywa� licznik wyraz�w ci�gu
				#
	mtc1.d $t2, $f4		# Pocz�tkowa warto�� licznika dla n = 0 to 1
				#
	cvt.d.w $f4, $f4	# Dlatego w $f4 ustawiamy warto�� na 1
	

	li $t2, 1		# $f6 i $f7 jako zmienna typu double b�dzie przechowywa� mianownik wyraz�w ci�gu
				#
	mtc1.d $t2, $f6		# Pocz�tkowa warto�� mianownika dla n = 0 to 1
				#
	cvt.d.w $f6, $f6	# Dlatego w $f6 ustawiamy warto�� na 1
	
	
	li $t2, -1		# Licznik wyrazu ci�gu, to poprzedni licznik * -1
				#
	mtc1.d $t2, $f8		# Dlatego w $f8 ustawiamy warto�� na -1
				#
	cvt.d.w $f8, $f8	# B�dzie on s�u�y� do zmieniania warto�ci licznika
	
	
	li $t2, 2		# Mianownik kolejnego wyrazu ci�gu r�ni si� o 2 wzgl�dem poprzedniego
				#
	mtc1.d $t2, $f10	# W $f10 ustawiamy warto�� na 2
				#
	cvt.d.w $f10, $f10	# Liczba w tym rejestrze b�dzie s�u�y�a do zmiany mianownika

		
wyrazy_ci�gu:			# Obliczamy kolejne wyrazy ci�gu i k�adziemy je na stos, robimy to n razy
	div.d $f0, $f4, $f6	# Zapisz w $f0 wynik dzielenia pomi�dzy licznikiem i mianownikiem kolejnych wyraz�w ci�gu
	
	jal stack_push		# Cz�stkowy wynik umie�� na stosie
	
	mul.d $f4, $f4, $f8	# 
				# Zwi�kszamy mianownik o 2 i mno�ymy licznik przez -1
	add.d $f6, $f6, $f10	#
	
	subi $t0, $t0, 1	# Zmiejsz o 1 warunek trwania p�tli
	
	bgez $t0, wyrazy_ci�gu	# Powtarzaj p�tle n razy 
	
	
	li $t2, 0		# Po sko�czeniu obliczania n wyraz�w ci�gu
				#	
	mtc1.d $t2, $f4		# Chcemy odczyta� ca�kowity wynik
				#
	cvt.d.w $f4, $f4	# W tym celu zerujemy zawarto�� w $f4, gdzie zapiszemy ca�kowity wynik

obliczanie_PI:
	jal stack_pop		# �ci�gnij cz�ciowy wynik ze stosu
	
	add.d $f4, $f4, $f0	# Cz�ciowy wynik dodaj do $f4, gdzie przechowywany jest ca�kowity wynik
	
	subi $t1, $t1, 1	#
				# Powtarzaj n razy	
	bgez $t1, obliczanie_PI	#
	
	
	li $t2, 4		# Za�aduj 4 do rejestru $f6
				#
	mtc1.d $t2, $f6		# W celu pomno�enia wyniku o 4
				#
	cvt.d.w $f6, $f6	# I uzyskanie przybli�onej warto�ci liczby PI
				#
	mul.d $f4, $f4, $f6	#
	

	li $v0, 4		# Za�aduj do $v0 warto�� 4 (kod dla syscall: wy�wietl napis znajduj�cy si� w $a0)
	
	la $a0, napis_PI	# Za�aduj do $a0 adres napis_PI
	
	syscall			# Wy�wietl napis_PI na ekranie
	
	
	li $v0, 3		# Za�aduj do $v0 warto�� 3 (kod dla syscall: wy�wietl liczb� zmiennoprzecinkow� znajduj�c� si� w $f12)
	
	mov.d $f12, $f4		# Przenie� do $f12 wynik programu
	
	syscall			# Wy�wietl obliczon� liczbe PI na ekranie
	
	j exit			# Przejd� do zako�czenia programu
	

stack_push: 	
	addi $sp, $sp, -8	# Obniz $sp o dwa s�owa	
	
	#sdc1 $f0, 0($sp)	
	
	swc1 $f0, 0($sp)	# 
				# Zapisz $f0 na stosie
	swc1 $f1, 4($sp)	#
	
	jr $ra			# Wr�� do callera
	
	
stack_pop: 	
	#ldc1 $f0, 0($sp)	
	
	lwc1 $f0, 0($sp)	#
				# Za�aduj warto�� do $f0
	lwc1 $f1, 4($sp)	#

	addi $sp, $sp, 8	# Zwieksz $sp o podw�jne s�owo
	
	jr $ra			# Wr�� do callera		

									
exit:	
	li $v0, 10 		# Za�aduj do $v0 warto�� 10 (kod dla syscall: koniec programu)

	syscall 		# Koniec programu 
