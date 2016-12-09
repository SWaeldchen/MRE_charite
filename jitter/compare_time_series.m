function compare_time_series(ts1, ts2)
if iscomplex(ts1) 
    ts1 = angle(ts1);
    ts2 = angle(ts2);
end
ts1_unwrap = dct_unwrap(ts1);
ts2_unwrap = dct_unwrap(ts2);
sz = size(ts1);
mids = round(sz/2);
ts1_cat = [];
ts1_unwrap_cat = [];
ts2_cat = [];
ts2_unwrap_cat = [];
for n = 1:sz(4)
    ts1_cat = cat(3, ts1_cat, ts1(:,:,:,n));
    ts1_unwrap_cat = cat(3, ts1_unwrap_cat, ts1_unwrap(:,:,:,n));
    ts2_cat = cat(3, ts2_cat, ts2(:,:,:,n));
    ts2_unwrap_cat = cat(3, ts2_unwrap_cat, ts2_unwrap(:,:,:,n));
end
ts1_slice = squeeze(ts1_cat(mids(1),:,:))';
ts2_slice = squeeze(ts2_cat(mids(1),:,:))';
ts1_unwrap_slice = squeeze(ts1_unwrap_cat(mids(1),:,:))';
ts2_unwrap_slice = squeeze(ts2_unwrap_cat(mids(1),:,:))';
figure;
subplot(2, 2, 1); imshow(ts1_slice, []); title('Original time series, cross section');
subplot(2, 2, 2); imshow(ts2_slice, []); title('De-jitter');
subplot(2, 2, 3); imshow(ts1_unwrap_slice, []); title('Original unwrapped');
subplot(2, 2, 4); imshow(ts2_unwrap_slice, []); title('De-jitter unwrapped');