% Example pipeline for processing histology

%% 1) Load CCF and set paths for slide and slice images

% Load CCF atlas
allen_atlas_path = 'C:\Users\phar0732\Documents\Allen Brain Mouse';
tv = readNPY([allen_atlas_path filesep 'template_volume_10um.npy']);
av = readNPY([allen_atlas_path filesep 'annotation_volume_10um_by_index.npy']);
st = loadStructureTree([allen_atlas_path filesep 'structure_tree_safe_2017.csv']);

%% Set paths for histology images and directory to save slice/alignment
im_path = 'Z:\00 IMAGES\Dave full slides Immuno Vial1\Export 317';
slice_path = [im_path filesep 'slices'];

%% 2) Preprocess slide images to produce slice images

% Set white balance and resize slide images, extract slice images
% (Note: this resizes the images purely for file size reasons - the CCF can
% be aligned to histology no matter what the scaling. If pixel size is
% available in metadata then automatically scales to CCF resolution,
% otherwise user can specify the resize factor as a second argument)

% Set resize factor
% resize_factor = []; % (slides ome.tiff: auto-resize ~CCF size 10um/px)
resize_factor = 1; % (slides tiff: resize factor)

% Set slide or slice images
slice_images = false; % (images are slides - extract individual slices)
% slice_images = true; % (images are already individual slices)

% Preprocess images
AP_process_histology(im_path,resize_factor,slice_images);

%% 3) (optional) Rotate, center, pad, flip slice images
AP_rotate_histology(slice_path);

%% 4) Select CCF that matches slices

% Find CCF slices corresponding to each histology slice
AP_grab_histology_ccf(tv,av,st,slice_path);


%% 5) Align CCF slices and histology slices
% (first: automatically, by outline)
AP_auto_align_histology_ccf(slice_path);
%% 6) (Optional: curate manually)
AP_manual_align_histology_ccf(tv,av,st,slice_path);

%% 7) Utilize aligned CCF

% Display aligned CCF over histology slices
AP_view_aligned_histology(st,slice_path);

%% 8) Optional: Draw probe trajectory
% Get probe trajectory from histology, convert to CCF coordinates
AP_get_probe_histology(tv,av,st,slice_path);

%% Julien's edit

SlicesFolder = 'Z:\00 IMAGES\Sharp Track testing\Luke\270_RGB_rawHisto-20%size_0to25000\slices';
load(fullfile(SlicesFolder,'atlas2histology_tform.mat'))
load(fullfile(SlicesFolder,'histology_ccf.mat'))


fold = dir(SlicesFolder)
idxtifs = [];


for f=1:length(fold)
    if contains(fold(f).name,'.tif')
        idxtifs = [idxtifs; f];
    end
end

fold=fold(idxtifs);

for s=1:length(fold)
   preproctif = imread(fullfile(fold(s).folder, fold(s).name));
  
end

%% 


tform = affine2d;
tform.T = gui_data.histology_ccf_alignment{curr_slice};   
tform_size = imref2d([size(curr_slice_im,1),size(curr_slice_im,2)]);
gui_data.histology_aligned_av_slices{curr_slice} = ...
    imwarp(curr_av_slice,tform,'nearest','OutputView',tform_size);
%%

% Display histology within 3D CCFe
AP_view_aligned_histology_volume(tv,av,st,slice_path,1);


% Align histology to electrophysiology
use_probe = 1;
AP_align_probe_histology(st,slice_path, ...
    spike_times,spike_templates,template_depths, ...
    lfp,channel_positions(:,2), ...
    use_probe);

% Extract slices from full-resolution images
% (not worth it at the moment, each slice is 200 MB)
% AP_grab_fullsize_histology_slices(im_path)













