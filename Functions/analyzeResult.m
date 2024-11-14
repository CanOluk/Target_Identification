function   resultsStrct= analyzeResult(varEXP,settSim,decisionTPT,decisionTAT)

[expcond,~,repeat]=unique(varEXP.TRIALS_P,'rows');
for i=1:size(varEXP.TRIALS_P,2)
    
    [expcondCAT,~,repeatCAT]=unique(varEXP.TRIALS_P(:,i),'rows');
    expcondCATs{i}=expcondCAT;
    repeatCATs{i}=repeatCAT;
end

for a=1:size(expcond,1)
    
    
    
    counts = zeros(size(settSim.discriminationCat_levels,2)+1, size(decisionTPT, 2));
    % Loop through each column and count the occurrences of each number (0 to 6)
    for i = 1:size(decisionTPT, 2)
        counts(:, i) = histcounts( decisionTPT(repeat==a,i), -0.5:size(settSim.discriminationCat_levels,2)+0.5);  % bin edges are set to count 0 to 6
    end
    
    for ii=1:size(varEXP.TRIALS_P,2)
        loc_temp=repeatCATs{ii}(repeat==a);
        locs(ii)=loc_temp(1);
        indexCell = num2cell(locs);
    end
    indexCell = num2cell(locs);
    resultsStrct.htmatrix(:,:,indexCell{:})=counts;
end




% for correct rejections


[expcond,~,repeat]=unique(varEXP.TRIALS_A,'rows');

for a=1:size(expcond,1)
    counts = zeros(size(settSim.discriminationCat_levels,2)+1, size(decisionTAT, 2));
    for i = 1:size(decisionTAT, 2)
        counts(:, i) = histcounts( decisionTAT(repeat==a,i), -0.5:size(settSim.discriminationCat_levels,2)+0.5);  % bin edges are set to count 0 to 6
    end
    
    resultsStrct.crjmatrix(:,:,a)=counts;
end


end