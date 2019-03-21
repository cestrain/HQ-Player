function [question,ans1,ans2,ans3,flag] = image_text_quotes()

% Image testing?
pos_question = [720 229 456 150]; 
pos_ans1 = [745 450 321 60];
pos_ans2 = [745 537 321 60];
pos_ans3 = [745 623 321 60];

% Current
% pos_question = [662 195 526 210]; 
% pos_ans1 = [708 439 378 63];
% pos_ans2 = [708 535 390 63];
% pos_ans3 = [708 630 404 63];

%% Question

% Take screen capture 
robot = java.awt.Robot();
rect = java.awt.Rectangle(pos_question(1),pos_question(2),pos_question(3),pos_question(4));
cap = robot.createScreenCapture(rect);

% Convert to an RGB image
rgb = typecast(cap.getRGB(0,0,cap.getWidth,cap.getHeight,[],0,cap.getWidth),'uint8');
imgData = zeros(cap.getHeight,cap.getWidth,3,'uint8');
imgData(:,:,1) = reshape(rgb(3:4:end),cap.getWidth,[])';
imgData(:,:,2) = reshape(rgb(2:4:end),cap.getWidth,[])';
imgData(:,:,3) = reshape(rgb(1:4:end),cap.getWidth,[])';
imwrite(imgData,'question.png')

% Load an image 
I = imread('question.png');
%imshow('question.png')

% Perform OCR
results = ocr(I);
words = results.Words;
i=2;
flag = 0;
while i < length(words)
    
    % Check first word for capital letter
    if isstrprop(words{i}(1),'upper')
        
        % This word has a capital, so the first quote goes before this
        words{i} = strcat('"',words{i});
        
        % Check if there is a group of two words that have capitals
        % together
        if i ~= length(words) & isstrprop(words{i+1}(1),'upper')
        
            % Check the third word in a row
            if i ~= length(words)-1 & isstrprop(words{i+2}(1),'upper')
                words{i+2} = strcat(words{i+2},'"');
                i=i+3;
            else 
                words{i+1} = strcat(words{i+1},'"');
                i=i+2;
                continue 
            end
        % The second word has no capital, so we put an end quote around
        % word 1
        else
            words{i} = strcat(words{i},'"');
            i=i+1;
            continue
        end
    else
        i=i+1;
    end
    if strcmpi(words{i},'not')
        flag=1;
    end
end
question = strjoin(words);
question = erase(question,'?');
question = erase(question,',')
%% Answer 1

% Take screen capture 
robot = java.awt.Robot();
rect = java.awt.Rectangle(pos_ans1(1),pos_ans1(2),pos_ans1(3),pos_ans1(4));
cap = robot.createScreenCapture(rect);

% Convert to an RGB image
rgb = typecast(cap.getRGB(0,0,cap.getWidth,cap.getHeight,[],0,cap.getWidth),'uint8');
imgData = zeros(cap.getHeight,cap.getWidth,3,'uint8');
imgData(:,:,1) = reshape(rgb(3:4:end),cap.getWidth,[])';
imgData(:,:,2) = reshape(rgb(2:4:end),cap.getWidth,[])';
imgData(:,:,3) = reshape(rgb(1:4:end),cap.getWidth,[])';
imwrite(imgData,'ans1.png')

% Load an image 
I = imread('ans1.png');
%imshow('ans1.png')

% Perform OCR
results = ocr(I);
results.Words;
ans1=strjoin(results.Words);

%% Answer 2

% Take screen capture 
robot = java.awt.Robot();
rect = java.awt.Rectangle(pos_ans2(1),pos_ans2(2),pos_ans2(3),pos_ans2(4));
cap = robot.createScreenCapture(rect);

% Convert to an RGB image
rgb = typecast(cap.getRGB(0,0,cap.getWidth,cap.getHeight,[],0,cap.getWidth),'uint8');
imgData = zeros(cap.getHeight,cap.getWidth,3,'uint8');
imgData(:,:,1) = reshape(rgb(3:4:end),cap.getWidth,[])';
imgData(:,:,2) = reshape(rgb(2:4:end),cap.getWidth,[])';
imgData(:,:,3) = reshape(rgb(1:4:end),cap.getWidth,[])';
imwrite(imgData,'ans2.png')

% Load an image 
I = imread('ans2.png');
%imshow('ans2.png')

% Perform OCR
results = ocr(I);
results.Words;
ans2=strjoin(results.Words);

%% Answer 3

% Take screen capture 
robot = java.awt.Robot();
rect = java.awt.Rectangle(pos_ans3(1),pos_ans3(2),pos_ans3(3),pos_ans3(4));
cap = robot.createScreenCapture(rect);

% Convert to an RGB image
rgb = typecast(cap.getRGB(0,0,cap.getWidth,cap.getHeight,[],0,cap.getWidth),'uint8');
imgData = zeros(cap.getHeight,cap.getWidth,3,'uint8');
imgData(:,:,1) = reshape(rgb(3:4:end),cap.getWidth,[])';
imgData(:,:,2) = reshape(rgb(2:4:end),cap.getWidth,[])';
imgData(:,:,3) = reshape(rgb(1:4:end),cap.getWidth,[])';
imwrite(imgData,'ans3.png')

% Load an image 
I = imread('ans3.png');
%imshow('ans3.png')

% Perform OCR
results = ocr(I);
results.Words;
ans3=strjoin(results.Words);
