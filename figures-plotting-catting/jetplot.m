function h = jetplot(x, BOUNDS)

if nargin < 2
    BOUNDS = [0 0 900 600];
end
sz = size(x);

h = figure('visible','off','position', BOUNDS);
hold on;
for n = 1:sz(2)
    plot(x(:,n), 'color', get_color(n, sz(2)));
end
hold off;

end
    
    
    
function color = get_color(entry_num, total_entries)
  %{
  one_third = round(total_entries / 3);
  two_thirds = one_third*2;
  r_val = min(entry_num/one_third, 1);
  g_val = max(min((entry_num - one_third)/one_third, 1),0);
  b_val = max(min((entry_num - two_thirds)/one_third, 1),0);
  color = [r_val, g_val, b_val];
  %}
  total_adj = total_entries*2+1;
  cmap = colormap(jet(total_adj));
  color = cmap(entry_num*2,:); % WATCH OUT FOR ENTRY NUM OF ZERO!!
end    
