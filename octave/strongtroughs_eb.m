function [pks, idx_s] = strongtroughs_eb (data, minH, minD, skip)

if nargin < 4
    skip = 10;
    if nargin < 3
        minD = 4;
        if nargin < 2
            minH = 1;
        end
    end
end

transpose = (size(data,1) == 1);
if (transpose)
data = data.';
end


  % Rough estimates of first and second derivative
  df1 = diff (data, 1); df1 = df1([1; (1:end)']);
  df2 = diff (data, 2); df2 = df2([1; 1; (1:end)']);

  % check for changes of sign of 1st derivative and positivity of 2nd
  % derivative.
  % <= in 1st derivative includes the case of oversampled signals.
  idx = df1.*[df1(2:end); 0] <= 0 & [df2(2:end); 0] > 0;
  
 % Get troughs whose derivs are above a cutoff
  df1_shift = [df1(2:end); 0];
  
  %sd = zeros(100, 1);
  %for n = 11:numel(df1)-10
  %    sd(n) = std(df1(n-10:n+10));
  %end
  %   boundaries
  %sd(sd == 0) = 0;
  
  sd = std(df1);
  idx_red  = idx & (df1_shift > minH.*sd);
  
  % sort according to magnitude
  [~, tmp] = sort (data(idx_red > 0), 'descend');
  idx_f = find(idx_red);
  idx_s = idx_f(tmp);

  % Treat troughs separated less than minD as one
  D = abs (bsxfun (@minus, idx_s, idx_s'));
  if (any (D(:) < minD))

    i = 1; %#ok<NASGU>
    peak = []; %#ok<NASGU>
    node2visit = 1:size(D,1);
    visited = [];
    idx_pruned = idx_s;

    % debug
%    h = plot(1:length(data),data,'-',idx_s,data(idx_s),'.r',idx_s,data(idx_s),'.g');
%    set(h(3),'visible','off');

    while (~ isempty (node2visit))

      d = D(node2visit(1),:);

      visited = [visited node2visit(1)];
      node2visit(1) = [];

      neighs  = setdiff (find (d < minD), visited);
      if (~ isempty (neighs))
        % debug
%        set(h(3),'xdata',idx_s(neighs),'ydata',data(idx_s(neighs)),'visible','on')
%        pause(0.2)
%        set(h(3),'visible','off');

        idx_pruned = setdiff (idx_pruned, idx_s(neighs));

        visited    = [visited neighs];
        node2visit = setdiff (node2visit, visited);

        % debug
%        set(h(2),'xdata',idx_pruned,'ydata',data(idx_pruned))
%        pause
      end

    end
    idx_s = idx_pruned;
  end
  
  pks = data(idx_s);


end
