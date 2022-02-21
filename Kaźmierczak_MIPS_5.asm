# Æwiczenie 5

	.data
	
wybór_znaku: .asciiz "Wybierz znak wpisujac 'x' albo 'o': "

z³y_znak: .asciiz "\nNiepoprawny znak\n"

iloœæ_rund: .asciiz "\nWpisz ilosc rund (od 1 do 5): "

z³a_iloœæ_rund: .asciiz "\nPodano niepoprawna ilosc rund\n"

pozycja: .asciiz "\nPodaj numer pozycji: "

z³a_pozycja: .asciiz "\nNiepoprawna pozycja\n"

zajêta_pozycja: .asciiz "\nPozycja zajeta\n"

numery_pól: .asciiz "\n1 2 3\n4 5 6\n7 8 9\n"

wygrana_g: .asciiz "Wygrana gracza\n"

wygrana_k: .asciiz "Wygrana komputera\n"

remis: .asciiz "Remis\n"

koniec: .asciiz "Koniec gry\nWyniki rund:"

wynik_g: .asciiz "\nGracz: "

wynik_k: .asciiz "\nKomputer: "

wynik_r: .asciiz "\nRemis: "

tab_pom: .byte 0, 0, 0, 0, 0, 0, 0, 0	# 1, 2, 3 rz¹d, 1, 2, 3 kolumna, 1 i 2 przek¹tna

	.text
	
main:
	li $v0, 4		# Za³aduj do $v0 wartoœæ 4 (kod dla syscall: wyœwietl napis znajduj¹cy siê w $a0)
	la $a0, wybór_znaku	# Za³aduj do $a0 adres wybór_znaku	
	syscall			# Wyœwietl wybór_znaku na ekranie
	
	li $v0, 12		# Za³aduj do $v0 wartoœæ 12 (kod dla syscall: wczytaj znak)
	syscall			# Wczytaj znak z klawiatury i za³aduj do $v0
	move $t0, $v0
	
	
	beq $t0, 120, ustaw_komp_na_o	#
	beq $t0, 111, ustaw_komp_na_x	# Ustal znak komputera
	
	
	li $v0, 4		# Za³aduj do $v0 wartoœæ 4 (kod dla syscall: wyœwietl napis znajduj¹cy siê w $a0)
	la $a0, z³y_znak	# Za³aduj do $a0 adres z³y_znak
	syscall			# Wyœwietl z³y_znak na ekranie
	
	j main			# Jeœli wybrano z³y znak, to zacznij ponownie


liczba_rund: 
	li $v0, 4		# Za³aduj do $v0 wartoœæ 4 (kod dla syscall: wyœwietl napis znajduj¹cy siê w $a0)
	la $a0, iloœæ_rund	# Za³aduj do $a0 adres iloœæ_rund
	syscall			# Wyœwietl iloœæ_rund na ekranie
	
	li $v0, 5		# Za³aduj do $v0 wartoœæ 5 (kod dla syscall: wczytaj licbê ca³kowit¹)
	syscall			# Wczytaj liczbê ca³kowit¹ z klawiatury i za³aduj do $v0
	move $t2, $v0
	
	
	blez $t2, z³a_liczba_rund	# Jeœli liczba nie z zakresu <1,5>,
	bgt $t2, 5, z³a_liczba_rund	# to przejdŸ do odpowiedniego komunikatu
	
	li $s0, 0x10010220 		# Adres poczatku tablicy na ruchy

	j wyczyœæ_pole
	
runda:	
	beqz $t2, wyniki		# Jeœli liczba rund jest liczba zero, to przejdŸ do wyœwietlana wyników
	subi $t2, $t2, 1		# W przeciwnym wypadku zmniejsz o 1 iloœæ pozosta³ych rund
					
	gra:
		jal wyœwietl_pole_gry	# Wyœwietl obecne pole gry
		
		li $v0, 4		# Za³aduj do $v0 wartoœæ 4 (kod dla syscall: wyœwietl napis znajduj¹cy siê w $a0)
		la $a0, pozycja		# Za³aduj do $a0 adres pozycja
		syscall			# Wyœwietl pozycja na ekranie
	
		li $v0, 5		# Za³aduj do $v0 wartoœæ 5 (kod dla syscall: wczytaj licbê ca³kowit¹)
		syscall			# Wczytaj liczbê ca³kowit¹ z klawiatury i za³aduj do $v0
		
		jal czy_dobry_nr	# SprawdŸ poprawnoœæ wyboru pola gracza
		jal czy_wygrana		# SprawdŸ, czy ktoœ wygra³
		j czy_remis		# SprawdŸ, czy jest remis
		
		ruch_przeciwnika:
			jal przeciwnik		# Wykonaj ruch przeciwnika
			jal czy_wygrana		# SprawdŸ, czy ktoœ wygra³
			j gra			# Wykonuj pêtle
	

ustaw_komp_na_o:		# Ustaw znak komputara na o, jeœli gracz wybra³ x
	li $t1, 111
	j liczba_rund


ustaw_komp_na_x:		# Ustaw znak komputara na x, jeœli gracz wybra³ o
	li $t1, 120	
	j liczba_rund
	

z³a_liczba_rund: 
	li $v0, 4		# Za³aduj do $v0 wartoœæ 4 (kod dla syscall: wyœwietl napis znajduj¹cy siê w $a0)
	la $a0, z³a_iloœæ_rund	# Za³aduj do $a0 adres z³a_iloœæ_rund
	syscall			# Wyœwietl z³a_iloœæ_rund na ekranie
	j liczba_rund		# PrzejdŸ do ponownego wpisywania iloœci rund
	
	
wyœwietl_pole_gry:
	li $v0, 11		# Za³aduj do $v0 wartoœæ 11 (kod dla syscall: wyœwietl znak znajduj¹cy siê w $a0)
	
	lb $a0, 0($s0)		# 
	syscall			# 
	lb $a0, 1($s0)		# 
	syscall			# Wyœwietl pierwszy rz¹d
	lb $a0, 2($s0)		# na ekranie
	syscall			# 
	li $a0, 10		#	
	syscall			#
	
	lb $a0, 3($s0)		# 
	syscall			# 	
	lb $a0, 4($s0)		# 
	syscall			# Wyœwietl drugi rz¹d
	lb $a0, 5($s0)		# na ekranie
	syscall			# 
	li $a0, 10		#
	syscall			#
	
	lb $a0, 6($s0)		# 
	syscall			# 
	lb $a0, 7($s0)		# Wyœwietl trzeci rz¹d
	syscall			# na ekranie
	lb $a0, 8($s0)		# 
	syscall			# 
	
	li $v0, 4		# Za³aduj do $v0 wartoœæ 4 (kod dla syscall: wyœwietl napis znajduj¹cy siê w $a0)
	la $a0, numery_pól	# Za³aduj do $a0 adres numery_pól
	syscall			# Wyœwietl numery_pól na ekranie	
	
	jr $ra

przeciwnik: 
	li $v0, 4				#
	add $t7, $s0, $v0			# Jeœli œrodek jest wolny,
	lb $t6, 0($t7)				# to ustaw tam znak
	beq $t6, 8, ustaw_pole_k		# 
	
	li $t7, 0
	
	przeciwnik_pêtla_2:
		lb $t6, tab_pom($t7)		#
		abs $t6, $t6			# Jeœli w tablicy pomocniczej
		beq $t6, 2, wybór_pola		# jedna z wartoœci jest równa
		addi $t7, $t7, 1		# 2 albo -2 to ustaw tam znak
		blt $t7, 8, przeciwnik_pêtla_2	# 
	
	li $t7, 0
	
	przeciwnik_pêtla_1:
		lb $t6, tab_pom($t7)		#
		abs $t6, $t6			# Jeœli w tablicy pomocniczej
		beq $t6, 1, wybór_pola		# jedna z wartoœci jest równa
		addi $t7, $t7, 1		# 1 albo -1 to ustaw tam znak
		blt $t7, 8, przeciwnik_pêtla_1	#
	
	wybór_pola:			# wybór pola w zale¿noœci od wartoœci w tab_pom
		beq $t7, 0, rz¹d1
		beq $t7, 1, rz¹d2
		beq $t7, 2, rz¹d3
		beq $t7, 3, kolumna1
		beq $t7, 4, kolumna2
		beq $t7, 5, kolumna3
		beq $t7, 6, przek¹tna1
		beq $t7, 7, przek¹tna2
		
	rz¹d1:
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
		
	rz¹d2:
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
	
	rz¹d3:
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
		
	przek¹tna1:
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
		
	przek¹tna2:
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
	blez $v0, z³y_nr	# SprawdŸ czy nr jest w zakresie
	bgt $v0, 9, z³y_nr	# od 1 do 9
	
	j czy_zajête_pole 	# PrzejdŸ do sprawdzania czy pole jest wolne
	
	z³y_nr:
		li $v0, 4		# Za³aduj do $v0 wartoœæ 4 (kod dla syscall: wyœwietl napis znajduj¹cy siê w $a0)
		la $a0, z³a_pozycja	# Za³aduj do $a0 z³a_pozycja
		syscall			# Wyœwietl z³a_pozycja na ekranie
		
		j gra
	
	
czy_zajête_pole:
	subi $v0, $v0, 1
	add $t7, $s0, $v0
	lb $t7, 0($t7)
	beq $t7, 8, ustaw_pole_g
	
	li $v0, 4		# Za³aduj do $v0 wartoœæ 4 (kod dla syscall: wyœwietl napis znajduj¹cy siê w $a0)
	la $a0, zajêta_pozycja	# Za³aduj do $a0 zajêta_pozycja
	syscall			# Wyœwietl zajêta_pozycja na ekranie

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
	j aktualizuj		# zosta³ wpisany
				#
	znak_x: 		#
		li $t7, 1	#
		
	aktualizuj:
		div $t6, $v0, 3		# Ustalenie nr wiersza
		lb $t8, tab_pom($t6)	# i zaaktualizowanie odpowiedniej
		add $t8, $t8, $t7	# wartoœci w tablicy
		sb $t8, tab_pom($t6)	# 
		
		li $t9, 3		#
		div $v0, $t9		#
		mfhi $t6		# Ustalenie nr kolumny
		addi $t6, $t6, 3	# i zaaktualizowanie odpowiedniej
		lb $t8, tab_pom($t6)	# wartoœci w tablicy
		add $t8, $t8, $t7	#
		sb $t8, tab_pom($t6)	#
		
		li $t9, 4		#
		div $v0, $t9		# 
		mfhi $t6		# Jeœli reszta z dzielenia 
		bnez $t6, przek¹tna_2	# przez 4 równa siê 0
		li $t6, 6		# to zaaktualizuj wartoœæ
		lb $t8, tab_pom($t6)	# przek¹tnej 1
		add $t8, $t8, $t7	#
		sb $t8, tab_pom($t6)	#
		
		bne $v0, 4, przek¹tna_2	#
		li $t6, 7		# SprawdŸ, czy interesuj¹cy nas
		lb $t8, tab_pom($t6)	# punkt to œrodek, jeœli tak,
		add $t8, $t8, $t7	# to zaaktualizuj wartoœæ
		sb $t8, tab_pom($t6)	# rzek¹tnej 2
		
		przek¹tna_2:
			mfhi $t6		#
			bne $t6, 2, return	# Jeœli reszta z dzielenia
			li $t6, 7		# przez 4 równa siê 2
			lb $t8, tab_pom($t6)	# to zaaktualizuj wartoœæ
			add $t8, $t8, $t7	# przek¹tnej 1
			sb $t8, tab_pom($t6)	#
			
	return:	
		jr $ra


czy_remis:
	li $t7, 0
	
	czy_remis_pêtla:			
		add $t8, $s0, $t7		#
		lb $t6, 0($t8)			# Jeœli pole gry zawiera 
		beq $t6, 8, ruch_przeciwnika	# znak o kodzie ASCII
		addi $t7, $t7, 1		# równym 8, to wróæ do gry
		blt $t7, 9, czy_remis_pêtla	# 
		
	addi $t5, $t5, 1	# Jeœli nie ma ¿adnego wolnego pola to gra koñczy siê remisem
	
	li $v0, 4		# Za³aduj do $v0 wartoœæ 4 (kod dla syscall: wyœwietl napis znajduj¹cy siê w $a0)
	la $a0, remis		# Za³aduj do $a0 adres remis
	syscall			# Wyœwietl remis na ekranie	
		
	j wyczyœæ_pole		# Czyœcimy pole gry oraz tab_pom
	

czy_wygrana:
	li $t7, 0
	
	czy_wygrana_pêtla:			#
		lb $t6, tab_pom($t7)		# Jeœli jedna z wartoœci w tab_pom
		beq $t6, 3, wygrana_x		# wynosi 3 to wygrywa x, a jeœli
		beq $t6, -3, wygrana_o		# wynosi -3 to wygrywa o
		addi $t7, $t7, 1		# 
		blt $t7, 8, czy_wygrana_pêtla	#
	
	jr $ra
		
wygrana_x:
	beq $t0, 120, wygrana_x_g	# Sprawdzamy kto jest x
	addi $t4, $t4, 1	# Zwyciêstwo komputera
	
	li $v0, 4		# Za³aduj do $v0 wartoœæ 4 (kod dla syscall: wyœwietl napis znajduj¹cy siê w $a0)
	la $a0, wygrana_k	# Za³aduj do $a0 adres wygrana_k
	syscall			# Wyœwietl wygrana_k na ekranie
	
	j wyczyœæ_pole		# Czyœcimy pole gry oraz tab_pom
	
	wygrana_x_g:
		addi $t3, $t3, 1	# Zwyciêstwo gracza

		li $v0, 4		# Za³aduj do $v0 wartoœæ 4 (kod dla syscall: wyœwietl napis znajduj¹cy siê w $a0)
		la $a0, wygrana_g	# Za³aduj do $a0 adres wygrana_g
		syscall			# Wyœwietl wygrana_g na ekranie
		
		j wyczyœæ_pole		# Czyœcimy pole gry oraz tab_pom

wygrana_o:
	beq $t0, 111, wygrana_o_g	# Sprawdzamy kto jest o
	addi $t4, $t4, 1		# Zwyciêstwo komputera
	
	li $v0, 4		# Za³aduj do $v0 wartoœæ 4 (kod dla syscall: wyœwietl napis znajduj¹cy siê w $a0)
	la $a0, wygrana_k	# Za³aduj do $a0 adres wygrana_k
	syscall			# Wyœwietl wygrana_k na ekranie
	
	j wyczyœæ_pole		# Czyœcimy pole gry oraz tab_pom
	
	wygrana_o_g:			# Zwyciêstwo gracza
		addi $t3, $t3, 1
		
		li $v0, 4		# Za³aduj do $v0 wartoœæ 4 (kod dla syscall: wyœwietl napis znajduj¹cy siê w $a0)
		la $a0, wygrana_g	# Za³aduj do $a0 adres wygrana_g
		syscall			# Wyœwietl wygrana_g na ekranie
		
		j wyczyœæ_pole		# Czyœcimy pole gry oraz tab_pom

wyczyœæ_pole:
	li $t7, 0
	li $t6, 8
	
	wyczyœæ_pole_pêtla:			
		add $t8, $s0, $t7		#
		sb $t6, 0($t8)			# Czyszczenie pola gry
		addi $t7, $t7, 1		#
		blt $t7, 9, wyczyœæ_pole_pêtla	#
	
	li $t7, 0
	li $t6, 0	
	wyczyœæ_tab_pêtla:
		sb $t6, tab_pom($t7)		#
		addi $t7, $t7, 1		# Czyszczenie tab_pom
		blt $t7, 8, wyczyœæ_tab_pêtla	#
		
	j runda


wyniki:													
	li $v0, 4		# Za³aduj do $v0 wartoœæ 4 (kod dla syscall: wyœwietl napis znajduj¹cy siê w $a0)
	la $a0, koniec		# Za³aduj do $a0 adres koniec
	syscall			# Wyœwietl koniec na ekranie
	
	la $a0, wynik_g		# Za³aduj do $a0 adres wynik_g
	syscall			# Wyœwietl wynik_g na ekranie
	li $v0, 1		# Za³aduj do $v0 wartoœæ 1 (kod dla syscall: wyœwietl liczbê ca³kowit¹ znajduj¹c¹ siê w $a0)
	move $a0, $t3		# Za³aduj do $a0 iloœæ zwyciêstw gracza
	
	syscall			# Wyœwietl iloœæ zwyciêstw gracza na ekranie
	li $v0, 4		# Za³aduj do $v0 wartoœæ 4 (kod dla syscall: wyœwietl napis znajduj¹cy siê w $a0)
	la $a0, wynik_k		# Za³aduj do $a0 adres wynik_k
	syscall			# Wyœwietl wynik_k na ekranie
	li $v0, 1		# Za³aduj do $v0 wartoœæ 1 (kod dla syscall: wyœwietl liczbê ca³kowit¹ znajduj¹c¹ siê w $a0)
	move $a0, $t4		# Za³aduj do $a0 iloœæ zwyciêstw komputera
	syscall			# Wyœwietl iloœæ zwyciêstw komputera na ekranie
	
	li $v0, 4		# Za³aduj do $v0 wartoœæ 4 (kod dla syscall: wyœwietl napis znajduj¹cy siê w $a0)
	la $a0, wynik_r		# Za³aduj do $a0 adres wynik_r
	syscall			# Wyœwietl wynik_r na ekranie
	li $v0, 1		# Za³aduj do $v0 wartoœæ 1 (kod dla syscall: wyœwietl liczbê ca³kowit¹ znajduj¹c¹ siê w $a0)
	move $a0, $t5		# Za³aduj do $a0 iloœæ remisów
	syscall			# Wyœwietl iloœæ remisów na ekranie
											
exit:	
	li $v0, 10 		# Za³aduj do $v0 wartoœæ 10 (kod dla syscall: koniec programu)
	syscall 		# Koniec programu 	
