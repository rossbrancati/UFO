function [ ] = ttc_trajectplot( p_x, p_y, dt, x_bos, y_bos, ttc, method)
%TTC_PLOT Plots the Base-of-Support, Center-of-Pressure, and Virtual
%Trajectory for three data points.

%Estimate Higher Order Derivatives =======================================%
%For Riccio, Slobounov, and Jerk Methods
v_x = cent_diff5(p_x, dt); %ML velocity
v_y = cent_diff5(p_y, dt); %AP velocity

%For Slobounov or Jerk Methods
if method == 2 || method == 3
    a_x = cent_diff5(v_x, dt); %ML acceleration
    a_y = cent_diff5(v_y, dt); %AP acceleration
else 
    a_x = zeros(size(v_x)); %set to 0
    a_y = zeros(size(v_y)); %set to 0
end

%For Jerk Method
if method == 3
    j_x = cent_diff5(a_x, dt); %ML jerk
    j_y = cent_diff5(a_y, dt); %AP jerk
else 
    j_x = zeros(size(v_x)); %set to 0
    j_y = zeros(size(v_y)); %set to 0
end

%Indices to Plot Extrapolated Trajectory
idx = [950:1000];

figure('color','white');
plot(x_bos, y_bos,'k');
xlabel('ML CoP (mm)');
ylabel('AP CoP (mm)');
axis([0 525 0 525]);
hold on;
scatter(x_bos,y_bos,'k','filled');
plot(p_x,p_y,'k');

%for each index
for i = idx
  
    tau = 0:0.001:ttc(i); %tau time series
    vt_x = zeros(size((tau))); %virtual trajectory x positions
    vt_y = zeros(size(tau)); %virutal trajectory y positions
    
    %for each value of tau
    for j = 1:length(tau)
         
        vt_x(j) = p_x(i) + v_x(i) * tau(j) + 0.5 * a_x(i) * (tau(j) ^ 2) + (1/3) * j_x(i) * tau(j) * tau(j) * tau(j);
        vt_y(j) = p_y(i) + v_y(i) * tau(j) + 0.5 * a_y(i) * (tau(j) ^ 2) + (1/3) * j_y(i) * tau(j) * tau(j) * tau(j);

    end %end tau
    
    plot(vt_x, vt_y, 'k');
    hold on;
    
end %end index

 %end function

