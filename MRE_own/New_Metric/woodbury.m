function [ Res ] = woodbury(A, C, U, V)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


Test = inv(A + U*(C\V));

Res = inv(A) - inv(A)*U*inv(C + V*inv(A)*U)*V*inv(A);

testRes = norm(Test - Res)


end

