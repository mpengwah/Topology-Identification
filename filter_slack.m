clc;clear all;close all
%Written By Pengwah Abu
load datareal

%prior to filter
i = diff(Ia,1,2);
v = diff(Va,1,2);
scatter(i(:),v(:))
set(gca,'FontSize',12,'FontName','Times New Roman')
ylim([-10 10]);xlim([-40 40]);grid on
xlabel('\Delta i');ylabel('\Delta v')

upstream = sort([3 7 1 6 2 4]) ; %upstream set of nodes
max(Va(upstream,:));
% plot(ans(1:5000))
Vup = Va(upstream,:); %new voltage matrix consisting of only the upstream voltages
cen_val = 244%244.5;
margin = 1; %margin allowed = 1 V
low = cen_val*(1 - margin / cen_val)
hi = cen_val*(1 + margin / cen_val)

tf = (Vup > low) & (Vup < hi); 
tf = sum(tf);
col = find(tf==6); %check if all the upstream nodes' voltages lie the range required

figure;
Vnew = Va(:,col);
Inew = Ia(:,col);
PFnew = PFa(:,col); %create the filtered matrices
inew = diff(Inew,1,2);
vnew = diff(Vnew,1,2);
scatter(inew(:),vnew(:))
ylim([-10 10]);xlim([-40 40]);grid on
xlabel('\Delta i');ylabel('\Delta v')
title('After Filtering')


%% PHASE B
% %prior to filter
% i = diff(Ib,1,2);
% v = diff(Vb,1,2);
% scatter(i(:),v(:))
% set(gca,'FontSize',12,'FontName','Times New Roman')
% ylim([-10 10]);xlim([-40 40]);grid on
% xlabel('\Delta i');ylabel('\Delta v')
% 
% upstream = sort([1 3 6 7 4]) ;
% max(Vb(upstream,:));
% % plot(ans(1:5000))
% Vup = Vb(upstream,:);
% cen_val = 244.5;
% margin = 1;
% low = cen_val*(1 - margin / cen_val)
% hi = cen_val*(1 + margin / cen_val)
% tf = (Vup > low) & (Vup < hi); 
% tf = sum(tf);
% col = find(tf==6); %number of upstream nodes
% 
% Vnew = Vb(:,col);
% Inew = Ib(:,col);
% inew = diff(Inew,1,2);
% vnew = diff(Vnew,1,2);
% scatter(inew(:),vnew(:))
% ylim([-10 10]);xlim([-40 40]);grid on
% xlabel('\Delta i');ylabel('\Delta v')
% title('After Filtering')
%% Sensitivity
