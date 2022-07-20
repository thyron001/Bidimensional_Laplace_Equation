classdef laplace < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        interfaz              matlab.ui.Figure
        voltaje               matlab.ui.control.NumericEditField
        VoltajedefiguraLabel  matlab.ui.control.Label
        errorusuario          matlab.ui.control.Spinner
        ErrorSpinnerLabel     matlab.ui.control.Label
        iteraciones           matlab.ui.control.Table
        Image                 matlab.ui.control.Image
        Calcular              matlab.ui.control.Button
        tamano                matlab.ui.control.NumericEditField
        TamaoLabel            matlab.ui.control.Label
    end



    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
          
        end

        % Value changed function: tamano
        function tamanoValueChanged(app, event)

        end

        % Button pushed function: Calcular
        function CalcularButtonPushed(app, event)
      %Se rescata el valor del tamano de la matriz y se crea una tabla
      %cuadrada con el mismo tamano
      N = app.tamano.Value;
      app.iteraciones.Data = cell(N, N);
      
      %Se definen las dimensiones x y y de la rejilla
      xdim = N;
      ydim = N;

      %Se inicializa la matriz a trabajar con ceros
      V_now = zeros(xdim + 1, ydim + 1);
      V_prev = zeros(xdim + 1, ydim + 1);

      %Se define el voltaje de la placa superior a 100 voltios
      V_now(1, 2 : xdim) = 100;
      
      %Creacion del triangulo
      li = xdim / 2;
      ld = xdim / 2 + 1;
      i = 0;

    while 1
        
        %Actualizaciòn de la fila
        fila = xdim / 4 + ( 1 + 2 * i );
        
        %Verificar que la fila no hay alcanzado su tope
        if ( fila == 3 * (xdim / 4) - 1 )
            break;
        end
       
        %Reemplazo de valores de voltaje constante
        V_now(fila : fila + 1, li : ld) = 100 * ones( 2 , abs(ld - li) + 1 );
       
        %Actulizaciòn de los lìmites laterales
        i = i + 1;
        li = li - 1;
        ld = ld + 1;
    end

%Contador de iteracion
iter=0;

%Calculo del error entre V_now y V_prev en todos los puntos
error = max(max(abs(V_now-V_prev)));

%Metodo de iteracion hasta que el error sea mayor al especificado
while (error > app.errorusuario.Value())
    
    iter = iter + 1; % Incremento del contador de iteracion
    
    % Actualizacion del punto central usando 4 puntos a la misma distancia
    % Solucion de la ecuacion de Laplace usando el metodo de diferencias finitas
    for i = 2 : 1 : xdim
        for j = 2 : 1 : ydim
        V_now(i, j) = (V_now(i - 1, j) + V_now(i + 1, j) + V_now(i, j - 1) + V_now(i ,j + 1)) / 4;
        end
    end
    %Se vuelve a poner el triangulo para que sus valores no cambien
            li = xdim / 2;
            ld = xdim / 2 + 1;
            i = 0;
            
            while 1
        
            %Actualizaciòn de la fila
            fila = xdim / 4 + ( 1 + 2 * i );
    
            %Verificar que la fila no hay alcanzado su tope
            if ( fila == 3 * (xdim / 4) - 1 )
            break;
            end
   
            %Reemplazo de valores de voltaje constante
            V_now(fila : fila + 1, li : ld ) = app.voltaje.Value * ones( 2 , abs(ld - li) + 1 );
   
            %Actulizaciòn de los lìmites laterales
            i = i + 1;
            li = li - 1;
            ld = ld + 1;
            end
    %Calculo del error maximo entre la matriz previa y la nueva en todos los puntos        
    error=max(max(abs(V_now - V_prev))); 
    % Se actualiza la nueva matriz
    V_prev=V_now; 
    %Se llena el cuadro con los valores finales
    app.iteraciones.Data = V_now(:,:);
    
    
    %Grafica dinamica que muestra el mapa de color que muestra como la solucion progresa    
    imagesc(V_now);colorbar;
    title(['Distribución de Voltaje en una malla de ',int2str(xdim),' x ',int2str(ydim),' en la iteración número ',int2str(iter)],'Color','k'); 
    drawnow;
    
    
end
      
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create interfaz and hide until all components are created
            app.interfaz = uifigure('Visible', 'off');
            app.interfaz.Color = [0.9294 0.9608 0.9882];
            app.interfaz.Position = [100 100 530 456];
            app.interfaz.Name = 'Bidimensional Laplace Equation Solver';
            app.interfaz.Icon = 'ico.webp';

            % Create TamaoLabel
            app.TamaoLabel = uilabel(app.interfaz);
            app.TamaoLabel.HorizontalAlignment = 'right';
            app.TamaoLabel.FontName = 'Segoe UI';
            app.TamaoLabel.FontSize = 13;
            app.TamaoLabel.FontWeight = 'bold';
            app.TamaoLabel.FontColor = [0.7608 0.149 0.1137];
            app.TamaoLabel.Position = [38 357 54 22];
            app.TamaoLabel.Text = 'Tamaño';

            % Create tamano
            app.tamano = uieditfield(app.interfaz, 'numeric');
            app.tamano.Limits = [4 Inf];
            app.tamano.RoundFractionalValues = 'on';
            app.tamano.ValueChangedFcn = createCallbackFcn(app, @tamanoValueChanged, true);
            app.tamano.FontName = 'Segoe UI';
            app.tamano.FontSize = 13;
            app.tamano.FontWeight = 'bold';
            app.tamano.FontColor = [0.1882 0.1569 0.4902];
            app.tamano.Position = [107 357 33 22];
            app.tamano.Value = 4;

            % Create Calcular
            app.Calcular = uibutton(app.interfaz, 'push');
            app.Calcular.ButtonPushedFcn = createCallbackFcn(app, @CalcularButtonPushed, true);
            app.Calcular.BackgroundColor = [0.1882 0.1569 0.4902];
            app.Calcular.FontWeight = 'bold';
            app.Calcular.FontColor = [0.9294 0.9569 0.9882];
            app.Calcular.Position = [375 20 100 23];
            app.Calcular.Text = 'Graficar';

            % Create Image
            app.Image = uiimage(app.interfaz);
            app.Image.Position = [10 380 268 68];
            app.Image.ImageSource = 'escudo-inge-03.png';

            % Create iteraciones
            app.iteraciones = uitable(app.interfaz);
            app.iteraciones.ColumnName = '';
            app.iteraciones.RowName = {};
            app.iteraciones.Position = [47 74 428 259];

            % Create ErrorSpinnerLabel
            app.ErrorSpinnerLabel = uilabel(app.interfaz);
            app.ErrorSpinnerLabel.HorizontalAlignment = 'right';
            app.ErrorSpinnerLabel.FontName = 'Segoe UI';
            app.ErrorSpinnerLabel.FontWeight = 'bold';
            app.ErrorSpinnerLabel.FontColor = [0.7608 0.149 0.1098];
            app.ErrorSpinnerLabel.Position = [174 357 34 22];
            app.ErrorSpinnerLabel.Text = 'Error';

            % Create errorusuario
            app.errorusuario = uispinner(app.interfaz);
            app.errorusuario.Step = 0.01;
            app.errorusuario.Limits = [0 1];
            app.errorusuario.FontName = 'Segoe UI';
            app.errorusuario.FontWeight = 'bold';
            app.errorusuario.FontColor = [0.1882 0.1608 0.4902];
            app.errorusuario.Position = [223 357 55 22];

            % Create VoltajedefiguraLabel
            app.VoltajedefiguraLabel = uilabel(app.interfaz);
            app.VoltajedefiguraLabel.HorizontalAlignment = 'right';
            app.VoltajedefiguraLabel.FontName = 'Segoe UI';
            app.VoltajedefiguraLabel.FontSize = 13;
            app.VoltajedefiguraLabel.FontWeight = 'bold';
            app.VoltajedefiguraLabel.FontColor = [0.7608 0.149 0.1137];
            app.VoltajedefiguraLabel.Position = [295 357 106 22];
            app.VoltajedefiguraLabel.Text = 'Voltaje de figura';

            % Create voltaje
            app.voltaje = uieditfield(app.interfaz, 'numeric');
            app.voltaje.Limits = [4 Inf];
            app.voltaje.RoundFractionalValues = 'on';
            app.voltaje.FontName = 'Segoe UI';
            app.voltaje.FontSize = 13;
            app.voltaje.FontWeight = 'bold';
            app.voltaje.FontColor = [0.1882 0.1569 0.4902];
            app.voltaje.Position = [416 357 33 22];
            app.voltaje.Value = 4;

            % Show the figure after all components are created
            app.interfaz.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = laplace

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.interfaz)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.interfaz)
        end
    end
end