% Select all artists from songs recorded between 1949 and 1960
% Artists from the studios to be studied are identified by examination and 
% manually saved to a .txt file
% 2017/12/30

start_year = 1959;
end_year = 1970;
mksqlite('open',sqldb);
fifties = mksqlite(['SELECT DISTINCT artist_name FROM songs WHERE year >= ' num2str(start_year) ' AND year <= ' num2str(end_year)]);
mksqlite('close');

fileID = fopen('artists.txt','w');
for n=1:length(fifties)
    fprintf(fileID,'%s\n',fifties(n).artist_name);
end
fclose(fileID);