%Funkcja generacji sygnału BPSK z zakłóceniami
%Jej argumentami są n-liczba bitów, %m-liczba sygnałów, 
%f-częstotliwość, x-losowana wartość z zakresu [0,1], 
%u - początkowa wartość amplitudy, d - początkowa wartość przesunięcia fazowego

function [A] = bpsk_genErr(n,m,f,x,u,d)
A = [];
B = [];
  %sygnal zaklocony
  for j=1:m  
    for i=1:n
      %kodowanie wartości 1
      if x(j,i)==1
        t=(i-1)*2*pi:1/f:2*i*pi-1/f;
        B=[B,(u(j,i))*cos(t+d(j,i))];
      %kodowanie wartości 0
      else
        t=(i-1)*2*pi:1/f:2*i*pi-1/f;
        B=[B,(u(j,i))*cos(t+pi+d(j,i))];
      end
    end
    A(j,:)=B;
    B=[];
end

