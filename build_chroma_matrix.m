[cval, cidx] = max(chroma_floored);
% cidx represents pitch class detected

note = 1:12;

clear chr_dif;
clear cdix;
clear cval;


for k = 1:size(cidx,2)-1
    chr_dif(k) = mod(abs(cidx(k+1)-cidx(k)),12);   % Interval (without direction) between each set of adjoining notes, reduced to within 1 octave
end

clear chroma_matrix;
chroma_matrix = zeros(12,12);

k=size(chr_dif,2);  % row (cidx) = starting pitch, column (chr_dif) = interval moved to, number in cell = number of occurrances of that pitch moving to that interval
for m = 1:k
    chroma_matrix(cidx(m), chr_dif(m)+1)  = chroma_matrix(cidx(m), chr_dif(m)+1)+1; % chr_dif has to be upped by 1 because it starts with 0 (no change)
end