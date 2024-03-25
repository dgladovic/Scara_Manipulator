k = 1;
Q11 = [];
D = [];
F = [];
load ('LAP.mat') %Ucitavanje mogucih vrednosti xH i yH
n = 0; %Zeljeno xH
m = 200; %Zeljeno yH
for i = 1:size(X,1)
    for j = 1:size(X,2)
        a = abs(X(i,j) - n); %Tacke u okolini zeljenog x
        b = abs(Y(i,j) - m); %Tacke u okolini zeljenog y
        if a <= 1.5 && b <= 1.5;
            Q11(1,k) = i; %Cuva vrednost q1 za datu tacku
            Q11(2,k) = j; %Cuva vrednost q2 za datu tacku
            Q11(3,k) = a; %Vrednost X za zadati kriterijum
            Q11(4,k) = b; %Vrednost Y za zadati kriterijum
            k = k+1;
            D = Q11(3,:);
            F = Q11(4,:);
        end
    end
end
d = min(D); %Najmanje odstupanje za X
f = min(F); %Najmanje odstupanje za Y
d1 = find(d == D); %Trazenje indeks
f1 = find(f == F);
comp = abs(D(1,d1) - F(1,d1));
comp1 = abs(D(1,f1) - F(1,f1)); %Poredjenje 2 minimuma
if comp1 > comp
    l = d1;
else
    l = f1;
end
for m = 1:size(l,2)
    M(1,m) = Q11(1,l(m)); %Pozicija q1
    M(2,m) = Q11(2,l(m)); %Pozicija q2
end
