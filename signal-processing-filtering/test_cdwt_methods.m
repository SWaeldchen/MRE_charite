function [mag] = test_cdwt_methods(dataset)

mag = cell(4, 1);
mag{1} = ESP_v0_52(dataset, [20 25 30], .002, 0, 0, 0, 0, 0);
mag{2} = ESP_v0_52(dataset, [20 25 30], .002, 0, 0, 0, 1, 0);
mag{3} = ESP_v0_52(dataset, [20 25 30], .002, 0, 0, 0, 2, 0);
mag{4} = ESP_v0_52(dataset, [20 25 30], .002, 0, 0, 0, 3, 0);
