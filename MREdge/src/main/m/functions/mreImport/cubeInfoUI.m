function varargout = cubeInfoUI(varargin)
% CUBEINFOUI M-file for cubeInfoUI.fig
%      CUBEINFOUI, by itself, creates a new CUBEINFOUI or raises the existing
%      singleton*.
%
%      H = CUBEINFOUI returns the handle to a new CUBEINFOUI or the handle to
%      the existing singleton*.
%
%      CUBEINFOUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CUBEINFOUI.M with the given input arguments.
%
%      CUBEINFOUI('Property','Value',...) creates a new CUBEINFOUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cubeInfoUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cubeInfoUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cubeInfoUI

% Last Modified by GUIDE v2.5 22-May-2017 16:46:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cubeInfoUI_OpeningFcn, ...
                   'gui_OutputFcn',  @cubeInfoUI_OutputFcn, ...
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


% --- Executes just before cubeInfoUI is made visible.
function cubeInfoUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cubeInfoUI (see VARARGIN)

% Choose default command line output for cubeInfoUI
handles.output = hObject;
handles.complexCube=varargin{1};
handles=updateTable(handles);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes cubeInfoUI wait for user response (see UIRESUME)
uiwait(hObject);


% --- Outputs from this function are returned to the command line.
function varargout = cubeInfoUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
varargout{2} = handles.complexCube;
delete(hObject);



% --- Executes on button press in applyButton.
function applyButton_Callback(hObject, eventdata, handles)
% hObject    handle to applyButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isequal(get(handles.cubeInfoUI, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(handles.cubeInfoUI);
end


function timeStepEdit_Callback(hObject, eventdata, handles)
% hObject    handle to timeStepEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of timeStepEdit as text
%        str2double(get(hObject,'String')) returns contents of timeStepEdit as a double


% --- Executes during object creation, after setting all properties.
function timeStepEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timeStepEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function directionEdit_Callback(hObject, eventdata, handles)
% hObject    handle to directionEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of directionEdit as text
%        str2double(get(hObject,'String')) returns contents of directionEdit as a double


% --- Executes during object creation, after setting all properties.
function directionEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to directionEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function frequencyEdit_Callback(hObject, eventdata, handles)
% hObject    handle to frequencyEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frequencyEdit as text
%        str2double(get(hObject,'String')) returns contents of frequencyEdit as a double


% --- Executes during object creation, after setting all properties.
function frequencyEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frequencyEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sliceEdit_Callback(hObject, eventdata, handles)
% hObject    handle to sliceEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sliceEdit as text
%        str2double(get(hObject,'String')) returns contents of sliceEdit as a double


% --- Executes during object creation, after setting all properties.
function sliceEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliceEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function newHandles=updateTable(handles)
newHandles=handles;

set(newHandles.cubeTable,'Data',getCubeInfoCell( handles.complexCube ));


function ok=checkDimensionCompatibility(complexCube,nSlices,nTimesteps,directions,frequencies)
    

function ok=applyDimensionCompatibility(complexCube,nSlices,nTimesteps,directions,frequencies)
    
