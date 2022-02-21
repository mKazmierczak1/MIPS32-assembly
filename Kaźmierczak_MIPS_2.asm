# Æwiczenie 2

# Znaczenie u¿ytych rejestrów:

# $t0 – przechwuje informacje nt. wyboru operacji

# $t1 – przechowuje klucz przekszta³cenia

# $t2 – przechwuje adres wpisanego tekstu

# $t3 – przechowuje index dla napisu wynikowego

# $t4 – przechowuje pojedynczy znak z tekstu wejœciowego

# $t5 – przechowuje kod ASCII znaku po przekszta³ceniu

# $v0 – przechowuje stosowny parametr dla wywo³ania systemowego syscall lub wczytan¹ wartoœæ wejœciow¹

# $a0 – przechowuje parametr wywo³ania systemowego syscall

# $a1 – przechowuje parametr wywo³ania systemowego syscall

	.data

tekst: .space 51

wynik: .space 51

napis_operacja:	.asciiz "\nWybierz operacje, ktora ma byc wykonana: \nS - szyfrowanie, D - deszyfrowanie: "

napis_klucz:	.asciiz "\nPodaj klucz przeksztalcenia (liczba naturalna z przedzialu od 0 do 25): "

napis_tekst:	.asciiz "\nPodaj tekst (maks. 50 znakow): "

napis_b³êdna_wartoœæ:	.asciiz "\nWpisano bledna wartosc."

	.text


main:	li $v0, 4		# Za³aduj do $v0 wartoœæ 4 (kod dla syscall: wyœwietl napis znajduj¹cy siê w $a0)
	
	la $a0, napis_operacja	# Za³aduj do $a0 adres napis_operacja
	
	syscall			# Wyœwietl napis_operacja (wybór operacji) na ekranie
	

	li $v0, 12		# Za³aduj do $v0 wartoœæ 12 (kod dla syscall: wczytaj znak)
	
	syscall			# Wczytaj znak z klawiatury i za³aduj do $v0
	
	move $t0, $v0			# Przenieœ wczytan¹ znak do rejestru $t0
	
	beq $t0, 83, wpisz_klucz	# Jeœli wpisano 'S' (ASCII - 83) to przejdŸ do wpisywania klucza
	
	beq $t0, 68, wpisz_klucz	# Jeœli wpisano 'D' (ASCII - 68) to przejdŸ do wpisywania klucza
	
	
	li $v0, 4		# Za³aduj do $v0 wartoœæ 4 (kod dla syscall: wyœwietl napis znajduj¹cy siê w $a0)
	
	la $a0, napis_b³êdna_wartoœæ	# Za³aduj do $a0 adres napis_b³êdna_wartoœæ
	
	syscall			# Wyœwietl napis_b³êdna_wartoœæ na ekranie
	
	j main			# Wróæ na pocz¹tek programu
	
	
wpisz_klucz:	li $v0, 4	# Za³aduj do $v0 wartoœæ 4 (kod dla syscall: wyœwietl napis znajduj¹cy siê w $a0)
	
	la $a0, napis_klucz	# Za³aduj do $a0 adres napis_klucz
	
	syscall			# Wyœwietl napis_klucz na ekranie
	
	
	li $v0, 5		# Za³aduj do $v0 wartoœæ 5 (kod dla syscall: wczytaj licbê ca³kowit¹)
	
	syscall			# Wczytaj liczbê ca³kowit¹ z klawiatury i za³aduj do $v0
	
	move $t1, $v0		# Przenieœ wczytan¹ liczbê do rejestru $t1
	
	
	bgt $t1, 25, b³êdny_klucz	# Jeœli wpisana liczba nie jest z przeddzia³u [0, 25] 
					# to przejdŸ do b³êdny_klucz
	bltz $t1, b³êdny_klucz		# 


wpisz_tekst:	li $v0, 4	# Za³aduj do $v0 wartoœæ 4 (kod dla syscall: wyœwietl napis znajduj¹cy siê w $a0)
	
	la $a0, napis_tekst	# Za³aduj do $a0 adres napis_tekst
	
	syscall			# Wyœwietl napis_tekst na ekranie
	
	
	li $v0, 8		# Za³aduj do $v0 wartoœæ 8 (kod dla syscall: wczytaj napis)
	
	la $a0, tekst		# Wczytaj adres tekst do rejestru $a0
	
	li $a1, 51		# Ustaw wartoœæ rejestru $a1 na 51 (w celu ustalenia d³ugoœci tekstu na 50 znaków)
	
	syscall			# Wczytaj napis z klawiatury i za³aduj do $v0
		
	la $t2, tekst		# Wczytaj adres pocz¹tku tesktu w $t2
	
	li $t3, 0		# Ustaw wartoœæ $t3 na 0(bêdzie to index dla napisu wynikowego)


	beq $t0, 83, szyfrowanie	# Jeœli wybrana opercaja to 'S' to przejdŸ do szyfrowania

	beq $t0, 68, deszyfrowanie	# Jeœli wybrana opercaja to 'D' to przejdŸ do deszyfrowania

	
pomiñ_znaki_S:	addu $t2, $t2, 1 	# Przesuniêcie o 1, jeœli znak nie jest du¿¹ liter¹		
				
szyfrowanie:	lb $t4, ($t2)		# Wczytanie kolejnego znaku z tekst i zapisanie go do $t4

	beqz $t4, wyœwietl_wynik	# Jezeli znak równa siê '0' to przejdŸ do wyœwietlania wyniku
	
	blt $t4, 65, pomiñ_znaki_S	# Jezeli znak to nie litera z przedzia³u A-Z (ASCII - [65, 90])
					# to przejdŸ do pomijania znaku
	bgt $t4, 90, pomiñ_znaki_S	#
	
	
	sub $t5, $t4, 65		# Zapisz w $t5 wynik odejmowania $t4 (kod ASCII znaku) i 65
	
	add $t5, $t5, $t1		# Dodaj przesuniêcie 
	
	div $t5, $t5, 26		# Wykonaj dzielenie wartoœci w $t5 przez 26
	
	mfhi $t5			# Przenieœ do $t5 reszte z dzielenia przez 26
	
	add $t4, $t5, 65		# Wynik w postaci liczby z zakresu [65, 90] zapisz w $t4 

	sb $t4, wynik($t3)		# Zapisz znak w wyniku
	
	addu $t2, $t2, 1		# Dodaj 1 do obecnej wartoœci w $t2
	
	addu $t3, $t3, 1		# Dodaj 1 do obecnej wartoœci w $t3
	
	
	j szyfrowanie			# Wykonaj ponownie pêtle (przejdŸ do szyfrowanie)

	
pomiñ_znaki_D:	addu $t2, $t2, 1 	# Przesuniêcie o 1, jeœli znak nie jest du¿¹ liter¹			
	
deszyfrowanie:	lb $t4, ($t2)		# Wczytanie kolejnego znaku z tekst i zapisanie go do $t4
	
	beqz $t4, wyœwietl_wynik	# Jezeli znak równa siê '0' to przejdŸ do wyœwietlania wyniku
	
	blt $t4, 65, pomiñ_znaki_D	# Jezeli znak to nie litera z przedzia³u A-Z (ASCII - [65, 90])
					# to przejdŸ do pomijania znaku
	bgt $t4, 90, pomiñ_znaki_D	#
	
	
	sub $t5, $t4, 39		# Zapisz w $t5 wynik odejmowania $t4 (kod ASCII znaku) i 39 (-64 + 26 = -39)
	
	sub $t5, $t5, $t1		# Odejmij przesuniêcie 
	
	div $t5, $t5, 26		# Wykonaj dzielenie wartoœci w $t5 przez 26
	
	mfhi $t5			# Przenieœ do $t5 reszte z dzielenia przez 26
	
	add $t4, $t5, 65		# Wynik w postaci liczby z zakresu [65, 90] zapisz w $t4 

	sb $t4, wynik($t3)		# Zapisz znak w wyniku
	
	addu $t2, $t2, 1		# Dodaj 1 do obecnej wartoœci w $t2
	
	addu $t3, $t3, 1		# Dodaj 1 do obecnej wartoœci w $t3
	
	
	j deszyfrowanie			# Wykonaj ponownie pêtle (przejdŸ do deszyfrowanie)


b³êdny_klucz:	li $v0, 4			# Za³aduj do $v0 wartoœæ 4 (kod dla syscall: wyœwietl napis znajduj¹cy siê w $a0)
	
		la $a0, napis_b³êdna_wartoœæ	# Za³aduj do $a0 adres napis_b³êdna_wartoœæ
	
		syscall				# Wyœwietl napis_b³êdna_wartoœæ na ekranie
	
		j wpisz_klucz			# Wróæ do wpisywania klucza


wyœwietl_wynik: li $t4, 0	# Za³aduj do rejestru $t4 0

	sb $t4, wynik($t3)	# Zapisz znak '0' w wyniku
	
	
	li $v0, 4		# Za³aduj do $v0 wartoœæ 4 (kod dla syscall: wyœwietl napis znajduj¹cy siê w $a0)
	
	la $a0, wynik		# Za³aduj do $a0 adres wynik
	
	syscall			# Wyœwietl tekst wynikowy na ekranie


exit:	li $v0, 10 		# Za³aduj do $v0 wartoœæ 10 (kod dla syscall: koniec programu)

	syscall 		# Koniec programu 
