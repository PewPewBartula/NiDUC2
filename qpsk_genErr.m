%Funkcja generacji sygnału QPSK z zakłóceniami
%Jej argumentami są n-liczba bitów, %m-liczba sygnałów, 
%f-częstotliwość, x-losowana wartość z zakresu [0,1], 
%u - początkowa wartość amplitudy, d - początkowa wartość przesunięcia fazowego

function [A] = qpsk_genErr(n,m,f,x,u,d)
A = [];
B = [];
 for j=1:m  
    for i=1:ceil(n/2)
    %W zaleznosci od otrzymanych par bitow, zachodza kolejne przesuniecia
    %fazowe
      if (x(2*j-1,i)==1 && x(2*j,i)==0)
        t=(i-1)*2*pi:1/f:2*i*pi-1/f;
       B=[B,(u(j,i))*cos(t+(1/4*pi)+d(j,i))];
      elseif (x(2*j-1,i)==0 && x(2*j,i)==0) 
        t=(i-1)*2*pi:1/f:2*i*pi-1/f;
        B=[B,(u(j,i))*cos(t+(3/4*pi)+d(j,i))];
      elseif (x(2*j-1,i)==0 && x(2*j,i)==1)
        t=(i-1)*2*pi:1/f:2*i*pi-1/f;
        B=[B,(u(j,i))*cos(t+(5/4*pi)+d(j,i))];
      elseif (x(2*j-1,i)==1 && x(2*j,i)==1)
        t=(i-1)*2*pi:1/f:2*i*pi-1/f;
        B=[B,(u(j,i))*cos(t+(7/4*pi)+d(j,i))];
      end
    end
    A(j,:)=B;
    B=[];
end

