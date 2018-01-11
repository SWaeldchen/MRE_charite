function [s_d, stats] = dejitter_phase_2(s, NORM, TOTAL_SHIFTS)

    if ~iscomplex(s)
        disp('This method is for complex data')
        return
    end
    
    % set constants
    if nargin < 3
        TOTAL_SHIFTS = 256;
        if nargin < 2
         NORM = 2;
        end
    end
                
    szs = size(s);
    % reshape Nd to 4d
    num_vols = prod(szs(4:end));
    s_resh = reshape(s, [szs(1) szs(2) szs(3) num_vols]);
    % make struct for stats
    num_slices = szs(3);
    stats.norms = zeros(num_slices - 1, num_vols);
    stats.distances = zeros(num_slices - 1, num_vols);
    % dejitter each volume
    for n = 1:num_vols
        [s_resh(:,:,:,n), stats.norms(:,n), stats.distances(:,n)] = dejitter_vol(s(:,:,:,n), TOTAL_SHIFTS, NORM);
    end
    % restore original dimensions
    s_d = reshape(s_resh, szs);
end

function [s_d, norms, distances] = dejitter_vol(s, TOTAL_SHIFTS, NORM)
    szs = size(s);
    num_slices = szs(3);
    % stats
    norms = zeros(num_slices - 1, 1);
    distances = zeros(num_slices - 1, 1);
    % accept first slice
    s_d(:,:,1) = s(:,:,1);
    % second slice is first order
    [s_d(:,:,2), norms(1), distances(1)] = dejitter_second_slice(s(:,:,1), s(:,:,2), TOTAL_SHIFTS, NORM); % linear for second slice
    % march through remaining slices
    for n = 3:num_slices
        next_slice = s(:,:,n);
        current_slice = s_d(:,:,n-1);
        prev_slice = s_d(:,:,n-2);
        [s_d(:,:,n), norms(n-1), distances(n-1)] = dejitter_slice(next_slice, current_slice, prev_slice, TOTAL_SHIFTS, NORM);
    end
end
   
function [slice_d, mn, dist] = dejitter_slice(next_slice, current_slice, prev_slice, TOTAL_SHIFTS, NORM)
    shifted_next_slices = get_slice_phase_shifts(next_slice, TOTAL_SHIFTS);
    norms = get_phase_shift_norms(shifted_next_slices, current_slice, prev_slice, TOTAL_SHIFTS, NORM);
    [mn, ind] = min(norms);
    slice_d = shifted_next_slices(:,:,ind);
    dist = get_distance(ind, TOTAL_SHIFTS);
end

function [s2_d, mn, dist] = dejitter_second_slice(s1, s2, TOTAL_SHIFTS, NORM)
    shifted_next_slices = get_slice_phase_shifts(s2, TOTAL_SHIFTS);
    norms = get_phase_shift_norms_firstord(shifted_next_slices, s1, TOTAL_SHIFTS, NORM);
    [mn, ind] = min(norms);
    s2_d = shifted_next_slices(:,:,ind);
    dist = get_distance(ind, TOTAL_SHIFTS);
end

function shifted_slices = get_slice_phase_shifts(slice, TOTAL_SHIFTS)
    szs = size(slice);
    shifted_slices = zeros(szs(1), szs(2), TOTAL_SHIFTS);
    for n = 1:TOTAL_SHIFTS
        shifted_slices(:,:,n) = slice * exp(-2*pi*1i*(n-1)/TOTAL_SHIFTS);
    end
end

function norms = get_phase_shift_norms(shifted_next_slices, curr_slice, prev_slice, TOTAL_SHIFTS, NORM)
    norms = zeros(TOTAL_SHIFTS, 1);
    for n = 1 : TOTAL_SHIFTS
        % phase arithmetic
        second_order_diff = angle( (shifted_next_slices(:,:,n) ./ curr_slice) .* (prev_slice ./ curr_slice) );
        norms(n) = norm(second_order_diff(:), NORM);
    end
end

function norms = get_phase_shift_norms_firstord(shifted_next_slices, curr_slice, TOTAL_SHIFTS, NORM)
    norms = zeros(TOTAL_SHIFTS, 1);
    for n = 1 : TOTAL_SHIFTS
        % phase arithmetic
        first_order_diff = angle(shifted_next_slices(:,:,n) ./ curr_slice);
        norms(n) = norm(first_order_diff(:), NORM);
    end
end

function d = get_distance(ind, TOTAL_SHIFTS)
    d_phase = 2*pi* (ind-1) / TOTAL_SHIFTS;
    d = min(d_phase, 2*pi - d_phase);
    if d ~= d_phase
        d = -d;
    end
end
