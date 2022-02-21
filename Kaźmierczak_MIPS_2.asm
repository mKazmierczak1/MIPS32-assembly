# �wiczenie 2

# Znaczenie u�ytych rejestr�w:

# $t0 � przechwuje informacje nt. wyboru operacji

# $t1 � przechowuje klucz przekszta�cenia

# $t2 � przechwuje adres wpisanego tekstu

# $t3 � przechowuje index dla napisu wynikowego

# $t4 � przechowuje pojedynczy znak z tekstu wej�ciowego

# $t5 � przechowuje kod ASCII znaku po przekszta�ceniu

# $v0 � przechowuje stosowny parametr dla wywo�ania systemowego syscall lub wczytan� warto�� wej�ciow�

# $a0 � przechowuje parametr wywo�ania systemowego syscall

# $a1 � przechowuje parametr wywo�ania systemowego syscall

	.data

tekst: .space 51

wynik: .space 51

napis_operacja:	.asciiz "\nWybierz operacje, ktora ma byc wykonana: \nS - szyfrowanie, D - deszyfrowanie: "

napis_klucz:	.asciiz "\nPodaj klucz przeksztalcenia (liczba naturalna z przedzialu od 0 do 25): "

napis_tekst:	.asciiz "\nPodaj tekst (maks. 50 znakow): "

napis_b��dna_warto��:	.asciiz "\nWpisano bledna wartosc."

	.text


main:	li $v0, 4		# Za�aduj do $v0 warto�� 4 (kod dla syscall: wy�wietl napis znajduj�cy si� w $a0)
	
	la $a0, napis_operacja	# Za�aduj do $a0 adres napis_operacja
	
	syscall			# Wy�wietl napis_operacja (wyb�r operacji) na ekranie
	

	li $v0, 12		# Za�aduj do $v0 warto�� 12 (kod dla syscall: wczytaj znak)
	
	syscall			# Wczytaj znak z klawiatury i za�aduj do $v0
	
	move $t0, $v0			# Przenie� wczytan� znak do rejestru $t0
	
	beq $t0, 83, wpisz_klucz	# Je�li wpisano 'S' (ASCII - 83) to przejd� do wpisywania klucza
	
	beq $t0, 68, wpisz_klucz	# Je�li wpisano 'D' (ASCII - 68) to przejd� do wpisywania klucza
	
	
	li $v0, 4		# Za�aduj do $v0 warto�� 4 (kod dla syscall: wy�wietl napis znajduj�cy si� w $a0)
	
	la $a0, napis_b��dna_warto��	# Za�aduj do $a0 adres napis_b��dna_warto��
	
	syscall			# Wy�wietl napis_b��dna_warto�� na ekranie
	
	j main			# Wr�� na pocz�tek programu
	
	
wpisz_klucz:	li $v0, 4	# Za�aduj do $v0 warto�� 4 (kod dla syscall: wy�wietl napis znajduj�cy si� w $a0)
	
	la $a0, napis_klucz	# Za�aduj do $a0 adres napis_klucz
	
	syscall			# Wy�wietl napis_klucz na ekranie
	
	
	li $v0, 5		# Za�aduj do $v0 warto�� 5 (kod dla syscall: wczytaj licb� ca�kowit�)
	
	syscall			# Wczytaj liczb� ca�kowit� z klawiatury i za�aduj do $v0
	
	move $t1, $v0		# Przenie� wczytan� liczb� do rejestru $t1
	
	
	bgt $t1, 25, b��dny_klucz	# Je�li wpisana liczba nie jest z przeddzia�u [0, 25] 
					# to przejd� do b��dny_klucz
	bltz $t1, b��dny_klucz		# 


wpisz_tekst:	li $v0, 4	# Za�aduj do $v0 warto�� 4 (kod dla syscall: wy�wietl napis znajduj�cy si� w $a0)
	
	la $a0, napis_tekst	# Za�aduj do $a0 adres napis_tekst
	
	syscall			# Wy�wietl napis_tekst na ekranie
	
	
	li $v0, 8		# Za�aduj do $v0 warto�� 8 (kod dla syscall: wczytaj napis)
	
	la $a0, tekst		# Wczytaj adres tekst do rejestru $a0
	
	li $a1, 51		# Ustaw warto�� rejestru $a1 na 51 (w celu ustalenia d�ugo�ci tekstu na 50 znak�w)
	
	syscall			# Wczytaj napis z klawiatury i za�aduj do $v0
		
	la $t2, tekst		# Wczytaj adres pocz�tku tesktu w $t2
	
	li $t3, 0		# Ustaw warto�� $t3 na 0(b�dzie to index dla napisu wynikowego)


	beq $t0, 83, szyfrowanie	# Je�li wybrana opercaja to 'S' to przejd� do szyfrowania

	beq $t0, 68, deszyfrowanie	# Je�li wybrana opercaja to 'D' to przejd� do deszyfrowania

	
pomi�_znaki_S:	addu $t2, $t2, 1 	# Przesuni�cie o 1, je�li znak nie jest du�� liter�		
				
szyfrowanie:	lb $t4, ($t2)		# Wczytanie kolejnego znaku z tekst i zapisanie go do $t4

	beqz $t4, wy�wietl_wynik	# Jezeli znak r�wna si� '0' to przejd� do wy�wietlania wyniku
	
	blt $t4, 65, pomi�_znaki_S	# Jezeli znak to nie litera z przedzia�u A-Z (ASCII - [65, 90])
					# to przejd� do pomijania znaku
	bgt $t4, 90, pomi�_znaki_S	#
	
	
	sub $t5, $t4, 65		# Zapisz w $t5 wynik odejmowania $t4 (kod ASCII znaku) i 65
	
	add $t5, $t5, $t1		# Dodaj przesuni�cie 
	
	div $t5, $t5, 26		# Wykonaj dzielenie warto�ci w $t5 przez 26
	
	mfhi $t5			# Przenie� do $t5 reszte z dzielenia przez 26
	
	add $t4, $t5, 65		# Wynik w postaci liczby z zakresu [65, 90] zapisz w $t4 

	sb $t4, wynik($t3)		# Zapisz znak w wyniku
	
	addu $t2, $t2, 1		# Dodaj 1 do obecnej warto�ci w $t2
	
	addu $t3, $t3, 1		# Dodaj 1 do obecnej warto�ci w $t3
	
	
	j szyfrowanie			# Wykonaj ponownie p�tle (przejd� do szyfrowanie)

	
pomi�_znaki_D:	addu $t2, $t2, 1 	# Przesuni�cie o 1, je�li znak nie jest du�� liter�			
	
deszyfrowanie:	lb $t4, ($t2)		# Wczytanie kolejnego znaku z tekst i zapisanie go do $t4
	
	beqz $t4, wy�wietl_wynik	# Jezeli znak r�wna si� '0' to przejd� do wy�wietlania wyniku
	
	blt $t4, 65, pomi�_znaki_D	# Jezeli znak to nie litera z przedzia�u A-Z (ASCII - [65, 90])
					# to przejd� do pomijania znaku
	bgt $t4, 90, pomi�_znaki_D	#
	
	
	sub $t5, $t4, 39		# Zapisz w $t5 wynik odejmowania $t4 (kod ASCII znaku) i 39 (-64 + 26 = -39)
	
	sub $t5, $t5, $t1		# Odejmij przesuni�cie 
	
	div $t5, $t5, 26		# Wykonaj dzielenie warto�ci w $t5 przez 26
	
	mfhi $t5			# Przenie� do $t5 reszte z dzielenia przez 26
	
	add $t4, $t5, 65		# Wynik w postaci liczby z zakresu [65, 90] zapisz w $t4 

	sb $t4, wynik($t3)		# Zapisz znak w wyniku
	
	addu $t2, $t2, 1		# Dodaj 1 do obecnej warto�ci w $t2
	
	addu $t3, $t3, 1		# Dodaj 1 do obecnej warto�ci w $t3
	
	
	j deszyfrowanie			# Wykonaj ponownie p�tle (przejd� do deszyfrowanie)


b��dny_klucz:	li $v0, 4			# Za�aduj do $v0 warto�� 4 (kod dla syscall: wy�wietl napis znajduj�cy si� w $a0)
	
		la $a0, napis_b��dna_warto��	# Za�aduj do $a0 adres napis_b��dna_warto��
	
		syscall				# Wy�wietl napis_b��dna_warto�� na ekranie
	
		j wpisz_klucz			# Wr�� do wpisywania klucza


wy�wietl_wynik: li $t4, 0	# Za�aduj do rejestru $t4 0

	sb $t4, wynik($t3)	# Zapisz znak '0' w wyniku
	
	
	li $v0, 4		# Za�aduj do $v0 warto�� 4 (kod dla syscall: wy�wietl napis znajduj�cy si� w $a0)
	
	la $a0, wynik		# Za�aduj do $a0 adres wynik
	
	syscall			# Wy�wietl tekst wynikowy na ekranie


exit:	li $v0, 10 		# Za�aduj do $v0 warto�� 10 (kod dla syscall: koniec programu)

	syscall 		# Koniec programu 
