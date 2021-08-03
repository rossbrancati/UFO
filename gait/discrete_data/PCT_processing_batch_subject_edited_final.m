close all
clear all
clc


test = process('S1');
function y = process(sheet)
prompt = 'Enter Age/Sex';
age_sex = input(prompt,'s');
prompt = 'Enter Study ID';
studyid = input(prompt,'s');
prompt = 'Enter Condition';
runcode = input(prompt,'s');
prompt = 'Enter Speed';
ogspeed = input(prompt,'s');
[file_list,path_n] = uigetfile('.txt','Select files for processing','MultiSelect','on');
if iscell(file_list) == 0
    file_list = {file_list};
end

y_total = zeros(1,74);

for i = 1:length(file_list)
    filename = file_list{i};
    data = readmatrix([path_n filename]);
    %data = readmatrix(data1);
    %data = data(5:end,:);
    height = data(1,2);
    mass = data(1,3);
    speed = data(1,4);
    sl = data(1,5);
    sl_hgt = data(1,6);
    cadence = data(1,9);
    
    %Ground reaction force plate 1
    fp1 = data(:,7);
    fp1 = rmmissing(fp1);
    
    %Ground reaction force plate 2
    fp2 = data(:,8);
    fp2 = rmmissing(fp2);
    fifty = 0.5*round(length(fp2));
    
    %peak ground reaction forces for first and second peaks
    %1
    [grf1 inx] = max(fp2(1:fifty));
    %2
    [grf2 ind] = max(fp2(fifty:end));
    
    
    %%%%%%%%%%%%%%%%%
    %%%%% KNEE %%%%%%
    %%%%%%%%%%%%%%%%%
   
    %knee flexion angle in first frame of stance - heel strike  
    kneex = data(:,11);
    kneex = rmmissing(kneex);
    %knee flexion at heel strike
    kfhs = kneex(1);
    %knee flexion at toe off
    kfto = kneex(end);
    
    %EDITED
    %local maximum of knee flexion angle in first 40% of stance
    mskf = max(kneex(1:round(.4*length(kneex))));
    
    %EDITED
    %local minimum of knee flexion in second half of stance
    mske_peak_stance = min(kneex(round(.5*length(kneex)):end));
    
    %I think that this is the minimum over the whole stance phase because
    %initially we were not going to clip trials for full gait cycle and
    %were only going to use the stance phase
    keps = min(kneex(40:end));
    
    %knee flexion range of motion for entire gait cycle
    %max knee flexion minus minimum knee flexion in entire gait cycle (if available). 
    kneexgc = data(:,17);
    kneexgc = rmmissing(kneexgc); %removes missing entries from vector
    kfrom_gc = max(kneexgc)-min(kneexgc);
    
    %Knee flexion range of motion for stance phase
    kfrom_stance = max(kneex)-min(kneex);
    
    %I'm not sure what MSFK is
    %Removed from output vector
    kneexforty = round(0.4*length(kneex));
    msfk = max(kneex(1:kneexforty));
    
    %Mid stance knee extension?
    kneexfifty = round(0.5*length(kneex));
    mske_ps = max(kneex(kneexfifty:end));
    
    %knee rotation angle
    kneez = data(:,13);
    kneez = rmmissing(kneez);
    %knee rotation angle
    krot_avg = mean(kneez);
    %knee rotation at heel strike
    krot_hs = kneez(1);
    
    %knee adduction/abduction angle
    kneey = data(:,12);
    kneey = rmmissing(kneey);
    fp2l = length(fp2);
    kneeyl = length(kneey);
    if grf1<grf2
        va = round((kneeyl/fp2l)*ind);
    else
        va = round((kneeyl/fp2l)*inx);
    end 
    for ii = 1:(length(kneey)-1)
        av(ii) = (kneey(ii+1)-kneey(ii))/2;
    end
    av = av';
    kneey10 = round(0.1*length(kneey));
    varus = max(av(kneey10:va));
    fad = data(:,31);
    fad = rmmissing(fad);
    fad_hs = fad(1);
    fs = round(((length(fad))/fp2l)*inx);
    fad_grf1 = fad(fs);
    fad_avg = mean(fad);
    
    
    
    %%%%%%%%%%%%%%%%%
    %%%%% HIP %%%%%%%
    %%%%%%%%%%%%%%%%%
    
    %Hip flexion angle in stance phase
    hipx_stance = data(:,10);
    hipx_stance = rmmissing(hipx_stance);
    %Hip flexion at heel strike
    hfhs = hipx_stance(1);
    %Hip flexion toe off
    hfto = hipx_stance(end);
    
    
    %max hip flexion in first 20% of stance
    hf_max = max(hipx_stance(1:round(.2*length(hipx_stance))));
    %max hip extension = local minimum in final 30% of stance
    he_max = min(hipx_stance(round(.7*length(hipx_stance)):end));
    
    %%%%%%%
    %not the same definition as the variables that Kath sent
    %hsrom_stance = max(hipx)-min(hipx);
    %%%%%%%
    
    %Range of motion of hip angle during stance
    hsrom_stance = hf_max - he_max;
    
    %Hip flexion angle gait cycle
    hipx_gc = data(:,16);
    hipx_gc = rmmissing(hipx_gc);
    hsrom_gc = max(hipx_gc)-min(hipx_gc);
    
    %%%%%%%%%%%%%%%%%
    %%%%% ANKLE %%%%%
    %%%%%%%%%%%%%%%%%
    
    %Ankle flexion angle stance phase
    anklex_stance = data(:,14);
    anklex_stance = rmmissing(anklex_stance);
    %Ankle flexion angle at heel strike
    afhs = anklex_stance(1);
    %Ankle flexion angle at toe off
    afto = anklex_stance(end);
    %minimum angle in stance (assuming pf is negative)
    apf_peak = min(anklex_stance);
    %max positive value - max negative value in stance 
    %the max negative value is equivalent to the minimum value 
    asrom_stance = max(anklex_stance)-min(anklex_stance);
    %Ankle flexion angle for whole gait cycle
    anklex_gc = data(:,18);
    anklex_gc = rmmissing(anklex_gc);
    %%max positive value - max negative value gait cycle
    %the max negative value is equivalent to the minimum value 
    asrom_gc = max(anklex_gc)-min(anklex_gc);
    
    %frontal plane ankle angles?
    ankley = data(:,15);
    ankley = rmmissing(ankley);
   
    %ankle eversion
    aev_peak = min(ankley);
    
    
    %Did not edit any of the pelvis variables
    %Anterior - Posterior pelvis movement stance phase (sagittal plane)
    pelvisxs = data(:,19);
    pelvisxs = rmmissing(pelvisxs);
    pant_peak = max(pelvisxs);
    
    %Anterior - Posterior pelvis movement whole gait cycle (saggital plane)
    pelvisxgc = data(:,20);
    pelvisxgc = rmmissing(pelvisxgc);
    pelvisxswing = pelvisxgc((length(pelvisxgc)/2):end);
    ppost_peak_swing = max(pelvisxswing);
    
    %Pelvis Hike - Drop movement (frontal plane)
    pelvisy = data(:,21);
    pelvisy = rmmissing(pelvisy);
    pdrop_peak = max(pelvisy);
    
    %Pelvis forwards/backwards rotation (transverse)
    pelvisz = data(:,22);
    pelvisz = rmmissing(pelvisz);
    prot_peak = max(pelvisz);
    
    %%%%%%%%%%%%%%%%%%
    %%%KNEE MOMENTS%%%
    %%%%%%%%%%%%%%%%%%
    
    %Knee flexion moment
    kfm = data(:,24);
    kfm = rmmissing(kfm);
    
    %Original in Kali's code
    %This is for the whole stance phase, whereas Kath's definition says
    %kfm_peak is the first local maximal in first 50% of stance, although
    %it doesn't really matter because you'll get the same value either way
    %kfm_peak = max(kfm);
    
    %Ross edit:
    %Added in first_kem_peak, second_kem_peak, and edited kfm_peak
    first_kem_peak = min(kfm(1:round(.2*length(kfm))));
    kfm_peak = max(kfm(1:round(.5*length(kfm))));
    second_kem_peak = min(kfm(round(.5*length(kfm)):end));
    
    %knee adduction moment
    kam = data(:,25);
    kam = rmmissing(kam);
    kaml = length(kam);
    kam50 = round(0.5*kaml);
    
    %Kali's equations
    %kam_first = max(kam(1:kam50));
    %kam_second = max(kam(kam50:end));
    
    %Ross edits:
    kam_first = min(kam(1:round(.5*length(kam))));
    kam_second = min(kam(round(.5*length(kam)):end));
    
    %Knee rotation moment
    krot = data(:,26);
    krot = rmmissing(krot);
    %Minimum knee rotation moment (not in Kath's document)
    kerot = min(krot);
    %maximum knee rotation moment (not in Kath's document)
    kirot = max(krot);
    
    %%%%%%%%%%%%%%%%%
    %%%HIP MOMENTS%%%
    %%%%%%%%%%%%%%%%%
    
    %Hip flexion moment
    hipm = data(:,23);
    hipm = rmmissing(hipm);
    %Maximum hip flexion moment
    
    %From Kali - left these the same 
    %Max hip flexiom moment
    hfm_peak = min(hipm(1:round(.5*length(hipm))));
    %Max hip extension moment
    hem_peak = max(hipm(round(.5*length(hipm)):end));
    
    %I added in the apm_peak and adm_peak assuming that:
    %apm_peak = ankle plantarflexion peak
    %adm_peak = ankle dorsiflexion peak
    ank_flex_mom = data(:,27);
    ank_flex_mom = rmmissing(ank_flex_mom);
    %local max first 50% stance
    apm_peak = max(ank_flex_mom(1:round(.5*length(ank_flex_mom))));
    %local min second 50% stance
    adm_peak = min(ank_flex_mom(round(.5*length(ank_flex_mom)):end));
    
    %Power calculations 
    %I did not edit any of these
    hip_power= data(:,28); 
    knee_power= data(:,29);
    ankle_power= data(:,30);
    hip_sag_moment = data(:,23);
    knee_sag_moment = data(:,24);
    ankle_sag_moment = data(:,27);
    peak_ext_pos_power = max(hip_power(hip_sag_moment < 0));
    peak_flex_pos_power = max(hip_power(hip_sag_moment > 0));
    hip_pos_power = peak_flex_pos_power + peak_ext_pos_power;
    hip_neg_power = min(hip_power(hip_sag_moment > 0));
    knee_pos_power= max(knee_power(knee_sag_moment < 0));
    knee_neg_power= min(knee_power);
    ankle_pos_power= max(ankle_power);
    ankle_neg_power= min(ankle_power);
    total_pos_power= hip_pos_power+knee_pos_power+ankle_pos_power;
    total_neg_power= hip_neg_power+knee_neg_power+ankle_neg_power;
    hip_rel_pos_power = (hip_pos_power / total_pos_power) * 100;
    knee_rel_pos_power = (knee_pos_power / total_pos_power) * 100;
    ankle_rel_pos_power = (ankle_pos_power / total_pos_power) * 100;
    hip_rel_neg_power = (hip_neg_power / total_neg_power) * 100;
    knee_rel_neg_power = (knee_neg_power / total_neg_power) * 100;
    ankle_rel_neg_power = (ankle_neg_power / total_neg_power) * 100;
    frame_rate = 200;
    hip_pos_work = trapz(hip_power(hip_power > 0)) ./ frame_rate;
    hip_neg_work = trapz(hip_power(hip_power < 0)) ./ frame_rate;
    knee_pos_work = trapz(knee_power(knee_power > 0)) ./ frame_rate;
    knee_neg_work = trapz(knee_power(knee_power < 0)) ./ frame_rate;
    ankle_pos_work = trapz(ankle_power(ankle_power > 0)) ./ frame_rate;
    ankle_neg_work = trapz(ankle_power(ankle_power < 0)) ./ frame_rate;
    total_pos_work = hip_pos_work + knee_pos_work + ankle_pos_work;
    total_neg_work = hip_neg_work + knee_neg_work + ankle_neg_work;
    hip_rel_pos_work = (hip_pos_work / total_pos_work) * 100;
    knee_rel_pos_work = (knee_pos_work / total_pos_work) * 100;
    ankle_rel_pos_work = (ankle_pos_work / total_pos_work) * 100;
    hip_rel_neg_work = (hip_neg_work / total_neg_work) * 100;
    knee_rel_neg_work = (knee_neg_work / total_neg_work) * 100;
    ankle_rel_neg_work = (ankle_neg_work / total_neg_work) * 100;
    
    %This was Kali's output and includes some extra variables that are not
    %in the variable list that Kath sent to me including:
    %  keps (same as KEPS I beleive)
    %  mdfk
    %  mske_ps
    %  krot_avg
    %  krot_hs 
    %  varus
    %  hf_max is missing
    %  he_max is missing
    %  hsrom_stance is not calcualted according to the def in Kath's doc
    
    %y = {age_sex studyid runcode ogspeed mass height speed sl sl_hgt cadence grf1 grf2 ... 
     %kfhs mskf keps kfrom_gc kfrom_stance kfto msfk mske_ps krot_avg krot_hs varus ...
     %hfhs hfto hsrom_stance hsrom_gc afhs afto apf_peak asrom_stance ...
     %asrom_gc aev_peak pant_peak pdrop_peak prot_peak kfm_peak kam_first kam_second...
     %kerot kirot hfm hem peak_ext_pos_power peak_flex_pos_power hip_pos_power hip_neg_power...
     %knee_pos_power knee_neg_power ankle_pos_power ankle_neg_power total_pos_power total_neg_power...
     %hip_rel_pos_power knee_rel_pos_power ankle_rel_pos_power hip_rel_neg_power knee_rel_neg_power...
     %ankle_rel_neg_power hip_pos_work hip_neg_work knee_pos_work knee_neg_work ankle_pos_work...
     %ankle_neg_work total_pos_work total_neg_work hip_rel_pos_work knee_rel_pos_work...
     %ankle_rel_pos_work hip_rel_neg_work knee_rel_neg_work ankle_rel_neg_work};
    
     
    %Edited output. edited the following variables from the above output:
    %  1) replaced keps with mske_peak_stance
    %  2) msfk
    %  3) mske_ps
    %  4) krot_avg
    %  5) krot_hs 
    %  6) varus
    %  7) Added in hf_max
    %  8) Added in he_max
    %  9) Edited hsrom_stance calculation in code above. 
    %  10) Added in first_kem_peak
    %  11) edited kfm_peak calculation in above code
    %  12) added in second_kem_peak
    %  13) edited kam_first and kam_second calculations 
    %  14) removed kerot and kirot > they are not in Kath's document
    %  15) edited peak_hfm and peak_hem
    %  16) added in apm_peak and adm_peak
     y = {age_sex studyid runcode ogspeed mass height speed sl sl_hgt cadence grf1 grf2... 
      kfhs mskf mske_peak_stance kfrom_gc kfrom_stance kfto...
      hfhs hfto hf_max he_max hsrom_stance hsrom_gc afhs afto apf_peak asrom_stance...
      asrom_gc krot_avg krot_hs aev_peak pant_peak ppost_peak_swing pdrop_peak prot_peak first_kem_peak kfm_peak...
      second_kem_peak kam_first kam_second kerot kirot hfm_peak hem_peak apm_peak adm_peak... 
      peak_ext_pos_power peak_flex_pos_power hip_pos_power hip_neg_power...
      knee_pos_power knee_neg_power ankle_pos_power ankle_neg_power total_pos_power total_neg_power...
      hip_rel_pos_power knee_rel_pos_power ankle_rel_pos_power hip_rel_neg_power knee_rel_neg_power...
      ankle_rel_neg_power hip_pos_work hip_neg_work knee_pos_work knee_neg_work ankle_pos_work...
      ankle_neg_work total_pos_work total_neg_work hip_rel_pos_work knee_rel_pos_work...
      ankle_rel_pos_work hip_rel_neg_work knee_rel_neg_work ankle_rel_neg_work fad_hs fad_grf1 fad_avg};
     
     file = '/Users/rossbrancati/Desktop/UFO/Gait/Discrete_data/UFO_Gait_Discrete_Variables.xlsx';
     
    rng = i+1;
    rng = num2str(rng);
    range = strcat('A',rng,':BZ',rng);
    
    %Original:
    %writecell(y,file,'Sheet','Sheet1','Range',range,'WriteMode','append')
    
    
    %Conditional statements for correct sheets in excel document
    if contains(filename,'0002') || contains(filename,'0003') || contains(filename,'0004') || contains(filename,'0005') || contains(filename,'0006')   
    
        writecell(y,file,'Sheet','Pre_SS','WriteMode','append')
        
    elseif contains(filename,'0007') || contains(filename,'0008') || contains(filename,'0009') || contains(filename,'00010') || contains(filename,'00011')

        writecell(y,file,'Sheet','Pre_Fast','WriteMode','append')
        
    elseif contains(filename,'0013') || contains(filename,'0014') || contains(filename,'0015') || contains(filename,'0016') || contains(filename,'0017')

        writecell(y,file,'Sheet','Post_SS','WriteMode','append')
        
    elseif contains(filename,'0018') || contains(filename,'0019') || contains(filename,'0020') || contains(filename,'0021') || contains(filename,'0022')

        writecell(y,file,'Sheet','Post_Fast','WriteMode','append')
        
    end 
  
    
    %Calculates the total for y over x number of trials
    y_total = y_total + cell2mat(y(1,7:80));
    
    
    
end
%Calculate the mean using the counter in the for loop (i.e.
%length(file_list))
y_mean = y_total ./ length(file_list);

y_mean_cell = num2cell(y_mean);

y_mean_cell_labs = {age_sex studyid runcode ogspeed mass height};

y_mean_cell_final = [y_mean_cell_labs y_mean_cell];

if contains(filename,'0002') || contains(filename,'0003') || contains(filename,'0004') || contains(filename,'0005') || contains(filename,'0006')   
    
    writecell(y_mean_cell_final,file,'Sheet','Pre_SS_Mean','WriteMode','append')
        
elseif contains(filename,'0007') || contains(filename,'0008') || contains(filename,'0009') || contains(filename,'00010') || contains(filename,'00011')

    writecell(y_mean_cell_final,file,'Sheet','Pre_Fast_Mean','WriteMode','append')
        
elseif contains(filename,'0013') || contains(filename,'0014') || contains(filename,'0015') || contains(filename,'0016') || contains(filename,'0017')

    writecell(y_mean_cell_final,file,'Sheet','Post_SS_Mean','WriteMode','append')
        
elseif contains(filename,'0018') || contains(filename,'0019') || contains(filename,'0020') || contains(filename,'0021') || contains(filename,'0022')

    writecell(y_mean_cell_final,file,'Sheet','Post_Fast_Mean','WriteMode','append')
    
end


end



