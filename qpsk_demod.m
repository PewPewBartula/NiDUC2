%Funkcja demodulująca pobrany sygnał BPSK.
%Jej argumentami są n-liczba bitów, 
%m-liczba sygnałów, f-częstotliwość, A - sygnał QPSK

function [X] = qpsk_demod(m,n,f,A)

  t=0:1/f:2*pi-1/f;
  %Fragmenty wzorcowe dla "11", "00", "01" "10".
  A11=cos(t+(7/4*pi));
  A00=cos(t+(3/4*pi));
  A01=cos(t+(5/4*pi));
  A10=cos(t+(1/4*pi));
  
  for o=1:m
    syg00(1,1:n)=0;
    syg01(1,1:n)=0;
    syg10(1,1:n)=0;
    syg11(1,1:n)=0;
    for i=1:n
       %Zmienne syg zapisuja roznice pomiedzy sygnalem pobranym i
       %wzorcowym
      for j=1:10
        syg10(i)=syg10(i)+abs(A(o,j*60+((i-1)*628)) - A10(j*60));
        syg00(i)=syg00(i)+abs(A(o,j*60+((i-1)*628)) - A00(j*60));
        syg11(i)=syg11(i)+abs(A(o,j*60+((i-1)*628)) - A11(j*60));
        syg01(i)=syg01(i)+abs(A(o,j*60+((i-1)*628)) - A01(j*60));
      end
      if (syg10(i)<syg00(i) && syg10(i)<syg01(i) && syg10(i)<syg11(i))
        X(o*2-1,i)=1;
        X(o*2,i)=0;
      elseif (syg00(i)<syg10(i) && syg00(i)<syg01(i) && syg00(i)<syg11(i))
        X(o*2-1,i)=0;
        X(o*2,i)=0;
      elseif (syg01(i)<syg00(i) && syg01(i)<syg10(i) && syg01(i)<syg11(i))
        X(o*2-1,i)=0;
        X(o*2,i)=1;
      elseif (syg11(i)<syg00(i) && syg11(i)<syg01(i) && syg11(i)<syg10(i))
        X(o*2-1,i)=1;
        X(o*2,i)=1;
      end
    end
end

