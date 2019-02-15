% Reads from a pre-determined list of artists in infile, queries the
% dataset for all songs by each artist and saves the hash codes in outfile
%
% infile    : list of artists found in the database who are identified as
%           having recorded exclusively with that label during the time period in
%           question
% outfile   : file to contain the hash codes for the songs located by
%           artists in infile
% sqldb     : the database to queried 

function get_songs(infile, outfile, sqldb)
    inFID = fopen(infile,'r');
    outFID = fopen(outfile,'w');
    while(~feof(inFID))
        artist = fgetl(inFID);
        start_year = fgetl(inFID);
        end_year = fgetl(inFID);
        mksqlite('open',sqldb);
        result = mksqlite(['SELECT song_id, track_id FROM songs WHERE artist_name = ''', artist, ''' AND year >= ' num2str(start_year) ' AND year <= ' num2str(end_year)]);
        mksqlite('close');
        for n=1:length(result)
            fprintf(outFID, '%s\n', result(n).track_id);
        end
    end
    fclose(inFID);
    fclose(outFID);
end