function count = getScreenFailCount(feature_keep, tru_pred)
    if length(feature_keep) > 0
        count = 0;
        for i = 1:length(tru_pred)
%         find in feature_keep
            for j = 1:length(feature_keep)
                if tru_pred(i) == feature_keep(j)
                    break
                end
                if j == length(feature_keep)
                    count = count + 1;
                end
            end
        end
    else
        count = length(tru_pred);
    end
end
