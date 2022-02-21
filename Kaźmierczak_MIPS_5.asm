# �wiczenie 5

	.data
	
wyb�r_znaku: .asciiz "Wybierz znak wpisujac 'x' albo 'o': "

z�y_znak: .asciiz "\nNiepoprawny znak\n"

ilo��_rund: .asciiz "\nWpisz ilosc rund (od 1 do 5): "

z�a_ilo��_rund: .asciiz "\nPodano niepoprawna ilosc rund\n"

pozycja: .asciiz "\nPodaj numer pozycji: "

z�a_pozycja: .asciiz "\nNiepoprawna pozycja\n"

zaj�ta_pozycja: .asciiz "\nPozycja zajeta\n"

numery_p�l: .asciiz "\n1 2 3\n4 5 6\n7 8 9\n"

wygrana_g: .asciiz "Wygrana gracza\n"

wygrana_k: .asciiz "Wygrana komputera\n"

remis: .asciiz "Remis\n"

koniec: .asciiz "Koniec gry\nWyniki rund:"

wynik_g: .asciiz "\nGracz: "

wynik_k: .asciiz "\nKomputer: "

wynik_r: .asciiz "\nRemis: "

tab_pom: .byte 0, 0, 0, 0, 0, 0, 0, 0	# 1, 2, 3 rz�d, 1, 2, 3 kolumna, 1 i 2 przek�tna

	.text
	
main:
	li $v0, 4		# Za�aduj do $v0 warto�� 4 (kod dla syscall: wy�wietl napis znajduj�cy si� w $a0)
	la $a0, wyb�r_znaku	# Za�aduj do $a0 adres wyb�r_znaku	
	syscall			# Wy�wietl wyb�r_znaku na ekranie
	
	li $v0, 12		# Za�aduj do $v0 warto�� 12 (kod dla syscall: wczytaj znak)
	syscall			# Wczytaj znak z klawiatury i za�aduj do $v0
	move $t0, $v0
	
	
	beq $t0, 120, ustaw_komp_na_o	#
	beq $t0, 111, ustaw_komp_na_x	# Ustal znak komputera
	
	
	li $v0, 4		# Za�aduj do $v0 warto�� 4 (kod dla syscall: wy�wietl napis znajduj�cy si� w $a0)
	la $a0, z�y_znak	# Za�aduj do $a0 adres z�y_znak
	syscall			# Wy�wietl z�y_znak na ekranie
	
	j main			# Je�li wybrano z�y znak, to zacznij ponownie


liczba_rund: 
	li $v0, 4		# Za�aduj do $v0 warto�� 4 (kod dla syscall: wy�wietl napis znajduj�cy si� w $a0)
	la $a0, ilo��_rund	# Za�aduj do $a0 adres ilo��_rund
	syscall			# Wy�wietl ilo��_rund na ekranie
	
	li $v0, 5		# Za�aduj do $v0 warto�� 5 (kod dla syscall: wczytaj licb� ca�kowit�)
	syscall			# Wczytaj liczb� ca�kowit� z klawiatury i za�aduj do $v0
	move $t2, $v0
	
	
	blez $t2, z�a_liczba_rund	# Je�li liczba nie z zakresu <1,5>,
	bgt $t2, 5, z�a_liczba_rund	# to przejd� do odpowiedniego komunikatu
	
	li $s0, 0x10010220 		# Adres poczatku tablicy na ruchy

	j wyczy��_pole
	
runda:	
	beqz $t2, wyniki		# Je�li liczba rund jest liczba zero, to przejd� do wy�wietlana wynik�w
	subi $t2, $t2, 1		# W przeciwnym wypadku zmniejsz o 1 ilo�� pozosta�ych rund
					
	gra:
		jal wy�wietl_pole_gry	# Wy�wietl obecne pole gry
		
		li $v0, 4		# Za�aduj do $v0 warto�� 4 (kod dla syscall: wy�wietl napis znajduj�cy si� w $a0)
		la $a0, pozycja		# Za�aduj do $a0 adres pozycja
		syscall			# Wy�wietl pozycja na ekranie
	
		li $v0, 5		# Za�aduj do $v0 warto�� 5 (kod dla syscall: wczytaj licb� ca�kowit�)
		syscall			# Wczytaj liczb� ca�kowit� z klawiatury i za�aduj do $v0
		
		jal czy_dobry_nr	# Sprawd� poprawno�� wyboru pola gracza
		jal czy_wygrana		# Sprawd�, czy kto� wygra�
		j czy_remis		# Sprawd�, czy jest remis
		
		ruch_przeciwnika:
			jal przeciwnik		# Wykonaj ruch przeciwnika
			jal czy_wygrana		# Sprawd�, czy kto� wygra�
			j gra			# Wykonuj p�tle
	

ustaw_komp_na_o:		# Ustaw znak komputara na o, je�li gracz wybra� x
	li $t1, 111
	j liczba_rund


ustaw_komp_na_x:		# Ustaw znak komputara na x, je�li gracz wybra� o
	li $t1, 120	
	j liczba_rund
	

z�a_liczba_rund: 
	li $v0, 4		# Za�aduj do $v0 warto�� 4 (kod dla syscall: wy�wietl napis znajduj�cy si� w $a0)
	la $a0, z�a_ilo��_rund	# Za�aduj do $a0 adres z�a_ilo��_rund
	syscall			# Wy�wietl z�a_ilo��_rund na ekranie
	j liczba_rund		# Przejd� do ponownego wpisywania ilo�ci rund
	
	
wy�wietl_pole_gry:
	li $v0, 11		# Za�aduj do $v0 warto�� 11 (kod dla syscall: wy�wietl znak znajduj�cy si� w $a0)
	
	lb $a0, 0($s0)		# 
	syscall			# 
	lb $a0, 1($s0)		# 
	syscall			# Wy�wietl pierwszy rz�d
	lb $a0, 2($s0)		# na ekranie
	syscall			# 
	li $a0, 10		#	
	syscall			#
	
	lb $a0, 3($s0)		# 
	syscall			# 	
	lb $a0, 4($s0)		# 
	syscall			# Wy�wietl drugi rz�d
	lb $a0, 5($s0)		# na ekranie
	syscall			# 
	li $a0, 10		#
	syscall			#
	
	lb $a0, 6($s0)		# 
	syscall			# 
	lb $a0, 7($s0)		# Wy�wietl trzeci rz�d
	syscall			# na ekranie
	lb $a0, 8($s0)		# 
	syscall			# 
	
	li $v0, 4		# Za�aduj do $v0 warto�� 4 (kod dla syscall: wy�wietl napis znajduj�cy si� w $a0)
	la $a0, numery_p�l	# Za�aduj do $a0 adres numery_p�l
	syscall			# Wy�wietl numery_p�l na ekranie	
	
	jr $ra

przeciwnik: 
	li $v0, 4				#
	add $t7, $s0, $v0			# Je�li �rodek jest wolny,
	lb $t6, 0($t7)				# to ustaw tam znak
	beq $t6, 8, ustaw_pole_k		# 
	
	li $t7, 0
	
	przeciwnik_p�tla_2:
		lb $t6, tab_pom($t7)		#
		abs $t6, $t6			# Je�li w tablicy pomocniczej
		beq $t6, 2, wyb�r_pola		# jedna z warto�ci jest r�wna
		addi $t7, $t7, 1		# 2 albo -2 to ustaw tam znak
		blt $t7, 8, przeciwnik_p�tla_2	# 
	
	li $t7, 0
	
	przeciwnik_p�tla_1:
		lb $t6, tab_pom($t7)		#
		abs $t6, $t6			# Je�li w tablicy pomocniczej
		beq $t6, 1, wyb�r_pola		# jedna z warto�ci jest r�wna
		addi $t7, $t7, 1		# 1 albo -1 to ustaw tam znak
		blt $t7, 8, przeciwnik_p�tla_1	#
	
	wyb�r_pola:			# wyb�r pola w zale�no�ci od warto�ci w tab_pom
		beq $t7, 0, rz�d1
		beq $t7, 1, rz�d2
		beq $t7, 2, rz�d3
		beq $t7, 3, kolumna1
		beq $t7, 4, kolumna2
		beq $t7, 5, kolumna3
		beq $t7, 6, przek�tna1
		beq $t7, 7, przek�tna2
		
	rz�d1:
		li $v0, 0
		add $t7, $s0, $v0
		lb $t6, 0($t7)
		beq $t6, 8, ustaw_pole_k
		
		li $v0, 1
		add $t7, $s0, $v0
		lb $t6, 0($t7)
		beq $t6, 8, ustaw_pole_k
		
		li $v0, 2
		add $t7, $s0, $v0
		lb $t6, 0($t7)
		beq $t6, 8, ustaw_pole_k
		
	rz�d2:
		li $v0, 3
		add $t7, $s0, $v0
		lb $t6, 0($t7)
		beq $t6, 8, ustaw_pole_k
		
		li $v0, 4
		add $t7, $s0, $v0
		lb $t6, 0($t7)
		beq $t6, 8, ustaw_pole_k
		
		li $v0, 5
		add $t7, $s0, $v0
		lb $t6, 0($t7)
		beq $t6, 8, ustaw_pole_k
	
	rz�d3:
		li $v0, 6
		add $t7, $s0, $v0
		lb $t6, 0($t7)
		beq $t6, 8, ustaw_pole_k
		
		li $v0, 7
		add $t7, $s0, $v0
		lb $t6, 0($t7)
		beq $t6, 8, ustaw_pole_k
		
		li $v0, 8
		add $t7, $s0, $v0
		lb $t6, 0($t7)
		beq $t6, 8, ustaw_pole_k
		
	kolumna1:
		li $v0, 0
		add $t7, $s0, $v0
		lb $t6, 0($t7)
		beq $t6, 8, ustaw_pole_k
		
		li $v0, 3
		add $t7, $s0, $v0
		lb $t6, 0($t7)
		beq $t6, 8, ustaw_pole_k
		
		li $v0, 6
		add $t7, $s0, $v0
		lb $t6, 0($t7)
		beq $t6, 8, ustaw_pole_k
		
	kolumna2:
		li $v0, 1
		add $t7, $s0, $v0
		lb $t6, 0($t7)
		beq $t6, 8, ustaw_pole_k
		
		li $v0, 4
		add $t7, $s0, $v0
		lb $t6, 0($t7)
		beq $t6, 8, ustaw_pole_k
		
		li $v0, 7
		add $t7, $s0, $v0
		lb $t6, 0($t7)
		beq $t6, 8, ustaw_pole_k
	
	kolumna3:
		li $v0, 2
		add $t7, $s0, $v0
		lb $t6, 0($t7)
		beq $t6, 8, ustaw_pole_k
		
		li $v0, 5
		add $t7, $s0, $v0
		lb $t6, 0($t7)
		beq $t6, 8, ustaw_pole_k
		
		li $v0, 8
		add $t7, $s0, $v0
		lb $t6, 0($t7)
		beq $t6, 8, ustaw_pole_k
		
	przek�tna1:
		li $v0, 0
		add $t7, $s0, $v0
		lb $t6, 0($t7)
		beq $t6, 8, ustaw_pole_k
		
		li $v0, 4
		add $t7, $s0, $v0
		lb $t6, 0($t7)
		beq $t6, 8, ustaw_pole_k
		
		li $v0, 8
		add $t7, $s0, $v0
		lb $t6, 0($t7)
		beq $t6, 8, ustaw_pole_k
		
	przek�tna2:
		li $v0, 2
		add $t7, $s0, $v0
		lb $t6, 0($t7)
		beq $t6, 8, ustaw_pole_k
		
		li $v0, 4
		add $t7, $s0, $v0
		lb $t6, 0($t7)
		beq $t6, 8, ustaw_pole_k
		
		li $v0, 6
		add $t7, $s0, $v0
		lb $t6, 0($t7)
		beq $t6, 8, ustaw_pole_k


ustaw_pole_k:			# Ustaw znak komp na odpowiednie miejsce
	add $t7, $s0, $v0
	sb $t1, 0($t7)
	j aktualizuj_tab_pom	# Aktualizuj dane w tab_pom

czy_dobry_nr: 			
	blez $v0, z�y_nr	# Sprawd� czy nr jest w zakresie
	bgt $v0, 9, z�y_nr	# od 1 do 9
	
	j czy_zaj�te_pole 	# Przejd� do sprawdzania czy pole jest wolne
	
	z�y_nr:
		li $v0, 4		# Za�aduj do $v0 warto�� 4 (kod dla syscall: wy�wietl napis znajduj�cy si� w $a0)
		la $a0, z�a_pozycja	# Za�aduj do $a0 z�a_pozycja
		syscall			# Wy�wietl z�a_pozycja na ekranie
		
		j gra
	
	
czy_zaj�te_pole:
	subi $v0, $v0, 1
	add $t7, $s0, $v0
	lb $t7, 0($t7)
	beq $t7, 8, ustaw_pole_g
	
	li $v0, 4		# Za�aduj do $v0 warto�� 4 (kod dla syscall: wy�wietl napis znajduj�cy si� w $a0)
	la $a0, zaj�ta_pozycja	# Za�aduj do $a0 zaj�ta_pozycja
	syscall			# Wy�wietl zaj�ta_pozycja na ekranie

	j gra

		
ustaw_pole_g:			# Ustaw znak gracza na odpowiednie miejsce
	add $t7, $s0, $v0
	sb $t0, 0($t7)
	j aktualizuj_tab_pom	# Aktualizuj dane w tab_pom
		

aktualizuj_tab_pom:
	add $t7, $s0, $v0	#
	lb $t7, 0($t7) 		#
	beq $t7, 120, znak_x	#
	li $t7, -1		# Ustal znak, jaki
	j aktualizuj		# zosta� wpisany
				#
	znak_x: 		#
		li $t7, 1	#
		
	aktualizuj:
		div $t6, $v0, 3		# Ustalenie nr wiersza
		lb $t8, tab_pom($t6)	# i zaaktualizowanie odpowiedniej
		add $t8, $t8, $t7	# warto�ci w tablicy
		sb $t8, tab_pom($t6)	# 
		
		li $t9, 3		#
		div $v0, $t9		#
		mfhi $t6		# Ustalenie nr kolumny
		addi $t6, $t6, 3	# i zaaktualizowanie odpowiedniej
		lb $t8, tab_pom($t6)	# warto�ci w tablicy
		add $t8, $t8, $t7	#
		sb $t8, tab_pom($t6)	#
		
		li $t9, 4		#
		div $v0, $t9		# 
		mfhi $t6		# Je�li reszta z dzielenia 
		bnez $t6, przek�tna_2	# przez 4 r�wna si� 0
		li $t6, 6		# to zaaktualizuj warto��
		lb $t8, tab_pom($t6)	# przek�tnej 1
		add $t8, $t8, $t7	#
		sb $t8, tab_pom($t6)	#
		
		bne $v0, 4, przek�tna_2	#
		li $t6, 7		# Sprawd�, czy interesuj�cy nas
		lb $t8, tab_pom($t6)	# punkt to �rodek, je�li tak,
		add $t8, $t8, $t7	# to zaaktualizuj warto��
		sb $t8, tab_pom($t6)	# rzek�tnej 2
		
		przek�tna_2:
			mfhi $t6		#
			bne $t6, 2, return	# Je�li reszta z dzielenia
			li $t6, 7		# przez 4 r�wna si� 2
			lb $t8, tab_pom($t6)	# to zaaktualizuj warto��
			add $t8, $t8, $t7	# przek�tnej 1
			sb $t8, tab_pom($t6)	#
			
	return:	
		jr $ra


czy_remis:
	li $t7, 0
	
	czy_remis_p�tla:			
		add $t8, $s0, $t7		#
		lb $t6, 0($t8)			# Je�li pole gry zawiera 
		beq $t6, 8, ruch_przeciwnika	# znak o kodzie ASCII
		addi $t7, $t7, 1		# r�wnym 8, to wr�� do gry
		blt $t7, 9, czy_remis_p�tla	# 
		
	addi $t5, $t5, 1	# Je�li nie ma �adnego wolnego pola to gra ko�czy si� remisem
	
	li $v0, 4		# Za�aduj do $v0 warto�� 4 (kod dla syscall: wy�wietl napis znajduj�cy si� w $a0)
	la $a0, remis		# Za�aduj do $a0 adres remis
	syscall			# Wy�wietl remis na ekranie	
		
	j wyczy��_pole		# Czy�cimy pole gry oraz tab_pom
	

czy_wygrana:
	li $t7, 0
	
	czy_wygrana_p�tla:			#
		lb $t6, tab_pom($t7)		# Je�li jedna z warto�ci w tab_pom
		beq $t6, 3, wygrana_x		# wynosi 3 to wygrywa x, a je�li
		beq $t6, -3, wygrana_o		# wynosi -3 to wygrywa o
		addi $t7, $t7, 1		# 
		blt $t7, 8, czy_wygrana_p�tla	#
	
	jr $ra
		
wygrana_x:
	beq $t0, 120, wygrana_x_g	# Sprawdzamy kto jest x
	addi $t4, $t4, 1	# Zwyci�stwo komputera
	
	li $v0, 4		# Za�aduj do $v0 warto�� 4 (kod dla syscall: wy�wietl napis znajduj�cy si� w $a0)
	la $a0, wygrana_k	# Za�aduj do $a0 adres wygrana_k
	syscall			# Wy�wietl wygrana_k na ekranie
	
	j wyczy��_pole		# Czy�cimy pole gry oraz tab_pom
	
	wygrana_x_g:
		addi $t3, $t3, 1	# Zwyci�stwo gracza

		li $v0, 4		# Za�aduj do $v0 warto�� 4 (kod dla syscall: wy�wietl napis znajduj�cy si� w $a0)
		la $a0, wygrana_g	# Za�aduj do $a0 adres wygrana_g
		syscall			# Wy�wietl wygrana_g na ekranie
		
		j wyczy��_pole		# Czy�cimy pole gry oraz tab_pom

wygrana_o:
	beq $t0, 111, wygrana_o_g	# Sprawdzamy kto jest o
	addi $t4, $t4, 1		# Zwyci�stwo komputera
	
	li $v0, 4		# Za�aduj do $v0 warto�� 4 (kod dla syscall: wy�wietl napis znajduj�cy si� w $a0)
	la $a0, wygrana_k	# Za�aduj do $a0 adres wygrana_k
	syscall			# Wy�wietl wygrana_k na ekranie
	
	j wyczy��_pole		# Czy�cimy pole gry oraz tab_pom
	
	wygrana_o_g:			# Zwyci�stwo gracza
		addi $t3, $t3, 1
		
		li $v0, 4		# Za�aduj do $v0 warto�� 4 (kod dla syscall: wy�wietl napis znajduj�cy si� w $a0)
		la $a0, wygrana_g	# Za�aduj do $a0 adres wygrana_g
		syscall			# Wy�wietl wygrana_g na ekranie
		
		j wyczy��_pole		# Czy�cimy pole gry oraz tab_pom

wyczy��_pole:
	li $t7, 0
	li $t6, 8
	
	wyczy��_pole_p�tla:			
		add $t8, $s0, $t7		#
		sb $t6, 0($t8)			# Czyszczenie pola gry
		addi $t7, $t7, 1		#
		blt $t7, 9, wyczy��_pole_p�tla	#
	
	li $t7, 0
	li $t6, 0	
	wyczy��_tab_p�tla:
		sb $t6, tab_pom($t7)		#
		addi $t7, $t7, 1		# Czyszczenie tab_pom
		blt $t7, 8, wyczy��_tab_p�tla	#
		
	j runda


wyniki:													
	li $v0, 4		# Za�aduj do $v0 warto�� 4 (kod dla syscall: wy�wietl napis znajduj�cy si� w $a0)
	la $a0, koniec		# Za�aduj do $a0 adres koniec
	syscall			# Wy�wietl koniec na ekranie
	
	la $a0, wynik_g		# Za�aduj do $a0 adres wynik_g
	syscall			# Wy�wietl wynik_g na ekranie
	li $v0, 1		# Za�aduj do $v0 warto�� 1 (kod dla syscall: wy�wietl liczb� ca�kowit� znajduj�c� si� w $a0)
	move $a0, $t3		# Za�aduj do $a0 ilo�� zwyci�stw gracza
	
	syscall			# Wy�wietl ilo�� zwyci�stw gracza na ekranie
	li $v0, 4		# Za�aduj do $v0 warto�� 4 (kod dla syscall: wy�wietl napis znajduj�cy si� w $a0)
	la $a0, wynik_k		# Za�aduj do $a0 adres wynik_k
	syscall			# Wy�wietl wynik_k na ekranie
	li $v0, 1		# Za�aduj do $v0 warto�� 1 (kod dla syscall: wy�wietl liczb� ca�kowit� znajduj�c� si� w $a0)
	move $a0, $t4		# Za�aduj do $a0 ilo�� zwyci�stw komputera
	syscall			# Wy�wietl ilo�� zwyci�stw komputera na ekranie
	
	li $v0, 4		# Za�aduj do $v0 warto�� 4 (kod dla syscall: wy�wietl napis znajduj�cy si� w $a0)
	la $a0, wynik_r		# Za�aduj do $a0 adres wynik_r
	syscall			# Wy�wietl wynik_r na ekranie
	li $v0, 1		# Za�aduj do $v0 warto�� 1 (kod dla syscall: wy�wietl liczb� ca�kowit� znajduj�c� si� w $a0)
	move $a0, $t5		# Za�aduj do $a0 ilo�� remis�w
	syscall			# Wy�wietl ilo�� remis�w na ekranie
											
exit:	
	li $v0, 10 		# Za�aduj do $v0 warto�� 10 (kod dla syscall: koniec programu)
	syscall 		# Koniec programu 	
