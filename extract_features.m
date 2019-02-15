% Gets the song hash codes listed in text_file and returns an object
% (label) of requested features.
% If min_year and max_year are provided, features are only extracted for
% songs year labels within the appropriate range of time.

function studio = extract_features(text_file, response, min_year, max_year)
fid = fopen(text_file);
n = 1;
while(~feof(fid))
    track = fgetl(fid);
    h5 = HDF5_Song_File_Reader([track, '.h5']);
    if(nargin == 4)
        eval = h5.get_year >= min_year && h5.get_year <= max_year;
    else
        eval = 1;
    end
    
    if(eval)
        studio(n).label = response;
        studio(n).track_id = h5.get_track_id;
        studio(n).title = h5.get_title;
        studio(n).artist = h5.get_artist_name;
        studio(n).year = h5.get_year;
        studio(n).artist_location = h5.get_artist_location;
        studio(n).tempo = h5.get_tempo;
        studio(n).key = h5.get_key;
        studio(n).mode = h5.get_mode;
        studio(n).segments_pitches = h5.get_segments_pitches; % Chroma features
        studio(n).tatums_start = h5.get_tatums_start;
        studio(n).bars_start = h5.get_bars_start;
        studio(n).segments_start = h5.get_segments_start;
        studio(n).segments_loudness_max = h5.get_segments_loudness_max; % Max dB per segment
        studio(n).segments_loudness_start = h5.get_segments_loudness_start; % dB value at onset
        studio(n).segments_loudness_max_time = h5.get_segments_loudness_max_time; % Time of max dB value in segment
        studio(n).segments_timbre = h5.get_segments_timbre;
        n = n+1;
    end
end
fclose(fid);
end