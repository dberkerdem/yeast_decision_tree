% Kesme yeri otomatik saptandiktan sonra 2. olarak bu dosya calisir
set(0,'RecursionLimit',10000)

clc
clear all
close all

load YeastData; % Data getiriliyor
n=size(Y,2); % Toplam data sayisi hesaplaniyor = 309
reportname='tree2cat'; % Rapora isim veriliyor

output_numeric=Y'; % Datanin tamaminin içinden "output" datasi aliniyor

%Output belirli araliklara göre kategorize ediliyor

%High Low
% for i=1:n
%       % 8.2 OUTPUTUN (Biomass) ortanca deðeri
%   if output_numeric(i)<8.2
%         if output_numeric(i)>=-100
%             output_categoric(i)={'low'};
%         end
%   end
%   
%   if output_numeric(i)<=10000
%         if output_numeric(i)>=8.2
%             output_categoric(i)={'high'};
%         end
%   end    
%   
% end

% High Medium Low
for i=1:n
      % 8.2 OUTPUTUN (Biomass) ortanca deðeri
  if output_numeric(i)<4.06
        if output_numeric(i)>=-100
            output_categoric(i)={'low'};
        end
  end
  if output_numeric(i)<18.4
        if output_numeric(i)>=4.06
            output_categoric(i)={'medium'};
        end
  end
  if output_numeric(i)<=10000
        if output_numeric(i)>=18.4
            output_categoric(i)={'high'};
        end
  end    
  
end

output_categoric=output_categoric'; % satýr

input_full=X'; %sütun

all_no=size(input_full,1); %Calisilacak toplam data sayisi bulunuyor

train_no=round(all_no*2/3); %"Data Training" icin kullanilacak data sayisi (Toplam Datanin 2/3'u kadar)
%train_no=256;
test_no=round(all_no/3); %"Test Training" icin kullanilicak data sayisi  (Toplam Datanin 1/3'u kadar)
%test_no=302-256;
%randompoints=[1:1:302];
%randompoints=randperm(train_no+test_no);
load('R5.mat')
Train=randompoints(1:train_no); % Training icin ayrilacak veriler rastgele secilir 
Test=randompoints(train_no+1:train_no+test_no); % Testing icin ayrilacak veriler geri kalanlarÄ± olacaktÄ±r

for i=1:train_no
    input_train(i,:)=input_full(Train(i),:);
    output_train(i,:)=output_categoric(Train(i),:);
end
for i=1:test_no
    input_test(i,:)=input_full(Test(i),:);
    output_test(i,:)=output_categoric(Test(i),:);
end
%En kritik komuttur. 
%Sadece "0" ve "1" degerine sahip olan parametreler [ ] iÃ§ine yazilir
%"{ }" iÃ§inde her parametreye denk gelen isimler " ' ' " iÃ§inde yazilir
%"Minleafsize" her bir branchta ne kadar minimum data olmasi gerektigini gosterir, maxnumofsplits maximum izin verilen dal sayisidir. Bu iki degerle oynayabiliriz
%t = fitctree(input_train,output_train,'CategoricalPredictors',[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31],'Surrogate','all','MinLeafSize',1,'MaxNumSplits',40);  

t = fitctree(input_train,output_train,'CategoricalPredictors',[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30],'PredictorNames',{'SM7','SKY7','W29','A101','PO1G','MUCL28849','LFMB20','LGAM S71','ACA-DC 50109','Gut2-PoxI-6GPD1','Pox1-6 GOD1+','Pold GPD1','Gut2-Pox1-6','Gut2','MTYL085','YPD','YPCG','YNB','DRBH','DSCBH','NDSCBH','PDA','YPDA','OMW','Desktop fermenter','Stirred tank','Bioreactor','Erlenmeyer Flask','Batch','Fed Batch','Yeast Extract','Dextrose','Agar','Glucose','Growth Temperature(C)','Total Cultivation Time(days)','Fermenter Volume(L)','Fermenter Working Volume(L)','Fermenter Mixing Speed(rpm)','Fermentation pH','time'},'Surrogate','all','MinLeafSize',1,'MaxNumSplits',30); 

 


%BURADA BUDANMAMIS ANA TREE BULUNUYOR ve ASAGIDA BU TREE'NIN ERROR ANALIZI VAR

%Training data error analizi
yfit = predict(t,input_train);
Results_train=[output_train,yfit];
count=0;
% "strcmp" compares the strings and returns logical 1 (true) if they are identical, and returns logical 0 (false) otherwise
TF = strcmp(Results_train(:,1), Results_train(:,2));
error_train(1)=(train_no-sum(TF))/train_no*100;
%Test data error analizi
yfit = predict(t,input_test);
Results_test=[output_test,yfit];
count=0;
% "strcmp" compares the strings and returns logical 1 (true) if they are identical, and returns logical 0 (false) otherwise
TF = strcmp(Results_test(:,1), Results_test(:,2));
error_test(1)=(test_no-sum(TF))/test_no*100;
nod(1)=t.NumNodes;

%Custom Pruning Level 1
t1 = prune(t,'level',1);
%Training data error analizi
yfit = predict(t1,input_train);
Results_train1=[output_train,yfit];
count=0;
% "strcmp" compares the strings str1 and str2 and returns logical 1 (true) if they are identical, and returns logical 0 (false) otherwise
TF = strcmp(Results_train1(:,1), Results_train1(:,2));
error_train(2)=(train_no-sum(TF))/train_no*100;
%Test data error analizi
yfit = predict(t1,input_test);
Results_test1=[output_test,yfit];
count=0;
% "strcmp" compares the strings str1 and str2 and returns logical 1 (true) if they are identical, and returns logical 0 (false) otherwise
TF = strcmp(Results_test1(:,1), Results_test1(:,2));
error_test(2)=(test_no-sum(TF))/test_no*100;
nod(2)=t1.NumNodes;

%Custom Pruning Level 2
t2 = prune(t,'level',2);
%Training data error analizi
yfit = predict(t2,input_train);
Results_train2=[output_train,yfit];
count=0;
% "strcmp" compares the strings str1 and str2 and returns logical 1 (true) if they are identical, and returns logical 0 (false) otherwise
TF = strcmp(Results_train2(:,1), Results_train2(:,2));
error_train(3)=(train_no-sum(TF))/train_no*100;
%Test data error analizi
yfit = predict(t2,input_test);
Results_test2=[output_test,yfit];
count=0;
% "strcmp" compares the strings str1 and str2 and returns logical 1 (true) if they are identical, and returns logical 0 (false) otherwise
TF = strcmp(Results_test2(:,1), Results_test2(:,2));
error_test(3)=(test_no-sum(TF))/test_no*100;
nod(3)=t2.NumNodes;

%Custom Pruning Level 3
t3 = prune(t,'level',3);
%Training data error analizi
yfit = predict(t3,input_train);
Results_train3=[output_train,yfit];
count=0;
% "strcmp" compares the strings str1 and str2 and returns logical 1 (true) if they are identical, and returns logical 0 (false) otherwise
TF = strcmp(Results_train3(:,1), Results_train3(:,2));
error_train(4)=(train_no-sum(TF))/train_no*100;
%Test data error analizi
yfit = predict(t3,input_test);
Results_test3=[output_test,yfit];
count=0;
% "strcmp" compares the strings str1 and str2 and returns logical 1 (true) if they are identical, and returns logical 0 (false) otherwise
TF = strcmp(Results_test3(:,1), Results_test3(:,2));
error_test(4)=(test_no-sum(TF))/test_no*100;
nod(4)=t3.NumNodes;

%Custom Pruning Level 4
t4 = prune(t,'level',4);
%Training data error analizi
yfit = predict(t4,input_train);
Results_train4=[output_train,yfit];
count=0;
% "strcmp" compares the strings str1 and str2 and returns logical 1 (true) if they are identical, and returns logical 0 (false) otherwise
TF = strcmp(Results_train4(:,1), Results_train4(:,2));
error_train(5)=(train_no-sum(TF))/train_no*100;
%Test data error analizi
yfit = predict(t4,input_test);
Results_test4=[output_test,yfit];
count=0;
% "strcmp" compares the strings str1 and str2 and returns logical 1 (true) if they are identical, and returns logical 0 (false) otherwise
TF = strcmp(Results_test4(:,1), Results_test4(:,2));
error_test(5)=(test_no-sum(TF))/test_no*100;
nod(5)=t4.NumNodes;

%Custom Pruning Level 5
t5 = prune(t,'level',5);
%Training data error analizi
yfit = predict(t5,input_train);
Results_train5=[output_train,yfit];
count=0;

% "strcmp" compares the strings str1 and str2 and returns logical 1 (true) if they are identical, and returns logical 0 (false) otherwise
TF = strcmp(Results_train5(:,1), Results_train5(:,2));
error_train(6)=(train_no-sum(TF))/train_no*100;

%Test data error analizi
yfit = predict(t5,input_test);
Results_test5=[output_test,yfit];
count=0;

% "strcmp" compares the strings str1 and str2 and returns logical 1 (true) if they are identical, and returns logical 0 (false) otherwise
TF = strcmp(Results_test5(:,1), Results_test5(:,2));
error_test(6)=(test_no-sum(TF))/test_no*100;
nod(6)=t5.NumNodes;

%Custom Pruning Level 6
t6 = prune(t,'level',6);
%Training data error analizi
yfit = predict(t6,input_train);
Results_train6=[output_train,yfit];
count=0;

% "strcmp" compares the strings str1 and str2 and returns logical 1 (true) if they are identical, and returns logical 0 (false) otherwise
TF = strcmp(Results_train6(:,1), Results_train6(:,2));
error_train(7)=(train_no-sum(TF))/train_no*100;

%Test data error analizi
yfit = predict(t6,input_test);
Results_test6=[output_test,yfit];
count=0;

% "strcmp" compares the strings str1 and str2 and returns logical 1 (true) if they are identical, and returns logical 0 (false) otherwise
TF = strcmp(Results_test6(:,1), Results_test6(:,2));
error_test(7)=(test_no-sum(TF))/test_no*100;
nod(7)=t6.NumNodes;

%Custom Pruning Level 7
t7 = prune(t,'level',7);
%Training data error analizi
yfit = predict(t7,input_train);
Results_train7=[output_train,yfit];
count=0;

% "strcmp" compares the strings str1 and str2 and returns logical 1 (true) if they are identical, and returns logical 0 (false) otherwise
TF = strcmp(Results_train7(:,1), Results_train7(:,2));
error_train(8)=(train_no-sum(TF))/train_no*100;

%Test data error analizi
yfit = predict(t7,input_test);
Results_test7=[output_test,yfit];
count=0;

% "strcmp" compares the strings str1 and str2 and returns logical 1 (true) if they are identical, and returns logical 0 (false) otherwise
TF = strcmp(Results_test7(:,1), Results_test7(:,2));
error_test(8)=(test_no-sum(TF))/test_no*100;
nod(8)=t7.NumNodes;

%Custom Pruning Level 8
t8 = prune(t,'level',8);
%Training data error analizi
yfit = predict(t8,input_train);
Results_train8=[output_train,yfit];
count=0;

% "strcmp" compares the strings str1 and str2 and returns logical 1 (true) if they are identical, and returns logical 0 (false) otherwise
TF = strcmp(Results_train8(:,1), Results_train8(:,2));
error_train(9)=(train_no-sum(TF))/train_no*100;

%Test data error analizi
yfit = predict(t8,input_test);
Results_test8=[output_test,yfit];
count=0;

% "strcmp" compares the strings str1 and str2 and returns logical 1 (true) if they are identical, and returns logical 0 (false) otherwise
TF = strcmp(Results_test8(:,1), Results_test8(:,2));
error_test(9)=(test_no-sum(TF))/test_no*100;
nod(9)=t8.NumNodes;

%Custom Pruning Level 9
t9 = prune(t,'level',9);
%Training data error analizi
yfit = predict(t9,input_train);
Results_train9=[output_train,yfit];
count=0;

% "strcmp" compares the strings str1 and str2 and returns logical 1 (true) if they are identical, and returns logical 0 (false) otherwise
TF = strcmp(Results_train9(:,1), Results_train9(:,2));
error_train(10)=(train_no-sum(TF))/train_no*100;

%Test data error analizi
yfit = predict(t9,input_test);
Results_test9=[output_test,yfit];
count=0;

% "strcmp" compares the strings str1 and str2 and returns logical 1 (true) if they are identical, and returns logical 0 (false) otherwise
TF = strcmp(Results_test9(:,1), Results_test9(:,2));
error_test(10)=(test_no-sum(TF))/test_no*100;
nod(10)=t9.NumNodes;


%Custom Pruning Level 10
t10 = prune(t,'level',10);
%Training data error analizi
yfit = predict(t10,input_train);
Results_train10=[output_train,yfit];
count=0;

% "strcmp" compares the strings str1 and str2 and returns logical 1 (true) if they are identical, and returns logical 0 (false) otherwise
TF = strcmp(Results_train10(:,1), Results_train10(:,2));
error_train(11)=(train_no-sum(TF))/train_no*100;

%Test data error analizi
yfit = predict(t10,input_test);
Results_test10=[output_test,yfit];
count=0;

% "strcmp" compares the strings str1 and str2 and returns logical 1 (true) if they are identical, and returns logical 0 (false) otherwise
TF = strcmp(Results_test10(:,1), Results_test10(:,2));
error_test(11)=(test_no-sum(TF))/test_no*100;
nod(11)=t10.NumNodes;
%BURADAN SONRA TREE SIZE VS ERROR CIZILIYOR
figure(2)
plot(nod,error_test, 'g-o',nod,error_train, 'b-o')
ylabel('Error%')
xlabel('Number of Leaves')
legend('Test','Train')
%Her bir noddaki errorlar
e =t.NodeError;
sizes = t.NodeSize;
number_of_nodes = t.NumNodes;
Summary=[nod',error_train',error_test'];

lows=strcmp(output_categoric(:),'low');
mids=strcmp(output_categoric(:),'medium');
highs=strcmp(output_categoric(:),'high');
lownumber=sum(lows)
mediumnumber=sum(mids)
highnumber=sum(highs)
open Summary %Summary dosyasinin ilk kolonu yaprak sayisi, ikinci kolon training, ucuncu kolon testing error
save Summary
%treelerden herhangi birini gormek icin view(tx,'Mode','graph') komutunu vermeliyiz
view(t1,'Mode','graph') %optimum tree
%view(t,'Mode','graph') %Ornekolarak budanmamis tree'yi koyuyorum