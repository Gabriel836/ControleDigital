clc;
close all;


clc;
clear;
close all;
format long;

%% 1. Matrizes do espaco de estados (Lab 6)

Ad = [0.8672 -0.0496;
      0.0836  0.9977];

Bd = [0.0836;
      0.0038];

Cd = [0 0.5929];
Dd = 0;

%% 2. Polos desejados (Lab 7)

p1 = 0.9204 + 0.0597j;
p2 = 0.9204 - 0.0597j;

polos_desejados = [p1 p2];

%% 3. Polinomio caracteristico desejado
% Pd(z) = (z-p1)*(z-p2)

Pd = real(poly(polos_desejados));

disp('Polinomio caracteristico desejado:');
disp(Pd);

%% 4. Polinomio caracteristico da planta
% P(z) = det(zI-Ad)

Pa = poly(Ad);

disp('Polinomio da planta em malha aberta:');
disp(Pa);

%% 5. Determinacao dos ganhos k1 e k2
% Para Amf = Ad - Bd*K:
%
% tr(Amf) = p1+p2
% det(Amf) = p1*p2
%
% K = [k1 k2]

% Condicao do traco
% B1*k1 + B2*k2 = tr(Ad) - soma dos polos

M11 = Bd(1);
M12 = Bd(2);

b1 = trace(Ad) - real(sum(polos_desejados));

% Condicao do determinante
% det(Ad-Bd*K) = produto dos polos

M21 = Bd(1)*Ad(2,2) - Bd(2)*Ad(1,2);
M22 = Bd(2)*Ad(1,1) - Bd(1)*Ad(2,1);

b2 = det(Ad) - real(prod(polos_desejados));

% Sistema linear M*[k1;k2] = b

M = [M11 M12;
     M21 M22];

b = [b1; b2];

ganhos = M\b;

K_manual = ganhos.';

disp('Ganho calculado pelos coeficientes:');
disp(K_manual);

%% 6. Calculo pelo comando place
% Conforme os slides do professor

K_place = place(Ad, Bd, polos_desejados);

disp('Ganho calculado pelo place:');
disp(K_place);

%% 7. Calculo pelo comando acker

K_acker = acker(Ad, Bd, polos_desejados);

disp('Ganho calculado pelo acker:');
disp(K_acker);

%% 8. Verificacao dos polos

Amf = Ad - Bd*K_place;

polos_obtidos = eig(Amf);

disp('Polos obtidos em malha fechada:');
disp(polos_obtidos);

%% 9. Verificacao da controlabilidade

Qc = ctrb(Ad, Bd);

disp('Posto da matriz de controlabilidade:');
disp(rank(Qc));

%% 10. Exibicao do ganho final

K = K_place;

disp('Ganho final para o Simulink:');
disp(K);



%-------------------------------
% QUESTÃO 4

figure
plot(out.y_d.Time, out.y_d.Data, 'b')
title("Resposta do sistema ao degrau (simulado no Simulink)")
grid

figure
plot(out.x_d.Time, out.x_d.Data, 'b')
title("Estados discretos do sistema (simulado no Simulink)")
grid

figure
plot(out.u_d.Time, out.u_d.Data, 'b')
title("Entrada do sistema (simulado no Simulink)")
grid
