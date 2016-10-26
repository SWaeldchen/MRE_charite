function [af, sf] = get_haar

af = zeros(2,2);
af(:,1) = [sqrt(2) sqrt(2)];
af(:,2) = [-sqrt(2) sqrt(2)];
sf = zeros(2,2);
sf(:,1) = [sqrt(2) sqrt(2)];
af(:,2) = [sqrt(2) -sqrt(2)];