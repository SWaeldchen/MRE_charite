function [db10_lo, db10_hi] = getdb10

db10_lo = [0.22641898, 0.85394354, 1.02432694, 0.19576696, ...
    -0.34265671, -0.04560113, 0.10970265, -0.00882680, ...
    -0.01779187, 4.71742793e-3];

db10_hi = fliplr(db10_lo);
db10_hi(2:2:end) = -1*db10_hi(2:2:end);

    
    