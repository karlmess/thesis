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
% Chroma features are floored to reduce the matrix to only the most
% strongly predicted pitch
% Amount of each chroma predicted are summed, then normalized to a range of
% 0 to 1

for n = 1:song_count
    mfcc_temp = song_set(n).segments_timbre;
    midpoint = ceil(size(mfcc_temp,2)/2);
    mfcc_reduced = mfcc_temp(:,midpoint-floor(num_frames/2)+1:midpoint+floor(num_frames/2));
    mfcc(:,n) = median(mfcc_reduced, 2);
    
    
    %% Processing of Chroma Features
    
    chroma_temp = song_set(n).segments_pitches;     % Gets chroma feature from song_set object as a temp variable for ease of use
    chroma_floored = floor(chroma_temp);            % Zeros out all but the strongest detected pitch
    chroma_unsorted(:,n) = sum(chroma_floored,2);   % Counts the number of segments in which each pitch appears for the entire song 
    key = song_set(n).key;                          % Get key center
    %[cval, cidx] = max(chroma_floored);             
    for k = 1:12
        chroma(k,n) = chroma_unsorted(mod(key+k-1,12)+1,n); % Rearrange chroma order so that key center = index 1
    end
    chroma(:,n) = chroma(:,n)/max(chroma(:,n));     % Normalize chroma count so that most common occurrence = 1
    
    
    [cval, cidx] = max(chroma_floored);             % Finds index of the max chroma in each column; result is a vector of the strongest detected pitches by segment in absolute terms (C = 1)
%    cdiff = zeros(size(cidx,2)-1,2);
    cdif = zeros(size(cidx,2)-1,1);                 % Initialize cdif vector
    for k = 1:size(cidx,2)-1
%         cdiff(k,1) = cidx(k+1)-cidx(k);
%         cdiff(k,2) = mod(cdiff(k,1),12);
        cdif(k) = mod(abs(cidx(k+1)-cidx(k)),12);   % Interval (without direction) between each set of adjoining notes, reduced to within 1 octave
    end
%     temp_chroma_change = hist(cdiff(:,2),0:11)';
    temp_chroma_change = hist(cdif,0:11)';          % Uses a 12 bin histogram to count the number of times each interval occurs
    m = mod(6:7:84,12)+1;                           % Maps out the chromatic scale as a circle of 5ths with the tonic at 7, 5th at 8, 4th at 6, etc.
                                                    % Idea is to mimic
                                                    % something close to a
                                                    % normal distribution,
                                                    % reasoning that the
                                                    % root occurs most, 5th
                                                    % and 4th second most,
                                                    % etc. Deviation from
                                                    % the normal
                                                    % distribution may be
                                                    % more detectable?
    l = (1:12);
    chroma_change(l,n) = temp_chroma_change(m);     % Chroma change values are stored
    %chroma_change(:,n) = temp_chroma_change(2:end);
    chroma_change(:,n) = chroma_change(:,n)/max(chroma_change(:,n));    % Normalize so that strongest occurring interval is 1
%%
    max_loud = song_set(n).segments_loudness_max;
    onset_loud = song_set(n).segments_loudness_start;
    segment_range = max_loud - onset_loud;
    dynamic_variance(n) = var(segment_range);
    dynamic_range(n) = max(max_loud(10:end-10)) - min(max_loud(10:end-10));
    
%% Create Chroma Change Matrix and Vectorize
%   Block this out if it proves ineffective!

    build_chroma_matrix;
    j = 1;
    for i = 1:12
        chroma_change_long(j:j+11,n) = chroma_matrix(:,i); % .* chroma(:,n);   % Multiplying by chroma() weights the change in chroma by the frequency with which the starting pitch occurs
        j = j+12;
    end

    
end