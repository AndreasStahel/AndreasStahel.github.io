function res = simpson(f,a,b,n)

%% simpson(f,a,b,n) compute the integral of the function f
%% on the interval [a,b] with using Simpsons rule
%% use n subintervals of equal length , n has to be even, otherwise n+1 is used
%% f is either a function handle, e.g  @sin or a vector of values

if isa(f,'function_handle')
  n = round(n/2+0.1)*2; %% assure even number of subintervals
  h = (b-a)/n;
  x = linspace(a,b,n+1);
  f_x = x;
  for k = 0:n
    f_x(k+1) = feval(f,x(k+1));
  end%for
else
  n=length(f)
  if (floor(n/2)-n/2==0)
    error('simpson: odd number of data points required');
  else
    n = n-1;
    h = (b-a)/n;
    f_x = f(:)';
  end%if
end%if

w = 2*[ones(1,n/2); 2*ones(1,n/2)]; w = w(:); % construct the Simpson weights
w = [w;1]; w(1)=1;
res = (b-a)/(3*n)*f_x*w;
