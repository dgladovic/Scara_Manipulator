function [m1,m2] = smart_mot3(korak,B)

i1 = 12.1558;
i2 = 10.8052;

pomeraj1 = korak/i1;
pomeraj2 = korak/i2;

ost2 = 0;
q = [];
q2= [];

for i = 1:size(B,1)
    ost1 = 3;
    j = 0;
    while ost1 >= pomeraj1
        ost1 = abs(B(i,1)) - j*pomeraj1 + ost2;
        nv(i,1)=j;
        j = j+1;
        ost2 = 0;
        if B(i,2)
            nv(i,2)=1;
        else
            nv(i,2)=0;
        end
    end
    q = [nv];
    ost2 = ost1+ost2;
end
k_ost1 = ost2;
ost2 = 0;

for i = 1:size(B,1)
    ost1 = 3;
    j = 0;
    while ost1 >= pomeraj2
        ost1 = abs(B(i,3)) - j*pomeraj2 + ost2;
        nv2(i,1)=j;
        j = j+1;
        ost2 = 0;
        if B(i,4)
            nv2(i,2)=1;
        else
            nv2(i,2)=0;
        end
    end
    q2 = [nv2];
    ost2 = ost1+ost2;
end
k_ost2 = ost2;
%% Sumiranje
j = 1;

for i = 1:size(q,1)
    if i == 1
        m1(j,1) = q(i,1);
        m1(j,2) = q(i,2);
    else
        if q(i-1,2) == q(i,2)
            m1(j,1) = q(i,1) + m1(j,1);
        else
            if q(i-1,1) == 0
                m1(j,1) = m1(j,1) - q(i,1);
                m1(j+1,1) =  q(i,1);
            end
            m1(j,1) = q(i,1) + m1(j,1);
            j = j+1;
            m1(j,2) = q(i,2);
        end
    end
end


j = 1;

for i = 1:size(q2,1)
    if i == 1
        m2(j,1) = q2(i,1);
        m2(j,2) = q2(i,2);
    else
        if q2(i-1,2) == q2(i,2)
            m2(j,1) = q2(i,1) + m2(j,1);
        else
            if q2(i-1,1) == 0
                m2(j,1) = m2(j,1) - q2(i,1);
                m2(j+1,1) =  q2(i,1);
            end
            m2(j,1) = q2(i,1) + m2(j,1);
            j = j+1;
            m2(j,2) = q2(i,2);
        end
    end
end

end
