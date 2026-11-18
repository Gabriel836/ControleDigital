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
