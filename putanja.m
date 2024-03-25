function  p = putanja(H, T,broj)
%H = [xH yH], T = [xT yT]
% funkcija vraca putanju izmedju H i T predstavljenu diskretno,
%tj. tackama sa jednakim korakom
if H(1) == T(1)
    for i = 1:broj
        x(i) = H(1);
    end
    x = x';
    y = linspace(H(2),T(2),broj)';
else
    x = linspace(H(1), T(1), broj)'; 
    k = (T(2) - H(2))/(T(1) - H(1));
    y = (k*x + H(2) - k*H(1));
end

p = [x, y];

end
