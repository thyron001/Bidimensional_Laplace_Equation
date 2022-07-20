%=====================================================================
%         1.Generar una matriz de nxn (n=4K,keI) de forma automatica
%=====================================================================

%Inserción del parámetro n
n = 4;
%Generación de la matriz de ceron de dimensión nxn
MAT = zeros(n);

%Generar valores constantes de 100 V en la primera fila
MAT(1:1,1:n) = 100*ones(1,n);

%Inserción del valor V_const
V_const = 25;


%=====================================================================
%       2.Dibujar un cuadrado con valores V_const dentro de MAT
%=====================================================================

%%%2.1 Dibujo del cuadrado dentro de la matriz 




%=====================================================================
%       2.Dibujar un triángulo con valores V_const dentro de MAT
%=====================================================================
V_now( (n/4) + 1 : 3*(n/4) , (n/4) + 1 : 3*(n/4) ) = app.voltaje.Value * ones(n/2); 

li = n/2;
ld = n/2 + 1;
i = 0;

while 1
    
    %Actualizaciòn de la fila
    fila = n/4 + ( 1 + 2*i );
    
    %Verificar que la fila no hay alcanzado su tope
    if ( fila == 3*(n/4) - 1 )
        break;
    end
   
    %Reemplazo de valores de voltaje constante
    MAT( fila:fila+1,li:ld ) = V_const * ones( 2 , abs(ld - li) + 1 );
   
    %Actulizaciòn de los lìmites laterales
    i = i + 1;
    li = li - 1;
    ld = ld + 1;
end

imagesc(MAT);            % Create a colored plot of the matrix values
colormap(flipud(gray));  % Change the colormap to gray (so higher values are
                         %   black and lower values are white)

textStrings = num2str(MAT(:), '%0.2f');       % Create strings from the matrix values
textStrings = strtrim(cellstr(textStrings));  % Remove any space padding
[x, y] = meshgrid(1:n);  % Create x and y coordinates for the strings
hStrings = text(x(:), y(:), textStrings(:),'HorizontalAlignment', 'center'); ...  % Plot the strings
                
midValue = mean(get(gca, 'CLim'));  % Get the middle value of the color range
textColors = repmat(MAT(:) > midValue, 1, 3);



##MAT2 = MAT;
##
##%=====================================================================
##%    3.Solución numérica para hallar el voltaje en cada punto
##%=====================================================================
##for k = 1:50
##    for f = 2:n - 1
##        for c = 2:n - 1
##            
##            %Mantener aquellos voltajes de valor constante
##            if MAT(f,c) == V_const
##                MAT2(f,c) = MAT(f,c);
##            else
##                MAT2(f,c) = (1/4) * ( MAT(f - 1,c) + MAT(f + 1,c) + MAT(f,c - 1) + MAT(f,c + 1) );
##            end
##                
##        end
##    end
##    %Actualización de la matriz
##    MAT = MAT2;
##    MAT2 = MAT;
##end
##
##figure(1)
##image(10*MAT)
##figure(2)
##image(10*MAT2)
