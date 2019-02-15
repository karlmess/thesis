yfit15 = trainedClassifier15.predictFcn(testing_data);

for n=1:testing_set_size
    G(n)=testing_label(n).ground_truth;
end

ARI15 = RandIndex(yfit15, G);