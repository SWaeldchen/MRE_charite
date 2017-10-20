function [h, outlierID] = singlebox(data,boxcolor,sampleno,axhandle)

% FUNCTION:
%   [h, outlierID] = singlebox(data,boxcolor,sampleno,axhandle)
%
% DESCRIPTION:
%   Create a single box-plot, with sample size, and return handles.
%   This enables combination of boxplots with varying sample sizes.
%   Quartiles are determined using Matlab's prctile() function.
%
% INPUT ARGUMENTS:
%   data     = vector of observations
%   boxcolor = color of box (default is black)   
%   sampleno = sample number (optional)
%   axhandle = handle to target axes (default is gca)
%
% OUTPUT ARGUMENTS:
%   h         = row vector of handles to the line objects making up the box, median, lower whisker, upper whisker, and outliers (if any)
%   outlierID = vector of indices into the original data vector, identifying the outliers
%
% Author: D.J. van Gerwen
% Created: 31-Mar-2011


% Process input arguments
if nargin < 4 % No axis handle specified
    axhandle = gca;
end
if nargin < 3 % No sample number specified
    lastsampleno = get(axhandle,'userdata'); % Last sample number is stored in userdata
    if isempty(lastsampleno)
        sampleno = 1;
    else
        sampleno = lastsampleno + 1; % Append
    end
end
if nargin < 2 % No box color specified
    boxcolor = 'k';
end
if nargin < 1 % No data specified: create example
    data = 4 + 1*randn(1,30); % Create some pseudo-random data: mu + sigma*randn
    data = [10 data -1] % Intentionally add some outliers
end

% Specify box parameters (hard coded for now...)
bw = 0.2; % Box width [-]
ww = bw/2; % Whisker width [-]

% Store sample number in axes' userdata property for later reference
set(axhandle,'userdata',sampleno)

% Determine sample size
n = length(data); % Sample size [-]

% Determine quartiles
quartiles = prctile(data,[25 50 75]); % Quartiles, i.e. Q1, Q2 (median), and Q3

% Identify outliers
[data, sortindex] = sort(data,'ascend'); % Sort data in ascending order
IQR = range(quartiles); % Determine inter-quartile range (i.e. Q3-Q1)
upperlim = quartiles(3) + 1.5*IQR; % Upper limit for classifying outliers
lowerlim = quartiles(1) - 1.5*IQR; % Lower limit for classifying outliers
upperwhiskerindex = find( data <= upperlim, 1, 'last' ); % Index of last observation still within 1.5*IQR from Q3 (NOTE: data must be sorted)
lowerwhiskerindex = find( data >= lowerlim, 1, 'first' ); % Index of first observation still within 1.5*IQR from Q1 (NOTE: data must be sorted)
nonoutlierindex = lowerwhiskerindex:upperwhiskerindex; % Indices to all data values that are NOT outliers
outlierindex = setdiff(1:n,nonoutlierindex); % Indices to data values that are outliers
outlierID = sortindex(outlierindex); % Indices into original UNSORTED data vector 

% Create five-point summary of data, i.e. [min Q1 median Q3 max] 
fivepoint = [min(data(nonoutlierindex)) quartiles max(data(nonoutlierindex))]; % Five point summary

% Select axes
axes(axhandle)


% Box
h(1) = line(sampleno+bw/2*[-1 1 1 -1 -1],fivepoint([4 4 2 2 4]),'linestyle','-','color',boxcolor,'linewidth',2);

% Median
h(2) = line(sampleno+bw/2*[-1 1],fivepoint([3 3]),'linestyle','-','color',boxcolor,'linewidth',2);

% Whiskers
h(3) = line(sampleno+ww/2*[0 0 -1 1],fivepoint([2 1 1 1]),'linestyle','-','color',boxcolor,'linewidth',2);
h(4) = line(sampleno+ww/2*[0 0 -1 1],fivepoint([4 5 5 5]),'linestyle','-','color',boxcolor,'linewidth',2);

% Outliers
if ~isempty(outlierindex)
    h(5) = line(sampleno*ones(1,length(outlierindex)),data(outlierindex),'linestyle','none','marker','+','color',boxcolor,'linewidth',2);
    for i = 1:length(outlierindex)
        outliertext{i} = num2str( outlierID(i) );
    end
    text(sampleno*ones(1,length(outlierindex))+0.1,data(outlierindex),outliertext)
end
    
% Update axis limits
axisold = axis; % get axis limits
axis([0 max(sampleno+1,axisold(2)) min(min(data)*1.1,axisold(3)) max(max(data)*1.1,axisold(4)) ]) % Set new axis limits based on old ones and on new data
if exist('axiszero','file')
    axiszero(2) % Set y-axis limits so that zero is included in the interval
end

% Update tick values and tick labels
xtick = 0:max(sampleno+1,axisold(2)); % Define tick labels
if iscell(get(axhandle,'xticklabel')) 
    xticklabel = get(axhandle,'xticklabel'); % obtain list of tick label strings, if these exist
end
%xticklabel{xtick==sampleno} = [num2str(sampleno) ' (n=' num2str(n) ')']; % Add string to list of tick labels (or create list)
%set(gca,'xtick',xtick,'xticklabel',xticklabel) % Update ticks and tick labels