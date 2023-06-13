function C=Covar(D,tau, sub_mean, tau_norm)
% oblicza wartosc funkcji kowariancji 'c(tau)' dla sygnalów zawartych w D i
% przesuniecia czasowego równego 'tau'
% parametry wejœciowe: D - macierz skladajaca sie z 2 kolumn (y(n), u(n));
% tau - zadana wartosc przesuniecia sygnalów (liczba próbek przesuniecia);

Y = D(:,1);
U = D(:,2);

N = size(Y,1);
Yp = zeros(N,1);

MU = (1/N)*sum(U);
MY = (1/N)*sum(Y);

Ud = U;
Yd = Y;
if (sub_mean)
    Ud = U - MU*ones(N,1);              %odjecie wartosci srednich
    Yd = Y - MY*ones(N,1);
end

if (tau>=0)
    Yp(1:(N-tau)) = Yd((1+tau):N);  
else
    Yp((1-tau):N) = Yd(1:(N+tau));  
end

CYU = 0;
if (tau_norm)
    CYU = (1/(N-abs(tau)))*(Ud'*Yp);
else
    CYU = (1/N)*(Ud'*Yp);
end

C = CYU;