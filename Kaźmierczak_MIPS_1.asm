# �wiczenie 1

# Znaczenie u�ytych rejestr�w:

# $t0 � przechowuje pierwsz� liczb� (parametr b)

# $t1 � przechwuje drug� liczb� (parametr c)

# $t2 � przechwuje drug� liczb� (parametr d)

# $t3 � przechowuje wynik r�wnania dla liczb zawartych w rejestrach $t0, $t1 i $t2

# $v0 � przechowuje stosowny parametr dla wywo�ania systemowego syscall lub wczytan� warto�� wej�ciow�

# $a0 � przechowuje parametr wywo�ania systemowego syscall


	.data

napis1:	.asciiz "1) a = b *(c - d)\n2) a = b /(c + d)\n3) a = b * c - d\nNumer wyrazenia, ktorego wartosc nalezy obliczyc: "

napis2:	.asciiz "Podaj wartosci zmiennych: "

napis_b:	.asciiz "\nb = "

napis_c:	.asciiz "c = "

napis_d:	.asciiz "d = "

napis_wynik:	.asciiz "Wartosc wyrazenia wynosi: "

napis_b��dna_warto��:	.asciiz "Wpisano bledna wartosc."

napis_dzielenie_przez_0:	.asciiz "Nie da sie dzielic przez zero."

napis_pytanie:	.asciiz "\nCzy kontynuowac? (tak - 1, nie - dowolna, nierowna 1 liczba calkowita): "

	.text


main:	li $v0, 4	# Za�aduj do $v0 warto�� 4 (kod dla syscall: wy�wietl napis znajduj�cy si� w $a0)
	
	la $a0, napis1	# Za�aduj do $a0 adres napis1
	
	syscall		# Wy�wietl napis1 (wyb�r r�wnania) na ekranie
	

	li $v0, 5	# Za�aduj do $v0 warto�� 5 (kod dla syscall: wczytaj licb� ca�kowit�)
	
	syscall		# Wczytaj liczb� ca�kowit� z klawiatury i za�aduj do $v0

	
	beq $v0, 1, funkcja_1		# Je�li wpisano 1 to wykonaj dzia�anie pierwsze
	
	beq $v0, 2, funkcja_2		# Je�li wpisano 2 to wykonaj dzia�anie drugie
	
	beq $v0, 3, funkcja_3		# Je�li wpisano 3 to wykonaj dzia�anie trzecie
		
	
	li $v0, 4			# Za�aduj do $v0 warto�� 4 (kod dla syscall: wy�wietl napis znajduj�cy si� w $a0)
	
	la $a0, napis_b��dna_warto��	# Za�aduj do $a0 adres napis_b��dna_warto��
	
	syscall				# Wy�wietl napis_b��dna_warto�� na ekranie
	
	j p�tla				# Przejd� do warunku p�tli
	
	

# a = b * (c - d)
funkcja_1:	jal wpisz_warto�ci	# Przejd� do wpisywania warto�ci dla poszczeg�lnych parametr�w
	
	sub $t3, $t1, $t2	# Za�aduj do $t3 wynik odejmowania $t1 i $t2 (c - d)
		
	mult $t0, $t3		# Wykonaj mno�enie pomi�dzy $t0 i $t3 [b * (c - d)]
		
	mflo $t3		# Przenie� wynik mno�enia z rejestru lo do $t3
	
	j wy�wietl_wynik	# Przejd� do wy�wietlania wyniku r�wnania
	
	
	
# a = b / (c + d)
funkcja_2:	jal wpisz_warto�ci	# Przejd� do wpisywania warto�ci dla poszczeg�lnych parametr�w

	add $t3, $t1, $t2		# Za�aduj do $t3 wynik dodawania $t1 i $t2 (c + d)
	
	beqz $t3, dzielenie_przez_0	# Je�li $t3 (c + d) jest r�wny 0 to przejd� do dzielenie_przez_0  
		
	div $t0, $t3			# Wykonaj dzielenie pomi�dzy $t0 i $t3 [b / (c + d)]
		
	mflo $t3			# Przenie� wynik z dzielenia (liczba ca�kowita, bez cz�ci u�amkowej) z rejestru lo do $t3
	
	j wy�wietl_wynik		# Przejd� do wy�wietlania wyniku r�wnania


	
# a = b * c - d
funkcja_3:	jal wpisz_warto�ci	# Przejd� do wpisywania warto�ci dla poszczeg�lnych parametr�w

	mult $t0, $t1		# Wykonaj mno�enie pomi�dzy $t0 i $t1 (b * c)
		
	mflo $t3		# Przenie� wynik mno�enia z rejestru lo do $t3
	
	sub $t3, $t3, $t2	# Za�aduj do $t3 wynik odejmowania $t3 i $t2 (b * c - d)
	
	j wy�wietl_wynik	# Przejd� do wy�wietlania wyniku r�wnania
	


dzielenie_przez_0:	li $v0, 4	# Za�aduj do $v0 warto�� 4 (kod dla syscall: wy�wietl napis znajduj�cy si� w $a0)
	
	la $a0, napis_dzielenie_przez_0	# Za�aduj do $a0 adres napis_dzielenie_przez_0
	
	syscall				# Wy�wietl napis_dzielenie_przez_0 na ekranie
	
	j p�tla				# Przejd� do warunku p�tli



wpisz_warto�ci:	li $v0, 4	# Za�aduj do $v0 warto�� 4 (kod dla syscall: wy�wietl napis znajduj�cy si� w $a0)
	
	la $a0, napis2		# Za�aduj do $a0 adres napis2
	
	syscall			# Wy�wietl napis2 na ekranie
	
	
	la $a0, napis_b # Za�aduj do $a0 adres napis_b
	
	syscall		# Wy�wietl napis_b na ekranie
	

	li $v0, 5	# Za�aduj do $v0 warto�� 5 (kod dla syscall: wczytaj licb� ca�kowit�)
	
	syscall		# Wczytaj liczb� ca�kowit� z klawiatury 
	
	move $t0, $v0	# Przenie� wczytan� liczbe do rejestru $t0 (parametr b)
	
	
	li $v0, 4	# Za�aduj do $v0 warto�� 4 (kod dla syscall: wy�wietl napis znajduj�cy si� w $a0)
	
	la $a0, napis_c	# Za�aduj do $a0 adres napis_c
	
	syscall		# Wy�wietl napis_c na ekranie
	

	li $v0, 5	# Za�aduj do $v0 warto�� 5 (kod dla syscall wczytaj: licb� ca�kowit�)
	
	syscall		# Wczytaj liczb� ca�kowit� z klawiatury 
	
	move $t1, $v0	# Przenie� wczytan� liczbe do rejestru $t1 (parametr c)
	
	
	li $v0, 4	# Za�aduj do $v0 warto�� 4 (kod dla syscall: wy�wietl napis znajduj�cy si� w $a0)
	
	la $a0, napis_d	# Za�aduj do $a0 adres napis_d
	
	syscall		# Wy�wietl napis_d na ekranie
	

	li $v0, 5	# Za�aduj do $v0 warto�� 5 (kod dla syscall: wczytaj licb� ca�kowit�)
	
	syscall		# Wczytaj liczb� ca�kowit� z klawiatury 
	
	move $t2, $v0	# Przenie� wczytan� liczbe do rejestru $t2 (parametr d)
	
	jr $ra		# Wr�� do odpowiedniego r�wnania
	
	
	
wy�wietl_wynik:	li $v0, 4	# Za�aduj do $v0 warto�� 4 (kod dla syscall: wy�wietl napis znajduj�cy si� w $a0)
	
	la $a0, napis_wynik	# Za�aduj do $a0 adres napis_wynik
	
	syscall			# Wy�wietl napis_wynik na ekranie
	
	move $a0, $t3		# Przenie� do rejestru $a0 zawarto�� $t3 (wynik r�wnania)
	
	li $v0, 1		# Za�aduj do $v0 warto�� 1 (kod dla syscall: wy�wietl liczb� ca�kowit� znajduj�c� si� w $a0)
	
	syscall			# Wy�wietl wynik r�wnania na ekranie



p�tla:	li $v0, 4		# Za�aduj do $v0 warto�� 4 (kod dla syscall: wy�wietl napis znajduj�cy si� w $a0)
	
	la $a0, napis_pytanie	# Za�aduj do $a0 adres napis_pytanie
	
	syscall			# Wy�wietl napis_pytanie na ekranie
	

	li $v0, 5		# Za�aduj do $v0 warto�� 5 (kod dla syscall: wczytaj licb� ca�kowit�)
	
	syscall			# Wczytaj liczb� ca�kowit� z klawiatury 
	
	
	beq $v0, 1, main	# Je�li wpisano 1 to rozpocznij dzia�anie programu od pocz�tku
	
	beq $v0, 0, exit	# Je�li wpisano 0 to przejd� do exit
	
	
	li $v0, 4			# Za�aduj do $v0 warto�� 4 (kod dla syscall: wy�wietl napis znajduj�cy si� w $a0)
	
	la $a0, napis_b��dna_warto��	# Za�aduj do $a0 adres napis_b��dna_warto��
	
	syscall				# Wy�wietl napis_pytanie na ekranie
	
	j p�tla
					
				
exit:	li $v0, 10 		# Za�aduj do $v0 warto�� 10 (kod dla syscall: koniec programu)

	syscall 		# Koniec programu 
