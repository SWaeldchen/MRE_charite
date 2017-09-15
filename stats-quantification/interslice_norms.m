function norms = interslice_norms(s, mask, NORM)

    if ~iscomplex(s)
        disp('This method is for complex data')
        return
    end
    
    if ~islogical(mask)
        disp('Method requires logical mask')
        return
    end
    
    % set constants
    if nargin < 3
     NORM = 2;
    end

                
    szs = size(s);
    % reshape Nd to 4d
    num_vols = prod(szs(4:end));
    s_resh = reshape(s, [szs(1) szs(2) szs(3) num_vols]);
    % make struct for stats
    num_slices = szs(3);
    norms = zeros(num_slices - 1, num_vols);
    % dejitter each volume
    for n = 1:num_vols
        norms(:,n) = get_norms_vol(s(:,:,:,n), mask, NORM);
    end
    
end

function norms = get_norms_vol(s, mask, NORM)
    szs = size(s);
    num_slices = szs(3);
    % stats
    norms = zeros(num_slices - 1, 1);
    % second slice is first order
    norms(1) = get_norm_firstord(s(:,:,1), s(:,:,2), mask(:,:,2), NORM); % linear for second slice
    % march through remaining slices
    for n = 3:num_slices
        next_slice = s(:,:,n);
        current_slice = s(:,:,n-1);
        prev_slice = s(:,:,n-2);
        norms(n-1) = get_norm(next_slice, current_slice, prev_slice, mask(:,:,n), NORM);
    end
end
   
function n = get_norm(next_slice, curr_slice, prev_slice, mask, NORM)
        second_order_diff = angle( (next_slice(mask) ./ curr_slice(mask)) .* (prev_slice(mask) ./ curr_slice(mask)) );
        %n = norm(second_order_diff(:), NORM);
        n = norm(second_order_diff(:), NORM) ./ numel(second_order_diff);
end

function n = get_norm_firstord(next_slice, curr_slice, mask, NORM)
        % phase arithmetic
        first_order_diff = angle(next_slice(mask) ./ curr_slice(mask));
        n = norm(first_order_diff(:), NORM);
end
