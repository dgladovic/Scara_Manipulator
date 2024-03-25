function [output_args] = stablo(broj, H, T,konf,n)

l2 = 150;
l4 = 105;

x = zeros(broj,1);

if H(1) == T(1)
    for i = 1:broj
        x(i,1) = H(1);
    end
    y = linspace(H(2),T(2),broj)';
else
    x = linspace(H(1), T(1), broj)';
    k = (T(2) - H(2))/(T(1) - H(1));
    y = (k*x + H(2) - k*H(1));
end

q = zeros(broj,2);
pp = [x y];

if konf == 1
    for i=1:broj
        
        q(i,2) = pi - acos((l2^2 + l4^2 - x(i)^2 - y(i)^2)/(2*l2*l4));
        q(i,1) = atan2(y(i),x(i)) - atan2(l4*sin(q(i,2)),(l2 + l4*cos(q(i,2)))); %prvo resenje
        
        x1(i) = l2*cos(q(i,1));     %prvo resenje
        y1(i) = l2*sin(q(i,1));
        x2(i) = x1(i) + l4*cos(q(i,1) + q(i,2));
        y2(i) = y1(i) + l4*sin(q(i,1) + q(i,2));
        
    end
else
    for i=1:broj
        q(i,2) = acos((l2^2 + l4^2 - x(i)^2 - y(i)^2)/(2*l2*l4)) - pi;
        q(i,1) = atan2(y(i),x(i)) - atan2(l4*sin(q(i,2)),(l2 + l4*cos(q(i,2)))); %drugo resenje
        
        x1(i) = l2*cos(q(i,1));     %prvo resenje
        y1(i) = l2*sin(q(i,1));
        x2(i) = x1(i) + l4*cos(q(i,1) + q(i,2));
        y2(i) = y1(i) + l4*sin(q(i,1) + q(i,2));        
        
    end
end

a = pp(:,1); 
b = pp(:,2);
    
h = animatedline('Color','b','LineStyle','--','LineWidth',1.5); 
h2 = animatedline('LineStyle','none','Marker','o'); 
h3 = animatedline('LineStyle','none','Marker','o','MarkerSize',1.5,'Color','k'); 

%Animacija
    for k = 1:broj 
          pause(n)
          addpoints(h,[0, x1(k)], [0, y1(k)])
          addpoints(h,[x1(k), x2(k)], [y1(k), y2(k)])
          addpoints(h2,a(k),b(k))
          addpoints(h3,a(k),b(k))
          drawnow
          pause(n)
          clearpoints(h)
          clearpoints(h2)
    end     
%Crtanje krajnjeg polozaja
    line([0, x1(end)], [0, y1(end)], 'LineWidth',2)
    line([x1(end), x2(end)], [y1(end), y2(end)], 'LineWidth',2)
    plot(0, 0, 'kx', 'MarkerSize',10, 'LineWidth',1.5)
    plot(x1(end), y1(end), 'kx', 'MarkerSize',10, 'LineWidth',1.5)
    plot(x2(end), y2(end), 'rx', 'MarkerSize',10, 'LineWidth',1.5)            
end
