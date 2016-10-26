function u_lap = lap_adapt_1d(u, jumps)

u_lap = conv(u, [1 -2 1], 'same');
jumps(jumps <= 2) = [];
jumps(jumps > (numel(u)-2)) = [];
u_lap(jumps-1) = u_lap(jumps-2);
u_lap(jumps+1) = u_lap(jumps+2);