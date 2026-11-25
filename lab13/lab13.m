clear
clc
close all

% Matrizes do sistema discreto
Ad = [0.8672 -0.0496; 0.0836 0.9977];
Bd = [0.0836; 0.0038];
Cd = [0 0.5929];
Dd = 0;

% 1. Montagem do sistema aumentado com ação integrativa
Aa = [Ad zeros(2,1); -Cd 1];
Ba = [Bd; 0];

% 2. Verificar a controlabilidade do sistema aumentado
Co = ctrb(Aa, Ba);

if rank(Co) == size(Aa, 1)
    disp('Sistema aumentado controlável!');
else
    error('Sistema aumentado não controlável.');
end

% 3. Escolher os polos desejados
% Dois polos utilizados no laboratório anterior
% Terceiro polo mais lento, responsável pela ação integrativa
polos = [1e-4 2e-4 0.5];

% 4. Calcular os ganhos por alocação de polos
Ka = place(Aa, Ba, polos);

% 5. Separar os ganhos de realimentação e ação integrativa
K = Ka(1:2);
Ki = -Ka(3);

disp('Ganho de realimentação de estados K:')
disp(K)

disp('Ganho de ação integrativa Ki:')
disp(Ki)

% 6. Verificar os polos da malha fechada
Amf = Aa - Ba*Ka;

polos_mf = eig(Amf);

disp('Polos da malha fechada:')
disp(polos_mf)

% 7. Verificar estabilidade
if all(abs(polos_mf) < 1)
    disp('Sistema em malha fechada estável!');
else
    disp('Sistema em malha fechada instável!');
end
