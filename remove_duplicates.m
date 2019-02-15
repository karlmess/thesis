function studio = remove_duplicates(raw_data)
    a = {raw_data(1:end).title};
    [title,id] = unique(a);
    studio = raw_data(id);
end