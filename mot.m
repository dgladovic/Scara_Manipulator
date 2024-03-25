function [q1, q2] = mot(korak, B)
    i1 = 12.1558; % prenosni odnos 1
    i2 = 10.8052; % prenosni odnos 2
    
    pomeraj1 = korak / i1;
    pomeraj2 = korak / i2;
    
    ost1 = 0;
    q1 = [];
    q2 = [];
    
    for i = 1:size(B,1)
        B(i,1) = B(i,1) + ost1;
        q1(i,2) = B(i,2);
        q1(i,1) = floor(abs(B(i,1)) / pomeraj1);
        ost1 = B(i,1) - sign(B(i,1)) * q1(i,1) * pomeraj1;
    end
    ost1
    
    ost2 = 0;
    for i = 1:size(B,1)
        B(i,3) = B(i,3) + ost2;
        q2(i,2) = B(i,4);
        q2(i,1) = floor(abs(B(i,3)) / pomeraj2);
        ost2 = B(i,3) - sign(B(i,3)) * q2(i,1) * pomeraj2;
    end
    ost2
    
    q1 = uint8(q1);
    q2 = uint8(q2);
end
