function copy_dependencies_to_folder(fList, path)
for n = 1:numel(fList)
    filename = fList{n};
    %[pathstr,name,ext] = fileparts(filename);
    copyfile(filename, path);
end