clearvars; clc; 
% Matrices y vectores. 
%Programe un script en Matlab que permita realizar una serie de operaciones con dos matrices (A y B) que se 
%introducirán por teclado. Para ello: 

% •Solicite al usuario las dimensiones de las matrices 
dim_A_str = input("Indique las dimensiones de la matriz A, introduciendo uno o dos números separados por un espacio: ", "s");
dim_B_str = input("Indique las dimensiones de la matriz B, introduciendo uno o dos números separados por un espacio: " , "s");

%proceso de creación de la matriz A
dim_A = str2num(dim_A_str); %convierte la cadena a num

%comprobar si es solo un num  
if isscalar(dim_A) && isnumeric(dim_A) && dim_A > 0 && mod(dim_A, 1) == 0
    DimensionesA = [dim_A, dim_A];
%comprobar si es un vector de dos nums
elseif isvector(dim_A) && length(dim_A) == 2 && all(isnumeric(dim_A)) && all(dim_A > 0) && all(mod(dim_A, 1) == 0)
    %vector válido
    DimensionesA = dim_A;
else
    %entrada inválida
    disp("Error: Debe introducir un entero positivo o dos enteros positivos."); %error handling kind of mid but works lol we can improve it later 
    return; % Terminar el script
end

%Llamar a la función en el otro script para crear la Matriz A pasando param DimensionesA 
disp("--- Matriz A ---");
A = IntroducirMatriz(DimensionesA);
disp("Matriz A generada:");
disp(A);

%proceso de creación de la matriz B
dim_B = str2num(dim_B_str);

if isscalar(dim_B) && isnumeric(dim_B) && dim_B > 0 && mod(dim_B, 1) == 0
    DimensionesB = [dim_B, dim_B];
elseif isvector(dim_B) && length(dim_B) == 2 && all(isnumeric(dim_B)) && all(dim_B > 0) && all(mod(dim_B, 1) == 0)
    DimensionesB = dim_B;
else
    disp('Error: Debe introducir un entero positivo o dos enteros positivos.');
    return;
end

disp("--- Matriz B ---");
B = IntroducirMatriz(DimensionesB);
disp("Matriz B generada:");
disp(B);

% •Calcule y muestre por pantalla:  
% •El valor del determinante y el rango de cada una de las matrices 
disp("--- Matriz A ---");
if size(A, 1)== size(A, 2)
    A_det = det(A);
    disp ("El determinante de A es:");
    disp(A_det);
else 
    disp ("No se puede realizar la el determinate de matrices no cuadradas: ");
end

A_rang = range(A);
disp ("El rango de A es:");
disp(A_rang);

disp("--- Matriz B ---");
if size(B, 1)== size(B, 2)
    B_det = det(B);
    disp ("El determinante de B es:");
    disp(B_det);
else 
    disp ("No se puede realizar la el determinate de matrices no cuadradas: ");
end

B_rang = range(B);
disp ("El rango de B es:");
disp(B_rang);

% •La transpuesta e inversa de cada una de las matrices 
disp("--- Matriz A ---");
A_trans = A';
disp ("La matriz transpuesta A es:");
disp(A_trans);

if size(A, 1)== size(A, 2) && A_det ~=0
    A_inv = inv(A);
    disp ("La matriz inversa A es:");
    disp(A_inv);
else 
    disp ("No se puede hacer la inversa de la matriz");
end 

disp("--- Matriz B ---");
B_trans = B';
disp ("La matriz transpuesta B es:");
disp(B_trans);

if size(B, 1)== size(B, 2) && B_det ~=0
    B_inv = inv(B);
    disp ("La matriz inversa B es:");
    disp(B_inv);
else 
    disp ("No se puede hacer la inversa de la matriz");
end 

% •El producto de A y B (matricial y elemento a elemento)
% comprobar primero columna matriz A y fila B de las matrices correspondientes
if size(A,2)== size(B,1)
    mult= A*B;
    disp ("La multiplicación (A * B) de las matrices  es: ");
    disp (mult);

    % 2. Calcular el producto elemento a elemento (A .* B) si las dimensiones son compatibles
    if all(size(A)==size(B))
        mult_elementos= A .* B ;
        disp ("La multiplicación (A .* B) de las matrices es: ");
        disp (mult_elementos);
    else
        disp("El producto elemento a elemento no se puede calcular (las matrices no tienen las mismas dimensiones).");
    end
else
    disp ("No se puede realizar la multiplicación de matrices: ");
end

% •Un vector fila obtenido concatenando la primera fila de cada una de las matrices
A_fila = A(1, :);
B_fila = B(1, :);
vector_fila_AB = [A_fila B_fila];
disp ("El vector fila obtenido concatenando la primera fila de cada una de las matrices es:");
disp(vector_fila_AB);

% •Un vector columna obtenido concatenando la primera columna de cada una de las matrices 
A_col = A(:, 1);
B_col = B(:, 1);
vector_col_AB = [A_col B_col];
disp ("El vector columna obtenido concatenando la primera columna de cada una de las matrices es:");
disp(vector_col_AB);
