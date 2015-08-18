function [data] = load_file(filename, format_spec)
% Read formatted data from text file 

    file_ID = fopen(filename);
    data = textscan(file_ID, format_spec);
    fclose(file_ID);

end

