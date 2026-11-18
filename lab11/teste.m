
clc;
clear;
close all;

%% Matrizes do Lab 6

Ad = [0.8672 -0.0496;
      0.0836  0.9977];

Bd = [0.0836;
      0.0038];

Cd = [0 0.5929];
Dd = 0;

% Ganho de realimentacao (Lab 11)
K = [0.2552 0.7269];

% Periodo de amostragem
T0 = 0.0897;

%% Parametros da simulacao

tf = 24;
t = 0:T0:tf;
N = length(t);

% Referencia
r = 1.17 * ones(1,N);

% Disturbio de -0.15 em 12 segundos
d = zeros(1,N);
d(t >= 12) = -0.15;

%% Simulacao discreta

% Condicoes iniciais nulas
x = zeros(2,N+1);
u = zeros(1,N);
y = zeros(1,N);

for k = 1:N

    % Lei de controle
    u(k) = r(k) + d(k) - K*x(:,k);

    % Saida do sistema
    y(k) = Cd*x(:,k) + Dd*u(k);

    % Atualizacao dos estados
    x(:,k+1) = Ad*x(:,k) + Bd*u(k);
end

%% Figura 1 - Estados

figure;
plot(t, x(1,1:N), 'b', 'LineWidth', 1.5);
hold on;
plot(t, x(2,1:N), 'r', 'LineWidth', 1.5);

xline(12, '--k', 'Disturbio');

grid on;
title('Estados discretos do sistema');
xlabel('Tempo (s)');
ylabel('Estados x(k)');
legend('x_1(k)', 'x_2(k)', 'Location', 'best');

%% Figura 2 - Saida

figure;
plot(t, y, 'b', 'LineWidth', 1.5);
hold on;
plot(t, r, '--k', 'LineWidth', 1);

xline(12, '--r', 'Disturbio');

grid on;
title('Resposta do sistema ao degrau');
xlabel('Tempo (s)');
ylabel('Saida y(k)');
legend('Saida', 'Referencia', 'Location', 'best');

%% Figura 3 - Entrada da planta

figure;
plot(t, u, 'b', 'LineWidth', 1.5);
hold on;

xline(12, '--r', 'Disturbio');

grid on;
title('Sinal de entrada da planta');
xlabel('Tempo (s)');
ylabel('Entrada u(k)');

%% Verificacao dos polos

Amf = Ad - Bd*K;

disp('Polos de malha fechada:');
disp(eig(Amf));

%% Valores finais

disp('Estados no final da simulacao:');
disp(x(:,N));

disp('Saida no final da simulacao:');
disp(y(end));

disp('Entrada no final da simulacao:');
disp(u(end));
