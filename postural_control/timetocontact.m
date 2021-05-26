function [ ttc, bound_ttc, bound_perc ] = timetocontact( p_x, p_y, dt, bounds, method, labels )
%TTC Calculates Time-to-Contact (tau)
%
% ARGUMENTS
% p_x - ML position of the center-of-pressure or center-of-mass
%
% p_y - AP position of the center-of-pressure or center-of-mass
%
% dt - Unit change in time between samples (1/sampling rate)
%
% bounds - Matrix of boundary coordinates (x in the first column, y in the
% second). Boundary coordinates should be entered in ordered clockwise, but
% need not begin with any particular boundary. If there are n boundary points (and
% therefore n boundaries) this matrix should be size n x 2.
%
% method - Determines the method for estimating tau. Slobounov (method 2) is the
% default.
%
%     Method 1 (Riccio)
%     Linear Equation:
%     C * tau + D = 0
%     where tau = virtual time-to-contact
%       C = [v_y(t) - m_bound * v_x(t)]
%       D = [(p_y(t) - y_bound) - m_bound * (p_x(t) - x_bound)]
%     
%     Method 2 (Slobounov)
%     Quadratic Equation:
%     B * tau^2 + C * tau + D = 0
%     where tau = virtual time-to-contact
%       B = [a_y(t) - m_bound * a_x(t)] / 2
%       C = [v_y(t) - m_bound * v_x(t)]
%       D = [(p_y(t) - y_bound) - m_bound * (p_x(t) - x_bound)]
%     
%     Method 3 (Jerk)
%     Quadratic Equation:
%     A * tau^3 + B * tau^2 + C * tau + D = 0
%     where tau = virtual time-to-contact
%       A = [j_y(t) - m_bound * j_x(t)] / 3
%       B = [a_y(t) - m_bound * a_x(t)] / 2
%       C = [v_y(t) - m_bound * v_x(t)]
%       D = [(p_y(t) - y_bound) - m_bound * (p_x(t) - x_bound)]
%
% labels - Cell array containing labels for the boundary variables. These labels are not
% required. If not provided as an argument the boundaries will simply be
% numbered. However, the labels can be useful for troubleshooting and
% debugging.
%
%RETURNS
% ttc - Time series of minimum Time-to-Contact in seconds. Minimum TtC is
% determined by taking smallest of the positive, real roots to the
% polynomial equations corresponding to the time it would take the
% extrapolated CoP/CoM trajectory to reach a boundary based on the
% instanteous position, velocity, and potentially higher-order derivatives.
%
% bound_ttc - Minimum Time-to-Contact values for each boundary. The minimum
% of the positive, real roots for each point in time is selected. If no
% positive, real roots exist a value of NaN is returned.
%
% bound_perc - Calculates the percentage of virtual contacts to each
% boundary. Uses the ttc_bound_perc function.
%
% ========================================================================%

%Housekeeping ============================================================%

%ensure at least the first four arguments are provided
if nargin < 4 
    disp('Error: Estimating TtC requires a minimum of both components of the CoP/CoM, dt, and boundary positions.');
    return;
end

%if method and labels are not provided
if nargin == 4
    method = 1; %use Slobounov method
    labels = num2cell(1:length(bounds)); %labels are numbered 
end

%if only labels are not provided
if nargin == 5
    labels = num2cell(1:length(bounds)); %labels are numbered
end

n_frames = length(p_x); %length of time series

%Estimate Higher Order Derivatives =======================================%

%For Riccio, Slobounov, and Jerk Methods
v_x = cent_diff5(p_x, dt); %ML velocity
v_y = cent_diff5(p_y, dt); %AP velocity

%For Slobounov or Jerk Methods
a_x = cent_diff5(v_x, dt); %ML acceleration
a_y = cent_diff5(v_y, dt); %AP acceleration

%For Jerk Method
j_x = cent_diff5(a_x, dt); %#ok<NASGU> %ML jerk 
j_y = cent_diff5(a_y, dt); %#ok<NASGU> %AP jerk

% TIME TO CONTACT ========================================================%

%Define Slopes and Points for each Boundary, polynomial coefficients (A,B,C,D),
%and initialize TtC variables

[b_n, ~] = size(bounds); %determine number of boundaries

%for each boundary
for i = 1:b_n
    
    %determine boundary slope based on current landmark
    if i == 1
        eval([labels{i} ' = (bounds(b_n,2) - bounds(i,2)) / ( bounds(b_n,1) - bounds(i,1));']); %use first and last boundary point
    else
        eval([labels{i} ' = (bounds(i-1,2) - bounds(i,2)) / ( bounds(i-1,1) - bounds(i,1));']); %use ith and i-1th (adjacent) boundary point
    end
    eval(['x_' labels{i} ' = bounds(i,1);']); %boundary x position
    eval(['y_' labels{i} ' = bounds(i,2);']); %boundary y position
    
    %if boundary line is vertical (i.e., slope = inf) set slope to large number
    if (eval(labels{i}) == inf)
        eval([labels{i} ' = 1e16;']);
    end
    
    %determine polynomial coefficients
    eval(['A_' labels{i} ' = (j_y - ' labels{i} ' .* j_x) / 3;']); %A coefficients
    eval(['B_' labels{i} ' = (a_y - ' labels{i} ' .* a_x) / 2;']); %B coefficients
    eval(['C_' labels{i} ' = (v_y - ' labels{i} ' .* v_x);']); %C coefficients
    eval(['D_' labels{i} ' = ((p_y - y_' labels{i} ') - ' labels{i} ' .* (p_x - x_' labels{i} '));']); %D coefficients
    
    %set unnecessary coefficients to 0 (A not needed for method 2, A & B
    %not needed for method 1)
    if method == 1 %set A and B to 0
        eval(['A_' labels{i} ' = zeros(size(A_' labels{i} '));']);
        eval(['B_' labels{i} ' = zeros(size(B_' labels{i} '));']);
    elseif method == 2 %set A to 0
        eval(['A_' labels{i} ' = zeros(size(A_' labels{i} '));']);
    end
    
    %create polynomial matrix
    eval(['p_' labels{i} ' = [ A_' labels{i} ' B_' labels{i} ' C_' labels{i} ' D_' labels{i} ' ];']);
    
    %create root matrix
    eval(['r_' labels{i} '  = zeros(n_frames, ' num2str(method) ');']);
    
    %create boundary TtC vector
    eval(['ttc_' labels{i} '  = zeros(n_frames,1);']);
    
end %end boundary

clear i;

%create TtC vector
ttc = zeros(n_frames,1);

%create boundary TtC matrix
bound_ttc = zeros(n_frames,b_n);

%create boundary crossing vector
bound_cross = zeros(n_frames, 1);

%create matrix for all boundary roots
rts = zeros(n_frames, b_n*method);

%Estimate TtC ============================================================%

%for each time point
for t = 1:n_frames
      
    %for each boundary
    for i = 1:b_n
        
        %find roots for boundary
        eval(['r_' labels{i} '(t,:)  = roots( p_' labels{i} '(t,:) );']);
        
        %add roots to full matrix
        rts(t, (method*i-(method-1)):method*i ) = eval(['r_' labels{i} '(t,:)']);
        
        %find roots greater than 0 and set imaginary roots to zero
        eval(['ind_' labels{i} ' = find(r_' labels{i} '(t,:)  >= 0 & imag(r_' labels{i} '(t,:))  == 0 );']);
        
        %calculate minimum TtC for boundary
        if isempty(eval(['ind_' labels{i}]))
            eval(['ttc_' labels{i} '(t,1) = NaN;']);
        else
            eval(['ttc_' labels{i} '(t,1) = min(r_' labels{i} '(t,ind_' labels{i} '));']);
        end
        
        %add boundary TtC to matrix
        bound_ttc(t,i) = eval(['ttc_' labels{i} '(t,1);']);
        
        %if TtC to all boundaries has been assessed
        if i == b_n
             
            %find all roots greater than 0 and set imaginary roots to 0
            ind = find(rts(t,:)  >= 0 & imag(rts(t,:))  == 0 );
            
            %calculates minimum TtC from the positive real roots
            [ ttc(t,1), min_idx ] = min(rts(t,ind));
            
            %find index corresponding to first boundary crossed, divide by
            %method (corresponds to number of possible roots), and raise to
            %next integer to get boundary number
            bound_cross(t,1) = ceil(ind(min_idx)/method);
            
        end
        
    end %end boundary
    
    clear i;
    
end %end time point

clear t;

bound_perc = ttc_bound_perc( bound_cross, b_n); %percent of contacts to each boundary

end %end function

