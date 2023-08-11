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
## @deftypefn {}  FitToolNL (@var{Dimension})
##
## start a GUI to perform nonlinear regression with one or two independent variables
##
## @itemize
## @item parameter @var{Dimesion}:  @var{"1D"} or @var{"2D"}, 
## indicates whether one or two independent variables are used
## @*default : @var{"1D"}
## @item Use the @r{"help"} button to get some very basic help.
## @item Use the @r{"1D/2D"} button to switch between problems with one or two independent variables.
## @item For 1D and 2D problems a few types of functions are in the pull down menue.
## @* The generated initial parameters p_i are naive guesses and have to be set to good values for the problem at hand. 
##   Other basis functions can be used by editing the function @r{f(x)} or @r{f(x,y)} in the box.
## @item @r{FitToolNL} uses the functions @r{nonlin_curvefit()} from the optim package.
## @item For advanced nonlinear regression problems use the commands @r{nonlin_curvefit()} or @r{leasqr()}. 
## They are considerably more powerfull and flexibel.
## @end itemize
## @seealso{nonlin_curvefit, leasqr, fsolve, lsqcurvefit, nlinfit}
## @end deftypefn

## Author: Andreas Stahel <andreas.stahel@gmx.com>
## Version 1.1
## Created: 2021-10-28

function FitToolNL(Dim, init = true)
pkg load optim  

if strcmp(graphics_toolkit(), 'qt') == 0
  warning('FitToolNL: QT toolkit required');
  return;
endif

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
%pos(1:2) = [10,10];
set(gcf, "Position", pos);

function init_plot(obj, init = false)
  h = guidata(obj);
  h.x = get (h.data_x_edit, 'string');
  h.y = get (h.data_y_edit, 'string');
  if Dim == "2D"
    h.z = get (h.data_z_edit, 'string');
  endif
  x_data = evalin('base',h.x); x_data = x_data(:);
  y_data = evalin('base',h.y); y_data = y_data(:); 
  if Dim == "1D"
    plot (x_data, y_data, '+r');
    xlabel('x'); ylabel('y');
  else
    z_data = evalin('base',h.z); z_data = z_data(:);
    plot3 (x_data, y_data, z_data, '+r');
    xlabel('x'); ylabel('y'); zlabel('z');
  endif
  guidata( obj, h);
endfunction% init_plot

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
     init_plot(obj,true);
  endif
  if exist_x&&exist_y&&exist_z&&(Dim == "2D")
     init_plot(obj,true);
  endif
  guidata( obj, h);
endfunction

function update_function1D(obj, init = false)
  h = guidata(obj);
  funcName = get (h.plot_func_select, 'string'){get (h.plot_func_select, 'value')};
  switch funcName
  case "Polynomial, linear"
    set(h.plot_func_edit,"string","p(1) + p(2)*x");
    set(h.plot_p0_edit, "string", "[ 0, 0]");
  case "Polynomial, quadratic"
    set(h.plot_func_edit,"string","p(1) + p(2)*x + p(3)*x.^2");
    set(h.plot_p0_edit, "string", "[ 0, 0, 0]");
  case "Polynomial, cubic"
    set(h.plot_func_edit,"string","p(1) + p(2)*x + p(3)*x.^2 + p(4)*x.^3");
    set(h.plot_p0_edit, "string", "[ 0, 0, 0, 0]");
  case "Trigonometric"
    set(h.plot_func_edit,"string","p(1)*cos(p(3)*x) + p(2)*sin(p(3)*x)");
    set(h.plot_p0_edit, "string", "[ 0, 0, 1]");
  case "Trigonometric and linear"
    set(h.plot_func_edit,"string","p(1)*cos(p(3)*x) + p(2)*sin(p(3)*x) + p(4) + p(5)*x");
    set(h.plot_p0_edit, "string", "[ 0, 0, 1, 0, 0]");   
  case "Exponential"
    set(h.plot_func_edit,"string","p(1)*exp(p(2)*x)");
    set(h.plot_p0_edit, "string", "[ 1, 0]");
  case "Exponential and constant"
    set(h.plot_func_edit,"string","p(1) + p(2)*exp(p(3)*x)");
    set(h.plot_p0_edit, "string", "[ 0, 1, 0]");
  case "Exponential and linear"
    set(h.plot_func_edit,"string","p(1) + p(2)*x + p(3)*exp(p(4)*x)");
    set(h.plot_p0_edit, "string", "[ 0, 0, 1, 0]");
  case "Exponential and trigonometric"
    set(h.plot_func_edit,"string","p(1)*exp(p(2)*x) + p(3)*cos(p(5)*x) + p(4)*sin(p(5)*x)");
    set(h.plot_p0_edit, "string", "[1, 0, 0, 0, 1]");
  case "Double exponential"
    set(h.plot_func_edit,"string","p(1)*exp(p(2)*x) + p(3)*exp(p(4)*x)");
    set(h.plot_p0_edit, "string", "[1, 1, 1, -1]");
  case "Gaussian"
    set(h.plot_func_edit,"string","p(1)*exp(-0.5*(x-p(2)).^2/p(3)^2)");
    set(h.plot_p0_edit, "string", "[1, 0, 1]");
  case  "Rational 1/2"
    set(h.plot_func_edit,"string","(p(1) + p(2)*x) ./ (1 + p(3)*x + p(4)*x.^2)");
    set(h.plot_p0_edit, "string", "[0, 0, 0, 0]");
  case  "Rational 2/2"
    set(h.plot_func_edit,"string","(p(1) + p(2)*x + p(3)*x.^2) ./ (1 + p(4)*x + p(5)*x.^2)");
    set(h.plot_p0_edit, "string", "[0, 0, 0, 0, 0]");
  endswitch
  guidata( obj, h);
endfunction% update_function

function update_function2D(obj, init = false)
  h = guidata(obj);
  funcName = get (h.plot_func_select, 'string'){get (h.plot_func_select, 'value')};
  switch funcName
  case "Polynomial, linear"
    set(h.plot_func_edit,"string","p(1) + p(2)*x + p(3)*y");
    set(h.plot_p0_edit, "string", "[ 0, 0, 0]");
  case "Polynomial, quadratic"
    set(h.plot_func_edit,"string","p(1) + p(2)*x + p(3)*y + p(4)*x.^2 + p(5)*x.*y + p(6)*y.^2");
    set(h.plot_p0_edit, "string", "[ 0, 0, 0, 0, 0, 0]");
  case "Trigonometric"
    set(h.plot_func_edit,"string","p(1)*cos(p(3)*x) + p(2)*sin(p(3)*x) + p(4)*cos(p(6)*y) + p(5)*sin(p(6)*y)");
    set(h.plot_p0_edit, "string", "[ 0, 0, 1, 0, 0, 1]");    
  case "Exponential"
    set(h.plot_func_edit,"string","p(1)*exp(p(2)*x+p(3)*y)");
    set(h.plot_p0_edit, "string", "[ 1, 0, 0]");
  case "Exponential and constant"
    set(h.plot_func_edit,"string","p(1) + p(2)*exp(p(3)*x+p(4)*y)");
    set(h.plot_p0_edit, "string", "[ 0, 1, 0, 0]");
  case "Gaussian"
    set(h.plot_func_edit,"string","p(1)*exp(-(p(4)*(x-p(2)).^2+p(5)*(x-p(2)).*(y-p(3))+p(6)*(y-p(3)).^2))");
    set(h.plot_p0_edit, "string", "[1, 0, 0, 1, 0, 1]");
  endswitch
  guidata( obj, h);
endfunction% update_function

function update_plot1D(obj, init = false)
  h = guidata(obj);
  eval(["func=@(p,x)",get(gcbo,'string'),";"]);
  x_data = evalin('base',h.x); x_data = x_data(:);
  y_data = evalin('base',h.y); y_data = y_data(:);
  x = x_data; y = y_data;
  p0 = eval(get(h.plot_p0_edit,"string"));
  [p, fy, cvg] = nonlin_curvefit (func, p0', x_data, y_data);
  if cvg <= 0  %% nonlin_curvefit did not converge
     helpdlg({"nonlin-curvefit() did not converge",...
              "try again with better initial values for the parameters p_i"},...
              "FitToolNL: did not converge")
  endif
  settings = optimset('ret_covp', true,'objf_type','wls');
  FitInfo = curvefit_stat (func, p, x_data, y_data, settings);
  set(h.results_p,"Data",[p,sqrt(diag(FitInfo.covp))])
  y_fit = func(p,x_data);
  rmean = norm(y_data-y_fit)/sqrt(length(y_data));
  r2 = corr(y_data,y_fit)^2;
  x = linspace(min(x_data),max(x_data),100)';
  y_fit = func(p,x);
  h.plot = plot (x_data, y_data, '+r', x, y_fit,"b");
  axis ([min(x),max(x)]);
  xlabel("x"); ylabel("y");
  set(h.results_r,"Data",[rmean;r2])
  guidata( obj, h);
endfunction% update_plot

function update_plot2D(obj, init = false)
  h = guidata(obj);
  eval(["func=@(x,y,p)",get(gcbo,'string'),";"]);
  func_merge = @(p,xy)func(xy(:,1),xy(:,2),p);
  x_data = evalin('base',h.x); x_data = x_data(:);
  y_data = evalin('base',h.y); y_data = y_data(:);
  z_data = evalin('base',h.z); z_data = z_data(:);
  x = x_data; y = y_data; z = z_data;
  p0 = eval(get(h.plot_p0_edit,"string"));
  [p, fy, cvg] = nonlin_curvefit (func_merge, p0', [x_data, y_data], z_data);
  if cvg <= 0  %% nonlin_curvefit did not converge
     helpdlg({"nonlin-curvefit() did not converge",...
              "try again with better initial values for the parameters p_i"},...
              "FitToolNL: did not converge")
  endif
  settings = optimset('ret_covp', true,'objf_type','wls');
  FitInfo = curvefit_stat (func_merge, p, [x_data, y_data], z_data, settings);
  set(h.results_p,"Data",[p,sqrt(diag(FitInfo.covp))])
  z_fit = func(x_data,y_data,p);
  rmean = norm(z_data-z_fit)/sqrt(length(z_data));
  r2 = corr(z_data,z_fit)^2;
  set(h.results_r,"Data",[rmean;r2])
  [x,y] = meshgrid(linspace(min(x_data),max(x_data),31),linspace(min(y_data),max(y_data),31));
  z = func(x(:),y(:),p);
  mesh(x, y, reshape(z,31,31));
  xlabel('x'); ylabel('y'); zlabel('z');
  hold on 
  plot3(x_data,y_data,z_data,"+r")
  hold off
  guidata( obj, h);
endfunction% update_plot

function restart(obj, init = false)
  clf;
  if Dim == "1D"
    FitToolNL("2D");
  else
    FitToolNL("1D");
  endif
endfunction

function export(obj, init = false)
  h = guidata(obj);
  ExportImport = get (h.Save_button, 'string'){get (h.Save_button, 'value')};
  FitResult = inputdlg("Name of variable","enter variable name",1);
  switch ExportImport
  case "export"
    p_data = get(h.results_p,"Data");
    assignin('base', FitResult{1},...
	    { get(h.plot_func_edit,'string'), p_data(:,1), p_data(:,2), get(h.plot_p0_edit,"string")});
  case "import"
    FitPar = evalin('base',FitResult{1});
    set(h.plot_func_edit, "string",FitPar{1})
    set(h.results_p,"Data",[FitPar{2},FitPar{3}])
    set(h.plot_p0_edit,"string",['[',sprintf('%g ' ,FitPar{2}),']']); 
  endswitch
endfunction

function ShowHelp(obj, init = false)
   helpdlg({"This GUI FitToolNL allows to solve simple nonlinear regression problems with one or two independent variables",...
   " ", "top left: data input","* read the data from the base context, where it has to exist",...
   "  the expressions are evaluated in the base context"," ",...
   "top right: select function and initial parameters","* select the type of function",...
   "  a naive guess of initial parameters is provided",...
   "  edit the initial parameter values",...
   "* the resulting function is displayed on the box below",...
   "  edit the function, if required","  Hit the Enter key in the function box to start the computation",...
   " ","bottom left: numerical results","* values of the mean residual and R-squared",...
   "* values of the optimal parameters and their standard deviation",...
   " ","bottom righ: graphical result","* graphics with the data and the optimal fit",...
   " ","top right corner","* help button to display this help",...
   "* 1D/2D  to toogle between one or two independent variables",...
   "* export/import to save or load data in the base context",...
   " ", "For advanced nonlinear regression problems use the commands nonlin\_{ }curvefit(), leasqr(), fsolve() or nlinfit()"},...
  "Help for nonlinear regression with FitToolNL")
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

h.plot_func = uicontrol ("style", "text",
                         "units", "normalized",
                         "string", "function:",
                         "horizontalalignment", "left",
                         "position", [0.35 0.95 0.20 0.04]);

h.plot_p0_label = uicontrol ("style", "text",
                             "units", "normalized",
                             "string", "p0 =",
                             "horizontalalignment", "left",
                             "position", [0.35 0.88 0.05 0.06]);

h.input_label = uicontrol ("style", "text",
                           "units", "normalized",
                           "string", "enter names of variables\nfrom your workspace",
                           "horizontalalignment", "left",
                           "position", [0.02 0.72 0.26 0.06]);                  

switch Dim
case "1D"
h.evaluate_label = uicontrol ("style", "text",
                              "units", "normalized",
                              "string", "hit ENTER in f(x) field to evaluate",
                              "horizontalalignment", "left",
                              "position", [0.40 0.83 0.33 0.06]);

h.plot_func_label = uicontrol ("style", "text",
                               "units", "normalized",
                               "string", "f(x) = ",
                               "horizontalalignment", "left",
                               "position", [0.34 0.78 0.05 0.06]);

h.plot_func_select = uicontrol ("style", "popupmenu",
                               "units", "normalized",
                               "string", {"Polynomial, linear",
                                          "Polynomial, quadratic",
                                          "Polynomial, cubic",
                                          "Trigonometric",
                                          "Trigonometric and linear",
                                          "Exponential",
                                          "Exponential and constant",
                                          "Exponential and linear",
                                          "Exponential and trigonometric",
                                          "Double exponential",
                                          "Gaussian",
                                          "Rational 1/2",
                                          "Rational 2/2"},
                               "callback", @update_function1D,
                               "position", [0.45 0.95 0.40 0.05]);

h.plot_func_edit = uicontrol ("style", "edit",
                               "units", "normalized",
                               "string", "p(1) + p(2)*x",
                               "callback", @update_plot1D,
                               "position", [0.40 0.78 0.58 0.06]);

h.plot_p0_edit = uicontrol ("style", "edit",
                            "units", "normalized",
                            "string", "[ 0, 0]",
                            "position", [0.40 0.88 0.45 0.06]);

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
h.evaluate_label = uicontrol ("style", "text",
                              "units", "normalized",
                              "string", "hit ENTER in f(x,y) field to evaluate",
                              "horizontalalignment", "left",
                              "position", [0.40 0.83 0.33 0.06]);

h.plot_func_label = uicontrol ("style", "text",
                               "units", "normalized",
                               "string", "f(x,y) = ",
                               "horizontalalignment", "left",
                               "position", [0.33 0.78 0.05 0.06]);

h.plot_func_select = uicontrol ("style", "popupmenu",
                               "units", "normalized",
                               "string", {"Polynomial, linear",
                                          "Polynomial, quadratic",
                                          "Trigonometric",
                                          "Exponential",
		                          "Exponential and constant",
                                          "Gaussian"},
                               "callback", @update_function2D,
                               "position", [0.45 0.95 0.40 0.05]);

h.plot_func_edit = uicontrol ("style", "edit",
                              "units", "normalized",
                              "string", "p(1) + p(2)*x + p(3)*y",
                              "callback", @update_plot2D,
                              "position", [0.40 0.78 0.58 0.06]);

h.plot_p0_edit = uicontrol ("style", "edit",
                            "units", "normalized",
                            "string", "[ 0, 0, 0]",
                            "position", [0.40 0.88 0.45 0.06]);

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
                      "RowName",{"r_mean", "r2"},
                      "ColumnWidth",{100},
                      "ColumnName",{"value"});

h.results_p = uitable("units","normalized",
                      "position",[0.01,0.05,0.26,0.50],
                      "ColumnWidth",{100,100},
                      "ColumnName",{"parameter p", " std(p) "});

%% Create initial figure and plot
guidata (gcf, h);
endfunction
