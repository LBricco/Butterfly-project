close all
clearvars
clc
format long

N = 16; % numero di campioni
Wr_vec = zeros(1, N/2); % vettore delle parti reali
Wi_vec = zeros(1, N/2); % vettore delle parti immaginarie
W_vec = zeros(1, N/2); % vettore dei twiddle factors completi
q = quantizer([24,23]); % quantizzatore (24 bit di cui 23 frazionari)

%% Calcolo dei twiddle factors
for j=1:N/2
    k = j - 1;
    x = 2 * pi * k / N;
    W_vec(j) = cos(x) - 1i*sin(x);
    Wr_vec(j) = real(W_vec(j));
    Wi_vec(j) = imag(W_vec(j));
end

%% Ingressi butterfly primo livello, dinamica -0.5/+0.5
dinamica_L1_W0 = [-0.5 0.5];
ingressi_L1_W0 = worstCaseInput(dinamica_L1_W0, q); % in C2
writematrix(ingressi_L1_W0)

%% Butterfly primo livello con W = W0
Wr = Wr_vec(1); % 1
Wi = Wi_vec(1); % 0
[risultati_L1_W0, dinamica_L2_W0_W4] = butterflyRange(Wr, Wi, dinamica_L1_W0); % uscite livello 1 (W0) e relativa dinamica
ingressi_L2_W0_W4 = worstCaseInput(dinamica_L2_W0_W4, q); % ingressi ai limiti della dinamica livello 2 (W0-W4)

writematrix(ingressi_L2_W0_W4)
writematrix(risultati_L1_W0,'risultati_L1_W0_matlab.txt','Delimiter','space')

%% Butterfly secondo livello con W = W0
Wr = Wr_vec(1); % 1
Wi = Wi_vec(1); % 0
[risultati_L2_W0, dinamica_L3_W0_W4] = butterflyRange(Wr, Wi, dinamica_L2_W0_W4); % uscite livello 2 (W0) e relativa dinamica
ingressi_L3_W0_W4 = worstCaseInput(dinamica_L3_W0_W4, q); % ingressi ai limiti della dinamica livello 3 (W0-W4)

writematrix(ingressi_L3_W0_W4)
writematrix(risultati_L2_W0,'risultati_L2_W0_matlab.txt','Delimiter','space')

%% Butterfly secondo livello con W = W4
Wr = Wr_vec(5); % 0
Wi = Wi_vec(5); % -1
[risultati_L2_W4, dinamica_L3_W2_W6] = butterflyRange(Wr, Wi, dinamica_L2_W0_W4); % uscite livello 2 (W4) e relativa dinamica
ingressi_L3_W2_W6 = worstCaseInput(dinamica_L3_W2_W6, q); % ingressi ai limiti della dinamica livello 3 (W2-W6)

writematrix(ingressi_L3_W2_W6)
writematrix(risultati_L2_W4,'risultati_L2_W4_matlab.txt','Delimiter','space')

%% Butterfly terzo livello con W = W0
Wr = Wr_vec(1); % 1
Wi = Wi_vec(1); % 0
[risultati_L3_W0, dinamica_L4_W0_W4] = butterflyRange(Wr, Wi, dinamica_L3_W0_W4); % uscite livello 3 (W0) e relativa dinamica
ingressi_L4_W0_W4 = worstCaseInput(dinamica_L4_W0_W4, q); % ingressi ai limiti della dinamica livello 4 (W0-W4)

writematrix(ingressi_L4_W0_W4)
writematrix(risultati_L3_W0,'risultati_L3_W0_matlab.txt','Delimiter','space')

%% Butterfly terzo livello con W = W4
Wr = Wr_vec(5); % 0
Wi = Wi_vec(5); % -1
[risultati_L3_W4, dinamica_L4_W2_W6] = butterflyRange(Wr, Wi, dinamica_L3_W0_W4); % uscite livello 3 (W4) e relativa dinamica
ingressi_L4_W2_W6 = worstCaseInput(dinamica_L4_W2_W6, q); % ingressi ai limiti della dinamica livello 4 (W2-W6)

writematrix(ingressi_L4_W2_W6)
writematrix(risultati_L3_W4,'risultati_L3_W4_matlab.txt','Delimiter','space')

%% Butterfly terzo livello con W = W2
Wr = Wr_vec(3); % 0.707106781186548
Wi = Wi_vec(3); % -0.707106781186548
[risultati_L3_W2, dinamica_L4_W1_W5] = butterflyRange(Wr, Wi, dinamica_L3_W2_W6); % uscite livello 3 (W2) e relativa dinamica
ingressi_L4_W1_W5 = worstCaseInput(dinamica_L4_W1_W5, q); % ingressi ai limiti della dinamica livello 4 (W1-W5)

writematrix(ingressi_L4_W1_W5)
writematrix(risultati_L3_W2,'risultati_L3_W2_matlab.txt','Delimiter','space')

%% Butterfly terzo livello con W = W6
Wr = Wr_vec(7); % -0.707106781186548
Wi = Wi_vec(7); % -0.707106781186548
[risultati_L3_W6, dinamica_L4_W3_W7] = butterflyRange(Wr, Wi, dinamica_L3_W2_W6); % uscite livello 3 (W6) e relativa dinamica
ingressi_L4_W3_W7 = worstCaseInput(dinamica_L4_W3_W7, q); % ingressi ai limiti della dinamica livello 4 (W3-W7)

writematrix(ingressi_L4_W3_W7)
writematrix(risultati_L3_W6,'risultati_L3_W6_matlab.txt','Delimiter','space')

%% Butterfly quarto livello con W = W0
Wr = Wr_vec(1); % 1
Wi = Wi_vec(1); % 0
[risultati_L4_W0, dinamica_uscita_L4_W0] = butterflyRange(Wr, Wi, dinamica_L4_W0_W4); % uscite livello 4 (W0) e relativa dinamica

writematrix(risultati_L4_W0,'risultati_L4_W0_matlab.txt','Delimiter','space')

%% Butterfly quarto livello con W = W4
Wr = Wr_vec(5); % 0
Wi = Wi_vec(5); % -1
[risultati_L4_W4, dinamica_uscita_L4_W4] = butterflyRange(Wr, Wi, dinamica_L4_W0_W4); % uscite livello 4 (W4) e relativa dinamica

writematrix(risultati_L4_W4,'risultati_L4_W4_matlab.txt','Delimiter','space')

%% Butterfly quarto livello con W = W2
Wr = Wr_vec(3); % 0.707106781186548
Wi = Wi_vec(3); % -0.707106781186548
[risultati_L4_W2, dinamica_uscita_L4_W2] = butterflyRange(Wr, Wi, dinamica_L4_W2_W6); % uscite livello 4 (W2) e relativa dinamica

writematrix(risultati_L4_W2,'risultati_L4_W2_matlab.txt','Delimiter','space')

%% Butterfly quarto livello con W = W6
Wr = Wr_vec(7); % -0.707106781186548
Wi = Wi_vec(7); % -0.707106781186548
[risultati_L4_W6, dinamica_uscita_L4_W6] = butterflyRange(Wr, Wi, dinamica_L4_W2_W6); % uscite livello 4 (W6) e relativa dinamica

writematrix(risultati_L4_W6,'risultati_L4_W6_matlab.txt','Delimiter','space')

%% Butterfly quarto livello con W = W1
Wr = Wr_vec(2); % 0.923879532511287
Wi = Wi_vec(2); % -0.382683432365090
[risultati_L4_W1, dinamica_uscita_L4_W1] = butterflyRange(Wr, Wi, dinamica_L4_W1_W5); % uscite livello 4 (W1) e relativa dinamica

writematrix(risultati_L4_W1,'risultati_L4_W1_matlab.txt','Delimiter','space')

%% Butterfly quarto livello con W = W5
Wr = Wr_vec(6); % -0.382683432365090
Wi = Wi_vec(6); % -0.923879532511287
[risultati_L4_W5, dinamica_uscita_L4_W5] = butterflyRange(Wr, Wi, dinamica_L4_W1_W5); % uscite livello 4 (W5) e relativa dinamica

writematrix(risultati_L4_W5,'risultati_L4_W5_matlab.txt','Delimiter','space')

%% Butterfly quarto livello con W = W3
Wr = Wr_vec(4); % 0.382683432365090
Wi = Wi_vec(4); % -0.923879532511287
[risultati_L4_W3, dinamica_uscita_L4_W3] = butterflyRange(Wr, Wi, dinamica_L4_W3_W7); % uscite livello 4 (W3) e relativa dinamica

writematrix(risultati_L4_W3,'risultati_L4_W3_matlab.txt','Delimiter','space')

%% Butterfly quarto livello con W = W7
Wr = Wr_vec(8); % -0.923879532511287
Wi = Wi_vec(8); % -0.382683432365090
[risultati_L4_W7, dinamica_uscita_L4_W7] = butterflyRange(Wr, Wi, dinamica_L4_W3_W7); % uscite livello 4 (W7) e relativa dinamica

writematrix(risultati_L4_W7,'risultati_L4_W7_matlab.txt','Delimiter','space')


%% Funzione per calcolare le 4 uscite (A', B') di una singola butterfly dati i 6 ingressi (A, B, W)
function [Ar_primo, Ai_primo, Br_primo, Bi_primo] = butterfly(Ar, Ai, Br, Bi, Wr, Wi)
% Moltiplicazioni
M1 = Br * Wr;
M2 = Bi * Wi;
M3 = Br * Wi;
M4 = Bi * Wr;
M5 = 2 * Ar;
M6 = 2 * Ai;

% Somme e sottrazioni
sigma_1 = Ar + M1;
sigma_2 = sigma_1 - M2;
sigma_3 = Ai + M3;
sigma_4 = sigma_3 + M4;
sigma_5 = M5 - sigma_2;
sigma_6 = M6 - sigma_4;

Ar_primo = sigma_2;
Ai_primo = sigma_4;
Br_primo = sigma_5;
Bi_primo = sigma_6;

% Arrotondamenti per riportare la dinamica a -1/+1
if abs(Ar_primo) >= 1
    while abs(Ar_primo) >= 1
        Ar_primo = Ar_primo / 2;
    end
else
    Ar_primo = Ar_primo / 2;
end

if abs(Ai_primo) >= 1
    while abs(Ai_primo) >= 1
        Ai_primo = Ai_primo / 2;
    end
else
    Ai_primo = Ai_primo / 2;
end

if abs(Br_primo) >= 1
    while abs(Br_primo) >= 1
        Br_primo = Br_primo / 2;
    end
else
    Br_primo = Br_primo / 2;
end

if abs(Bi_primo) >= 1
    while abs(Bi_primo) >= 1
        Bi_primo = Bi_primo / 2;
    end
else
    Bi_primo = Bi_primo / 2;
end

end

%% Funzione per calcolare la dinamica di uscita della butterfly al variare della dinamica di ingresso e del twiddle factor W
% @return output_data_real = matrice con i risultati corrispondenti ad ingressi ai limiti della dinamica
% @return output_range = dinamica di uscita della butterfly
% I dati uscita verranno usati per il confronto con i risultati della simulazione, quindi conviene generare una matrice di numeri reali 16x4
    function [output_data_real, output_range] = butterflyRange(Wr, Wi, range)
        % calcolo le uscite con tutte le combinazioni di ingressi
        output_data_real = zeros(16,4);
        i = 1;
        for n1=1:2
            for n2=1:2
                for n3=1:2
                    for n4=1:2
                        Ar = range(n1);
                        Ai = range(n2);
                        Br = range(n3);
                        Bi = range(n4);
                        [Ar_primo, Ai_primo, Br_primo, Bi_primo] = butterfly(Ar, Ai, Br, Bi, Wr, Wi);
                        output_data_real(i,1) = Ar_primo;
                        output_data_real(i,2) = Ai_primo;
                        output_data_real(i,3) = Br_primo;
                        output_data_real(i,4) = Bi_primo;
                        i = i + 1;
                    end
                end
            end
        end
        
        % ciclo sugli elementi della matrice e sostituisco con degli zeri tutti i numeri inferiori in modulo a 1e-12
        for i=1:16
            for j=1:4
                if abs(output_data_real(i,j)) < 1e-12
                    output_data_real(i,j) = 0;
                end
            end
        end
        
        % definisco il nuovo range
        output_range = [min(output_data_real,[],"all") max(output_data_real,[],"all")];
    end

%% Funzione per calcolare tutte le combinazioni di ingressi ai limiti della dinamica
% La matrice risultante verrà data in pasto a Modelsim, quindi è conveniente generare una matrice 4x16 e convertirne gli elementi in C2 con la funzione dec2bin
    function output_data = worstCaseInput(input_range, quantizer)
        output_data_real = zeros(4,16);
        i = 1;
        for n1=1:2
            for n2=1:2
                for n3=1:2
                    for n4=1:2
                        output_data_real(1,i) = input_range(n1);
                        output_data_real(2,i) = input_range(n2);
                        output_data_real(3,i) = input_range(n3);
                        output_data_real(4,i) = input_range(n4);
                        i = i + 1;
                    end
                end
            end
        end
        output_data = num2bin(quantizer, output_data_real);
    end