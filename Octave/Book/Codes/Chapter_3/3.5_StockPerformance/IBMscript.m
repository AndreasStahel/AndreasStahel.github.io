indata = zeros(1,365*10);        % allocate storage for the data

infile = fopen('IBM.csv','rt');  % open the file text for reading
tline  = fgetl(infile);          % read the title line

k = 0;                           % a counter
inline = fgetl(infile)           % read a line
while ischar(inline)             % test for end of input file
  counter = find(inline==',');   % find the first ','
                                 % then consider only the rest of the line
  newline = inline(counter(1)+1:length(inline));
                                 % read the numbers
  A = sscanf(newline,'%f%c%f%c%f%c%f%c%f');
  k = k+1;
  indata(k) = A(1);              % store only the first number
  inline = fgetl(infile);        % get the next input line
end%while
fclose(infile);                  % close the file

disp(sprintf('Number of trading days from 1990 to 1999 is %i',k))

indata = fliplr(indata(1:k));    % reverse the order of the stock values
figure(1); plot(indata)
           xlabel('days'); ylabel('value of stock');
           axis([0, k, 0, max(indata)]);
