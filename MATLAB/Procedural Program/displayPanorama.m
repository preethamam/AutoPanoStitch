function [allPanoramas, croppedPanoramas] = displayPanorama(finalPanoramaTforms, imageNeighbors, input, ...
                                                images, concomps, myImg, datasetName)

    %%***********************************************************************%
    %*                   Automatic panorama stitching                       *%
    %*                        Display panorama                              *%
    %*                                                                      *%
    %* Code author: Preetham Manjunatha                                     *%
    %* Github link: https://github.com/preethamam                           *%
    %* Date: 01/27/2022                                                     *%
    %************************************************************************%
    
    % Initialize
    allPanoramas = cell(1,length(finalPanoramaTforms));
    croppedPanoramas = cell(1,length(finalPanoramaTforms));
    
    for ii = 1:length(finalPanoramaTforms)
            % Create and display panorama
            [panorama, gainpanorama, noBlendCompensationPanorama, gainImages, ...
                gainRGB, warpedImages, xCorrect, yCorrect] = ...
                renderPanorama(input, images, imageNeighbors{ii}, finalPanoramaTforms{ii}, concomps, ii);
            
            % Final panorama cropper
            croppedImage = panoramaCropper(input, panorama);   
            
            % Store panoramas
            allPanoramas{ii}     = panorama;
            croppedPanoramas{ii} = croppedImage;
            
            if input.displayPanoramas
                % Full panorama
                figure('Name','Full panorama image');
                imshow(panorama)
    
                % Plot the bounding boxes
                figure('Name','Cropped panorama image');
                imshow(croppedImage)
                ax = gcf;
                exportgraphics(ax,'pano_crop.jpg')
        
                % Generate a random (bright) color
                lineRGB = mod(rand(size(xCorrect,2),3),100);
                max_channel = max(lineRGB(:,1), max(lineRGB(:,2), lineRGB(:,3)));
                lines_brightRGB = lineRGB ./ max_channel;
                
                % Plot the bounding boxes
                figure('Name','Panorama image with/without bounding polygons');
                imshow(panorama)
                if strcmp(input.warpType,'planar')
                    hold on
                    for i = 1:size(xCorrect,2)
                        plot(xCorrect(:,i), yCorrect(:,i), 'Color', lines_brightRGB(i,:), 'LineWidth', 1)
                        drawnow;
                    end
                    hold off
                end
                
                % Plot the bounding boxes
                figure('Name','Gain compensated panorama image');
                imshow(gainpanorama)
        
                % Plot the bounding boxes
                figure('Name','No gain/blending image');
                imshow(noBlendCompensationPanorama)
            end
    
            % Export the graphics
            % ax = gca;     
            % 
            % if ismac
            %     % Code to run on Mac platform
            %     exportgraphics(ax, fullfile('../../../../../../../Team Work/Team CrackSTITCH/Results/MATLAB Stitch/', [input.warpType '_' input.Transformationtype '_' ...
            %     num2str(myImg) '_' num2str(ii) '_' char(datasetName{myImg}) '.png']),'Resolution',300)
            % elseif isunix
            %     % Code to run on Linux platform
            %     exportgraphics(ax, fullfile(['../../../../../../../Team Work/Team CrackSTITCH/Results/MATLAB Stitch/', input.warpType '_' input.Transformationtype '_'...
            %     num2str(myImg) '_' num2str(ii) '_' char(datasetName{myImg}) '.png']),'Resolution',300)
            % elseif ispc
            %     % Code to run on Windows platform
            %     exportgraphics(ax, fullfile(['..\..\..\..\..\..\..\Team Work\Team CrackSTITCH\Results\MATLAB Stitch\', input.warpType '_'  input.Transformationtype '_' ...
            %     num2str(myImg) '_' num2str(ii) '_' char(datasetName{myImg}) '.png']),'Resolution',300)
            % else
            %     disp('Platform not supported')
            % end
            % 
            % ax = gcf;
            % exportgraphics(ax,'pano_full.jpg')
    
            % if ismac
            %     % Code to run on Mac platform
            %     imwrite(panorama, fullfile('../../../../../../../Team Work/Team CrackSTITCH/Results/MATLAB Stitch/', [input.warpType '_' input.Transformationtype '_' ...
            %     num2str(myImg) '_' num2str(ii) '_' char(datasetName{myImg}) '.png']))
            % elseif isunix
            %     % Code to run on Linux platform
            %     imwrite(panorama, fullfile(['../../../../../../../Team Work/Team CrackSTITCH/Results/MATLAB Stitch/', input.warpType '_' input.Transformationtype '_' ...
            %     num2str(myImg) '_' num2str(ii) '_' char(datasetName{myImg}) '.png']))
            % elseif ispc
            %     % Code to run on Windows platform
            %     imwrite(panorama, fullfile(['..\..\..\..\..\..\..\Team Work\Team CrackSTITCH\Results\MATLAB Stitch\', input.warpType '_' input.Transformationtype '_' ...
            %     num2str(myImg) '_' num2str(ii) '_' char(datasetName{myImg}) '.png']))
            % else
            %     disp('Platform not supported')
            % end
    
            if ismac
                % Code to run on Mac platform
                imwrite(panorama, [input.warpType '_' input.Transformationtype '_' ...
                num2str(myImg) '_' num2str(ii) '_' char(datasetName{myImg}) '.png'])
            elseif isunix
                % Code to run on Linux platform
                imwrite(panorama, [input.warpType '_' input.Transformationtype '_' ...
                num2str(myImg) '_' num2str(ii) '_' char(datasetName{myImg}) '.png'])
            elseif ispc
                % Code to run on Windows platform
                imwrite(panorama, [ input.warpType '_' input.Transformationtype '_' ...
                num2str(myImg) '_' num2str(ii) '_' char(datasetName{myImg}) '.png'])
            else
                disp('Platform not supported')
            end
    end
end