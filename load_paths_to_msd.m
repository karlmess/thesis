cd /Volumes/audio_drive/THESIS
build = 0; % Set to 1 to build MEX files

%% Code below taken from https://labrosa.ee.columbia.edu/millionsong/pages/matlab-introduction

% add mksqlite to the path
addpath(genpath('mksqlite'));
%addpath(genpath('MSD'));

% set up Million Song paths
global MillionSong
MillionSong ='MSD';  % or 'MillionSong' for full set
msd_data_path=[MillionSong,'/data'];
msd_addf_path=[MillionSong,'/AdditionalFiles'];
MSDsubset=''; % or '' for full set
msd_addf_prefix=[msd_addf_path,'/',MSDsubset];
% Check that we can actually read the dataset
assert(exist(msd_data_path,'dir')==7,['msd_data_path ',msd_data_path,' is not found.']);

% path to the Million Song Dataset code
msd_code_path='MSongsDB';
assert(exist(msd_code_path,'dir')==7,['msd_code_path ',msd_code_path,' is wrong.']);
% add to the path
addpath([msd_code_path,'/MatlabSrc']);

sqldb = [msd_addf_prefix,'track_metadata.db'];

% Build MEX files
if(build)
    cd mksqlite
    buildit
    cd ..
end

%% Adds all MSD folders to the path, necessary for finding songs quickly
% This does take about 120 seconds to run so keep it to a minimum.
full_path = genpath(msd_data_path);
addpath(full_path);