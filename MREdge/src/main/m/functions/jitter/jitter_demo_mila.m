load('time_series');
NORM = 0.5;
ts_d = dejitter_phase(ts, NORM);
compare_time_series(ts, ts_d);