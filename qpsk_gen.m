%Funkcja generacji sygnału QPSK
%Jej argumentami są n-liczba bitów, 
%m-liczba sygnałów, f-częstotliwość, x-losowana wartość z zakresu [0,1]

function [A,a] = qpsk_gen(n,m,f,x)
  b=[];
  a=[];
  %W wypadku nieparzystej liczby bitow dopisujemy "0"
  if mod(n,2)~=0
    x(:,n+1)=0;
  end
  %Przemiana macierzy
  for i=1:m
    b=reshape(x(i,:),2,ceil(n/2));
    a(i*2-1,:)=b(1,:);
    a(i*2,:)=b(2,:);
    b=[];
  end
  B=[];
  A=[];
  for j=1:m
    %W zaleznosci od otrzymanych par bitow, zachodza kolejne przesuniecia
    %fazowe
    for i=1:ceil(n/2)
      if (a(j*2-1,i)==1 && a(j*2,i)==0) 
        t=(i-1)*2*pi:1/f:2*i*pi-1/f;
        B=[B,cos(t+(1/4*pi))];
      elseif (a(j*2-1,i)==0 && a(j*2,i)==0) 
        t=(i-1)*2*pi:1/f:2*i*pi-1/f;
        B=[B,cos(t+(3/4*pi))];
      elseif (a(j*2-1,i)==0 && a(j*2,i)==1) 
        t=(i-1)*2*pi:1/f:2*i*pi-1/f;
        B=[B,cos(t+(5/4*pi))];
      elseif (a(j*2-1,i)==1 && a(j*2,i)==1) 
        t=(i-1)*2*pi:1/f:2*i*pi-1/f;
        B=[B,cos(t+(7/4*pi))];
      end
    end
    A(j,:)=B;
    B=[];
end

