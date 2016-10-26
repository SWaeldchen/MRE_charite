function dualtree_plotall(w, title_)
    figure(); 
    for n = 1:4
            subplot(4, 1, n); 
            hold on;
            r = w{n}{1};
            i = w{n}{2};
            plot(r, 'b', 'LineWidth', 2); 
            plot(i, 'r', 'LineWidth', 2);
            plot(sqrt(r.^2 + i.^2), 'g', 'LineWidth', 1);
            title(['Level ', num2str(n)]);
    end
