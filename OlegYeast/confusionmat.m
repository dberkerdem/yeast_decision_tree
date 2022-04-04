% 3. olarak bu dosya calisir
%Optimum tree ismi t yazan yerlere konulacak. Orjinal budanmamamis tree ismi t, budanmis treeler t1, t2, t3... seklinde isimlendiriliyo

%Bütün data icin node ve error analizi
[yfitall,score,nodeall,cname] = predict(t,input_full);

%Testing icin node ve error analizi
%Once test datasi sort ediliyor
input_test=[Test',input_test];
input_test=sortrows(input_test);
input_test(:,1)=[];
output_test=[num2cell(Test'),output_test];
output_test=sortrows(output_test);
output_test(:,1)=[];

[yfittest,scoretest,nodetest,cname]=predict(t,input_test);

for i=1:n
    accurall(i)=isequal(output_categoric(i),yfitall(i)); %burada gercek output ile tahmin edilen ayni mi kontrol ediliyor
end
Resultsall=[output_categoric,yfitall]; %gercek deger ve tahmin edilen
%Resultsall2=[accurall',nodeall]; %accuracy ve datanin hangi node'a gittigi(bu calisma icin cok da onemli degil, o yuzden inaktif)

for i=1:test_no %test nosu
    accurtest(i)=isequal(output_test(i),yfittest(i)); %burada gercek output ile tahmin edilen ayni mi kontrol ediliyor
end
Resultstest=[output_test,yfittest]; %gercek deger, tahmin edilen
%Resultstest2=[accurtest',nodetest]; %gercek deger, datanin hangi node'a gittigi (bu calisma icin cok da onemli degil, o yuzden inaktif)
Testnosorted=sort(Test');

%open Resultsall
%open Resultsall2
%open Testnosorted
%open Resultstest
%open Resultstest2
filename = 'confmat.xlsx';
xlswrite(filename, Resultsall,'Resultsall','a2:b303')
xlswrite(filename, Resultstest,'Resultstest','a2:b102')
%open confmat.xlsx
