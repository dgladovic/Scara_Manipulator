function y = oblast1(p)
%funkcija proverava da li putanja ili tacka pripada oblasti
qmax = [(170/2)*2*pi/360; (254/2)*2*pi/360];
[m,~] = size(p);


for i = 1:m
    if (p(i,1) - 150*cos(qmax(1)))^2 + (p(i,2) - 150*sin(qmax(1)))^2 <= 105^2
        k = 1;
        break
    else 
        k = 0;
    end
end

y = k;
end
