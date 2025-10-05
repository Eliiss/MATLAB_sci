% Función para introducir una matriz por teclado (o rellenarla con valores aleatorios)
function Matriz = IntroducirMatriz(Dimensiones)

filas = Dimensiones(1);
columnas = Dimensiones(2);
Matriz = zeros(filas, columnas);

mensaje = input("Introduzca r si desea crear una matriz aleatoria o enter si desea introducir los valores manualmente: ", "s");

if strcmpi(mensaje, "r")
    %completar con valores aleatorios del 1 al 100
    Matriz = round(rand(filas, columnas) * 99) + 1; % round redondea
else
    for i =1: filas
        for j=1: columnas
            % Bucle while para asegurar una entrada válida
            valido = false;
            while ~valido
                %pedir al usuario que introduzca los valores para cada elemento de la fila
                elemento_str = input(['Ingrese el valor para la posición (' num2str(i) ',' num2str(j) '): '], 's');
                % Convertir str a num
                elemento = str2double(elemento_str);
                if ~isnan(elemento) %devuelve 1 si es not a number y 0 en otro caso
                    Matriz(i,j) = elemento;
                    valido = true; % La entrada es válida, salir del bucle while
                else
                    disp('Error: Entrada no válida. Introduzca un número.');
                    % El bucle while continuará, solicitando la entrada nuevamente.
                end
            end
        end 
    end
end

      
     
        