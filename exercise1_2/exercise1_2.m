close all;
clear;
clc;

data_file = 'data/mnist.mat';

data = load(data_file);

% Read the train data
[train_C1_indices, train_C2_indices,train_C1_images,train_C2_images] = read_data(data.trainX,data.trainY.');

% Read the test data
[test_C1_indices, test_C2_indices,test_C1_images,test_C2_images] = read_data(data.testX,data.testY.');


%% Compute Aspect Ratio for all but one image from each class

for i = 1 : size(train_C1_images,1)
    image = reshape(train_C1_images(i,:,:), 28, 28);
    aRatioTrain1(i) = computeAspectRatio(image, 0);
end

for i = 1 : size(train_C2_images,1)
    image = reshape(train_C2_images(i,:,:), 28, 28);
    aRatioTrain2(i) = computeAspectRatio(image, 0);
end

for i = 1 : size(test_C1_images,1)-1
    image = reshape(test_C1_images(i,:,:), 28, 28);
    aRatioTest1(i) = computeAspectRatio(image, 0);
end

for i = 1 : size(test_C2_images,1)-1
    image = reshape(test_C2_images(i,:,:), 28, 28);
    aRatioTest2(i) = computeAspectRatio(image, 0);
end

% Compute and print the last image from each class
figure(1)
image = reshape(test_C1_images(size(test_C1_images,1),:,:), 28, 28);
aRatioTest1(size(test_C1_images,1)) = computeAspectRatio(image, 1);

figure(2)
image = reshape(test_C2_images(size(test_C2_images,1),:,:), 28, 28);
aRatioTest2(size(test_C2_images,1)) = computeAspectRatio(image, 1);


minAspectRatio1 = min([aRatioTest1, aRatioTrain1]);
maxAspectRatio1 = max([aRatioTest1, aRatioTrain1]);
minAspectRatio2 = min([aRatioTest2, aRatioTrain2]);
maxAspectRatio2 = max([aRatioTest2, aRatioTrain2]);

% Compute the aspect ratios of all images and store the value of the i-th image in aRatios(i)

minAspectRatio = min(minAspectRatio1 , minAspectRatio2)
maxAspectRatio = max(maxAspectRatio1 , maxAspectRatio2)


%% Bayesian Classifier


% Prior Probabilities
PC1 = size(train_C1_images,1)/(size(train_C1_images,1)+size(train_C2_images,1))
PC2 = size(train_C2_images,1)/(size(train_C1_images,1)+size(train_C2_images,1))


% Likelihoods
m1 = 1/size(aRatioTrain1,2)*sum(aRatioTrain1);
m2 = 1/size(aRatioTrain2,2)*sum(aRatioTrain2);
var1 = sqrt(1/size(aRatioTrain1,2)*sum((aRatioTrain1-m1).^2));
var2 = sqrt(1/size(aRatioTrain2,2)*sum((aRatioTrain2-m2).^2));
aRatioTestTotal = [aRatioTest1, aRatioTest2];
Labels = [ones(1, size(aRatioTest1,2)), 2*ones(1, size(aRatioTest2,2))];
PgivenC1 = normpdf(aRatioTestTotal, m1, var1);
PgivenC2 = normpdf(aRatioTestTotal, m2, var2);

% Posterior Probabilities
PC1givenL = PgivenC1 .* PC1./(PgivenC1 .* PC1+PgivenC2 .* PC2);
PC2givenL = PgivenC2 .* PC2./(PgivenC1 .* PC1+PgivenC2 .* PC2);

% Classification result
BayesClass = (PC2givenL>PC1givenL)+1;

% Count misclassified digits
count_errors = sum(Labels ~= BayesClass)

% Total Classification Error (percentage)
Error = count_errors/ size(aRatioTestTotal,2);