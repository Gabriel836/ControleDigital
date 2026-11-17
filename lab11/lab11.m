clc;
close all;

% Matrizes discretas do Lab 6
Ad = [0.8672 -0.0496;
      0.0836  0.9977];

Bd = [0.0836;
      0.0038];

% Polos dominantes do PID (Lab 7)
p1 = 0.9204 + 0.0597j;
p2 = 0.9204 - 0.0597j;

polos_desejados = [p1 p2];

% Calculo do ganho de realimentacao
K = place(Ad, Bd, polos_desejados);

disp('Ganho de realimentacao K:');
disp(K);

% Matriz da malha fechada
Amf = Ad - Bd*K;

% Verificacao dos polos obtidos
polos_obtidos = eig(Amf);

disp('Polos da malha fechada:');
disp(polos_obtidos);

% Matrizes e ganho
Ad = [0.8672 -0.0496;
      0.0836  0.9977];

Bd = [0.0836; 0.0038];
Cd = [0 0.5929];
K = [0.2552 0.7269];

T0 = 0.0897;

% Matriz de malha fechada
Amf = Ad - Bd*K;

% Verificacao de estabilidade
eig(Amf)

% Simulacao independente do Simulink
sistema = ss(Amf, Bd, Cd, 0, T0);

figure;
step(1.17*sistema, 24);
grid on;
title('Resposta esperada com realimentacao de estados');
xlabel('Tempo (s)');
ylabel('Saida y(k)');


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
