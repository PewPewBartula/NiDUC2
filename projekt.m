close all;
clear all;
clc;

n=1000; %liczby wygenerowanych bitów
b=5; %liczba rozkładów błędów amplitudy/fazy
m=b*b;
f=100; %częstotliwość
u=1; %początkowa wartość amplitudy
d=0; %początkowa wartość przesunięcia fazowego
s=6;

%Generacja bitow
x = randi([0 1],m,n);
figure(1);

%Modulacja BPSK
A=bpsk_gen(n,m,f,x);
subplot(2,2,1);
plot(A(s,:));
axis([0,6280,-1.4,1.4]);
title("Oryginalny sygnal BPSK");

%Generacja macierzy z bledami amplitud
sigu=0:1/b:1-1/b; 
sigd=0:1/b*2:1*2-1/b*2;
l=1;
u=[];
d=[];
for i=1:b
  for j=1:b
    u(l,:)=normrnd(1,sigu(i),1,n);
    d(l,:)=normrnd(0,sigd(j),1,n);
    l=l+1;
  end
end

%Generacja sygnalu BPSK z zakloceniami
A=bpsk_genErr(n,m,f,x,u,d);
subplot(2,2,2);
plot(A(s,:));
axis([0,6280,-1.4,1.4]);
title("Zaklocony sygnal BPSK");

%Demodulacja BPSK
X = bpsk_demod(m,n,f,A);

figure(2);
for i=1:n
  xw(i) = u(s,i)*cos(d(s,i)+(1-x(s,i))*pi);
  yw(i) = u(s,i)*sin(d(s,i)+(1-x(s,i))*pi);
end
scatter(xw,yw,10,'b','.'); 
axis([-2,2,-2,2]);
title("Diagram konstelacji BPSK");
hold on;
grid on;
axis equal;
hold off;

%Modulacja QPSK
figure(1);
[qA,a]=qpsk_gen(n,m,f,x);
subplot(2,2,3);
plot(qA(s,:));
axis([0,6280,-1.4,1.4]);
title("Oryginalny sygnal QPSK");

%Generacja macierzy z bledami amplitud
l=1;
qu=[];
qd=[];
for i=1:b
  for j=1:b
    qu(l,:)=normrnd(1,sigu(i),1,ceil(n/2));
    qd(l,:)=normrnd(0,sigd(j),1,ceil(n/2));
    l=l+1;
  end
end

%Sygnal zaklocony dla QPSK
qA=qpsk_genErr(n,m,f,a,qu,qd);
subplot(2,2,4);
plot(qA(s,:));
axis([0,6280,-1.4,1.4]);
title("Zaklocony sygnal QPSK");

qa = qpsk_demod(m,ceil(n/2),f,qA);

figure(3);
for i=1:ceil(n/2)
  if (qa(2*s-1,i)==1 && qa(2*s,i)==0)
    p=1/4;
  elseif (qa(2*s-1,i)==0 && qa(2*s,i)==0)
    p=3/4;
  elseif (qa(2*s-1,i)==0 && qa(2*s,i)==1)
    p=5/4;
  elseif (qa(2*s-1,i)==1 && qa(2*s,i)==1)
    p=7/4;
  end
  qxw(i) = qu(s,i)*cos(qd(s,i)+pi*p);
  qyw(i) = qu(s,i)*sin(qd(s,i)+pi*p);
end
scatter(qxw,qyw,10,'b','.');
axis([-2,2,-2,2]);
title("Diagram konstelacji QPSK");
hold on;
grid on;
axis equal;
hold off;

Err=0;
ber(1:m)=0;
berq(1:m)=0;
Errq=0;

for o=1:m
  for i=1:n
    if x(o,i)~=X(o,i)
      Err=Err+1;
    end
  end
  for i=1:ceil(n/2)
    if ((a(2*o-1,i)~=qa(2*o-1,i)) || (a(2*o,i)~=qa(2*o,i)))
      Errq=Errq+1;
    end
  end
  ber(o)=Err/n;
  berq(o)=Errq/ceil(n/2);
  NotErr=n-Err;
  NotErrq=ceil(n/2)-Errq;
  EF(o)=NotErr/(length(A(o,:))/f);
  EFq(o)=NotErrq/(length(qA(o,:))/f);
  Err=0;
  Errq=0;
  NotErr=0;
  NotErrq=0;
end

%wykresy trojwymiarowe dla bit error rate i efektywnosci dla obu modulacji
tic
figure(4)
subplot(2,2,1);
ber=reshape(ber,b,b);
mesh(sigu,sigd,ber);
axis([0,1,0,2,0,1]);
title("Zaleznosc BER od roznych rozkladow prawd. bledow  - BSK");
zlabel("BER");
xlabel("u");
ylabel("d");

subplot(2,2,2);
berq=reshape(berq,b,b);
mesh(sigu,sigd,berq);
axis([0,1,0,2,0,1]);
title("Zaleznosc BER od roznych rozkladow prawd. bledow  - QPSK");
zlabel("BER");
xlabel("u");
ylabel("d");

subplot(2,2,3);
EF=reshape(EF,b,b);
mesh(sigu,sigd,EF);
axis([0,1,0,2,0,0.4]);
title("Zaleznosc EF od roznych rozkladow prawd. bledow - BSK");
zlabel("EF");
xlabel("u");
ylabel("d");

subplot(2,2,4);
EFq=reshape(EFq,b,b);
mesh(sigu,sigd,EFq);
axis([0,1,0,2,0,0.4]);
title("Zaleznosc EF od roznych rozkladow prawd. bledow - QPSK");
zlabel("EF");
xlabel("u");
ylabel("d");


