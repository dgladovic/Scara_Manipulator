function [d_q] = kretanje(broj, H, T,konf)

%H = [xH yH], T = [xT yT]
% funkcija vraca putanju izmedju H i T predstavljenu diskretno,
%tj. tackama sa jednakim korakom


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
delta_q = zeros(broj,4);
p = [x y];

if konf == 1
    for i=1:broj
        
        q(i,2) = pi - acos((l2^2 + l4^2 - x(i)^2 - y(i)^2)/(2*l2*l4));
        q(i,1) = atan2(y(i),x(i)) - atan2(l4*sin(q(i,2)),(l2 + l4*cos(q(i,2)))); %prvo resenje
        
        if i == 1
            continue
        else
            delta_q(i,1) = q(i,1) - q(i-1,1);
            delta_q(i,3) = q(i,2) - q(i-1,2);
            
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
else
    for i=1:broj
        q(i,2) = acos((l2^2 + l4^2 - x(i)^2 - y(i)^2)/(2*l2*l4)) - pi;
        q(i,1) = atan2(y(i),x(i)) - atan2(l4*sin(q(i,2)),(l2 + l4*cos(q(i,2)))); %drugo resenje
        if i == 1
            continue
        else
            delta_q(i,1) = q(i,1) - q(i-1,1);
            delta_q(i,3) = q(i,2) - q(i-1,2);
            
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
end

d_q = delta_q(2:end,:);

end
