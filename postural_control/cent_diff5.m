function [ xp ] = cent_diff5( x, dt )
%CENT_DIFF3 Numerical approximation of the derivative of x via a
%three-point central difference which provides fourth order accuracy (i.e.,
%truncation errors on the order of dt^4). Derivatives of the first and last
%data points are estimated using front_diff and back_diff, respectively. A
%three-point central difference is used to estimate xp at the second and
%second-to-last points.
%
% ARGUMENTS
% x - Vector or matrix containing numerical data. If x is a matrix
% differentation operates along the vertical dimensions (i.e., each column
% is differentiated).
% 
% dt - Unit change in time between samples (assumed constant).
%
% RETURNS
% xp - First-order derivative of x with respect to time. If x is an m x n
% vector or matrix, xp will have a size of m x n.
%
%=========================================================================%

[ r, c ] = size(x); %determine the size of x

xp = zeros(r, c); %create empty matrix for the derivative values

%for each column
for i = 1:c
    
    %for each row
    for j = 1:r
        
        if j == 1 %if at the first data point take a forward difference
            
            xp(j,i) = (x(j+1,i)-x(j,i)) / dt;
            
        %if at the second or second to last data point calculate three point
        %central difference    
        elseif j == 2 || j == r-1
            
            xp(j,i) = (x(j+1,i) - x(j-1,i)) / (2*dt); 
       
        %if at the last data point take a backward difference    
        elseif j == r 
            
            xp(j,i) = (x(j,i) - x(j-1,i)) / dt;
            
        else
                
            xp(j,i) = (x(j-2,i) - 8*x(j-1,i) + 8*x(j+1,i) - x(j+2,i)) / (12*dt); %calculate five point central difference
            
        end %end if
        
    end %end row
    
end %end column

end %end function