clear all; 
close all; 
clc; global camera; % close, delete and clean the executed application.

adaptor = 'gentl'; device = 1; format = 'mono8'; % settings parameters of the acquisition device.
camera = videoinput(adaptor,device,format); % create object instance of monochrome usb 3.0 camera.
properties = getselectedsource(camera); % extracting camera properties.
camera.FramesPerTrigger = 1; % set amount frames captured on each camera trigger shot.
resolution = get(camera,'videoresolution'); % obtain resolution of the acquisition device.
bands = get(camera,'numberofbands'); % it's number of color bands in the data to be acquired.
properties.ExposureTime = 33000; % light penetrates the camera and reaches the digital sensor.
height = image(zeros(resolution(2),resolution(1),bands)); % estimate height that you must have preview.
window = figure(1); preview(camera,height); % new figure inserted to store the camera preview data.
set(window,'keypressfcn',@keyboardpress); % link the control method from keyboard to current window.

function keyboardpress(src,event), global camera
    disp(event.Key); % display the key selected by the user on the screen.
    switch event.Key 
        case 'leftarrow' % execute this action if the left arrow has been selected.
            stoppreview(camera); % stop image acquisition through the usb3 camera.
        case 'rightarrow' % execute this action if the right arrow has been selected.
            frame = getsnapshot(camera); % extract current frame and save output as PNG.
            imwrite(frame, strcat('acquired',num2str(rand(1)),'.PNG'));
    end
end
