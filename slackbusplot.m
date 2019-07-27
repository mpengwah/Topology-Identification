clc;clear all;
load datareal
figure;
h = plot((0:5:1999*5)/60,Va(1,1:2000),'Color',[0 0.1 0.9],'LineWidth',1.25)
set(gca,'FontSize',12,'FontName', 'Times New Roman')
ylabel('Estimated Slack Bus Voltage')%,'FontSize',20,'FontName','Times New Roman','FontWeight','bold')
xlabel('Time (h)')%,'FontSize'),20,'FontName','Times New Roman','FontWeight','bold')
 xlim([0 160])
 ylim([min(Va(1,1:2000))-0.5 max(Va(1,1:2000))+0.5])
ax = gca;
outerpos = ax.OuterPosition;
ti = ax.TightInset; 
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3);
ax_height = outerpos(4) - ti(2) - ti(4);
ax.Position = [left bottom ax_width ax_height-0.05];