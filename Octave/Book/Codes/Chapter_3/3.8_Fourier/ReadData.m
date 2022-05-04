%filename1='SC1007.TXT';
%filename2='SC2007.TXT';
filename1 = 'SC1001.TXT';
filename2 = 'SC2001.TXT';

indata = zeros(2,10007);         % allocate storage for the data

infile = fopen(filename1,'r');   % open the file for reading
for k = 1:5
  tline = fgetl(infile);         % read 5 lines of text
end%for

k = 0;                          % a counter
inline = fgetl(infile);         % read a line
while ischar(inline)            % test for end of input file   
  A=sscanf(inline,'%f%c%f'); % read the two numbers
  k = k+1;
  indata(1,k) = A(1);           % store only the time
  indata(2,k) = A(3);           % store only the amplitude
  inline = fgetl(infile);       % get the next input line
end%for
fclose(infile);                 % close the file

disp(sprintf('Number of datapoints is  %i',k))

timedataIn = indata(1,1:k);
ampdataIn  = indata(2,1:k);
TimeIn = timedataIn(k)-timedataIn(1)
FreqIn = 1/(timedataIn(2)-timedataIn(1))
figure(1); plot(timedataIn,ampdataIn)
           title('Amplitude of input'); grid on
           xlabel('Time'); ylabel('Amplitude')

indata = zeros(2,10007);        % allocate storage for the data

infile = fopen(filename2,'r');   % open the file for reading
for k = 1:5
  tline = fgetl(infile);         % read 5 lines of text
end%for

k = 0;                           % a counter
inline = fgetl(infile);          % read a line
while ischar(inline)             % test for end of input file   
  A = sscanf(inline,'%f%c%f');   % read the two numbers
  k = k+1;
  indata(1,k) = A(1);            % store only the time
  indata(2,k) = A(3);            % store only the amplitude
  inline = fgetl(infile);        % get the next input line
end%while
fclose(infile);                  % close the file

disp(sprintf('Number of datapoints is  %i',k))

timedataOut = indata(1,1:k);
ampdataOut  = indata(2,1:k);
TimeOut = timedataOut(k)-timedataOut(1)
FreqOut = 1/(timedataOut(2)-timedataOut(1))
figure(2); plot(timedataOut,ampdataOut)
           title('Amplitude of response');  grid on
           xlabel('Time'); ylabel('Amplitude')