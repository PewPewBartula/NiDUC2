%Funkcja generacji sygnału BPSK
%Jej argumentami są n-liczba bitów, 
%m-liczba sygnałów, f-częstotliwość, x-losowana wartość z zakresu [0,1]

function [A] = bpsk_gen(n,m,f,x)
A = [];
B = [];
for j=1:m  
    for i=1:n
      %kodowanie wartości 1
      if x(j,i)==1
        t=(i-1)*2*pi:1/f:2*i*pi-1/f;
        B=[B,cos(t)];
      %kodowanie wartości 0
      else
        t=(i-1)*2*pi:1/f:2*i*pi-1/f;
        B=[B,cos(t+pi)];
      end
    end
    A(j,:)=B;
    B=[];
end

