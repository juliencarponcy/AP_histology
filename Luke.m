[file,path,indx] = uigetfile('*.tif','MultiSelect','on');
GFPchan = 2;
percThresh = 20;
valueThresh = 75; % from 0 to 255;
GaussFiltValue = 7; %  higher = more blurry,  lower = more "dotty"

for s=1:length(file)
    sections(s).raw = imread(fullfile(path,file{s}));
    sections(s).filt =  imgaussfilt(sections(s).raw,GaussFiltValue);
    
    temp = squeeze(sections(s).raw(:,:,GFPchan));
    temp = reshape(temp,size(temp,1)*size(temp,2),1);
%     valueThresh = prctile(double(temp),62);
    temp = squeeze(sections(s).raw(:,:,GFPchan));
    mask = temp<valueThresh;
    temp(mask)=0;
    sections(s).thresh = temp;
    
    results.GFPthreshFilt(:,:,s) =  imgaussfilt(sections(s).thresh,GaussFiltValue);
    results.GFPthresh(:,:,s) = temp;
    
    results.GFPraw(:,:,s) = sections(s).raw(:,:,GFPchan);
    results.GFPfilt(:,:,s) = sections(s).filt(:,:,GFPchan);
    
end

figure; imshow( results.GFPthresh)

results.average = squeeze(mean(results.GFPfilt,3));
results.averageThreshFilt =  squeeze(mean(results.GFPthreshFilt,3));

figure; pcolor(flipud(results.averageThreshFilt));
colormap(jet)
shading interp
set(gca,'Clim',[0 20])