%% Moby Motion Isolator
%
% Clarifies moving objects in an image sequence.
% Written for MATLAB 2013
%

%% Please set these for each file.
%
filename = '141222_8_crop'
INPUT_FILE_EXTENSION = '.jpeg'

% This is '%04d' if you have 4 digits (like, video0004.jpeg)
numberingFormat = '%04d';

% Try a couple framerates until you get the output video to be the right
% length.
OUTPUT_FRAME_RATE = 33.333;

% If the last image frame is named 'video0097.jpeg', this is 97.
NUMBER_OF_FRAMES = 5145;

% This is where the frames are.
INPUT_DIRECTORY = 'input\frames_8\';

%% Usage Instructions
%
% Please see the Usage Instructions clearer information.
%
% - Place this script in an empty folder.
%
% - Create two more folders: 'input' and 'output'
%
% - Create another folder inside of the 'input' folder where your image
%   frames will go.
%
% - Turn your video into image frames, named sequentially (like a0001.jpg, 
%   a0002.jpg, a0003.jpg...)
%
% - Set the variables in the "set these for each file" section below
%
% - Run the script. 
%
% - Your processed video will be in the 'output' folder.
%

%% Authorship
%
% Mustafa Hussain
% Digital Image Processing with Dr. Anas Salah Eddin
% FL Poly, Spring 2015
%


%% You probably don't need to touch this.
%

OUTPUT_VIDEO_FILE_EXTENSION = '.avi';
OUTPUT_DIRECTORY = 'output\';

% Open video writer.
writerObj = VideoWriter(strcat(OUTPUT_DIRECTORY, filename, '_motion_isolated', OUTPUT_VIDEO_FILE_EXTENSION))
writerObj.FrameRate = OUTPUT_FRAME_RATE;
open(writerObj);

currentFrameIndex = 0;
h = waitbar(0, strcat('Processing_', filename, '...'));

% For every frame, do some stuff.
while currentFrameIndex < (NUMBER_OF_FRAMES - 1)
    
    nextFrameIndex = currentFrameIndex + 1;
    thisFrame = double(rgb2gray(imread(strcat(INPUT_DIRECTORY, filename, sprintf(numberingFormat, currentFrameIndex), INPUT_FILE_EXTENSION))));
    nextFrame = double(rgb2gray(imread(strcat(INPUT_DIRECTORY, filename, sprintf(numberingFormat, nextFrameIndex), INPUT_FILE_EXTENSION))));
    
    % Subtract next frame from this frame. This isolates motion.
    motionIsolatedFrame = thisFrame - nextFrame;
    
    % Save the isolated-motion frame if it's legitimate.
    if not(max(max(motionIsolatedFrame)) == min(min(motionIsolatedFrame)))

        % Make it something we can see.
        motionIsolatedFrame = uint8((motionIsolatedFrame + 255) ./ 2);
        gamma = 0.5; % Experimentally determined.
        inputRange = [0.4, 0.6]; % Experimentally determined.
        motionIsolatedFrame = imadjust(motionIsolatedFrame, inputRange, [0, 1], gamma);

        % Save it.
        writeVideo(writerObj, motionIsolatedFrame);
    end
    
    waitbar(currentFrameIndex / NUMBER_OF_FRAMES, h, strcat('Processing ', filename, '...'));
    
    currentFrameIndex = currentFrameIndex + 1;
end

% Close handles.
close(h);
close(writerObj);
