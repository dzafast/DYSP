   class Dysp

      def initialize
         system 'cls'
         @root
         @file
         @tablica
         @fizyczny
         @wartosc_meldunek
         @pol_zal
         @pol_wyl
         @mel_pomiar
         @wynik
         @lista
         powitanie
         dane_wejsciowe
         raport
      end

      def powitanie
         system 'cls'
         puts ""
         puts "".center(80, '*')
         puts " Witaj edytorze danych NC ".center(80)
         puts "".center(80, '*')
         puts ""
         puts "jesli chcesz wyjść z programu, wystarczy, że wpiszesz słowo (end)".center(80)
         dane_wejsciowe
      end

      def dane_wejsciowe

            puts ""
            puts "".center(80, '*')
            print "    Zawartość katalogu /Programy  ".center(80)
            puts ""
            puts "".center(80, '*')

            # przeszukanie katalogu Programy i wyświetlenie jego zawartości
            Dir.foreach("../Programy/") { |start| puts start} #dziala tak samo jak Dir.entries...

            puts ""
            puts ""
            puts "".center(80, '*')
            print "    wpisz nazwę katalogu  ".center(80)
            puts ""
            puts "".center(80, '*')
            #przekazanie przez usera nazwy katalogu
            root = gets.chomp

            # przeszukanie katalogu Programy/root i wyświetlenie jego zawartości
            dir = Dir.entries("../Programy/#{root}").each { |e| puts " #{e}"}

            #ozdobnik zadajacy pytanie?
            puts ""
            puts ""
            puts "".center(80, '*')
            print "wpisz nazwę pliku  ".center(80)
            puts ""
            puts "".center(80, '*')

            #przekazanie przez usera (z klawiatury) pliku (file) z rządanego katalogu (root)
            file = gets.chomp

         @root = root
         @file = file
         przetworzenie_danych
      end

      def przetworzenie_danych
         #Utworzenie pustych tablic
         tablica = Array.new
         tab_zakres = Array.new
         fizyczny = Array.new
         tab_fizyczny = Array.new
         wartosc_meldunek = Array.new
         pol_zal = Array.new
         pol_wyl = Array.new
         mel_pomiar = Array.new
         tab_kanaly = Array.new
         #wzorzec szukający wyrażenia (nrDysp oraz nrFiz) i dopasowujący  wszystkie znaki po nim
         maska_nrDysp = /nrDysp:(.+)/
         maska_nrFiz = /nrFiz:(.+)/
         maska_meldunek = /meldunek:(.+)/
         maska_pol_zal = /polecenie_zal:(.+)/
         maska_pol_wyl = /polecenie_wyl:(.+)/
         maska_pom = /pomiar/
         maska_kanaly = /kanaly:(.+)/
         #Otwarcie rzadanego pliku (file) w katalogu (root) i przekazanie jego zawartości do bloku (zawartosc)
         File.open("../Programy/#{@root}/#{@file}") do |zawartosc|

            #iterakcja po zmiennej (zawartosc) i przekazanie anych do bloku kodu (infile)
            zawartosc.each_line do |infile|
               #warunek dopasowujący zmienną (infile) do wzorca
               if infile =~ maska_nrDysp
                  #rozbicie uzyskanych danych na dwa elementy (text i wartość), gdzie text odpowiada za napis (nrDysp), a (wartosc) za interesujący nas nr (wartosc liczbowa).
                  text, wartosc = infile.scan(/(nrDysp:)(.+)/).flatten
                  wartosc = wartosc.to_i #ponieważ (wartosc) odczytana jest z pliku tekstowego jest wartoscia typu string i w takiej formie jest przekazana do tablicy, dlatego tez nalezy zamienic ją na wartosc liczbową aby mozna było przeprowadzić sortowanie na liczbach a nie na tekscie.
                  tablica << wartosc
                  @tablica = tablica.sort
               end
               if infile =~ maska_nrFiz
                  flaga, jednostka = infile.scan(/(nrFiz:)(.+)/).flatten #flaga to nrFiz: jednostka to cyfra po dwukropku
                  jednostka = jednostka.to_i
                  fizyczny << jednostka
                  @fizyczny = fizyczny.sort
               end
               if infile =~ maska_meldunek
                  meldunek, seriabit = infile.scan(/(meldunek:)(.+)/).flatten
                  wartosc_meldunek << meldunek
                  @wartosc_meldunek = wartosc_meldunek
               end
               if infile =~ maska_pol_zal
                  polecenie_zal, seriabit_zal = infile.scan(/(polecenie_zal:)(.+)/).flatten
                  pol_zal << polecenie_zal
                  @pol_zal = pol_zal
               end
               if infile =~ maska_pol_wyl
                  polecenie_wyl, seriabit_wyl = infile.scan(/(polecenie_wyl:)(.+)/).flatten
                  pol_wyl << polecenie_wyl
                  @pol_wyl = pol_wyl
               end
               if
                  infile =~ maska_pom
                  typ, pomiar = infile.scan(/(pomiar)/).flatten
                  mel_pomiar << pomiar
                  @mel_pomiar = mel_pomiar
               end
               if infile =~ maska_kanaly
                  kanal, wartosc_kan = infile.scan(/(kanaly:)(.+)/).flatten
                  wartosc_kan = wartosc_kan.to_i
                  tab_kanaly << wartosc_kan
                  @kanaly = tab_kanaly.sort
               end
            end
            pierwszy = @tablica.first #wybranie pierwszej cyfry z tablicy
            ostatni = @tablica.last #wybranie ostatniej cyfry z tablicy
            zakres = (pierwszy..ostatni) #utworzenie zakresu z pierwszej i ostatniej cyfry tabeli
            @tab_zakres = [*zakres] #utworzenie pełnego zakresu i dodanie go do zdefiniowanej tablicy

            pierwsza = @fizyczny.first
            ostatnia = @fizyczny.last
            lista = (pierwsza..ostatnia)
            @tab_fizyczny = [*lista]

            pierwszy_k = @kanaly.first
            ostatni_k = @kanaly.last
            wynik = (pierwszy_k..ostatni_k)
            @tab_kanaly = [*wynik]
         end
         wynik_obliczen
      end

      def wynik_obliczen
         #@tab_zakres = [*zakres] #utworzenie tablicy z zakresu
         #print tablica_zakresu.class <== sprawdzenie czy utworzona tablica jest klasy Array
         puts "".center(80, '-')
         puts "Lista stanowisk w #{@file}".center(80)
         puts ""

         @tablica.each {|y| print "#{y} "} #wydrukowanie na ekranie wszystkich stanowisk z tablicy @tablica
         puts ""
         puts ""
         puts "Ilość stanowisk #{@tablica.length}".center(80) #policzenie obiektow w tablicy
         puts "".center(80, '-')

         puts "Lista nr fizycznych stanowisk w #{@file}".center(80)
         @fizyczny.each {|y| print " #{y} "}
         puts ""
         puts ""
         puts "Ilość nr fizycznych #{@fizyczny.length}".center(80) #policzenie obiektow w tablicy
         puts "".center(80, '-')
         puts ""

         puts "lista wolnych nr dyspozytorskich (nrDysp)".center(80)
         @wynik = (@tab_zakres - @tablica)
         @wynik.each {|x| print "#{x} "}
         puts ""
         puts ""
         puts "".center(80, '-')

         puts "Lista wolnych nr fizycznych (nrFiz)".center(80)
         @lista = (@tab_fizyczny - @fizyczny)
         @lista.each {|x| print "#{x} "}
         puts ""
         puts ""
         puts "".center(80, '-')

         puts "Lista wolnych nr kanałow".center(80)
         @ilosc_kanal = (@tab_kanaly - @kanaly)
         @ilosc_kanal.each {|x| print " #{x} "}
         puts ""
         puts ""
         puts "".center(80, '/')

         puts "Lista zajętych kanałow".center(80)
         puts "wszystkie razem - #{@kanaly.length}".center(80)
         puts ""
         puts "".center(80, '-')
         @kanaly.each {|x| print " #{x} "}
         puts ""
         puts ""
         puts "".center(80, '/')

         puts "liczba meldunkow + pomiary".center(80)
         puts ("#{@wartosc_meldunek.size}").center(80)
         puts ""
         puts "".center(80, '-')
         puts ""

         @mel = @wartosc_meldunek.size
         @mel_pom = @mel_pomiar.size
         puts "liczba medunkow bez pomiarow".center(80)
         @wynik_mel_minus_pom = (@mel - @mel_pom)
         puts ("#{@wynik_mel_minus_pom}").center(80)
         puts ""
         puts "".center(80, '-')
         puts ""

         puts "liczba pomiarow".center(80)
         puts ("#{@mel_pomiar.size}").center(80)
         puts ""
         puts "".center(80, '-')
         puts ""

         puts "liczba polecen zal + wyl".center(80)
         @wynik = (@pol_zal + @pol_wyl)
         puts ("#{@wynik.size}").center(80)
         puts ""
         puts "".center(80, '!')
         puts "Koniec przetwarzania danych #{@file}".center(80)
         puts "".center(80, '!')
         dane_wejsciowe
      end

      def koniec
         puts "Nacisnij [enter]".center(80)
         gets
         puts "Do widzenia".center(80)
         exit
      end

   end

dysp = Dysp.new
