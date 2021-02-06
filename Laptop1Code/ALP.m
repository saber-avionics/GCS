function varargout = ALP(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ALP_OpeningFcn, ...
                   'gui_OutputFcn',  @ALP_OutputFcn, ...
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



% --- Executes just before GS is made visible.
function ALP_OpeningFcn(hObject, eventdata, handles, varargin)


% Choose default command line output for GS
handles.output = hObject;
% Timer code
handles.timer = timer(...                   % Creates master timer
    'ExecutionMode','fixedRate', ...        % Runs continuously
    'Period', 1, ...                        % Period of 1 sec
    'TimerFcn', {@Master_update, hObject}); % Specifies callback fcn
start(handles.timer);



% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = ALP_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

% --- Executes on button press in Receive_Data_button.
function Receive_Data_button_Callback(hObject, eventdata, handles)
ALP_readinserial(1)

% --- Executes on button press in Deploy_Chutes_button.
function Deploy_Chutes_button_Callback(hObject, eventdata, handles)
% hObject    handle to Deploy_Chutes_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global deploy_chutes
deploy_chutes = 1;
set(handles.are_you_sure_menu,'Visible','On')
set(handles.YES_button,'Visible','On')
set(handles.NO_button,'Visible','On')

% --- Executes on button press in ABORT_button.
function ABORT_button_Callback(hObject, eventdata, handles)
% hObject    handle to ABORT_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global abort
abort = 1;
set(handles.are_you_sure_menu,'Visible','On')
set(handles.YES_button,'Visible','On')
set(handles.NO_button,'Visible','On')

% --- Executes on button press in YES_button.
function YES_button_Callback(hObject, eventdata, handles)
% hObject    handle to YES_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global deploy_chutes
global abort
global stop_reading
global end_program
if deploy_chutes ==1
    ALP_sendcommands(1,0)
elseif abort == 1
    ALP_sendcommands(0,1)
elseif stop_reading == 1
    ALP_readinserial(0)
elseif end_program == 1
    exit
else ALP_sendcommands(0,0), ALP_readinserial(1)
end


set(handles.YES_button,'Visible','Off')
set(handles.NO_button,'Visible','Off')
set(handles.are_you_sure_menu,'Visible','Off')




% --- Executes on button press in NO_button.
function NO_button_Callback(hObject, eventdata, handles)
% hObject    handle to NO_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global deploy_chutes
global abort
global stop_reading
global end_program
deploy_chutes = 0;
abort = 0;
stop_reading = 0;
end_program = 0;
set(handles.YES_button,'Visible','Off')
set(handles.NO_button,'Visible','Off')
set(handles.are_you_sure_menu,'Visible','Off')



% Enter m-files to be updated.
function Master_update(hObject, eventdata, hfigure)
handles = guidata(hfigure);
ALP_readinserial(receiveData);
ALP_Telemetry_Update(handles);

% --- Executes during object creation, after setting all properties.
function Chutes_Deployed_Confirmed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Chutes_Deployed_Confirmed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function Abort_Confirmed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Abort_Confirmed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function Disp_Alt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Disp_Alt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function Disp_Position_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Disp_Position (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function Disp_Press_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Disp_Press (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function Disp_Accel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Disp_Accel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function Disp_Temp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Disp_Temp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function Disp_GPS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Disp_GPS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function Mission_Time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Mission_Time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function GPS_Time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GPS_Time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function Packet_Count_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Packet_Count (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function Previous_Packet_Count_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Previous_Packet_Count (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function Packet_Search_Time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Packet_Search_Time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function Software_State_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Software_State (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function GPS_Sat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GPS_Sat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function Battery_Temp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Battery_Temp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function Motor_Temp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Motor_Temp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function Board_Temp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board_Temp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function Voltage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Voltage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function Current_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Current (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function Magnetic_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Magnetic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in end_receive.
function end_receive_Callback(hObject, eventdata, handles)
% hObject    handle to end_receive (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stop_reading
stop_reading = 1;
set(handles.are_you_sure_menu,'Visible','On')
set(handles.YES_button,'Visible','On')
set(handles.NO_button,'Visible','On')


% --- Executes on button press in end_program.
function end_program_Callback(hObject, eventdata, handles)
% hObject    handle to end_program (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global end_program
end_program = 1;
set(handles.are_you_sure_menu,'Visible','On')
set(handles.YES_button,'Visible','On')
set(handles.NO_button,'Visible','On')
