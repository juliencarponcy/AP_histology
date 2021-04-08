function avRGB = av_to_RGB_fast(st,histology_ccf,s)
    
    avRGB = zeros(size(histology_ccf(s).av_slices,1),size(histology_ccf(s).av_slices,2),3);
    f= waitbar(0,'Reconstructing atlas colors');
    unique_sphinx_id = unique(histology_ccf(s).av_slices);
    unique_sphinx_id = unique_sphinx_id(~isnan(unique_sphinx_id));
    unique_sphinx_id = unique_sphinx_id(unique_sphinx_id>0);
    avRGB = nan([size(histology_ccf(s).av_slices) 3]);
    histology_ccf(s).av_slices(:,:,2)=histology_ccf(s).av_slices;
    histology_ccf(s).av_slices(:,:,3)=histology_ccf(s).av_slices(:,:,1);
    
    for a = 1:length(unique_sphinx_id)
        tempmask = histology_ccf(s).av_slices == unique_sphinx_id(a);   % %                     y

        rgbval = hex2rgb(st.color_hex_triplet(unique_sphinx_id(a)));
        rgbvalmat = ones(size(histology_ccf(s).av_slices));
        rgbvalmat(:,:,1) = rgbval(1);
        rgbvalmat(:,:,2) = rgbval(2);
        rgbvalmat(:,:,3) = rgbval(3);

        if isa(rgbval,'double')
            avRGB(tempmask) = rgbvalmat(tempmask);
        elseif sum(rgbval) == 3
            avRGB(tempmask,:) = [NaN NaN NaN];
        else

        end


            
        
        waitbar(a/length(unique_sphinx_id),f,strcat('Reconstructing atlas colors, section:',num2str(s)))
    end
    close(f)
end
%     figure;imagesc(avRGB)
