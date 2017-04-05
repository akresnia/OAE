directory_name = 'C:\Users\Alicja\Desktop\praca mgr\moje OAE\20_03\';
files = dir(fullfile(directory_name, '*_SFOAE_*.mat'));
%fileIndex = find(~[files.isdir]);
n = length(files);
a=1;
b=1;
c=1;
short = cell(n,4);
long = cell(n,4);
longest = cell(n,4);

for i = 1:length(files)
fileName = files(i).name; 
disp(fileName)
A = load([directory_name fileName]);

if A.cfg.uni_numf == 4
    short{a,1} = fileName(4); %ear
    short{a,2} = fileName(12:19); %date
    short{a,3} = A.dat;
    short{a,4} = fileName(20:25); %hour
    a = a + 1;
elseif A.cfg.uni_numf == 5
    long{b,1} = fileName(4); %ear
    long{b,2} = fileName(12:19); %date
    long{b,3} = A.dat;
    long{b,4} = fileName(20:25);
    b = b + 1;
elseif A.cfg.uni_numf==60
    longest{c,1} = fileName(4); %ear
    longest{c,2} = fileName(12:19); %date
    longest{c,3} = A.dat;
    longest{c,4} = fileName(20:25);
    c = c + 1;
else
    disp('Unknown length!')
end
end
