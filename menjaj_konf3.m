function [y,m1,m2] = menjaj_konf3(konf, xT, yT,n,broj,korak)
%% Resavac
l1 = 188;
l2 = 150;
l3 = 25;
l4 = 105;

q1(2) = pi - acos((l2^2 + l4^2 - xT^2 - yT^2)/(2*l2*l4));
q1(1) = atan2(yT,xT) - atan2(l4*sin(q1(2)),(l2 + l4*cos(q1(2)))); %prvo resenje

q2(2) = acos((l2^2 + l4^2 - xT^2 - yT^2)/(2*l2*l4)) - pi;
q2(1) = atan2(yT,xT) - atan2(l4*sin(q2(2)),(l2 + l4*cos(q2(2)))); %drugo resenje

if konf == 1
    
    x11 = l2*cos(q2(1));   %drugo resenje
    y11 = l2*sin(q2(1));
    x22 = x11 + l4*cos(q2(1) + q2(2));
    y22 = y11 + l4*sin(q2(1) + q2(2));
    
    qm = linspace(q1(1),q2(1),broj);
    qn = linspace(q1(2),q2(2),broj);
    
    A = qm';
    B = qn';
    
    delta_q = zeros(size(qm,2),4);
    
    %Pomeranje
    for i=1:size(qm,2)
        if i == 1
            continue
        else
            delta_q(i,1) = A(i,1) - A(i-1,1);
            delta_q(i,3) = B(i,1) - B(i-1,1);
            
            if sign(delta_q(i,1)) == 1
                delta_q(i,2) = 1;
            else
                delta_q(i,2) = 0;
            end
            
            if sign(delta_q(i,3)) == 1
                delta_q(i,4) = 1;
            else
                delta_q(i,4) = 0;
            end
        end
    end
    
    %%Animacija
    for j = 1:size(qm,2)
        x1(j) = l2*cos(qm(j));
        y1(j) = l2*sin(qm(j));
        x2(j) = x1(j) + l4*cos(qm(j) + qn(j));
        y2(j) = y1(j) + l4*sin(qm(j) + qn(j));
    end
    
    h = animatedline('Color','b','LineStyle','--','LineWidth',1.5);
    h2 = animatedline('LineStyle','none','Marker','x','Color','k', 'MarkerSize',10,'LineWidth',1.5);
    h3 = animatedline('LineStyle','none','Marker','x','Color','r', 'MarkerSize',10,'LineWidth',1.5);
    
    %Animacija
    for k = 1:size(qm,2)
        pause(n)
        addpoints(h,[0, x1(k)], [0, y1(k)])
        addpoints(h,[x1(k), x2(k)], [y1(k), y2(k)])
        addpoints(h2,x1(k),y1(k))
        addpoints(h3,x2(k),y2(k))
        
        drawnow
        pause(n)
        clearpoints(h)
        clearpoints(h2)
        clearpoints(h3)
        
    end
    y = 2;
    
else
    
    x1 = l2*cos(q1(1));
    y1 = l2*sin(q1(1));
    x2 = x1 + l4*cos(q1(1) + q1(2));
    y2 = y1 + l4*sin(q1(1) + q1(2));
   
    qm = linspace(q2(1),q1(1),broj);
    qn = linspace(q2(2),q1(2),broj);
    
    A = qm';
    B = qn';
    
    delta_q = zeros(size(qm,2),4);
    
    %Pomeranje
    for i=1:size(qm,2)
        if i == 1
            continue
        else
            delta_q(i,1) = A(i,1) - A(i-1,1);
            delta_q(i,3) = B(i,1) - B(i-1,1);
            
            if sign(delta_q(i,1)) == 1
                delta_q(i,2) = 1;
            else
                delta_q(i,2) = 0;
            end
            
            if sign(delta_q(i,3)) == 1
                delta_q(i,4) = 1;
            else
                delta_q(i,4) = 0;
            end
        end
    end
    
    %Animacija
    for j = 1:size(qm,2)
        x1(j) = l2*cos(qm(j));
        y1(j) = l2*sin(qm(j));
        x2(j) = x1(j) + l4*cos(qm(j) + qn(j));
        y2(j) = y1(j) + l4*sin(qm(j) + qn(j));
    end
    
    h = animatedline('Color','b','LineStyle','--','LineWidth',1.5);
    h2 = animatedline('LineStyle','none','Marker','x','Color','k', 'MarkerSize',10);
    h3 = animatedline('LineStyle','none','Marker','x','Color','r', 'MarkerSize',10);
    
    %Animacija
    for k = 1:size(qm,2)
        pause(n)
        addpoints(h,[0, x1(k)], [0, y1(k)])
        addpoints(h,[x1(k), x2(k)], [y1(k), y2(k)])
        addpoints(h2,x1(k),y1(k))
        addpoints(h3,x2(k),y2(k))
        drawnow
        pause(n)
        clearpoints(h)
        clearpoints(h2)
        clearpoints(h3)
        
    end
    
    y = 1;
end
%% Slanje Motoru
C = delta_q(2:end,:);

i1 = 12.1558;
i2 = 10.8052;

pomeraj1 = korak/i1;
pomeraj2 = korak/i2;

ost2 = 0;
q = [];
q2= [];

for i = 1:size(C,1)
    ost1 = 3;
    j = 0;
    while ost1 >= pomeraj1
        ost1 = abs(C(i,1)) - j*pomeraj1 + ost2;
        nv(i,1)=j;
        j = j+1;
        ost2 = 0;
        if C(i,2)
            nv(i,2)=1;
        else
            nv(i,2)=0;
        end
    end
    a = [nv];
    ost2 = ost1+ost2;
end
k_ost1 = ost2;
ost2 = 0;

for i = 1:size(C,1)
    ost1 = 3;
    j = 0;
    while ost1 >= pomeraj2
        ost1 = abs(C(i,3)) - j*pomeraj2 + ost2;
        nv2(i,1)=j;
        j = j+1;
        ost2 = 0;
        if C(i,4)
            nv2(i,2)=1;
        else
            nv2(i,2)=0;
        end
    end
    a2 = [nv2];
    ost2 = ost1+ost2;
end
k_ost2 = ost2;
%% Sumirano
j = 1;

for i = 1:size(a,1)
    if i == 1
        m1(j,1) = a(i,1);
        m1(j,2) = a(i,2);
    else
        if a(i-1,2) == a(i,2)
            m1(j,1) = a(i,1) + m1(j,1);
        else
            if a(i-1,1) == 0
                m1(j,1) = m1(j,1) - a(i,1);
                m1(j+1,1) =  a(i,1);
            end
            m1(j,1) = a(i,1) + m1(j,1);
            j = j+1;
            m1(j,2) = a(i,2);
        end
    end
end


j = 1;

for i = 1:size(a2,1)
    if i == 1
        m2(j,1) = a2(i,1);
        m2(j,2) = a2(i,2);
    else
        if a2(i-1,2) == a2(i,2)
            m2(j,1) = a2(i,1) + m2(j,1);
        else
            if a2(i-1,1) == 0
                m2(j,1) = m2(j,1) - a2(i,1);
                m2(j+1,1) =  a2(i,1);
            end
            m2(j,1) = a2(i,1) + m2(j,1);
            j = j+1;
            m2(j,2) = a2(i,2);
        end
    end
end
end
