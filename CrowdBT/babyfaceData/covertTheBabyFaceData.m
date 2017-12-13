saveFileFolder = './'
saveFileName='BabyFacePreference.mat';
loadFileFolder = './real_data/'
D=[];
for i=1:21
    d=load([loadFileFolder 'FARM_' int2str(i) '.txt']); % how to convert the integer to the string.
    D=[D;d];  %space connect the new matrix on the right, f,or ; under the bottom
end

save([saveFileFolder saveFileName],'D'); 