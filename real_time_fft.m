% Reference: https://www.mathworks.com/matlabcentral/answers/412242-how-to-see-live-plot-of-my-voice

function varargout = real_time_fft(varargin)
% REAL_TIME_FFT MATLAB code for real_time_fft.fig
%      REAL_TIME_FFT, by itself, creates a new REAL_TIME_FFT or raises the existing
%      singleton*.
%
%      H = REAL_TIME_FFT returns the handle to a new REAL_TIME_FFT or the handle to
%      the existing singleton*.
%
%      REAL_TIME_FFT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REAL_TIME_FFT.M with the given input arguments.
%
%      REAL_TIME_FFT('Property','Value',...) creates a new REAL_TIME_FFT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before real_time_fft_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to real_time_fft_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help real_time_fft

% Last Modified by GUIDE v2.5 10-Jun-2020 18:16:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @real_time_fft_OpeningFcn, ...
                   'gui_OutputFcn',  @real_time_fft_OutputFcn, ...
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
end


% --- Executes just before real_time_fft is made visible.
function real_time_fft_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to real_time_fft (see VARARGIN)

% Choose default command line output for real_time_fft
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes real_time_fft wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end


% --- Outputs from this function are returned to the command line.
function varargout = real_time_fft_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end


% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1
    global Fs;
    global nBits;
    global NumChannels;
    
    global duration;
    global step_duration;
    global ylim1;
    global ylim2;
    
    global L;
    global Time;
    global NFFT;
    global Frequency;
    global signal;
    global step_L;
    global recorder;
    
    Fs = 3000;
    nBits = 24;
    NumChannels = 1;
    
    duration = 3;
    step_duration = 0.1;
    ylim1 = 1;
    ylim2 = 100;
    
    L = Fs * duration;
    Time = linspace(0, duration * 1000, L);
    NFFT = 2^nextpow2(L);
    Frequency = linspace(0,Fs/2,NFFT/2+1);
    signal = zeros(L, 1);
    step_L = Fs * step_duration;
    recorder = audiorecorder(Fs, nBits, NumChannels);
    
    if get(hObject, 'Value')
        recorder.record();
        while recorder.isrecording()
            pause(step_duration);
            data = recorder.getaudiodata();
            sz = size(data);
            step_sz = min(step_L, sz);
            
            signal = cat(1, signal(step_sz + 1:L), data(sz - step_sz + 1:sz));
            plot(handles.axes1, Time, signal);
            ylim(handles.axes1, [-ylim1 ylim1]);
            xlabel(handles.axes1, 'Time (microseconds)');
            ylabel(handles.axes1, 'x(t)');

            Y = fft(signal, NFFT);
            plot(handles.axes2, Frequency, abs(Y(1:NFFT/2+1)));
            ylim(handles.axes2, [0 ylim2]);
            xlabel(handles.axes2, 'Frequency (hertz)');
            ylabel(handles.axes2, '|X(F)|');
            
            drawnow();
        end
    else
        stop(recorder);
    end
end
