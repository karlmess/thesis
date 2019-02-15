date_comp = datevec(date);
yyyy = num2str(date_comp(1),4);
mm = num2str(date_comp(2),2);
dd = num2str(date_comp(3),2);
date_label = strcat(yyyy, '_', mm, '_', dd, '_');

G = array2table(training_data);
writetable(G, strcat(date_label, 'train.csv'));

H = array2table(testing_data);
writetable(H, strcat(date_label, 'test.csv'));

I = struct2table(training_label);
writetable(I, strcat(date_label, 'train_label.csv'));

J = struct2table(testing_label);
writetable(J, strcat(date_label, 'test_label.csv'));