load_paths_to_msd;
% % 
% % 
% % % 
get_songs('motown_artists.txt', 'motown_songs.txt', sqldb);
get_songs('stax_artists.txt', 'stax_songs.txt', sqldb);
get_songs('chess_artists.txt', 'chess_songs.txt', sqldb);
get_songs('fame_artists.txt', 'fame_songs.txt', sqldb);
get_songs('atlantic_artists.txt', 'atlantic_songs.txt', sqldb);
% get_songs('rca_artists.txt', 'rca_songs.txt', sqldb);

motown_raw = extract_features('motown_songs.txt', 1, 1959, 1971);
stax_raw = extract_features('stax_songs.txt', 2, 1959, 1971);
chess_raw = extract_features('chess_songs.txt', 3, 1957, 1967);
fame_raw = extract_features('fame_songs.txt', 4, 1963, 1971);
atlantic_raw = extract_features('atlantic_songs.txt', 5);
% rca_raw = extract_features('rca_songs.txt', 6);

motown = remove_duplicates(motown_raw);
stax = remove_duplicates(stax_raw);
chess = remove_duplicates(chess_raw);
fame = remove_duplicates(fame_raw);
atlantic = remove_duplicates(atlantic_raw);
% rca = remove_duplicates(rca_raw);

rng('shuffle');
% m = randperm(70);

song_set = [motown, stax, chess, fame, atlantic];%, rca];

%% TIMBRAL FEATURES
song_count = size(song_set,2);
% extracts the number of mfcc segments in each song, then takes the min
a = zeros(1,song_count);
for n = 1:song_count
    a(n) = size(song_set(n).segments_timbre,2);
end
num_frames = min(a);
% Bring all mfcc matrices to a uniform size from middle-out
% Result is a (12*num_frames) X (number of songs) matrix, each column
% representing all the desired mfcc's for 1 song
for n = 1:song_count
    clear mfcc_temp;
    clear mfcc_reduced;
    mfcc_temp = song_set(n).segments_timbre;
    midpoint = ceil(size(mfcc_temp,2)/2);
    mfcc_reduced = mfcc_temp(:,midpoint-floor(num_frames/2)+1:midpoint+floor(num_frames/2));
    mfcc_mean(:,n) = mean(mfcc_reduced, 2);
    mfcc_std(:,n) = std(mfcc_reduced');
    
end

%% CHROMA FEATURES
for n = 1:song_count
    
    clear chroma_temp;
    clear chroma_sorted;
    
    chroma_temp = song_set(n).segments_pitches;     % Gets chroma feature from song_set object as a temp variable for ease of use
    
    key(n) = song_set(n).key + 1;                          % Get key center, bring to MATLAB index range such that C = 1
    for k = 1:12
        j = mod(key(n)+k-1,12);
        if j==0
            j = 12;
        end
        chroma_sorted(k,:) = chroma_temp(j,:); % Rearrange chroma order so that key center = index 1
    end
    
    
    
    [cval, cidx] = max(chroma_sorted);
 

    clear chr_dif;
    clear cdix;
    clear cval;

    for k = 1:size(cidx,2)-1
        chr_dif(k) = cidx(k+1)-cidx(k); % mod(abs(cidx(k+1)-cidx(k)),12);   % Interval (without direction) between each set of adjoining notes, reduced to within 1 octave
    end

    clear chroma_matrix;
    chroma_matrix = zeros(12,23);

    k=size(chr_dif,2);  % row (cidx) = starting pitch, column (chr_dif) = interval moved to, number in cell = number of occurrances of that pitch moving to that interval
    for m = 1:k
        chroma_matrix(cidx(m), chr_dif(m)+12)  = chroma_matrix(cidx(m), chr_dif(m)+12)+1; % chr_dif has to be upped by 1 because it starts with 0 (no change)
    end
    
    j = 1;
    for i = 1:12
        chroma_change_long(j:j+11,n) = chroma_matrix(:,i); % Multiplying by chroma() weights the change in chroma by the frequency with which the starting pitch occurs
        j = j+12;
    end
    
    pitch_margin(:,n) = sum(chroma_matrix, 2);       % Marginal distribution of pitch classes
    interval_margin(:,n) = sum(chroma_matrix, 1)';    % Marginal distribution of intervals
    
end



%% DYNAMICS FEATURES
for n = 1:song_count
    max_loud = song_set(n).segments_loudness_max;
    onset_loud = song_set(n).segments_loudness_start;
    segment_range = max_loud - onset_loud;
    segment_histogram(:,n) = hist(segment_range, 16);
    dynamic_mean(n) = mean(segment_range);
    dynamic_variance(n) = std(segment_range);
    max_rms(n) = rms(max_loud);
    onset_rms(n) = rms(onset_loud);
end

%% TEMPO AND KEY FEATURES

for n = 1:song_count
    seconds_per_beat(n) = 60/song_set(n).tempo;
    pocket(n) = mean(song_set(n).segments_loudness_max_time)/seconds_per_beat(n);
    tightness(n) = var(song_set(n).segments_loudness_max_time)/seconds_per_beat(n);
    
    qual(n) = song_set(n).mode;                        % 0 = minor, 1 = major
end

create_data_new;