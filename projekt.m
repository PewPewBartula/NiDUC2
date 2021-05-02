close all;
clear all;
clc;

n=1000;
b=5;
m=b*b;
f=100;
qu=1;
qd=0;
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
qu=[];
qd=[];
for i=1:b
  for j=1:b
    qu(l,:)=normrnd(1,sigu(i),1,n);
    qd(l,:)=normrnd(0,sigd(j),1,n);
    l=l+1;
  end
end

%Generacja sygnalu BPSK z zakloceniami
A=bpsk_genErr(n,m,f,x,qu,qd);
subplot(2,2,2);
plot(A(s,:));
axis([0,6280,-1.4,1.4]);
title("Zaklocony sygnal BPSK");

%Demodulacja BPSK
X = bpsk_demod(m,n,f,A);

figure(2);
for i=1:n
  xw(i) = qu(s,i)*cos(qd(s,i)+(1-x(s,i))*pi);
  yw(i) = qu(s,i)*sin(qd(s,i)+(1-x(s,i))*pi);
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
[A,a]=qpsk_gen(n,m,f,x);
subplot(2,2,3);
plot(A(s,:));
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
A=qpsk_genErr(n,m,f,a,qu,qd);
subplot(2,2,4);
plot(A(s,:));
axis([0,6280,-1.4,1.4]);
title("Zaklocony sygnal QPSK");

qa = qpsk_demod(m,ceil(n/2),f,A);

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


