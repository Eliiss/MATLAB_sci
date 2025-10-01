clearvars
% Matrices y vectores. 
% Realice un script de Matlab que permita desarrollar una serie de operaciones con una matriz:
% 1. Cree la siguiente matriz A y el vector v: 

A = [1 2; 3 4; 5 6; 7 8];
v = [14; 16; 18; 20];

% 2. Obtenga y visualice una matriz B concatenando la matriz A y el vector v.
B = [A v];

% 3. Obtenga y visualice un vector fila resultado de concatenar las filas de la matriz B.
vector_fila= [];
for i = 1:size(B,1)
    vector_fila = [vector_fila B(i,:)]; %coge la fila i de B y se añade al vector_fila.
end

% 4.  Obtenga y visualice un vector columna resultado de concatenar las columnas de la matriz B. 
vector_columna = B (:); 

