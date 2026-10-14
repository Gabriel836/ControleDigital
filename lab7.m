% ----------------------------------------
% Refazendo coisas do lab 4
% ----------------------------------------

% ----------------------------------------
% EXERCICIO 27
% ----------------------------------------

ess_pct = 14.5; 
Kp = 100/ess_pct - 1;
disp('Kp necessario para ess% especificado:')
disp(Kp)

% ------------------------------------------
% Função de transferência
% ------------------------------------------

wn = 0.77;
zeta = 1.013;
R = 1.17;

Gp = tf(wn^2, [1 2*zeta*wn wn^2]);

% -------------------------------------------
% Tkp
% -----------------------------------------
Gmfc = feedback(Kp*Gp, 1);
wb = bandwidth(Gmfc);
fb = wb/(2*pi);
fs = 10*fb;
Tkp = 1/fs;
disp("Tkp:")
Tkp

%------------------------------------------
% planta discretizada com zero holder
% ---------------------------------------
Gz = c2d(Gp, Tkp, 'zoh');
disp("planta discretizada com zero holder")
Gz