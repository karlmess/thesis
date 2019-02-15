function write_results(classifier, testing_data, testing_label, training_data, training_label, title)
    
    test_title = strcat('test_', title, '.csv');
    train_title = strcat('train_', title, '.csv');

    yfit = classifier.predictFcn(testing_data);
    for n=1:size(testing_label,2)
        testing_label(n).prediction = yfit(n);
    end
    T = struct2table(testing_label);
    writetable(T,test_title);
    
    endpoint = size(training_data, 1);
    
    zfit = classifier.predictFcn(training_data(2:endpoint,:));
    for n=1:size(training_label,2)
        training_label(n).prediction = zfit(n);
    end
    Tr = struct2table(training_label);
    writetable(Tr,train_title);
    'Success!'
end