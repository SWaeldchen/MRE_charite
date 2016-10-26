function [mag phi] = test_all_interp_methods(U, freqs, spacing, twoD)

[mag_4x_1 phi_4x_1] = ESP_v0_3(U, freqs, spacing, twoD, 4, 1);
[mag_4x_2 phi_4x_2] = ESP_v0_3(U, freqs, spacing, twoD, 4, 2);
[mag_4x_3 phi_4x_3] = ESP_v0_3(U, freqs, spacing, twoD, 4, 3);
[mag_4x_4 phi_4x_4] = ESP_v0_3(U, freqs, spacing, twoD, 4, 4);
[mag_4x_5 phi_4x_5] = ESP_v0_3(U, freqs, spacing, twoD, 4, 5);
[mag_4x_6 phi_4x_6] = ESP_v0_3(U, freqs, spacing, twoD, 4, 6);

mag = {mag_4x_1, mag_4x_2, mag_4x_3, mag_4x_4, mag_4x_5, mag_4x_6};
phi = {phi_4x_1, phi_4x_2, phi_4x_3, phi_4x_4, phi_4x_5, phi_4x_6};
