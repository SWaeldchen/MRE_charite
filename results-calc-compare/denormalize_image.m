function newData = denormalize_image(data, mini, maxi);

range = maxi - mini;

newData = data*range - mini;

