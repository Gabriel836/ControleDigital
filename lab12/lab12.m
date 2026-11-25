Ad = [0.8672 -0.0496; 0.0836 0.9977]
Bd = [0.0836; 0.0038]
Cd = [0 0.5929]
Dd = [0]

% 1. Verificar se o sistema é observável (posto deve ser igual à ordem do sistema, 2)
O = obsv(Ad, Cd);
if rank(O) == size(Ad, 1)
    disp('Sistema observável!');
else
    error('Sistema não observável.');
end

% 2. Definir os polos desejados para comportamento dead-beat (z = 0)
% Opção A: Usando 'place' (exige polos distintos e diferentes de zero)
polos_place = [1e-4 2e-4]; 
L = place(Ad', Cd', polos_place)';

% 3. Conferir os polos do observador (devem estar em ~0)
polos_observador = eig(Ad - L*Cd)

% 4. Matrizes auxiliares para montar o diagrama da Figura 1 no Simulink (Exercício 2)
F = Ad;
H = Bd - L*Dd; % Caso Dd = 0, resulta em H = Bd
disp("F: ")
disp(F)

disp("H: ")
disp(H)

disp("Ganho do observador: ")
disp(L)

%Gráficos
figure
plot(out.yd.Time, out.yd.Data, 'b')
title("Resposta do sistema ao degrau: saída real e estimada")
grid
hold on
plot(out.yd_estimado.Time, out.yd_estimado.Data, 'r')
legend('Real', 'Estimado', 'Location','best')
hold off

figure
plot(out.xd.Time, out.xd.Data, 'b', 'DisplayName', 'Real')
title("Estados discretos do sistema: real e estimado")
grid
hold on
plot(out.xd_estimado.Time, out.xd_estimado.Data, 'r', 'DisplayName', 'Estimado')
legend('Real', 'Estimado', 'Location', 'best')
