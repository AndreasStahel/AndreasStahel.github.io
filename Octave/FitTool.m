## Copyright (C) 2021 Andreas Stahel
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <https://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {}  FitTool (@var{Dimension})
##
## start a GUI to perform linear regression with one or two independent variables
##
## @itemize
## @item parameter @var{Dimesion}:  @var{"1D"} or @var{"2D"}, 
## indicates whether one or two independent variables are used
## @*default : @var{"1D"}
## @item Use the @r{"help"} button to get some very basic help.
## @item Use the @r{"1D/2D"} button to switch between problems with one or two independent variables.
## @item For 1D problems polynomials up to degree six are in the pull down menue. 
## @*Other basis functions can be used by editing the matrix @var{M} in the box.
## @item For 2D problems polynomials up to degree three are in the pull down menue. 
##   Other basis functions can be used by editing the matrix @var{M} in the box.
## @item @r{FitTool} uses the function @r{LinearRegression()} from the Optim package.
## @item For advanced linear regression problems use the commands @r{LinearRegression()}
## or @r{regress()}. They are considerably more powerfull and flexibel.
## @end itemize
## @seealso{LinearRegression, regress}
## @end deftypefn

## Author: Andreas Stahel <Andreas.Stahel@gmx.com>
## Version 1.1
## Created: 2021-10-28

function FitTool(Dim, init = true)

if strcmp(graphics_toolkit(), 'qt') == 0
  warning('FitTool: QT toolkit required');
  return;
endif
  
pkg load optim
  
if nargin<1
  Dim = "1D";
endif

switch Dim
  case {"1D", "1d", 1}
    Dim = "1D";
  case {"2D", "2d", 2}
    Dim = "2D";
endswitch

clear h
clf
h.ax = axes('position', [0.35, 0.10, 0.63, 0.66]);
h.x = 'x'; h.y = 'y'; h.z = 'z';
set (gcf, "color", get(0,"defaultuicontrolbackgroundcolor"))
pos = get(gcf,"Position"); pos(3:4) = [750,600]; 
set(gcf, "Position", pos);

function update_data (obj, init = false)
  h = guidata(obj);
  switch (gcbo)
    case {h.data_x_edit}
      h.x = get (gcbo, 'string');
    case {h.data_y_edit}
      h.y = get (gcbo, 'string');
    case {h.data_z_edit}
      h.z = get (gcbo, 'string');
  endswitch
  exist_x = evalin('base',["exist('",h.x,"')"]);
  exist_y = evalin('base',["exist('",h.y,"')"]);
  exist_z = evalin('base',["exist('",h.z,"')"]);
  if exist_x&&exist_y&&(Dim == "1D")
     init_plot1D(obj);
  endif
  if exist_x&&exist_y&&exist_z&&(Dim == "2D")
     init_plot2D(obj,true);
  endif
  guidata( obj, h);
endfunction

function init_plot1D(obj, init = false)
  h = guidata(obj);
  h.x = get (h.data_x_edit, 'string');
  h.y = get (h.data_y_edit, 'string');
  x_data = evalin('base',h.x); x_data = x_data(:);
  y_data = evalin('base',h.y); y_data = y_data(:);
  plot (x_data, y_data, '+r');
  xlabel('x'); ylabel('y');
  guidata( obj, h);
endfunction% init_plot

function init_plot2D(obj, init = false)
  h = guidata(obj);
  h.x = get (h.data_x_edit, 'string');
  h.y = get (h.data_y_edit, 'string');
  h.z = get (h.data_z_edit, 'string');
  x_data = evalin('base',h.x); x_data = x_data(:);
  y_data = evalin('base',h.y); y_data = y_data(:); 
  z_data = evalin('base',h.z); z_data = z_data(:);
  plot3 (x_data, y_data, z_data, '+b');
  xlabel('x'); ylabel('y'); zlabel('z');
  guidata( obj, h);
endfunction% init_plot


function update_function1D(obj, init = false)
  h = guidata(obj);
  degree = get (h.plot_func_select, 'value');
  str ="[";
  for jj = 0:degree
    str = [str," x.^",num2str(jj),","];
  endfor
  str(end)="]";
  set(h.plot_func_edit,"string",str);
  guidata( obj, h);
endfunction% update_function

function update_function2D(obj, init = false)
  h = guidata(obj);
  funcName = get (h.plot_func_select, 'string'){get (h.plot_func_select, 'value')};
  switch funcName
    case "constant"
      str = "[x.^0]";
    case "linear"
      str = "[x.^0, x, y]";
    case "quadratic"
      str = "[x.^0, x, y, x.^2, x.*y, y.^2]";
    case "cubic"
      str = "[x.^0, x, y, x.^2, x.*y, y.^2, x.^3, x.^2.*y, x.*y.^2, y.^3]";
  endswitch
  set(h.plot_func_edit,"string",str);
  guidata( obj, h);
endfunction% update_function

function update_plot1D(obj, init = false)
  h = guidata(obj);
  fcn_string = get(gcbo,'string');
  %h.fcn = str2func(['@(x,omega)',get(gcbo,'string')]);
  x_data = evalin('base',h.x); x_data = x_data(:);
  y_data = evalin('base',h.y); y_data = y_data(:);
  x = x_data;
  M = eval(fcn_string);
  [p,~,~,dp] = LinearRegression(M,y_data);
  set(h.results_p,"Data",[p,sqrt(dp)])
  y_fit = M*p;
  rmean = norm(y_data-y_fit)/sqrt(length(y_data));
  r2 = corr(y_data,y_fit)^2;
  x = linspace(min(x_data),max(x_data),100)';
  y_fit = eval(fcn_string)*p;
  h.plot = plot (x_data, y_data, '+r', x, y_fit,"b");
  axis ([min(x),max(x)]);
  xlabel("x"); ylabel("y");
  set(h.results_r,"Data",[rmean;r2])
  guidata( obj, h);
endfunction% update_plot

function update_plot2D(obj, init = false)
  h = guidata(obj);
  fcn_string = get(gcbo,'string');
  x_data = evalin('base',h.x); x_data = x_data(:);
  y_data = evalin('base',h.y); y_data = y_data(:);
  z_data = evalin('base',h.z); z_data = z_data(:);
  x = x_data; y = y_data;
  M = eval(fcn_string);
  [p,~,~,dp] = LinearRegression(M,z_data);
  set(h.results_p,"Data",[p,sqrt(dp)])
  z_fit = M*p;
  rmean = norm(z_data-z_fit)/sqrt(length(z_data));
  r2 = corr(z_data,z_fit)^2;
  [x,y] = meshgrid(linspace(min(x_data),max(x_data),31),linspace(min(y_data),max(y_data),31));
  x = x(:);, y = y(:);
  z_fit = reshape(eval(fcn_string)*p,31,31);
  x = reshape(x,31,31);  y = reshape(y,31,31);
  mesh(x, y, z_fit);
  xlabel('x'); ylabel('y'); zlabel('z');
  hold on 
  plot3(x_data,y_data,z_data,"+b ")
  hold off
  set(h.results_r,"Data",[rmean;r2])
  guidata( obj, h);
endfunction% update_plot


function restart(obj, init = false)
  clf;
  if Dim == "1D"
    FitTool("2D");
  else
    FitTool("1D");
  endif
endfunction

function export(obj, init = false)
  h = guidata(obj);
  ExportImport = get (h.Save_button, 'string'){get (h.Save_button, 'value')};
  FitResult = inputdlg("Name of variable","enter variable name",1);
%  funcName = get (h.plot_func_select, 'string'){get (h.plot_func_select, 'value')};
  switch ExportImport
  case "export"
    p_data = get(h.results_p,"Data");
    assignin('base', FitResult{1},...
	    { get(h.plot_func_edit,'string'), p_data(:,1), p_data(:,2)});
  case "import"
    FitPar = evalin('base',FitResult{1});
    set(h.plot_func_edit, "string",FitPar{1})
    set(h.results_p,"Data",[FitPar{2},FitPar{3}])
  endswitch
endfunction

function ShowHelp(obj, init = false)
   helpdlg({"This GUI FitTool allows to solve simple linear regression problems with one or two independent variables",...
   " ","top left: data input","* read the data from the base context, where it has to exist",...
   "  the expressions are evaluated in the base context"," ",...
   "top right: select function","* select the degree of the polynomial",...
   "  the resulting matrix formula is displayed on the box below",...
   "* edit the resulting matrix, if required. This allows for regression with different basis functions.",...
   "  Hit the Enter key in the matrix box to start the computation",...
   " ","bottom left: numerical results","* values of the mean residual and R-squared",...
   "* values of the optimal parameters and their standard deviations",...
   " ","bottom righ: graphical result","* graphics with the data and the optimal fit",...
   " ","top right corner","* help button to display this help",...
   "* 1D/2D  to toogle between one or two independent variables",...
   "* export/import to save or load data in the base context",...
   " ", "For advanced linear regression problems use the functions LinearRegressio() or regress()"},...
  "Help for linear regression with FitTool")
endfunction

h.help_button = uicontrol ("style", "pushbutton",
                           "units", "normalized",
                           "string", "help",
                           "callback", @ShowHelp,
                           "value", 0,
                           "position", [0.88 0.96 0.10 0.04]);
                           
h.Save_button = uicontrol ("style", "popupmenu",
                           "units", "normalized",
                           "string", {"export","import"},
                           "callback", @export,
                           "position", [0.88 0.88 0.10 0.04]);

h.Dim_toggle = uicontrol ("style", "togglebutton",
                          "units", "normalized",
                          "string", "1D/2D",
                          "callback", @restart,
                          "value", 0,
                          "position", [0.88 0.92 0.10 0.04]);

h.input_label = uicontrol ("style", "text",
                           "units", "normalized",
                           "string", "enter names of variables\nfrom your workspace",
                           "horizontalalignment", "left",
                           "position", [0.02 0.72 0.26 0.06]);                  

h.evaluate_label = uicontrol ("style", "text",
                              "units", "normalized",
                              "string", "hit ENTER in M field to evaluate",
                              "horizontalalignment", "left",
                              "position", [0.40 0.85 0.30 0.06]);
                           
switch Dim
  case "1D"
h.plot_func = uicontrol ("style", "text",
                         "units", "normalized",
                         "string", "type of polynomial:",
                         "horizontalalignment", "left",
                         "position", [0.35 0.95 0.35 0.05]);
                         
h.plot_func_select = uicontrol ("style", "popupmenu",
                                "units", "normalized",
                                "string", {"linear",
                                           "quadratic",
                                           "cubic",
                                           "quartic",
                                           "quintic",
                                           "sextic"},
                                "callback", @update_function1D,
                                "position", [0.60 0.96 0.25 0.04]);
h.plot_func_edit = uicontrol ("style", "edit",
                              "units", "normalized",
                              "string", "[x.^0,x]",
                              "callback", @update_plot1D,
                              "position", [0.40 0.80 0.58 0.06]);
h.data_y_label = uicontrol ("style", "text",
                            "units", "normalized",
                            "string", "y:",
                            "horizontalalignment", "center",
                            "position", [0.01 0.80 0.04 0.06]);

h.data_y_edit = uicontrol ("style", "edit",
                           "units", "normalized",
                           "string", "y",
                           "callback", @update_data,
                           "position", [0.05 0.80 0.10 0.06]);

  case "2D"
h.plot_func = uicontrol ("style", "text",
                         "units", "normalized",
                         "string", "type of polynomial:",
                         "horizontalalignment", "left",
                         "position", [0.35 0.95 0.35 0.05]);

h.plot_func_select = uicontrol ("style", "popupmenu",
                                "units", "normalized",
                                "string", {"linear",
                                           "constant",
                                           "quadratic",
                                           "cubic"},
                                "callback", @update_function2D,
                                "position", [0.60 0.95 0.25 0.05]);
h.plot_func_edit = uicontrol ("style", "edit",
                              "units", "normalized",
                              "string", "[x.^0,x,y]",
                              "callback", @update_plot2D,
                              "position", [0.40 0.80 0.58 0.06]);
h.data_y_label = uicontrol ("style", "text",
                            "units", "normalized",
                            "string", "y:",
                            "horizontalalignment", "center",
                            "position", [0.16 0.90 0.04 0.06]);

h.data_y_edit = uicontrol ("style", "edit",
                           "units", "normalized",
                           "string", "y",
                           "callback", @update_data,
                           "position", [0.20 0.90 0.10 0.06]);
                           
h.data_z_label = uicontrol ("style", "text",
                            "units", "normalized",
                            "string", "z:",
                            "horizontalalignment", "center",
                            "position", [0.01 0.80 0.04 0.06]);
h.data_z_edit = uicontrol ("style", "edit",
                           "units", "normalized",
                           "string", "z",
                           "callback", @update_data,
                           "position", [0.05 0.80 0.10 0.06]);

endswitch

h.plot_func_label = uicontrol ("style", "text",
                               "units", "normalized",
                               "string", "M = ",
                               "horizontalalignment", "left",
                               "position", [0.34 0.80 0.05 0.06]);

h.data_x_label = uicontrol ("style", "text",
                            "units", "normalized",
                            "string", "x:",
                            "horizontalalignment", "center",
                            "position", [0.01 0.90 0.04 0.06]);

h.data_x_edit = uicontrol ("style", "edit",
                           "units", "normalized",
                           "string", "x",
                           "callback", @update_data,
                           "position", [0.05 0.90 0.10 0.06]);

h.results_r = uitable("units","normalized",
                      "Position",[0.01,0.55,0.26,0.13],
                      "RowName",{"r_mean", "R2"},
                      "ColumnWidth",{100},
                      "ColumnName",{"value"});

h.results_p = uitable("units","normalized",
                      "position",[0.01,0.05,0.26,0.50],
                      "ColumnWidth",{100,100},
                      "ColumnName",{"parameter p", " std(p) "});


%% Create initial figure and plot

guidata (gcf, h);
endfunction
