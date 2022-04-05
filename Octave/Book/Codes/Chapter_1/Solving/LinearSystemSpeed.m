nlist = floor(logspace(3.4,4,10));
timer = zeros(size(nlist));
for k = 1:length(nlist)
  n = nlist(k);
  A = rand(n)-0.5 + n*eye(n);
  f = rand(n,1);
  t0 = cputime();
  x = A\f;
  timer(k) = cputime() - t0;
end%for

MFlops = 1/3*nlist.^3./timer/1e6

figure(1); plot(nlist,timer,'+-')
           xlabel('n, size of system'); ylabel('time [s]');  grid on

figure(2); plot(log10(nlist),log10(timer),'+-')
           xlabel('log(n)'); ylabel('log(time)');  grid on
