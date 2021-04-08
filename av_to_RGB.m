function avRGB = av_to_RGB(st,curr_atl,s)
    
    avRGB = zeros(size(curr_atl,1),size(curr_atl,2),3);
    f= waitbar(0,'Reconstructing atlas colors');
    
    for y=1:size(curr_atl,1)-1
% %                     y
        for x=1:size(curr_atl,2)-1
            
            rgbval = hex2rgb(st.color_hex_triplet(curr_atl(y,x)));
            if isa(rgbval,'double')
                avRGB(y,x,:) = rgbval;
            elseif sum(rgbval) == 3
                avRGB(y,x,:) = [NaN NaN NaN];
            else
                
            end
                

        end
        waitbar(y/size(curr_atl,2),f,strcat('Reconstructing atlas colors, section:',num2str(s)))
    end
    close(f)
%     figure;imagesc(avRGB)
