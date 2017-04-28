filename = 'dpoae_data_01.txt';
fileID = fopen(filename);
head_lines  = 9276;
% C_data1 = textscan(fileID,['%q', '%*q', '%*q', ...
%     repmat('%q',[1,3]), repmat('%*q',[1,7]),repmat('%q',[1,17]),'%*[^\n]'],...
%     'HeaderLines',head_lines,'CollectOutput',1, 'Delimiter',',');
%d8 - int8, %*[^\n] skips the remainder of a line %q - quoted data

C_data1 = textscan(fileID, repmat('%q',[1,52]),...
   'HeaderLines',head_lines, 'CollectOutput',1,'Delimiter',',');

idx1 = find(strcmp(C_data1{1}, 'TestData'), 1, 'first');
idx2 = find(strcmp(C_data1{1}, 'TestSession'), 1, 'first');
data = C_data1{1}(1:idx2-1,:);
fclose(fileID);