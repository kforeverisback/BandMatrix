function varargout = BMGui(varargin)
% BMGUI MATLAB code for BMGui.fig
%      BMGUI, by itself, creates a new BMGUI or raises the existing
%      singleton*.
%
%      H = BMGUI returns the handle to a new BMGUI or the handle to
%      the existing singleton*.
%
%      BMGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BMGUI.M with the given input arguments.
%
%      BMGUI('Property','Value',...) creates a new BMGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BMGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BMGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BMGui

% Last Modified by GUIDE v2.5 13-Aug-2016 23:15:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BMGui_OpeningFcn, ...
                   'gui_OutputFcn',  @BMGui_OutputFcn, ...
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


% --- Executes just before BMGui is made visible.
function BMGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BMGui (see VARARGIN)

% Choose default command line output for BMGui
%hObject.UserData = struct('Sparse_Input_File','sparse_matrix.txt','Sparse_Output_File','sparse_mat_out.txt');
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BMGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = BMGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btn_create.
function btn_create_Callback(hObject, eventdata, handles)
filename = handles.txt_gen_fileName.String;
n = str2double(handles.txt_gen_N.String);
k = str2double(handles.txt_gen_K.String);
r = str2double(handles.txt_gen_R.String);
density = str2double(handles.txt_gen_density.String) / 100;

input_file_name = handles.txt_gen_input.String;
randomized = handles.chk_randomize.Value == 1;
write_params = handles.chk_writeparams.Value == 1;
read_sparse = handles.radio_gen_sparse_input.Value == 1;
generate_sparse = handles.radio_gen_sparse_gen.Value == 1;

if(generate_sparse)
    creation_mode = 'sparse_gen';
    if(density <= 0 || density > 1)
    uiwait(msgbox('These conditions must be met: 0 <= k,r < n, 0 < density < 100','Error in value Range','modal'));
    return
    end    
elseif(read_sparse)
    creation_mode = 'sparse_input';
else
    creation_mode = 'band_gen';
    if(k >= n || r >= n || k < 0 || r < 0)
    uiwait(msgbox('These conditions must be met: 0 <= k,r < n, 0 < density < 100','Error in value Range','modal'));
    return
    end
end

band_create2([n,k,r,density], creation_mode, input_file_name, randomized, write_params, filename);


% --- Executes on button press in radio_c_manual.
function radio_c_manual_Callback(hObject, eventdata, handles)
if(hObject.Value == 1) % Selected
    handles.txt_c_k.Enable = 'on';
    handles.txt_c_r.Enable = 'on';
end
% Hint: get(hObject,'Value') returns toggle state of radio_c_manual

% --- Executes when selected object is changed in uibuttongroup1.
function uibuttongroup1_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup1 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(~isempty(strfind(hObject.Tag,'manual')))
    handles.txt_c_k.Enable = 'on';
    handles.txt_c_r.Enable = 'on';
else
    handles.txt_c_k.Enable = 'off';
    handles.txt_c_r.Enable = 'off';
end


% --- Executes when selected object is changed in uibuttongroup4.
function uibuttongroup4_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup4 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(~isempty(strfind(hObject.Tag,'manual')))
    handles.txt_dc_k.Enable = 'on';
    handles.txt_dc_r.Enable = 'on';
else
    handles.txt_dc_k.Enable = 'off';
    handles.txt_dc_r.Enable = 'off';
end


% --- Executes on button press in btn_c_cmpress.
function btn_c_cmpress_Callback(hObject, eventdata, handles)
input_file = handles.txt_c_input.String;
output_file = handles.txt_c_output.String;
k = str2double(handles.txt_c_k.String);
r = str2double(handles.txt_c_r.String);

if(k < 0 || r < 0)
    uiwait(msgbox('These conditions must be met: k < n, r< n, k >= 0, r >= 0','Error in value Range','modal'));
    return
end

read_k_r_from_file = handles.radio_c_read_file.Value == 1;
write_params = handles.chk_c_write.Value == 1;
if(handles.radio_c_manual.Value == 1) % Manual Input
    band_comp(input_file, read_k_r_from_file, write_params, output_file, k ,r);
else % Or Read file/Auto
    band_comp(input_file, read_k_r_from_file, write_params, output_file);
end


% --- Executes on button press in btn_dc_dcmpres.
function btn_dc_dcmpres_Callback(hObject, eventdata, handles)
input_file = handles.txt_dc_input.String;
output_file = handles.txt_dc_output.String;
k = str2double(handles.txt_dc_k.String);
r = str2double(handles.txt_dc_r.String);

if(k < 0 || r < 0)
    uiwait(msgbox('These conditions must be met: k < n, r< n, k >= 0, r >= 0','Error in value Range','modal'));
    return
end

read_k_r_from_file = handles.radio_dc_read_file.Value == 1;
write_params = handles.chk_dc_write.Value == 1;
if(handles.radio_dc_manual.Value == 1) % Manual Input
    band_decomp(input_file, read_k_r_from_file, write_params, output_file, k ,r);
else % Or Read file/Auto
    if(~read_k_r_from_file)
        uiwait(msgbox('Auto detection does not work perfectly for large K and R','Warning','modal'));
    end
    band_decomp(input_file, read_k_r_from_file, write_params, output_file);
end


% --- Executes when selected object is changed in uibuttongroup7.
function uibuttongroup7_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup7 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(~isempty(strfind(hObject.Tag,'sparse_gen')))
    handles.txt_gen_input.Enable = 'on';
    %handles.figure1.UserData.Sparse_Input_File = handles.txt_gen_input.String;
    %handles.txt_gen_input.String = handles.figure1.UserData.Sparse_Output_File;
    handles.txt_gen_input.String = 'sparse_mat_out.txt';
    handles.label_gen_sparse_input.String = 'Sparse Out :';
    
    handles.txt_gen_N.Enable = 'on';
    handles.txt_gen_K.Enable = 'off';
    handles.txt_gen_R.Enable = 'off';
    handles.txt_gen_density.Enable = 'on';
    handles.chk_randomize.Enable = 'on';
elseif(~isempty(strfind(hObject.Tag,'sparse_input')))
    
    %handles.figure1.UserData.Sparse_Output_File = handles.txt_gen_input.String;
    %handles.txt_gen_input.String = handles.figure1.UserData.Sparse_Input_File;
    handles.txt_gen_input.String = 'spare_matrix.txt';
    handles.txt_gen_input.Enable = 'on';
    handles.label_gen_sparse_input.String = 'Sparse Input :';
  
    handles.txt_gen_N.Enable = 'off';
    handles.txt_gen_K.Enable = 'off';
    handles.txt_gen_R.Enable = 'off';
    handles.txt_gen_density.Enable = 'off';
    handles.chk_randomize.Enable = 'off';
else
    handles.txt_gen_input.Enable = 'off';
    %handles.figure1.UserData.Sparse_Output_File = handles.txt_gen_input.String;
    %handles.txt_gen_input.String = handles.figure1.UserData.Sparse_Input_File;
    %handles.label_gen_sparse_input.String = 'Sparse Input :';
    
    handles.txt_gen_N.Enable = 'on';
    handles.txt_gen_K.Enable = 'on';
    handles.txt_gen_R.Enable = 'on';
    handles.txt_gen_density.Enable = 'off';
    handles.chk_randomize.Enable = 'on';
end
