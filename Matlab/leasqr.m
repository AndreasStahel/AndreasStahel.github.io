function [f,p,kvg,iter,corp,covp,covr,stdresid,Z,r2]= ...
      leasqr(x,y,pin,F,stol,niter,wt,dp,dFdp,options)
%function[f,p,kvg,iter,corp,covp,covr,stdresid,Z,r2]=
%                   leasqr(x,y,pin,F,{stol,niter,wt,dp,dFdp,options})
%
% Version 3.beta
%  {}= optional parameters
% Levenberg-Marquardt nonlinear regression of f(x,p) to y(x), where:
% x=vec or mat of indep variables, 1 row/observation: x=[x0 x1....xm]
% y=vec of obs values, same no. of rows as x.
% wt=vec(dim=length(x)) of statistical weights.  These should be set
%   to be proportional to (sqrt of var(y))^-1; (That is, the covariance
%   matrix of the data is assumed to be proportional to diagonal with diagonal
%   equal to (wt.^2)^-1.  The constant of proportionality will be estimated.),
%   default=ones(length(y),1).
% pin=vector of initial parameters to be adjusted by leasqr.
% dp=fractional incr of p for numerical partials,default= .001*ones(size(pin))
%   dp(j)>0 means central differences.
%   dp(j)<0 means one-sided differences.
% Note: dp(j)=0 holds p(j) fixed i.e. leasqr wont change initial guess: pin(j)
% F=name of function in quotes,of the form y=f(x,p)
% dFdp=name of partials M-file in quotes default is prt=dfdp(x,f,p,dp,F)
% stol=scalar tolerances on fractional improvement in ss,default stol=.0001
% niter=scalar max no. of iterations, default = 20
% options=matrix of n rows (same number of rows as pin) containing 
%   column 1: desired fractional precision in parameter estimates.
%     Iterations are terminated if change in parameter vector (chg) on two
%     consecutive iterations is less than their corresponding elements
%     in options(:,1).  [ie. all(abs(chg*current parm est) < options(:,1))
%      on two consecutive iterations.], default = zeros().
%   column 2: maximum fractional step change in parameter vector.
%     Fractional change in elements of parameter vector is constrained to be 
%     at most options(:,2) between sucessive iterations.
%     [ie. abs(chg(i))=abs(min([chg(i) options(i,2)*current param estimate])).],
%     default = Inf*ones().
%
%          OUTPUT VARIABLES
% f=vec function values computed in function func.
% p=vec trial or final parameters. i.e, the solution.
% kvg=scalar: =1 if convergence, =0 otherwise.
% iter=scalar no. of interations used.
% corp= correlation matrix for parameters
% covp= covariance matrix of the parameters
% covr = diag(covariance matrix of the residuals)
% stdresid= standardized residuals
% Z= matrix that defines confidence region
% r2= coefficient of multiple determination

% All Zero guesses not acceptable
% Richard I. Shrager (301)-496-1122
% Modified by A.Jutan (519)-679-2111
% Modified by Ray Muzic 14-Jul-1992
%       1) add maxstep feature for limiting changes in parameter estimates
%          at each step.
%       2) remove forced columnization of x (x=x(:)) at beginning. x could be
%          a matrix with the ith row of containing values of the 
%          independent variables at the ith observation.
%       3) add verbose option
%       4) add optional return arguments covp, stdresid, chi2
%       5) revise estimates of corp, stdev
% Modified by Ray Muzic 11-Oct-1992
%	1) revise estimate of Vy.  remove chi2, add Z as return values
% Modified by Ray Muzic 7-Jan-1994
%       1) Replace ones(x) with a construct that is compatible with versions
%          newer and older than v 4.1.
%       2) Added global declaration of verbose (needed for newer than v4.x)
%       3) Replace return value var, the variance of the residuals with covr,
%          the covariance matrix of the residuals.
%       4) Introduce options as 10th input argument.  Include
%          convergence criteria and maxstep in it.
%       5) Correct calculation of xtx which affects coveraince estimate.
%       6) Eliminate stdev (estimate of standard deviation of parameter
%          estimates) from the return values.  The covp is a much more
%          meaningful expression of precision because it specifies a confidence
%          region in contrast to a confidence interval..  If needed, however,
%          stdev may be calculated as stdev=sqrt(diag(covp)).
%       7) Change the order of the return values to a more logical order.
%       8) Change to more efficent algorithm of Bard for selecting epsL.
%       9) Tigten up memory usage by making use of sparse matrices (if 
%          MATLAB version >= 4.0) in computation of covp, corp, stdresid.
% Modified by Sean Brennan 17-May-1994
%          verbose is now a vector: 
%          verbose(1) controls output of results
%          verbose(2) controls plotting intermediate results
%
% References:
% Bard, Nonlinear Parameter Estimation, Academic Press, 1974.
% Draper and Smith, Applied Regression Analysis, John Wiley and Sons, 1981.
%
%set default args

% argument processing
%

verbose = [0 0]; % choose by hand

if(exist('verbose')~=1), %If verbose undefined, print nothing
	verbose(1)=0;    %This will not tell them the results
	verbose(2)=0;    %This will not replot each loop
end;

%plotcmd='plot(x(:,1),y,''.'',''markersize'',1,x(:,1),f,''linewidth'',2); %shg';
%%if (sscanf(version,'%f') >= 4),
vernum = sscanf(version,'%f');
%if vernum(1) >= 4,
%  global verbose
%  plotcmd='plot(x(:,1),y,''.'',x(:,1),f,''linewidth'',2); figure(gcf)';
%end;

plotcmd='plot(x(:,1),y,''.'',x(:,1),f,''linewidth'',2); figure(gcf)';

if (nargin <= 8), dFdp='dfdp'; end;
if (nargin <= 7), dp=.001*(pin*0+1); end; %DT
if (nargin <= 6), wt=ones(length(y),1); end;	% SMB modification
if (nargin <= 5), niter=20; end;
if (nargin == 4), stol=.0001; end;
%

y=y(:); wt=wt(:); pin=pin(:); dp=dp(:); %change all vectors to columns
% check data vectors- same length?
m=length(y); n=length(pin); p=pin;[m1,m2]=size(x);
if m1~=m ,error('input(x)/output(y) data must have same number of rows ') ,end;

if (nargin <= 9), 
  options=[zeros(n,1) Inf*ones(n,1)];
  nor = n; noc = 2;
else
  [nor noc]=size(options);
  if (nor ~= n),
    error('options and parameter matrices must have same number of rows'),
  end;
  if (noc ~= 2),
    options=[options(noc,1) Inf*ones(noc,1)];
  end;
end;
pprec=options(:,1);
maxstep=options(:,2);
%

% set up for iterations
%

f=feval(F,x,p); fbest=f; pbest=p;
r=wt.*(y-f);
sbest=r'*r;
nrm=zeros(n,1);
chgprev=Inf*ones(n,1);
kvg=0;
epsLlast=1;
epstab=[.1 1 1e2 1e4 1e6];

% do iterations
%
for iter=1:niter,
  pprev=pbest;
  prt=feval(dFdp,x,fbest,pprev,dp,F);
  r=wt.*(y-fbest);
  sprev=sbest;
  sgoal=(1-stol)*sprev;
  for j=1:n,
    if dp(j)==0,
      nrm(j)=0;
    else
      prt(:,j)=wt.*prt(:,j);
      nrm(j)=prt(:,j)'*prt(:,j);
      if nrm(j)>0,
        nrm(j)=1/sqrt(nrm(j));
      end;
    end
    prt(:,j)=nrm(j)*prt(:,j);
  end;
% above loop could ? be replaced by:
% prt=prt.*wt(:,ones(1,n)); 
% nrm=dp./sqrt(diag(prt'*prt)); 
% prt=prt.*nrm(:,ones(1,m))';
  [prt,s,v]=svd(prt,0);
  s=diag(s);
  g=prt'*r; 
  for jjj=1:length(epstab),
    epsL = max(epsLlast*epstab(jjj),1e-7);
    se=sqrt((s.*s)+epsL);
    gse=g./se;
    chg=((v*gse).*nrm);
%   check the change constraints and apply as necessary
    ochg=chg;
    for iii=1:n,
      if (maxstep(iii)==Inf), break; end;
      chg(iii)=max(chg(iii),-abs(maxstep(iii)*pprev(iii)));
      chg(iii)=min(chg(iii),abs(maxstep(iii)*pprev(iii)));
    end;
    if (verbose(1) && any(ochg ~= chg)),
      disp(['Change in parameter(s): ' ...
         sprintf('%d ',find(ochg ~= chg)) 'were constrained']);
    end;
    aprec=abs(pprec.*pbest);       %---
% ss=scalar sum of squares=sum((wt.*(y-f))^2).
%    if (any(abs(chg) > 0.1*aprec)),%---  % only worth evaluating function if
      p=chg+pprev;                       % there is some non-miniscule change
      f=feval(F,x,p);
      r=wt.*(y-f);
      ss=r'*r;
      if ss<sbest,
        pbest=p;
        fbest=f;
        sbest=ss;
      end;
      if ss<=sgoal,
        break;
      end;
      %    end;                          %---
  end;
  epsLlast = epsL;
  if (verbose(2)),
    eval(plotcmd);
  end;
  if ss<eps,
    break;
  end
  aprec=abs(pprec.*pbest);
%  [aprec chg chgprev]
  if (all(abs(chg) < aprec) & all(abs(chgprev) < aprec)),
    kvg=1;
    if (verbose(1)),
      fprintf('Parameter changes converged to specified precision\n');
    end;
    break;
  else
    chgprev=chg;
  end;
  if ss>sgoal,
    break;
  end;
end;

% set return values
%
p=pbest;
f=fbest;
ss=sbest;
kvg=((sbest>sgoal)|(sbest<=eps)|kvg);
if kvg ~= 1 , %disp(' CONVERGENCE NOT ACHIEVED! '),% 
end;

% CALC VARIANCE COV MATRIX AND CORRELATION MATRIX OF PARAMETERS
% re-evaluate the Jacobian at optimal values
jac=feval(dFdp,x,f,p,dp,F);
msk = dp ~= 0;
n = sum(msk);           % reduce n to equal number of estimated parameters
jac = jac(:, msk);	% use only fitted parameters

%% following section is Ray Muzic's estimate for covariance and correlation
%% assuming covariance of data is a diagonal matrix proportional to
%% diag(1/wt.^2).  
%% cov matrix of data est. from Bard Eq. 7-5-13, and Row 1 Table 5.1 

if vernum(1) >= 4,
  Q=sparse(1:m,1:m,(0*wt+1)./(wt.^2));  % save memory
  Qinv=inv(Q);
else
  Qinv=diag(wt.*wt);
  Q=diag((0*wt+1)./(wt.^2));
end;
resid=y-f;                                    %un-weighted residuals
covr=resid'*Qinv*resid*Q/(m-n);                 %covariance of residuals
Vy=1/(1-n/m)*covr;  % Eq. 7-13-22, Bard         %covariance of the data 

jtgjinv=inv(jac'*Qinv*jac);			%argument of inv may be singular
covp=jtgjinv*jac'*Qinv*Vy*Qinv*jac*jtgjinv; % Eq. 7-5-13, Bard %cov of parm est
d=sqrt(abs(diag(covp)));
corp=covp./(d*d');

covr=diag(covr);                 % convert returned values to compact storage
stdresid=resid./sqrt(diag(Vy));  % compute then convert for compact storage
Z=((m-n)*jac'*Qinv*jac)/(n*resid'*Qinv*resid);

%%% alt. est. of cov. mat. of parm.:(Delforge, Circulation, 82:1494-1504, 1990
disp('Alternate estimate of cov. of param. est.')
covp=resid'*Qinv*resid/(m-n)*jtgjinv;

%Calculate R^2 (Ref Draper & Smith p.46)
%
r=corrcoef(y,f);
if (exist('OCTAVE_VERSION'))
  r2=r^2;
else
  r2=r(1,2).^2;
end

% if someone has asked for it, let them have it
%
if (verbose(2)), eval(plotcmd); end,
if (verbose(1)),
  disp(' Least Squares Estimates of Parameters')
  disp(p')
  disp(' Correlation matrix of parameters estimated')
  disp(corp)
  disp(' Covariance matrix of Residuals' )
  disp(covr)
  disp(' Correlation Coefficient R^2')
  disp(r2)
  sprintf(' 95%% conf region: F(0.05)(%.0f,%.0f)>= delta_pvec''*Z*delta_pvec',n,m-n)
  Z
%   runs test according to Bard. p 201.
  n1 = sum((f-y) < 0);
  n2 = sum((f-y) > 0);
  nrun=sum(abs(diff((f-y)<0)))+1;
  if ((n1>10)&(n2>10)), % sufficent data for test?
    zed=(nrun-(2*n1*n2/(n1+n2)+1)+0.5)/(2*n1*n2*(2*n1*n2-n1-n2)...
      /((n1+n2)^2*(n1+n2-1)));
    if (zed < 0),
      prob = erfc(-zed/sqrt(2))/2*100;
      disp([num2str(prob) '% chance of fewer than ' num2str(nrun) ' runs.']);
    else,
      prob = erfc(zed/sqrt(2))/2*100;
      disp([num2str(prob) '% chance of greater than ' num2str(nrun) ' runs.']);
    end;
  end;
end;

% A modified version of Levenberg-Marquardt
% Non-Linear Regression program previously submitted by R.Schrager.
% This version corrects an error in that version and also provides
% an easier to use version with automatic numerical calculation of
% the Jacobian Matrix. In addition, this version calculates statistics
% such as correlation, etc....
%
% Version 3 Notes
% Errors in the original version submitted by Shrager (now called version 1)
% and the improved version of Jutan (now called version 2) have been corrected.
% Additional features, statistical tests, and documentation have also been
% included along with an example of usage.  BEWARE: Some the the input and
% output arguments were changed from the previous version.
%
%     Ray Muzic     <rfm2@ds2.uh.cwru.edu>
%     Arthur Jutan  <jutan@charon.engga.uwo.ca>
