%% Parametri
clear all, clc
close all

broj = 8;      %Broj diskretnih tacaka
T = 10;         %Brzina animacije
n = 1/T;
korak = 0.13;   %Korak Motora
%% Inverzna Kinematika
l1 = 188;
l2 = 150;
l3 = 25;
l4 = 105;

qmax = [(170/2)*2*pi/360; (254/2)*2*pi/360];

p = sprintf('Unesite x koordinatu vrha robota: ');
xH = input(p);
p = sprintf('Unesite y koordinatu vrha robota: ');
yH = input(p);

if sqrt(xH^2 + yH^2) > l2+l4
    disp('Nije moguce ostvariti zadati polozaj vrha robota.')
else
    
    q1 = [0;0];
    
    q1(2) = pi - acos((l2^2 + l4^2 - xH^2 - yH^2)/(2*l2*l4));
    q1(1) = atan2(yH,xH) - atan2(l4*sin(q1(2)),(l2 + l4*cos(q1(2)))); %prvo resenje
    
    q2(2) = acos((l2^2 + l4^2 - xH^2 - yH^2)/(2*l2*l4)) - pi;
    q2(1) = atan2(yH,xH) - atan2(l4*sin(q2(2)),(l2 + l4*cos(q2(2)))); %drugo resenje
    
    if (abs(q1(1)) > qmax(1) || abs(q1(2)) > qmax(2))
        konf1 = 0;
    else
        konf1 = 1;
    end
    
    if (abs(q2(1)) > qmax(1) || abs(q2(2)) > qmax(2))
        konf2 = 0;
    else
        konf2 = 1;
    end
    
    if konf1 == 1 && konf2 == 1
        
        p = sprintf('Unesite konfiguraciju robota, 1 ili 2: ');
        konf = input(p);
        
        x1 = l2*cos(q1(1));     %prvo resenje
        y1 = l2*sin(q1(1));
        x2 = x1 + l4*cos(q1(1) + q1(2));
        y2 = y1 + l4*sin(q1(1) + q1(2));
        
        x11 = l2*cos(q2(1));   %drugo resenje
        y11 = l2*sin(q2(1));
        x22 = x11 + l4*cos(q2(1) + q2(2));
        y22 = y11 + l4*sin(q2(1) + q2(2));
        
        if konf == 1
            
            openfig('radni_prostor2.fig')
            hold on
            axis equal
            line([0, x1], [0, y1], 'LineWidth',2)
            line([x1, x2], [y1, y2], 'LineWidth',2)
            plot(0, 0, 'kx', 'MarkerSize',10, 'LineWidth',1.5)
            plot(x1, y1, 'kx', 'MarkerSize',10, 'LineWidth',1.5)
            plot(x2, y2, 'rx', 'MarkerSize',10, 'LineWidth',1.5)
            xlabel('$$x$$','interpreter','latex','fontsize',14)
            ylabel('$$y$$','interpreter','latex','fontsize',14)
        elseif konf == 2
            
            openfig('radni_prostor2.fig')
            hold on
            axis equal
            line([0, x11], [0, y11], 'LineWidth',2)
            line([x11, x22], [y11, y22], 'LineWidth',2)
            plot(0, 0, 'kx', 'MarkerSize',10, 'LineWidth',1.5)
            plot(x11, y11, 'kx', 'MarkerSize',10, 'LineWidth',1.5)
            plot(x22, y22, 'rx', 'MarkerSize',10, 'LineWidth',1.5)
            xlabel('$$x$$','interpreter','latex','fontsize',14)
            ylabel('$$y$$','interpreter','latex','fontsize',14)
        end
        
        
    elseif konf1 == 1 && konf2 == 0
        
        konf = 1;
        
        x1 = l2*cos(q1(1));
        y1 = l2*sin(q1(1));
        x2 = x1 + l4*cos(q1(1) + q1(2));
        y2 = y1 + l4*sin(q1(1) + q1(2));
        
        openfig('radni_prostor2.fig')
        hold on
        axis equal
        line([0, x1], [0, y1], 'LineWidth',2)
        line([x1, x2], [y1, y2], 'LineWidth',2)
        plot(0, 0, 'kx', 'MarkerSize',10, 'LineWidth',1.5)
        plot(x1, y1, 'kx', 'MarkerSize',10, 'LineWidth',1.5)
        plot(x2, y2, 'rx', 'MarkerSize',10, 'LineWidth',1.5)
        xlabel('$$x$$','interpreter','latex','fontsize',14)
        ylabel('$$y$$','interpreter','latex','fontsize',14)
        
    elseif konf1 == 0 && konf2 == 1
        
        konf = 2;
        
        x11 = l2*cos(q2(1));
        y11 = l2*sin(q2(1));
        x22 = x11 + l4*cos(q2(1) + q2(2));
        y22 = y11 + l4*sin(q2(1) + q2(2));
        
        openfig('radni_prostor2.fig')
        hold on
        axis equal
        line([0, x11], [0, y11], 'LineWidth',2)
        line([x11, x22], [y11, y22], 'LineWidth',2)
        plot(0, 0, 'kx', 'MarkerSize',10, 'LineWidth',1.5)
        plot(x11, y11, 'kx', 'MarkerSize',10, 'LineWidth',1.5)
        plot(x22, y22, 'rx', 'MarkerSize',10, 'LineWidth',1.5)
        xlabel('$$x$$','interpreter','latex','fontsize',14)
        ylabel('$$y$$','interpreter','latex','fontsize',14)
        
    else
        disp('Nije moguce ostvariti zadati polozaj vrha robota.')
        
    end
end
%% Pocetna Oblast
%x = linspace(-100, 300, 500);
xB = 160; yB = -150;
xA = 160; yA = 150;

plot(xA, yA, 'k*', 'MarkerSize',10, 'LineWidth',1.5)
plot(xB, yB, 'k*', 'MarkerSize',10, 'LineWidth',1.5)

load dkp.mat
syms sq1 sq2

p = sprintf('Unesite x koordinatu krajnjeg polozaja: ');
xT = input(p);
p = sprintf('Unesite y koordinatu krajnjeg polozaja: ');
yT = input(p);

plot(xT, yT, 'rx', 'MarkerSize',10, 'LineWidth',1.5)

a = 1;

if oblast1([xH, yH])==1
    pozH = 1;
elseif oblast2([xH, yH])==1
    pozH = 2;
else
    pozH = 4;
end

if oblast1([xT, yT])==1
    pozT = 1;
elseif oblast2([xT, yT])==1
    pozT = 2;
else
    pozT = 4;
end

if (konf==1 && pozT==2) || (konf==2 && pozT==1)
    promena_konf = 1;
else
    promena_konf = 0;
end

if promena_konf == 1 && pozH == 4
    
    [konf,M01,M02] = menjaj_konf3(konf, xH, yH,n,broj,korak)
    
end

pp = [0,0];
pp = putanja([xH,yH], [xT,yT],broj);
B = [];
%% Algoritam
if oblast3(pp) == 1
    if pozH == 1 && pozT == 2
        
        pp = putanja([xH,yH],[xA,yA],broj);
        [B] = kretanje(broj, [xH,yH], [xA,yA],konf)
        [M11,M12] = smart_mot3(korak,B)
        stablo(broj, [xH,yH], [xA,yA],konf,n)
        
        [konf,M01,M02] = menjaj_konf3(konf, xA, yA,n,broj,korak)
        
        pp = putanja([xA,yA],[xB,yB],broj);
        [B] = kretanje(broj, [xA,yA], [xB,yB],konf)
        [M21,M22] = smart_mot3(korak,B)
        stablo(broj, [xA,yA], [xB,yB],konf,n)
        
        pp = putanja([xB,yB],[xT,yT],broj);
        [B] = kretanje(broj, [xB,yB],[xT,yT],konf)
        [M31,M32] = smart_mot3(korak,B)
        stablo(broj, [xB,yB], [xT,yT],konf,n)
        
    elseif pozH == 2 && pozT == 1
        
        pp = putanja([xH,yH],[xB,yB],broj);
        [B] = kretanje(broj, [xH,yH], [xB,yB],konf)
        [M11,M12] = smart_mot3(korak,B)
        stablo(broj, [xH,yH], [xB,yB],konf,n)
        
        [konf,M01,M02] = menjaj_konf3(konf, xB, yB,n,broj,korak)
        
        pp = putanja([xB,yB],[xA,yA],broj);
        [B] = kretanje(broj, H, T,konf)
        [M21,M22] = smart_mot3(korak,B)
        stablo(broj, [xB,yB], [xA,yA],konf,n)
        
        pp = putanja([xA,yA],[xT,yT],broj);
        [B] = kretanje(broj, H, T,konf)
        [M31,M32] = smart_mot3(korak,B)
        stablo(broj, [xA,yA], [xT,yT],konf,n)
        
    elseif pozH == 4 && pozT == 1
        pp = putanja([xH,yH],[xA,yA],broj);
        if oblast3(pp) == 1
            
            pp = putanja([xH,yH],[xB,yB],broj);
            [B] = kretanje(broj, [xH,yH], [xB,yB],konf)
            [M11,M12] = smart_mot3(korak,B)
            stablo(broj, [xH,yH], [xB,yB],konf,n)
            
            pp = putanja([xB,yB],[xA,yA],broj);
            [B] = kretanje(broj, [xB,yB], [xA,yA],konf)
            [M21,M22] = smart_mot3(korak,B)
            stablo(broj, [xB,yB], [xA,yA],konf,n)
        else
            [B] = kretanje(broj, [xH,yH], [xA,yA],konf)
            [M11,M12] = smart_mot3(korak,B)
            stablo(broj, [xH,yH], [xA,yA],konf,n)
        end
        pp = putanja([xA,yA],[xT,yT],broj);
        [B] = kretanje(broj, [xA,yA], [xT,yT],konf)
        [M31,M32] = smart_mot3(korak,B)
        stablo(broj, [xA,yA], [xT,yT],konf,n)
        
    elseif pozH == 4 && pozT == 2
        pp = putanja([xH,yH],[xB,yB],broj);
        if oblast3(pp) == 1
            
            pp = putanja([xH,yH],[xA,yA],broj);
            [B] = kretanje(broj, [xH,yH], [xA,yA],konf)
            [M11,M12] = smart_mot3(korak,B)
            stablo(broj, [xH,yH], [xA,yA],konf,n)
            
            pp = putanja([xA,yA],[xB,yB],broj);
            [B] = kretanje(broj, [xA,yA], [xB,yB],konf)
            [M21,M22] = smart_mot3(korak,B)
            stablo(broj, [xA,yA], [xB,yB],konf,n)
        else
            [B] = kretanje(broj, [xH,yH], [xB,yB],konf)
            [M11,M12] = smart_mot3(korak,B)
            stablo(broj, [xH,yH], [xB,yB],konf,n)
        end
        pp = putanja([xB,yB],[xT,yT],broj);
        [B] = kretanje(broj, [xB,yB], [xT,yT],konf)
        [M31,M32] = smart_mot3(korak,B)
        stablo(broj, [xB,yB], [xT,yT],konf,n)
        
    elseif pozH == 1 && pozT == 4
        
        pp = putanja([xH,yH],[xA,yA],broj);
        [B] = kretanje(broj, [xH,yH], [xA,yA],konf)
        [M11,M12] = smart_mot3(korak,B)
        stablo(broj, [xH,yH], [xA,yA],konf,n)
        
        pp = putanja([xA,yA],[xT,yT],broj);
        if oblast3(pp) == 1
            
            pp = putanja([xA,yA],[xB,yB],broj);
            [B] = kretanje(broj, [xA,yA], [xB,yB],konf)
            [M21,M22] = smart_mot3(korak,B)
            stablo(broj, [xA,yA], [xB,yB],konf,n)
            
            pp = putanja([xB,yB],[xT,yT],broj);
            [B] = kretanje(broj, [xB,yB], [xT,yT],konf)
            [M31,M32] = smart_mot3(korak,B)
            stablo(broj, [xB,yB], [xT,yT],konf,n)
            
        elseif oblast2(pp) == 1
            promena_konf = 1;
            
            [konf,M01,M02] = menjaj_konf3(konf, xA, yA,n,broj,korak)
            
            [B] = kretanje(broj, [xA,yA], [xT,yT],konf)
            [M21,M22] = smart_mot3(korak,B)
            stablo(broj, [xA,yA], [xT,yT],konf,n)
        else
            [B] = kretanje(broj, [xA,yA], [xT,yT],konf)
            [M21,M22] = smart_mot3(korak,B)
            stablo(broj, [xA,yA], [xT,yT],konf,n)
        end
        
    elseif pozH == 2 && pozT == 4
        
        pp = putanja([xH,yH],[xB,yB],broj);
        [B] = kretanje(broj, [xH,yH], [xB,yB],konf)
        [M11,M12] = smart_mot3(korak,B)
        stablo(broj, [xH,yH], [xB,yB],konf,n)
        
        pp = putanja([xB,yB],[xT,yT],broj);
        if oblast3(pp) == 1
            
            pp = putanja([xB,yB],[xA,yA],broj);
            [B] = kretanje(broj, [xB,yB], [xA,yA],konf)
            [M21,M22] = smart_mot3(korak,B)
            stablo(broj, [xB,yB], [xA,yA],konf,n)
            
            pp = putanja([xA,yA],[xT,yT],broj);
            [B] = kretanje(broj, [xA,yA], [xT,yT],konf)
            [M31,M32] = smart_mot3(korak,B)
            stablo(broj, [xA,yA], [xT,yT],konf,n)
            
        elseif oblast1(pp) == 1
            promena_konf = 1;
            
            [konf,M01,M02] = menjaj_konf3(konf, xB, yB,n,broj,korak)
            
            [B] = kretanje(broj, [xB,yB], [xT,yT],konf)
            [M21,M22] = smart_mot3(korak,B)
            stablo(broj, [xB,yB], [xT,yT],konf,n)
        else
            [B] = kretanje(broj, [xB,yB], [xT,yT],konf)
            [M21,M22] = smart_mot3(korak,B)
            stablo(broj, [xB,yB], [xT,yT],konf,n)
        end
    elseif pozH == 4 && pozT == 4
        pp = putanja([xH,yH],[xA,yA],broj);
        if oblast3(pp) == 1
            
            pp = putanja([xH,yH],[xB,yB],broj);
            [B] = kretanje(broj, [xH,yH], [xB,yB],konf)
            [M11,M12] = smart_mot3(korak,B)
            stablo(broj, [xH,yH], [xB,yB],konf,n)
            
            pp = putanja([xB,yB],[xA,yA],broj);
            [B] = kretanje(broj, [xB,yB], [xA,yA],konf)
            [M21,M22] = smart_mot3(korak,B)
            stablo(broj, [xB,yB], [xA,yA],konf,n)
            
            pp = putanja([xA,yA],[xT,yT],broj);
            [B] = kretanje(broj, [xA,yA], [xT,yT],konf)
            [M31,M32] = smart_mot3(korak,B)
            stablo(broj, [xA,yA], [xT,yT],konf,n)
        else
            [B] = kretanje(broj, [xH,yH], [xA,yA],konf)
            [M11,M12] = smart_mot3(korak,B)
            stablo(broj, [xH,yH], [xA,yA],konf,n)
            
            pp = putanja([xA,yA],[xB,yB],broj);
            [B] = kretanje(broj, [xA,yA], [xB,yB],konf)
            [M21,M22] = smart_mot3(korak,B)
            stablo(broj, [xA,yA], [xB,yB],konf,n)
            
            pp = putanja([xB,yB],[xT,yT],broj);
            [B] = kretanje(broj, [xB,yB], [xT,yT],konf)
            [M31,M32] = smart_mot3(korak,B)
            stablo(broj, [xB,yB], [xT,yT],konf,n)
        end
    end
else
    pp = putanja([xH,yH],[xT,yT],broj);
    [B] = kretanje(broj, [xH,yH], [xT,yT],konf)
    [M11,M12] = smart_mot3(korak,B)
    stablo(broj, [xH,yH], [xT,yT],konf,n)
end
%% Komunikacija
