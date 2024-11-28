function EchoEffectTool()
    % Create a simple GUI to apply echo to an audio file
    
    % Main figure
    mainWindow = figure('Name', 'Echo Effect Tool', 'NumberTitle', 'off', ...
        'Position', [300, 200, 700, 500], 'MenuBar', 'none', 'Resize', 'off');

    % Panels for layout
    controlPanel = uipanel('Parent', mainWindow, 'Title', 'Controls', ...
        'Position', [0.05, 0.1, 0.35, 0.8]);
    plotPanel = uipanel('Parent', mainWindow, 'Title', 'Waveform Display', ...
        'Position', [0.45, 0.1, 0.5, 0.8]);

    % Axes for waveform visualization
    originalAxes = axes('Parent', plotPanel, 'Position', [0.1, 0.6, 0.8, 0.35]);
    echoAxes = axes('Parent', plotPanel, 'Position', [0.1, 0.1, 0.8, 0.35]);

    % Initial variables
    audioData = [];
    fs = 4800; % Default sampling rate
    delayTime = 400; % in ms
    echoGain = 0.5;

    % Add buttons and sliders
    uicontrol('Parent', controlPanel, 'Style', 'pushbutton', 'String', 'Load Audio', ...
        'Units', 'normalized', 'Position', [0.1, 0.85, 0.8, 0.1], ...
        'Callback', @loadAudio);

    uicontrol('Parent', controlPanel, 'Style', 'text', 'String', 'Delay (ms):', ...
        'Units', 'normalized', 'Position', [0.1, 0.7, 0.4, 0.05], ...
        'HorizontalAlignment', 'left');
    delaySlider = uicontrol('Parent', controlPanel, 'Style', 'slider', ...
        'Min', 50, 'Max', 1000, 'Value', delayTime, ...
        'Units', 'normalized', 'Position', [0.1, 0.65, 0.8, 0.05], ...
        'Callback', @(src, event) updateDelay());
    delayValueText = uicontrol('Parent', controlPanel, 'Style', 'text', ...
        'String', sprintf('%d ms', delayTime), 'Units', 'normalized', ...
        'Position', [0.6, 0.7, 0.3, 0.05]);

    uicontrol('Parent', controlPanel, 'Style', 'text', 'String', 'Echo Gain:', ...
        'Units', 'normalized', 'Position', [0.1, 0.5, 0.4, 0.05], ...
        'HorizontalAlignment', 'left');
    gainSlider = uicontrol('Parent', controlPanel, 'Style', 'slider', ...
        'Min', 0.1, 'Max', 1, 'Value', echoGain, ...
        'Units', 'normalized', 'Position', [0.1, 0.45, 0.8, 0.05], ...
        'Callback', @(src, event) updateGain());
    gainValueText = uicontrol('Parent', controlPanel, 'Style', 'text', ...
        'String', sprintf('%.2f', echoGain), 'Units', 'normalized', ...
        'Position', [0.6, 0.5, 0.3, 0.05]);

    uicontrol('Parent', controlPanel, 'Style', 'pushbutton', 'String', 'Play Original', ...
        'Units', 'normalized', 'Position', [0.1, 0.3, 0.8, 0.1], ...
        'Callback', @playOriginal);
    uicontrol('Parent', controlPanel, 'Style', 'pushbutton', 'String', 'Play Echoed', ...
        'Units', 'normalized', 'Position', [0.1, 0.15, 0.8, 0.1], ...
        'Callback', @playEchoed);

    % Callback functions
    function loadAudio(~, ~)
        [file, path] = uigetfile({'*.wav'}, 'Select an Audio File');
        if isequal(file, 0)
            return; % User canceled
        end
        [audioData, fs] = audioread(fullfile(path, file));
        if size(audioData, 2) > 1
            audioData = mean(audioData, 2); % Convert to mono if stereo
        end
        plotWaveform(originalAxes, audioData, 'Original Audio');
    end

    function updateDelay()
        delayTime = round(get(delaySlider, 'Value'));
        set(delayValueText, 'String', sprintf('%d ms', delayTime));
    end

    function updateGain()
        echoGain = get(gainSlider, 'Value');
        set(gainValueText, 'String', sprintf('%.2f', echoGain));
    end

    function playOriginal(~, ~)
        if isempty(audioData)
            errordlg('No audio loaded!', 'Error');
            return;
        end
        sound(audioData, fs);
    end

    function playEchoed(~, ~)
        if isempty(audioData)
            errordlg('No audio loaded!', 'Error');
            return;
        end
        delaySamples = round((delayTime / 1000) * fs);
        echoedAudio = applyEcho(audioData, delaySamples, echoGain);
        plotWaveform(echoAxes, echoedAudio, 'Echoed Audio');
        sound(echoedAudio, fs);
    end

    % Helper functions
    function plotWaveform(ax, data, titleText)
        axes(ax);
        plot((0:length(data)-1) / fs, data);
        xlabel('Time (s)');
        ylabel('Amplitude');
        title(titleText);
        grid on;
    end

    function echoedSignal = applyEcho(inputSignal, delay, gain)
        echoedSignal = inputSignal;
        for n = (delay + 1):length(inputSignal)
            echoedSignal(n) = echoedSignal(n) + gain * inputSignal(n - delay);
        end
    end
end
