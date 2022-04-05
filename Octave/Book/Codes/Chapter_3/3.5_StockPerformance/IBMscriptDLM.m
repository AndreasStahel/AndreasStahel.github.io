% read all the data, starting at column 2 and row 2
data = dlmread('IBM.csv',',',1,1);  

indata = data(:,1)';                % use second column only
k = length(data)-1;
indata = fliplr(indata(2:k+1));  % reverse the order of the stock values
disp(sprintf('Number of trading days from 1990 to 1999 is %i',k))

plot(indata)
xlabel('days'); ylabel('value of stock');
axis([0, k, 0, max(indata)]);
grid on
