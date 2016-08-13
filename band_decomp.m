function [ output,total_elems,k,r ] = band_decomp( input_file_or_matrix, read_k_r_from_file, write_parameters, output_file, k , r)
%Band Matrix DeCompression
%  Input Parameters
%    input_file_or_matrix   - Input Matrix or File Name
%    read_write_k_r_from_file(logical)
%                          - Read & write k and r from and to file 
%   output_file            -Output File name, optional
%  Output Parameters
%    output - Output Compressed Matrix
%    total_elems - Total elements
%    k,r - Same as before

%% Checking if file name or a Matrix
% If matrix is not square then file name is provided
if(size(input_file_or_matrix, 1) == 1)
    A = dlmread(input_file_or_matrix);
else
   A = input_file_or_matrix;
end

% if(~exist('output_file', 'var'))
%     output_file = 'band_decomp.txt';
% elseif(isempty(output_file))
%     output_file = 'band_decomp.txt';
% end

if(islogical(read_k_r_from_file) && read_k_r_from_file) % Read from file
    k = A(1,1);
    r = A(1,2);
    total_elems = A(1,3);
    A = A(2:end,:);
    row = size(A,1);
elseif(~exist('k','var')  || ~exist('r','var')) % Auto Detect K, R
    row = size(A,1);
    k = 0; r = 0, row_max_elem = 0;
    for i = 1:size(A,1)
        temp_find = find(A(i,:), 1, 'last');
        val=temp_find - i;
        if(~isempty(val))
            k = max(val,k);
            row_max_elem = max(temp_find, row_max_elem);
        end
    end
    r = row_max_elem - k - 1;
    %k = numel(A(1,:)) - 1;
    %r = numel(A(end,:)) - 1;
    %k = find(A(1,:), 1, 'last') - 1;
    %r = find(A(:,end), 1, 'first') - 1;
    total_elems = (k*r + r*(r+1)/2 + (k+r+1)*(row - r) - k*(k+1)/2);
end % Otherwise K,R is given
output = zeros(row, row);

for i = 1:r+1
    a = A(i,1:min(k+i,row));
    output(i,1:max(size(a))) = a;
end

skip = 2;
for i = r+2:row-k
    a = A(i, :);
    output(i, skip:min(skip+k+r, row)) = a;
    skip = skip+1;
end
for i = row-k+1:row
    a = A(i, 1:min(row-skip+1, row));
    output(i, skip:end) = a;
    skip = skip + 1;
end

  if(exist('output_file', 'var'))
    if(~isempty(output_file))
        %% Delete existing file
        if(exist(output_file,'file'))
           delete(output_file);
        end
        %% Write values
        if(islogical(write_parameters) && write_parameters)
            dlmwrite(output_file,[k r],'delimiter', ',', 'precision', 6);
        end
        dlmwrite(output_file, output, 'delimiter', ',', 'precision', 6, '-append');
        display(strcat('Decompressed File: ', output_file));
    end
end
display(' ');
end

