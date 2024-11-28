function varargout = e(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tes_OpeningFcn, ...
                   'gui_OutputFcn',  @tes_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

function tes_OpeningFcn(hObject, eventdata, handles, varargin)
vol = 2.5;
set(handles.slider15,'value',vol);
handles.output = hObject;
guidata(hObject, handles);

function varargout = tes_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function play_equalizer(hObject, handles)
global player;
[handles.y,handles.Fs] = audioread(handles.fullpathname);
handles.Volume=get(handles.slider15,'value');
%handles.y=handles.y(NewStart:end,:); 
handles.g1=get(handles.slider3,'value');
handles.g2=get(handles.slider4,'value');
handles.g3=get(handles.slider5,'value');
handles.g4=get(handles.slider7,'value');
handles.g5=get(handles.slider8,'value');
 handles.g6=get(handles.slider9,'value');
 handles.g7=get(handles.slider10,'value');
 handles.g8=get(handles.slider11,'value');
 handles.g9=get(handles.slider6,'value');
handles.g10=get(handles.slider12,'value');
handles.g11=get(handles.slider16,'value');
handles.g12=get(handles.slider17,'value');
set(handles.text35, 'String',handles.g1);
set(handles.text19, 'String',handles.g2);
set(handles.text20, 'String',handles.g3);
set(handles.text21, 'String',handles.g4);
set(handles.text22, 'String',handles.g5);
set(handles.text23, 'String',handles.g6);
set(handles.text24, 'String',handles.g7);
set(handles.text25, 'String',handles.g8);
set(handles.text26, 'String',handles.g9);
set(handles.text27, 'String',handles.g10);
set(handles.text34, 'String',handles.g11);
set(handles.text16, 'String',handles.g12);

%lowpas
cut_off=200; 
orde=16;
a=fir1(orde,cut_off/(handles.Fs/2),'low');
y1=handles.g1*filter(a,1,handles.y);

% %bandpass1
f1=201;
f2=400;
b1=fir1(orde,[f1/(handles.Fs/2) f2/(handles.Fs/2)],'bandpass');
y2=handles.g2*filter(b1,1,handles.y);
% 
% %bandpass2
f3=401;
f4=800;
b2=fir1(orde,[f3/(handles.Fs/2) f4/(handles.Fs/2)],'bandpass');
y3=handles.g3*filter(b2,1,handles.y);
% 
% %bandpass3
 f4=801;
f5=1500;
 b3=fir1(orde,[f4/(handles.Fs/2) f5/(handles.Fs/2)],'bandpass');
 y4=handles.g4*filter(b3,1,handles.y);
% 
% %bandpass4
 f5=1501;
f6=3000;
 b4=fir1(orde,[f5/(handles.Fs/2) f6/(handles.Fs/2)],'bandpass');
 y5=handles.g5*filter(b4,1,handles.y);
% 
% %bandpass5
  f7=3001;
f8=5000;
  b5=fir1(orde,[f7/(handles.Fs/2) f8/(handles.Fs/2)],'bandpass');
  y6=handles.g6*filter(b5,1,handles.y);
% 
% %bandpass6
  f9=5001;
f10=7000;
  b6=fir1(orde,[f9/(handles.Fs/2) f10/(handles.Fs/2)],'bandpass');
  y7=handles.g7*filter(b6,1,handles.y);
% 
% %bandpass7
  f11=7001;
f12=10000;
  b7=fir1(orde,[f11/(handles.Fs/2) f12/(handles.Fs/2)],'bandpass');
  y8=handles.g8*filter(b7,1,handles.y);
% 
 % %bandpass8
  f13=10001;
f14=15000;
  b8=fir1(orde,[f13/(handles.Fs/2) f14/(handles.Fs/2)],'bandpass');
  y9=handles.g9*filter(b8,1,handles.y);

% %bandpass9
  f15=15001;                        %%FROM HERE MAY OVERLAPS THE NYQUIST FREQUENCY
f16=  min(20000, handles.Fs/2);
  b9=fir1(orde,[f15/(handles.Fs/2) f16/(handles.Fs/2)],'bandpass');
  y10=handles.g10*filter(b9,1,handles.y);

% %bandpass10
  f17=20001;
f18=min(25000, handles.Fs/2);
  b10=fir1(orde,[f17/(handles.Fs/2) f18/(handles.Fs/2)],'bandpass');
  y11=handles.g11*filter(b10,1,handles.y);


 %highpass
cut_off2=25000;
c=fir1(orde,cut_off2/(handles.Fs/2),'high');
y12=handles.g12*filter(c,1,handles.y);


 handles.yT=y1+y2+y3+y4+y5+y6+y7+y8+y9+y10+y11+y12;
player = audioplayer(handles.Volume*handles.yT, handles.Fs);
 subplot(2,1,1);
 plot(handles.y);
 subplot(2,1,2);
 plot(handles.yT);

guidata(hObject,handles)



% SLIDERSSS
function slider3_Callback(hObject, eventdata, handles)
function slider3_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function slider4_Callback(hObject, eventdata, handles)
function slider4_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function slider5_Callback(hObject, eventdata, handles)
function slider5_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function slider6_Callback(hObject, eventdata, handles)
function slider6_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function slider7_Callback(hObject, eventdata, handles)
function slider7_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function slider8_Callback(hObject, eventdata, handles)
function slider8_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function slider9_Callback(hObject, eventdata, handles)
function slider9_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function slider10_Callback(hObject, eventdata, handles)
function slider10_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function slider11_Callback(hObject, eventdata, handles)
function slider11_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function slider12_Callback(hObject, eventdata, handles)
function slider12_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider16_Callback(hObject, eventdata, handles)
function slider16_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider17_Callback(hObject, eventdata, handles)
function slider17_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



%BUTTONSSSSSS
function pushbutton4_Callback(hObject, eventdata, handles)
global player;
play_equalizer(hObject, handles); 
stop(player);
guidata(hObject,handles)

function pushbutton2_Callback(hObject, eventdata, handles)
global player;
%equalizer_play();
play_equalizer(hObject, handles); 
play(player);
guidata(hObject,handles)

function pushbutton1_Callback(hObject, eventdata, handles)
[filename pathname] = uigetfile({'*.wav'},'File Selector');
handles.fullpathname = strcat(pathname, filename);
set(handles.text3, 'String',handles.fullpathname) 
guidata(hObject,handles)
