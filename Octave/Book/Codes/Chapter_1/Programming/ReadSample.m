filename = 'Sample.txt';    % open the file for reading, in text mode
infile = fopen(filename,'rt');
c = blanks(20); x = zeros(1,20); n = x; % prealocate the memory

for k = 1:3                 % read and dump the three header lines
  tline = fgetl(infile);
end%for

k = 1;                      % initialize the data counter
tline = fgetl(infile);
while ischar(tline)  
  % if tline not character, then we reached the end of the file
  % scan the string in the format: character float integer
  [ct,xt,nt] = sscanf(tline,"%1c%g%i","C"); % Octave only
  c(k) = ct; x(k) = xt;n(k) = nt; % store the data in the vectors
  tline = fgetl(infile);      % read the next line
  k = k+1;                    % increment the counter
end%while

fclose(infile);               % close the file
% use only the effectively read data
x = x(1:k-1); n = n(1:k-1); 
c = c(1:k-1)
