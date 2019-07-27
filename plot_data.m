clc;close all
clear all;

load plot1
figure;
plot(Spa(:),'o')%,'LineWidth',1.25,'Color',[0 0 1],'Marker','.');
grid on; hold on;
plot(Yp_unfilt(:),'s')%,'LineWidth',1.25,'Color',[1 0 0],'MArker','.')%,'Marker','o');
plot(Yp_filt(:),'d')%,'LineWidth',2,'Color','k','Marker','.');
 xlim([0 14*14+1])

set(gca,'FontSize',12,'FontName', 'Times New Roman')
t= legend('Using Power Formulation in [9]','Using Current Formulation without Filtering','Using Current Formulation After Filtering')
t.Position = [0.33 0.8284 0.3982 0.0919]
xlabel('Position in Resistance Matrix')%,'FontSize')%,12,'FontName','Times New Roman')
ylabel('Resistance, \Omega')%,'FontSize'),12,'FontName','Times New Roman')
ax = gca;
outerpos = ax.OuterPosition;
ti = ax.TightInset; 
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3);
ax_height = outerpos(4) - ti(2) - ti(4);
ax.Position = [left bottom ax_width ax_height];
