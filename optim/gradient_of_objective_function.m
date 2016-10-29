function g2 = gradient_of_objective_function(y, x, lambda, epsilon)
    del_J = grad_J(y, epsilon);
    g2 = y-x+lambda*del_J;
end
    