function [ A, total_non_zero, Non_Zero_Percent ] = band_create2( n_k_r_density, creation_mode, input_file_name, randomize_values, write_parameters, output_file )

%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%n=20;k=4;r=1;

n=n_k_r_density(1);
k = n_k_r_density(2);
r = n_k_r_density(3);
density=n_k_r_density(4);

if(strcmp(creation_mode, 'sparse_gen') == 1)
    ASparse = sprandn(n,n,density)*1000;
    [A,k,r] = sparse_matrix_to_band(ASparse);
elseif(strcmp(creation_mode, 'sparse_input') == 1)
    ASparse = dlmread(input_file_name);
    n = size(ASparse,1);
    [A,k,r] = sparse_matrix_to_band(ASparse);
elseif(strcmp(creation_mode, 'band_gen') == 1)
    if(islogical(randomize_values) && randomize_values)
    %% Randomized values
        A = randomized_band_matrix(n , k , r);
    else
    %% Fixed Values
        A = fixed_value_band_matrix(n , k , r);
    end
end

A=A(1:n,1:n);
display(sprintf('Create Matrix with parameters n=%d,k=%d,r=%d', n, k, r));

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
        dlmwrite(output_file, A, 'delimiter', ',', 'precision', 6, '-append');
        display(strcat('File Created: ', output_file))
    end
end
syms i
%total_non_zero=symsum(r+k-i,i,0,r-1)+symsum(r+k-i,i,0,k-1)+(n-k-r)*(k+r+1);
%%Zero=n^2-NonZero
%Non_Zero_Percent=100*vpa((total_non_zero)/n^2);
%display(sprintf('Total Non-zero Memory Elements: %d\nSize in KB(4 Byte/MemElem):%.2f KB', total_non_zero, total_non_zero * 4/1024));
%display(sprintf('Location representation Size in KB(4 Byte/MemElem):%.2f KB', total_non_zero *3* 4/1024));
%display(' ');
end

function [Aout,k,r] = sparse_matrix_to_band(As)
    p = symrcm(As);
    Ar = As(p,p);
    Aout = double(int32(full(Ar)));
    
    [k,r] = detect_k_r(Aout);
end

function [Aout,k,r] = sparse_matrix_read(n, density)
    As = sprandn(n,n,density);
    p = symrcm(As);
    Ar = As(p,p);
    Aout = double(int32(full(Ar)*1000));
    
    [k,r] = detect_k_r(Aout);
end

function Aout = randomized_band_matrix(n, k , r)
    Aout=zeros(n,n);
    for i=1:n
        Aout(i,i)=int32(rand()*1000);
    end
    for i=1:(n)
        for j=1:k
          Aout(i,i+j)=int32(rand()*1000);
        end
    end
    for i=1:(n)
        for j=1:r
          Aout(i+j,i)=int32(rand()*1000);
        end
    end
end

function Aout = fixed_value_band_matrix(n,k,r)
    Aout=zeros(n,n);
    for i=1:n
        Aout(i,i)=1;
    end
    for i=1:(n)
        for j=1:k
          Aout(i,i+j)=2;
        end
    end
    for i=1:(n)
        for j=1:r
          Aout(i+j,i)=3;
        end
    end
end