%% 
clear
close all

%------------------------------------------------------
% QUESTAO 1
%------------------------------------------------------

% Parametros
K = 1;
wn = 0.77;
zeta = 1.013; % Sobreamortecido (zeta > 1)
R = 1.17;

% Funcao de transferencia
G = K * tf(wn^2, [1 2*zeta*wn wn^2]);

% Polos
p = pole(G);
disp("Polos FT contínua:");
disp(p);

%------------------------------------------------------
% QUESTAO 2
%------------------------------------------------------

% Largura de banda
wb = bandwidth(G);
disp("Largura de banda [rad/s]:")
disp(wb)

fb = wb/(2*pi);
disp("Largura de banda [Hz]:")
disp(fb)

% Frequencia de amostragem
fs = 10 * fb;
disp("Frequencia de amostragem (10 * fb) [Hz]:")
disp(fs)

T0 = 1/fs;
disp("Periodo de amostragem:")
disp(T0)

%------------------------------------------------------
% QUESTAO 3
%------------------------------------------------------

% Funcao de transferencia discreta (zero holder)
Gz = c2d(G, T0, 'zoh');

%------------------------------------------------------
% QUESTAO 4
%------------------------------------------------------

% Polos e zeros
Pz = pole(Gz);
Zz = zero(Gz);

disp("Polos da FT discreta (zero holder):")
disp(Pz)

disp("Zeros da FT discreta (zero holder):")
disp(Zz);

%------------------------------------------------------
% QUESTAO 5
%------------------------------------------------------

% Resposta da FT continua ao degrau
figure
step(R*G);
title("Resposta do sistema ao degrau")
grid

hold on
step(R*Gz);
legend('Contínuo', 'Discreto')

%------------------------------------------------------
% QUESTAO 7
%------------------------------------------------------

[num, den] = tfdata(G, 'v');
disp("Coeficientes do numerador da TF")
disp(num)

disp("Coeficientes do denominador da TF")
disp(den)

%------------------------------------------------------
% QUESTAO 8
%------------------------------------------------------
%% 

figure
plot(out.y_c.Time, out.y_c.Data, 'b')
title("Resposta do sistema ao degrau (simulado no Simulink)")
grid

hold on;
stairs(out.y_d.Time, out.y_d.Data, 'r');
legend('Contínuo', 'Discreto')