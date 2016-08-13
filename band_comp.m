function [ output,total_elems,k,r ] = band_comp( input_file_or_matrix, read_k_r_from_file, write_params_to_file, output_file, k, r )
%Band Matrix Compression
%  Input Parameters
%    input_file_or_matrix       - Input Matrix or File Name
%    read_k_r_from_file(logical)- Read values of k and r from file
%    write_params_to_file(logical)-Write parameters k and r to file
%    k - Value of k (Optional)
%    r - Value of r (Optional)
%  Output Parameters
%    output - Output Compressed Matrix
%    total_elems - Total elements
%    k,r - Same as before

%% Checking if file name or a Matrix
% If matrix is not square then file name is provided
if(size(input_file_or_matrix, 1) == 1)
    A = dlmread(input_file_or_matrix);
    display(sprintf('Band Matrix Compression, input file: %s', input_file_or_matrix));
else
    A = input_file_or_matrix;
    display(sprintf('Band Matrix Compression, given input Matrix'));
end

if(~exist('output_file','var'))
    output_file = 'band_comp.txt';
end

%% Auto Detect K and R from non-zero values
if(islogical(read_k_r_from_file) && read_k_r_from_file) % Read from file
    k = A(1,1);
    r = A(1,2);
    A = A(2:end,:); %% Skip the first line as it contains k,r
elseif(~exist('k','var')  || ~exist('r','var')) % Auto Detect K, R
    %%Dr Aslan Edit-> Check every row for perfect k, check every colm for
    %%perfect r
    [k r] = detect_k_r(A);
    %OLD Auto detection code, which considers only first row
    %k = find(A(1,:), 1, 'last') - 1;
    %r = find(A(:,1), 1, 'last') - 1;
end % Otherwise K,R is given

%% Delete existing file
if(exist(output_file,'file'))
           delete(output_file);
end


%% Write K, R and Total Elements to output file
[row, colm] = size(A);
total_elems = (k*r + r*(r+1)/2 + (k+r+1)*(row - r) - k*(k+1)/2);
if(write_params_to_file)
    dlmwrite(output_file, [k r total_elems], 'delimiter', ',', 'precision', 6);
end

for i = 1:r+1
    a = A(i,1:min(k+i,row));
    dlmwrite(output_file, a, 'delimiter', ',', 'precision', 6, '-append');
end
skip = 2;
for i = r+2:row-k
    a = A(i, skip:min(skip+k+r,row));
    dlmwrite(output_file, a, 'delimiter', ',', 'precision', 6, '-append');
    skip = skip+1;
end

%for i = row-k+1:row
for i = max(r+2,row-k+1):row
    a = A(i, skip:end);
    dlmwrite(output_file, a, 'delimiter', ',', 'precision', 6, '-append');
    skip = skip + 1;
end

display(strcat('Compressed File: ', output_file));
display(' ');
output = dlmread(output_file);
end
