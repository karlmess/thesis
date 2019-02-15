load_paths_to_msd;
get_songs('motown_artists.txt', 'motown_songs.txt', sqldb);
get_songs('stax_artists.txt', 'stax_songs.txt', sqldb);
get_songs('fame_artists.txt', 'fame_songs.txt', sqldb);
get_songs('chess_artists.txt', 'chess_songs.txt', sqldb);
%get_songs('abbeyroad_artists.txt', 'abbeyroad_songs.txt', sqldb);
%get_songs('control_group_artists.txt', 'control_songs.txt', sqldb);
motown_raw = extract_features('motown_songs.txt', 1, 1959, 1971);
% motown_late = extract_features('motown_songs.txt', 2, 1965, 1971);
stax_raw = extract_features('stax_songs.txt', 2, 1959, 1971);
% stax_late = extract_features('stax_songs.txt', 4, 1964, 1971);
fame_raw = extract_features('fame_songs.txt', 3, 1966, 1971);
chess_raw = extract_features('chess_songs.txt', 3, 1956, 1965);
%abbeyroad = extract_features('abbeyroad_songs.txt', 5, 1960, 1970);
%control = extract_features('control_songs.txt', 0, 1980, 1989);

motown = remove_duplicates(motown_raw);
stax = remove_duplicates(stax_raw);
fame = remove_duplicates(fame_raw);
chess = remove_duplicates(chess_raw);

song_set = [motown, stax, fame, chess]; %, abbeyroad, control];
prepare_features;
create_data;

% samples_per_label = min([size(motown_early,2), size(motown_late,2), size(stax_early,2), size(stax_late,2)]);
% song_set = [motown_early(1:samples_per_label), motown_late(1:samples_per_label), stax_early(1:samples_per_label), stax_late(1:samples_per_label)];
% prepare_features;
% create_data;