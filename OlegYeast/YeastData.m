clc
clear all 
close all

X=xlsread('Olegyeast.xlsx','MatlabData','f3:at304'); %Input Data
Y=xlsread('Olegyeast.xlsx','MatlabData','au3:au304'); %Output Data

X=X';
Y=Y';

save YeastData