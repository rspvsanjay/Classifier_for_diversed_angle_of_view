path1='H:\090\';
list1 = dir(path1);
fName1 = {list1.name};
[~,y1]=size(fName1);
path1
group1=cell(1,1);
train=[];
temp =[];
for num1 = 65:y1
    path2 = char(strcat(path1,fName1(num1),'\'));
    list2 = dir(path2);
    fName2 = {list2.name};
    [~,y2]=size(fName2);
    fName1(num1)
    for num2 = 9:y2
        path3 = char(strcat(path2,fName2(num2),'\'));
        list3 = dir(path3);
        fName3 = {list3.name};
        [~,y3]=size(fName3);
        
        for num3 = 8%3:y3
            path4 = char(strcat(path3,fName3(num3),'\'));
            list4 = dir(path4);
            fName4 = {list4.name};
            [~,y4]=size(fName4);
            
            for num4 = 3:y4
                path5 = char(strcat(path4,fName4(num4)));
                group1{1} = [group1{1},num1-2];
                Image = imread(char(strcat(path5)));
                temp=Image(:);
                train=[train; double(temp')];
            end
            
        end        
    end
end

[coeff,score,~,~,explained] = pca(train);
sm = 0;
no_components = 0;
for k = 1:size(explained,1)
    sm = sm+explained(k);
    if sm <= 99.4029
        no_components= no_components+1;
    end
end
m = mean(train,1);
mat1 = score(:,1:no_components);

acc = [];
for num=3:13
test1= [];
group2=cell(1,1);
predicted_class = [];
for num1 = 65:y1
    path2 = char(strcat(path1,fName1(num1),'\'));
    list2 = dir(path2);
    fName2 = {list2.name};
    [~,y2]=size(fName2);
%     fName1(num1)
    for num2 = 7:8%9:y2
        path3 = char(strcat(path2,fName2(num2),'\'));
        list3 = dir(path3);
        fName3 = {list3.name};
        [~,y3]=size(fName3);
        
        for num3 = num%3:y3
            path4 = char(strcat(path3,fName3(num3),'\'));
            list4 = dir(path4);
            fName4 = {list4.name};
            [~,y4]=size(fName4);
            group2{1} = [group2{1},num1-2];
            classes = [];
            probabilities = [];
            for num4 = 3:y4
                path5 = char(strcat(path4,fName4(num4)));                
                Image = imread(char(strcat(path5)));
                Img_mean = double(Image(:)')-m;
                Img_proj = Img_mean*coeff;
                test_features = Img_proj(:,1:no_components);
                [class,err,POSTERIOR] = classify(test_features,mat1,group1{1},'diaglinear');
                classes = [classes,class];
                [max1,index] = max(POSTERIOR);
                probabilities = [probabilities,max1];
            end
            unique_cl = unique(classes);
            sum_prob = [];
            for number1=1:length(unique_cl)
                p = 0;
                for number2 = 1:length(classes)
                    if unique_cl(number1)==classes(number2)
                        p = p+probabilities(number2);
                    end
                end
                sum_prob = [sum_prob,p];
            end
            [max1,index] = max(sum_prob);
            predicted_class = [predicted_class,unique_cl(index)];
        end        
    end
end
 
accuracy = 0;
for number=1:length(predicted_class)
    if predicted_class(number)==group2{1}(number)
        accuracy = accuracy+1;
    end
end

disp("Result for nm to nm");
(accuracy*100)/length(predicted_class)
total = (accuracy*100)/length(predicted_class);
acc = [acc,total];
end
acc

