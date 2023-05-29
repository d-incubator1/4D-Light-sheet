% Despersion Objective Function Calculation

% Parameters Description


% Input
% images: the matrix storing all images of a aticular slice on different
%         time instances
% timeInstances: the array storing the phase locked time indices
%         of all images in the first period
% T_p: period

% Output
% Signal Dispersion Energy

function [energy] = getPeriodMatchEnergy(T_p,images,h_T,numOfImages)

    timeInstances = 0:numOfImages-1; % initialize an array of all time indexes
    timeInstances = timeInstances .* h_T; % convert the array to times
    timeInstances = mod(timeInstances, T_p); % phase lock w.r. to different candidate period
 
    [height, width, ~] = size(images);

    energy = 0;

    [timeInstances_sort, index] = sort(timeInstances , 'ascend'); % sort time instances into ascending order

    for i = 1:numOfImages-1

        buffer = images(:,:,index(i+1)) - images(:,:,index(i)); % subtraction
        buffer = buffer.^2;
        
        timeDiff = timeInstances_sort(i+1) - timeInstances_sort(i);
        timeDiff = timeDiff^2 / T_p^2; % Using T_p to normalize will kill the weight of timeDiff, as the number becomes
                                       % too small compare to image intancity difference, we can come back later to think about this
        
        buffer = buffer + timeDiff;
        energy = energy + sqrt(sum(sum(buffer))); % I implement this line exactly as paper, but I think sqrt() is not necessary
                                                  % We can come back later to compare the difference
    end

