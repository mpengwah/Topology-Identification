%Written By Pengwah Abu Bakr Siddique
%DATE MOD: 4/2/19
%ID: 27195139
%NOTE: This code is for sensitivity matrix calculation version 2

% clc;clear all;

load datafilt
Pnew = Vnew .* Inew .*abs(PFnew);
Qnew = sqrt((Vnew.*Inew).^2 - Pnew.^2).*sign(PFnew);
p = diff(Pnew,1,2); 
q = diff(Qnew,1,2);
v = diff(Vnew,1,2);
K = [p' q'];

n = length(v);
sigma = full(gallery('tridiag',n,-0.5,1,-0.5));

%COEFFICIENTS CALCULATION
Const = K' * inv(sigma);
A = pinv(Const * K) * Const * v';

Sp = -240 * A';
[r,c]=size(Sp);
Spa = Sp(1:c/2,1:c/2)
Sqa = Sp(1:c/2,c/2+1:end)


% figure;
% plot(Spa(:),'LineWidth',1.25,'Color',[0 0 1]);
% grid on;
% set(gca,'FontSize',12,'FontName', 'Times New Roman')
% xlabel('Position in Resistance Matrix')%,'FontSize')%,12,'FontName','Times New Roman')
% ylabel('Resistance \Omega')%,'FontSize'),12,'FontName','Times New Roman')
% hold on
% plot(zeros(1,18*18,1),'Color','r','LineWidth',0.75)
% xlim([0 18*18+1])
% 
% ax = gca;
% outerpos = ax.OuterPosition;
% ti = ax.TightInset; 
% left = outerpos(1) + ti(1);
% bottom = outerpos(2) + ti(2);
% ax_width = outerpos(3) - ti(1) - ti(3);
% ax_height = outerpos(4) - ti(2) - ti(4);
% ax.Position = [left bottom ax_width ax_height];