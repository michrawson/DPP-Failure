function pass = checkScreen(feature_keep, tru_pred)
    pass = true;
    for i = 1:length(tru_pred)
%         find in feature_keep
        if length(feature_keep) > 0
            for j = 1:length(feature_keep)
                if tru_pred(i) == feature_keep(j)
                    break
                end
                if j == length(feature_keep)
                    pass = false;
                    return
                end
            end
        else
            pass = false;
            return
        end
    end
