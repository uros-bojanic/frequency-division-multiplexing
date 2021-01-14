% Uros Bojanic 2019/0077

% t = linspace(0,0.015,1000);
% y1 = heaviside(t).*2.*sin(2400*pi.*t).*exp(-150.*t);
% y2 = heaviside(t-0.001)-heaviside(t-0.002);

w = linspace(-50000,50000,100000);

% Spektar signala y_{1}(t)
AFK1 = (4800*pi)./(sqrt(((2400*pi)^(2)+150^(2)-w.^(2)).^(2)+(300.*w).^(2)));
figure(1)
plot(w,AFK1);
title('|Y_{1}(j\omega)|')
xlabel('Kruzna ucestanost [rad/s]')
ylabel('Amplitudska frekvencijska karakteristika')

% Spektar signala y_{2}(t)
AFK2 = 0.001.*abs((sin(0.0005.*w))./(0.0005.*w));
figure(2)
plot(w,AFK2);
title('|Y_{2}(j\omega)|')
xlabel('Kruzna ucestanost [rad/s]')
ylabel('Amplitudska frekvencijska karakteristika')

% Spektar filtriranog signala y_{1}^{n}(t)
AFK1_NF = AFK1;
wb1 = 20000;
for i=1 : size(w,2)
    if (abs(w(i)) >  wb1)
        AFK1_NF(i) = 0;
    end
end
figure(3)
plot(w,AFK1_NF);
title('|Y_{1}^n(j\omega)|')
xlabel('Kruzna ucestanost [rad/s]')
ylabel('Amplitudska frekvencijska karakteristika')

% Spektar filtriranog signala y_{2}^{n}(t)
AFK2_NF = AFK2;
wb2 = 20000;
for i=1 : size(w,2)
    if (abs(w(i)) >  wb2)
        AFK2_NF(i) = 0;
    end
end
figure(4)
plot(w,AFK2_NF);
title('|Y_{2}^n(j\omega)|')
xlabel('Kruzna ucestanost [rad/s]')
ylabel('Amplitudska frekvencijska karakteristika')

% Spektar modulisanog filtriranog signala y_{2}^{m}(t)
w_new = linspace(-100000,100000,200000);
AFK2_NF_MOD = zeros(size(w_new));
wc = wb1 * 2;
for i = 1 : size(w,2)
    if (AFK2_NF(i) ~= 0)
        AFK2_NF_MOD(i + 50000 - wc) = AFK2_NF_MOD(i + 50000 - wc) + AFK2_NF(i)/2;
        AFK2_NF_MOD(i + 50000 + wc) = AFK2_NF_MOD(i + 50000 + wc) + AFK2_NF(i)/2;
    end
end
figure(5)
plot(w_new,AFK2_NF_MOD);
title('|Y_{2}^m(j\omega)|')
xlabel('Kruzna ucestanost [rad/s]')
ylabel('Amplitudska frekvencijska karakteristika')

% Spektar transmisionog signala y_{T}(t)
AFKT = AFK2_NF_MOD;
for i = 1 : size(w,2)
    if (AFK2_NF(i) ~= 0)
        AFKT(i + 50000) = AFKT(i + 50000) + AFK1_NF(i);
    end
end
figure(6)
plot(w_new,AFKT);
title('|Y_{T}(j\omega)|')
xlabel('Kruzna ucestanost [rad/s]')
ylabel('Amplitudska frekvencijska karakteristika')

% Spektar prijemnog signala y_{R}(t)
AFKR = AFKT;
wr = wb1 + 2*wb2;
for i=1 : size(w_new,2)
    if (abs(w_new(i)) >  wr)
        AFKR(i) = 0;
    end
end
figure(7)
plot(w_new,AFKT);
title('|Y_{R}(j\omega)|')
xlabel('Kruzna ucestanost [rad/s]')
ylabel('Amplitudska frekvencijska karakteristika')

% Spektar signala y_{2}^{b}(t) dobijenog filtriranjem
AFK2_B = AFKR;
wPO1 = wb1;
wPO2 = wb2 + wc;
for i = 1 + wc : size(w_new,2) - wc
    if (abs(w_new(i)) <  wPO1 || abs(w_new(i)) > wPO2)
        AFK2_B(i) = 0;
    end
end
figure(8)
plot(w_new,AFK2_B);
title('|Y_{2}^{b}(j\omega)|')
xlabel('Kruzna ucestanost [rad/s]')
ylabel('Amplitudska frekvencijska karakteristika')

% Spektar signala y_{2}^{d}(t) dobijenog demodulacijom
AFK2_D = zeros(size(w_new));
for i = 1 + wc : size(w_new,2) - wc
    if (AFK2_B(i) ~= 0)
        AFK2_D(i + wc) = AFK2_D(i + wc) + AFK2_B(i)/2;
        AFK2_D(i - wc) = AFK2_D(i - wc) + AFK2_B(i)/2;
    end
end
figure(9)
plot(w_new,AFK2_D);
title('|Y_{2}^{d}(j\omega)|')
xlabel('Kruzna ucestanost [rad/s]')
ylabel('Amplitudska frekvencijska karakteristika')

% Spektar rekonstruisanog signala y_{1}^{r}(t)
AFK1_r = zeros(size(w));
for i = 1 + 50000 : size(w_new,2) - 50000
    if (abs(w_new(i)) <  wb1)
        AFK1_r(i - 50000) = AFKR(i);
    end
end
figure(10)
plot(w,AFK1_r);
title('|Y_{1}^{r}(j\omega)|')
xlabel('Kruzna ucestanost [rad/s]')
ylabel('Amplitudska frekvencijska karakteristika')

% Spektar rekonstruisanog signala y_{2}^{r}(t)
AFK2_r = zeros(size(w));
for i = 1 + 50000 : size(w_new,2) - 50000
    if (abs(w_new(i)) <  wb1)
        AFK2_r(i - 50000) = 2*AFK2_D(i);
    end
end
figure(11)
plot(w,AFK2_r);
title('|Y_{2}^{r}(j\omega)|')
xlabel('Kruzna ucestanost [rad/s]')
ylabel('Amplitudska frekvencijska karakteristika')