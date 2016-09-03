function output_args = Demo( trials, depth, weights, animate_p)
    % example usage: m = Demo(30, 10, [1/3 1/3 1/3], true);
    %                m = Demo(30, 10, [.5 .5], true);

    % Go!
    output_args = createMovie(trials ,depth, createDeMoivreSampler(123, weights), animate_p);
end

function animation = createMovie(trials, depth, sampler, animate_p)
    binIncrement = 2*depth/trials;

    % Create model
    model = createModel(trials, depth, sampler);
    
    % Set up Axis
    axisHndl = gca;
    view(72,30);
    axis vis3d;
    set(gcf, 'color', 'w');
    set(axisHndl, ...
        'XLim',  [0, depth*1.2], 'YLim',  [0, depth*1.2], 'ZLim',  [0, depth*1.2], ...
        'XTick', [],         'YTick', [],         'ZTick', [], ...
        'Drawmode', 'fast', 'Visible', 'on', 'NextPlot', 'add', ...
        'color', 'w', 'XColor', 'w', 'YColor', 'w', 'ZColor', 'w');
   
    % Draw Simplexs
    tc(1,1,1,1:3) = [.5 .5 1];
    for dIndex = depth:depth,
        tp = dIndex * eye(3);
        patch(tp(:,1), tp(:,2), tp(:,3), tc, 'EdgeColor', [1 1 1], 'FaceAlpha', 0.1);
    end
    
    currentPath = line ('color', 'b', 'Marker', '.', 'markersize', 10, 'erase', 'xor',...
                        'xdata', [], 'ydata', [], 'zdata', []);
    
    ball = line ('color', 'r', 'Marker', '.', 'markersize', 25, ...
                 'xdata', 0, 'ydata', 0, 'zdata', 0);
    
    % Initialise animation
    animation(1) = getframe;
    
    for tIndex = 1:trials,
        
        if(animate_p),
           for dIndex = 1:depth,
                % Record the animation
                animation((depth * (tIndex - 1)) + dIndex) = getframe;
                
                set(ball, 'xdata',model(dIndex,tIndex,1), ...
                          'ydata',model(dIndex,tIndex,2), ...
                          'zdata',model(dIndex,tIndex,3));
                  
                set(currentPath, 'xdata',[0; model(1:dIndex,tIndex,1)], ...
                                 'ydata',[0; model(1:dIndex,tIndex,2)], ...
                                 'zdata',[0; model(1:dIndex,tIndex,3)]);
           end
        end
        
        % Reset Current Path
        set(ball, 'xdata',0,'ydata',0,'zdata',0);
        set(currentPath, 'xdata',[],'ydata',[],'zdata',[]);
        
        % Draw History Path
        line('Marker', '.', 'markersize', 5, 'LineWidth', 0.25, 'Color', [.8 .8 .9],...
             'xdata', [0; model(:,tIndex,1)], 'ydata', [0;model(:,tIndex,2)], 'zdata', [0;model(:,tIndex,3)]);
         
        % Draw Bins
        bx = model(depth,tIndex,1) + 1;
        by = model(depth,tIndex,2) + 1;
        bz = model(depth,tIndex,3) + 1;

        try
            bins(bx,by,bz) = bins(bx,by,bz) + 1;
            set(lineBin(bx,by,bz), ...
                'xdata', [bx - 1; bx - 1 + (bins(bx,by,bz) * binIncrement)], ...
                'ydata', [by - 1; by - 1 + (bins(bx,by,bz) * binIncrement)], ...
                'zdata', [bz - 1; bz - 1 + (bins(bx,by,bz) * binIncrement)]);
        catch ME,
            bins(bx,by,bz) = 1;
            lineBin(bx,by,bz) = line(...
                'Marker', 'o', 'markersize', 3, 'Color', 'b', ...
                'xdata', [bx - 1; bx - 1 + (bins(bx,by,bz) * binIncrement)], ...
                'ydata', [by - 1; by - 1 + (bins(bx,by,bz) * binIncrement)], ...
                'zdata', [bz - 1; bz - 1 + (bins(bx,by,bz) * binIncrement)]);
        end
    end
end




function model = createModel(trials, depth, sampler)
    samples = sampler(trials * depth); % ceil(rand(1, trials*depth) * dimension);

    % Initialise Model
    model = zeros(depth, trials, 3);
    
    % Create Unit vectors
    for t = 1:trials,
        for d = 1:depth,
            model(d,t, samples(1, t*d)) = 1;
        end
    end
    
    % Create ball trajectory 
    model = cumsum(model, 1);
end

function sampler = createDeMoivreSampler(prngSeed, weights)
    % Initialize Sampler
    rand('twister', prngSeed);
    weights = cumsum(weights);
    d = size(weights, 2);
    
    function index = Map(s)
        for index = 1:d,
           if (s < weights(index)), break; end
        end
    end
    
    function samples = Sampler(nSamples)
        samples = arrayfun( @Map, rand(1, nSamples));
    end

    sampler = @Sampler;
end