% Assembles feature matrix - each column represents 1 song
% Be sure to run prepare_features first

clear all_data;
song_count = size(song_set,2);
% vector_length = size(mfcc,1)+size(chroma,1)+size(chroma_change,1)+4;
vector_length = size(mfcc,1)+size(chroma,1)+7+size(chroma_change,1);
all_data = zeros(vector_length, song_count);

for n=1:song_count
    all_data(1,n) = song_set(n).label;
    all_data(2,n) = song_set(n).tempo;
    [b, a] = max(hist(song_set(n).segments_loudness_max_time,100));
    all_data(3,n) = a;
    all_data(4,n) = song_set(n).key;
    all_data(5,n) = dynamic_variance(n);
    all_data(6,n) = 0; %dynamic_range(n);
    all_data(7:18,n) = chroma(:,n);
    all_data(19:30,n) = mfcc(:,n);
    all_data(31,n) = 0;
    all_data(32:end,n) = chroma_change(:,n);
    
end

% Determine training/testing split sizes
training_set_size = round(song_count * 0.8);
testing_set_size = song_count-training_set_size;

% Generate vectors of randomized index numbers
idx = 1:song_count;
idx_rand = idx(randperm(length(idx)));
training_idx = idx_rand(1:training_set_size);
testing_idx = idx_rand(training_set_size+1:end);

% Pre-allocate training and testing matrices
training_data = zeros(vector_length, training_set_size);
testing_data = zeros(vector_length-1, testing_set_size);
%testing_label = zeros(testing_set_size,1);

% Training Data
for n=1:training_set_size
    training_data(:,n) = all_data(:,training_idx(n));
end

clear training_label;
for n=1:training_set_size 
    training_label(n).title = song_set(training_idx(n)).title;
    training_label(n).artist = song_set(training_idx(n)).artist;
    training_label(n).year = song_set(training_idx(n)).year;
    training_label(n).ground_truth = all_data(1,training_idx(n));
    %training_data(:,n) = all_data(2:end,training_idx(n));
end

 clear testing_label;
% Testing Data
for n=1:testing_set_size 
    testing_label(n).title = song_set(testing_idx(n)).title;
    testing_label(n).artist = song_set(testing_idx(n)).artist;
    testing_label(n).year = song_set(testing_idx(n)).year;
    testing_label(n).ground_truth = all_data(1,testing_idx(n));
    testing_data(:,n) = all_data(2:end,testing_idx(n));
end