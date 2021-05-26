function [ml_v, ap_v, net_v ] = copVelocity( ml, ap, samp )
%COPVELOCITY Returns mean absolute ML, AP, and net speed of the COP

vml = cent_diff3( ml, 1/samp); %ML velocity
vap = cent_diff3( ap, 1/samp); %AP velocity

ml_v = mean(abs(vml)); %mean abs ML velocity
ap_v = mean(abs(vap)); %mean abs AP velocity
net_v = mean(sqrt(vml.^2 + vap.^2)); %mean net velocity

end %end function

