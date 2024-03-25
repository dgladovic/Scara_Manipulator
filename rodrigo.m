function [ A ] = rodrigo(e, psi)
%matrica transformacije za rotaciju oko jedinicnog vektora e za ugao od psi
%radijana

e_d = dualni_obj(e);
e_d2 = e_d^2;

A = eye(3) + (1-cos(psi))*e_d^2 + sin(psi)*e_d;

end
