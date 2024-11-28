function InteractiveFilterDesigner()
    % Initialize the interactive filter design tool
    
    % Create the main figure
    mainFig = figure('Name', 'Filter Designer', 'NumberTitle', 'off', ...
        'Position', [200, 200, 800, 600], 'MenuBar', 'none', ...
        'Resize', 'off', 'Toolbar', 'none');

    % Initialize designData and store it in the figure's UserData
    designData.zeros = [];
    designData.poles = [];
    set(mainFig, 'UserData', designData);

    % Create axis for plotting
    plotAxis = axes('Parent', mainFig, 'Units', 'normalized', ...
        'Position', [0.05, 0.3, 0.6, 0.65]);
    initializePlot(plotAxis);

    % Create UI controls
    uicontrol(mainFig, 'Style', 'pushbutton', 'String', 'Add Zero', ...
        'Units', 'normalized', 'Position', [0.7, 0.8, 0.25, 0.05], ...
        'Callback', @(src, event) addPoint('zero', plotAxis, mainFig));
    uicontrol(mainFig, 'Style', 'pushbutton', 'String', 'Add Pole', ...
        'Units', 'normalized', 'Position', [0.7, 0.7, 0.25, 0.05], ...
        'Callback', @(src, event) addPoint('pole', plotAxis, mainFig));
    uicontrol(mainFig, 'Style', 'pushbutton', 'String', 'Clear Design', ...
        'Units', 'normalized', 'Position', [0.7, 0.6, 0.25, 0.05], ...
        'Callback', @(src, event) clearDesign(plotAxis, mainFig));
    uicontrol(mainFig, 'Style', 'pushbutton', 'String', 'Analyze Filter', ...
        'Units', 'normalized', 'Position', [0.7, 0.5, 0.25, 0.05], ...
        'Callback', @(src, event) analyzeFilter(mainFig));
end

function initializePlot(ax)
    % Setup the plotting area
    axes(ax);
    hold on;
    axis([-2, 2, -2, 2]);
    grid on;
    xlabel('Real');
    ylabel('Imaginary');
    title('Pole-Zero Plot');
    % Draw the unit circle
    theta = linspace(0, 2*pi, 100);
    plot(cos(theta), sin(theta), '--k');
end

function addPoint(type, ax, fig)
    % Add a zero or pole interactively
    [x, y] = ginput(1);
    data = get(fig, 'UserData'); % Retrieve current designData
    if strcmp(type, 'zero')
        newPoint = x + 1j*y;
        data.zeros = [data.zeros, newPoint, conj(newPoint)];
        plot(ax, real(newPoint), imag(newPoint), 'ob', 'MarkerSize', 8);
        plot(ax, real(conj(newPoint)), imag(conj(newPoint)), 'ob', 'MarkerSize', 8);
    elseif strcmp(type, 'pole')
        newPoint = x + 1j*y;
        data.poles = [data.poles, newPoint, conj(newPoint)];
        plot(ax, real(newPoint), imag(newPoint), 'xr', 'MarkerSize', 8);
        plot(ax, real(conj(newPoint)), imag(conj(newPoint)), 'xr', 'MarkerSize', 8);
    end
    set(fig, 'UserData', data); % Update designData in the figure
end

function clearDesign(ax, fig)
    % Clear the design and reset the plot
    data = get(fig, 'UserData'); % Retrieve current designData
    data.zeros = [];
    data.poles = [];
    set(fig, 'UserData', data); % Update designData in the figure
    cla(ax);
    initializePlot(ax);
end

function analyzeFilter(fig)
    % Analyze the designed filter
    data = get(fig, 'UserData'); % Retrieve current designData
    if isempty(data.zeros) && isempty(data.poles)
        msgbox('No zeros or poles specified.', 'Error', 'error');
        return;
    end
    
    % Calculate coefficients
    B = poly(data.zeros);
    A = poly(data.poles);

    % Display coefficients
    disp('Numerator coefficients (B):');
    disp(B);
    disp('Denominator coefficients (A):');
    disp(A);

    % Visualize results
    figure;
    zplane(B, A);
    title('Pole-Zero Diagram');

    figure;
    freqz(B, A);
    title('Frequency Response');

    figure;
    impz(B, A);
    title('Impulse Response');
end
