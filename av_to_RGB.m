function avRGB = av_to_RGB(st,avplan)
    
    avRGB = zeros(size(avplan,1),size(avplan,2),3);
    f= waitbar(0,'Reconstructing atlas colors')
    
    for y=1:size(avplan,1)-1
% %                     y

        for x=1:size(avplan,2)-1
            
            rgbval = hex2rgb(st.color_hex_triplet(avplan(y,x)));
            if isa(rgbval,'double')
                avRGB(y,x,:) = rgbval;
            elseif sum(rgbval) == 3
                avRGB(y,x,:) = [NaN NaN NaN];
            else
                
            end
                

        end
        waitbar(y/size(avplan,2),f,'Reconstructing atlas colors')
    end
    close(f)
%     figure;imagesc(avRGB)
