%Input importance
%2. olarak bu dosya calistirilir
%Optimum tree ismi t yazan yerlere konulacak. Orjinal budanmamamis tree ismi t, budanmis treeler t1, t2, t3... seklinde isimlendiriliyo

imp = predictorImportance(t1);

figure;
bar(imp);
title('Predictor Importance Estimates');
ylabel('Estimates');
xlabel('Predictors');
h = gca;
h.XTickLabel = t1.PredictorNames;
h.XTickLabelRotation = 90;
set(gca,'XTick',1:1:65);
h.TickLabelInterpreter = 'none';

view(t1,'Mode','graph')

open Summary
save (strcat(reportname))

% filename = 'confmat.xlsx';
% xlswrite(filename, imp','table','b2:b44')
% dagg={'SM7','SKY7','W29','A101','PO1G','MUCL28849','LFMB20','LGAM S71','ACA-DC 50109','Gut2-PoxI-6GPD1','Pox1-6 GOD1+','Pold GPD1','Gut2-Pox1-6','Gut2','MTYL085','YPD','YPCG','YNB','DRBH','DSCBH','NDSCBH','PDA','YPDA','OMW','Desktop fermenter','Stirred tank','Bioreactor','Erlenmeyer Flask','Batch','Fed Batch','Yeast Extract','Dextrose','Agar','Glucose','Growth Temperature(C)','Total Cultivation Time(days)','Fermenter Volume(L)','Fermenter Working Volume(L)','Fermenter Mixing Speed(rpm)','Fermentation pH','time'};
% xlswrite(filename, dagg','table','a2:a44')