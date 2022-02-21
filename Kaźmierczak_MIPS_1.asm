# Æwiczenie 1

# Znaczenie u¿ytych rejestrów:

# $t0 – przechowuje pierwsz¹ liczbê (parametr b)

# $t1 – przechwuje drug¹ liczbê (parametr c)

# $t2 – przechwuje drug¹ liczbê (parametr d)

# $t3 – przechowuje wynik równania dla liczb zawartych w rejestrach $t0, $t1 i $t2

# $v0 – przechowuje stosowny parametr dla wywo³ania systemowego syscall lub wczytan¹ wartoœæ wejœciow¹

# $a0 – przechowuje parametr wywo³ania systemowego syscall


	.data

napis1:	.asciiz "1) a = b *(c - d)\n2) a = b /(c + d)\n3) a = b * c - d\nNumer wyrazenia, ktorego wartosc nalezy obliczyc: "

napis2:	.asciiz "Podaj wartosci zmiennych: "

napis_b:	.asciiz "\nb = "

napis_c:	.asciiz "c = "

napis_d:	.asciiz "d = "

napis_wynik:	.asciiz "Wartosc wyrazenia wynosi: "

napis_b³êdna_wartoœæ:	.asciiz "Wpisano bledna wartosc."

napis_dzielenie_przez_0:	.asciiz "Nie da sie dzielic przez zero."

napis_pytanie:	.asciiz "\nCzy kontynuowac? (tak - 1, nie - dowolna, nierowna 1 liczba calkowita): "

	.text


main:	li $v0, 4	# Za³aduj do $v0 wartoœæ 4 (kod dla syscall: wyœwietl napis znajduj¹cy siê w $a0)
	
	la $a0, napis1	# Za³aduj do $a0 adres napis1
	
	syscall		# Wyœwietl napis1 (wybór równania) na ekranie
	

	li $v0, 5	# Za³aduj do $v0 wartoœæ 5 (kod dla syscall: wczytaj licbê ca³kowit¹)
	
	syscall		# Wczytaj liczbê ca³kowit¹ z klawiatury i za³aduj do $v0

	
	beq $v0, 1, funkcja_1		# Jeœli wpisano 1 to wykonaj dzia³anie pierwsze
	
	beq $v0, 2, funkcja_2		# Jeœli wpisano 2 to wykonaj dzia³anie drugie
	
	beq $v0, 3, funkcja_3		# Jeœli wpisano 3 to wykonaj dzia³anie trzecie
		
	
	li $v0, 4			# Za³aduj do $v0 wartoœæ 4 (kod dla syscall: wyœwietl napis znajduj¹cy siê w $a0)
	
	la $a0, napis_b³êdna_wartoœæ	# Za³aduj do $a0 adres napis_b³êdna_wartoœæ
	
	syscall				# Wyœwietl napis_b³êdna_wartoœæ na ekranie
	
	j pêtla				# PrzejdŸ do warunku pêtli
	
	

# a = b * (c - d)
funkcja_1:	jal wpisz_wartoœci	# PrzejdŸ do wpisywania wartoœci dla poszczególnych parametrów
	
	sub $t3, $t1, $t2	# Za³aduj do $t3 wynik odejmowania $t1 i $t2 (c - d)
		
	mult $t0, $t3		# Wykonaj mno¿enie pomiêdzy $t0 i $t3 [b * (c - d)]
		
	mflo $t3		# Przenieœ wynik mno¿enia z rejestru lo do $t3
	
	j wyœwietl_wynik	# PrzejdŸ do wyœwietlania wyniku równania
	
	
	
# a = b / (c + d)
funkcja_2:	jal wpisz_wartoœci	# PrzejdŸ do wpisywania wartoœci dla poszczególnych parametrów

	add $t3, $t1, $t2		# Za³aduj do $t3 wynik dodawania $t1 i $t2 (c + d)
	
	beqz $t3, dzielenie_przez_0	# Jeœli $t3 (c + d) jest równy 0 to przejdŸ do dzielenie_przez_0  
		
	div $t0, $t3			# Wykonaj dzielenie pomiêdzy $t0 i $t3 [b / (c + d)]
		
	mflo $t3			# Przenieœ wynik z dzielenia (liczba ca³kowita, bez czêœci u³amkowej) z rejestru lo do $t3
	
	j wyœwietl_wynik		# PrzejdŸ do wyœwietlania wyniku równania


	
# a = b * c - d
funkcja_3:	jal wpisz_wartoœci	# PrzejdŸ do wpisywania wartoœci dla poszczególnych parametrów

	mult $t0, $t1		# Wykonaj mno¿enie pomiêdzy $t0 i $t1 (b * c)
		
	mflo $t3		# Przenieœ wynik mno¿enia z rejestru lo do $t3
	
	sub $t3, $t3, $t2	# Za³aduj do $t3 wynik odejmowania $t3 i $t2 (b * c - d)
	
	j wyœwietl_wynik	# PrzejdŸ do wyœwietlania wyniku równania
	


dzielenie_przez_0:	li $v0, 4	# Za³aduj do $v0 wartoœæ 4 (kod dla syscall: wyœwietl napis znajduj¹cy siê w $a0)
	
	la $a0, napis_dzielenie_przez_0	# Za³aduj do $a0 adres napis_dzielenie_przez_0
	
	syscall				# Wyœwietl napis_dzielenie_przez_0 na ekranie
	
	j pêtla				# PrzejdŸ do warunku pêtli



wpisz_wartoœci:	li $v0, 4	# Za³aduj do $v0 wartoœæ 4 (kod dla syscall: wyœwietl napis znajduj¹cy siê w $a0)
	
	la $a0, napis2		# Za³aduj do $a0 adres napis2
	
	syscall			# Wyœwietl napis2 na ekranie
	
	
	la $a0, napis_b # Za³aduj do $a0 adres napis_b
	
	syscall		# Wyœwietl napis_b na ekranie
	

	li $v0, 5	# Za³aduj do $v0 wartoœæ 5 (kod dla syscall: wczytaj licbê ca³kowit¹)
	
	syscall		# Wczytaj liczbê ca³kowit¹ z klawiatury 
	
	move $t0, $v0	# Przenieœ wczytan¹ liczbe do rejestru $t0 (parametr b)
	
	
	li $v0, 4	# Za³aduj do $v0 wartoœæ 4 (kod dla syscall: wyœwietl napis znajduj¹cy siê w $a0)
	
	la $a0, napis_c	# Za³aduj do $a0 adres napis_c
	
	syscall		# Wyœwietl napis_c na ekranie
	

	li $v0, 5	# Za³aduj do $v0 wartoœæ 5 (kod dla syscall wczytaj: licbê ca³kowit¹)
	
	syscall		# Wczytaj liczbê ca³kowit¹ z klawiatury 
	
	move $t1, $v0	# Przenieœ wczytan¹ liczbe do rejestru $t1 (parametr c)
	
	
	li $v0, 4	# Za³aduj do $v0 wartoœæ 4 (kod dla syscall: wyœwietl napis znajduj¹cy siê w $a0)
	
	la $a0, napis_d	# Za³aduj do $a0 adres napis_d
	
	syscall		# Wyœwietl napis_d na ekranie
	

	li $v0, 5	# Za³aduj do $v0 wartoœæ 5 (kod dla syscall: wczytaj licbê ca³kowit¹)
	
	syscall		# Wczytaj liczbê ca³kowit¹ z klawiatury 
	
	move $t2, $v0	# Przenieœ wczytan¹ liczbe do rejestru $t2 (parametr d)
	
	jr $ra		# Wróæ do odpowiedniego równania
	
	
	
wyœwietl_wynik:	li $v0, 4	# Za³aduj do $v0 wartoœæ 4 (kod dla syscall: wyœwietl napis znajduj¹cy siê w $a0)
	
	la $a0, napis_wynik	# Za³aduj do $a0 adres napis_wynik
	
	syscall			# Wyœwietl napis_wynik na ekranie
	
	move $a0, $t3		# Przenieœ do rejestru $a0 zawartoœæ $t3 (wynik równania)
	
	li $v0, 1		# Za³aduj do $v0 wartoœæ 1 (kod dla syscall: wyœwietl liczbê ca³kowit¹ znajduj¹c¹ siê w $a0)
	
	syscall			# Wyœwietl wynik równania na ekranie



pêtla:	li $v0, 4		# Za³aduj do $v0 wartoœæ 4 (kod dla syscall: wyœwietl napis znajduj¹cy siê w $a0)
	
	la $a0, napis_pytanie	# Za³aduj do $a0 adres napis_pytanie
	
	syscall			# Wyœwietl napis_pytanie na ekranie
	

	li $v0, 5		# Za³aduj do $v0 wartoœæ 5 (kod dla syscall: wczytaj licbê ca³kowit¹)
	
	syscall			# Wczytaj liczbê ca³kowit¹ z klawiatury 
	
	
	beq $v0, 1, main	# Jeœli wpisano 1 to rozpocznij dzia³anie programu od pocz¹tku
	
	beq $v0, 0, exit	# Jeœli wpisano 0 to przejdŸ do exit
	
	
	li $v0, 4			# Za³aduj do $v0 wartoœæ 4 (kod dla syscall: wyœwietl napis znajduj¹cy siê w $a0)
	
	la $a0, napis_b³êdna_wartoœæ	# Za³aduj do $a0 adres napis_b³êdna_wartoœæ
	
	syscall				# Wyœwietl napis_pytanie na ekranie
	
	j pêtla
					
				
exit:	li $v0, 10 		# Za³aduj do $v0 wartoœæ 10 (kod dla syscall: koniec programu)

	syscall 		# Koniec programu 
