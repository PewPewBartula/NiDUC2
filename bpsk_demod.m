%Funkcja demodulująca pobrany sygnał BPSK.
%Jej argumentami są n-liczba bitów, 
%m-liczba sygnałów, f-częstotliwość, A - sygnał BPSK
function [X] = bpsk_demod(m,n,f,A)

 t=0:1/f:2*pi-1/f;
 %Fragmenty wzorcowe dla "1" i "0".
 A1=cos(t);
 A0=cos(t+pi);
  for o=1:m
    syg1(1,1:n)=0;
    syg0(1,1:n)=0;
    for i=1:n
      for j=1:10
        %Zmienne syg zapisuja roznice pomiedzy sygnalem pobranym i
        %wzorcowym
        syg1(i)=syg1(i)+abs(A(o,j*60+((i-1)*628)) - A1(j*60));
        syg0(i)=syg0(i)+abs(A(o,j*60+((i-1)*628)) - A0(j*60));
      end
      if (syg1(i)<syg0(i))
        X(o,i)=1;
      else
        X(o,i)=0;
      end
    end
  end



