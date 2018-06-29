%% EN608 CRUISE
fpath = '\\sosiknas1\Lab_data\Attune\EN608\ExportedStats\';
outpath = '\\sosiknas1\Lab_data\Attune\EN608\Summary\';
filelist = dir([fpath 'NES*']); %for EN608 Cruise

%% AR29 CRUISE
fpath = '\\sosiknas1\Backup\SPIROPA\20180414_AR29\Attune\proc\Exported_Stats\';
outpath = '\\sosiknas1\Backup\SPIROPA\20180414_AR29\Attune\Summary\' ; %FIX';
filelist = dir([fpath 'SFD*']);

%%
filelist = {filelist.name}';
flistchar = char(filelist);
%dstr = flistchar(:,15:end-5);
dstr = flistchar(:,10:end-5)
mdate = datenum(dstr);
[~,s] = sort(mdate);

filelist = filelist(s);

SynConc = [];
SynCount = [];
SynYcv = [];
EukConc = SynConc;
EukCount = [];
EukYcv = [];
fcsfile_syn = SynConc;
fcsfile_euk = SynConc;
for count = 1:length(filelist)
    disp(filelist(count))
    itable = importfile([fpath filelist{count}]);
    ii = strmatch( 'Syn', itable.Gate);
    sample = itable.Sample(ii); 
    a = ~isnan(sample);clc
    ii = ii(a);
    SynConc = [SynConc; itable.Concentration(ii)];
    SynCount = [SynCount; itable.Count(ii)];
    SynYcv = [SynYcv; itable.YCV(ii)];
    exp = itable.Experiment(ii);
    sample = itable.Sample(ii); 
    temp = cellstr([char(exp) repmat('_Group_day0_Sample(', length(exp),1) num2str(sample) repmat(').fcs', length(exp),1)]);
    temp = regexprep(temp, '( ', '(');
    temp = regexprep(temp, '( ', '(');
    fcsfile_syn = [fcsfile_syn; temp]; clear temp 
    ii = strmatch( 'Euk', itable.Gate);
    sample = itable.Sample(ii); 
    a = ~isnan(sample);
    ii = ii(a);
    EukConc = [EukConc; itable.Concentration(ii)]; 
    EukCount = [EukCount; itable.Count(ii)];
    EukYcv = [EukYcv; itable.YCV(ii)];
    exp = itable.Experiment(ii);
    sample = itable.Sample(ii); 
    temp = cellstr([char(exp) repmat('_Group_day0_Sample(', length(exp),1) num2str(sample) repmat(').fcs', length(exp),1)]);
    temp = regexprep(temp, '( ', '(');
    temp = regexprep(temp, '( ', '(');
    temp = regexprep(temp, '(NaN)', '');
    fcsfile_euk = [fcsfile_euk; temp]; clear temp 
    %FileSampleCount(count) = length(ii);
end

save([outpath 'compiled_stats'], 'fcsfile*', 'SynConc', 'EukConc','SynCount','SynYcv', 'EukCount','EukYcv');

%return
figure
plot(SynConc*1000, '.-')
hold on
plot(EukConc*1000, '.-')
xlim([0 2563])
ylabel('Cell concentration (ml^{-1})')
%xlabel('2-minute sample resolution, 31-Jan to 5-Feb 2018')
xlabel('2-minute sample resolution, 16-Apr to 29-Apr 2018')
lh = legend('\itSynechococcus', 'Small eukaryotes', 'location', 'northwest');
%title('onshore              \leftarrow                     offshore            \rightarrow                    onshore')
set(lh, 'fontsize', 14)