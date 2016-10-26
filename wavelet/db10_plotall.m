function db10_plotall(w, title_)
    figure(); 
    for n = 1:4
            if (n == 1)
                 title(title_);
            end
            subplot(4, 1, n); 
            hold on;
            plot(w{n}, 'b', 'LineWidth', 2); 
            title(['Level ', num2str(n)]);

    end
