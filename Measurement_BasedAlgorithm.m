%Written By Pengwah Abu Bakr Siddique
%ID: 27195139
%Date Modified: 22/11/18
% clc;clear all
% 
% load data
% load phaseC
close all
Sp = Yp;

dr = zeros(length(Sp));
for i=1:length(Sp)
    for j=1:length(Sp)
        dr(i,j) = Sp(i,i) + Sp(j,j) - 2 * Sp(i,j);
    end
end

D =abs(dr);  %DISTANCE MATRIX

set = 1:length(D);
sib=[];par=[];
A=[];
tol =0.018;
while (length(set)>2)
    %-------------PART A
    %COMPUTING THE PHI VALUES
    x=1;y=1;
    for i=1:length(set)
        for j = i+1:length(set)
            for k = 1:length(set)
                if (set(k) ~=set(i) && set(k) ~= set(j))
                    phi(y,x) = (D(set(i),set(k)) - D(set(j),set(k)));
                    ind(y,:) = [set(i) set(j)];
                    x = x+1;
                end
            end
            y=y+1;    x=1;
        end
    end
    %contains the index and phi values
    data = [ind phi];
    [r,c] = size(phi);
    %finding difference between the calculated values
    if (c>1)
        err = diff(phi,1,2);
    else
        err=phi;
    end
    %------------------------------------------
    %Part B Finding siblings and Parents
    for i = 1:length(err)
        cond = sign(phi(i,:));
        %Modify the value 0.05 for a better representation:
        %Depends on trial and error: Visual Inspection required
        %An extenstion is to include a loop to derive different graphs
        %0.06 and 0.0009 are used respectively for the result32_1
        if(abs(err(i,:))<tol & cond(1) == cond(:)) %%SIGN IS VERY IMPORTANT 
%             if (D(ind(i,1),ind(i,2)) == abs(phi(i,:))) %parent conditions
            if ((D(ind(i,1),ind(i,2)) - mean(abs(phi(i,:)))) < 0.0005) %TOLERANCE FACTOR = 0.0005
                if (phi(i,:)>0)
                    par(i,:)=[ind(i,2),ind(i,1)];
                else
                    par(i,:) = [ind(i,1) ind(i,2)];
                end
            else %else they must be siblings
                sib(i,:) = [ind(i,1) ind(i,2)];
            end
        end
    end
    %--------------
    %PART C
    % JOINING LINKS AND CREATING PARENTS
    %PARENTS
    [r,c]=size(par);
    par_nodes=[];
    for i=1:r
        if (par(i,:) ~= 0)
            A(par(i,1),par(i,2)) = 1;
            A(par(i,2),par(i,1)) = 1;
            set(set==par(i,2))=[];
            set(set==par(i,1))=[];
            par_nodes(length(par_nodes) + 1) = par(i,1);
        end
    end
    
    %SIBLINGS -> Implying Parent needs to be created and Adjacency matrix
    %must be updated
    [r,c]=size(sib);
    h = length(D);
    head=[];check = [];
    for i=1:r
        if (sib(i,:) ~= 0)
            check = [check sib(i,:)];
            if (numel(find(check==sib(i,1))) < 2 && numel(find(check==sib(i,2)))<2)
                head(length(head) + 1) = h + 1;
                h=h+1;
                A(h,sib(i,1))=1;A(sib(i,1),h)=1;
                A(h,sib(i,2))=1;A(sib(i,2),h)=1;
                set(set==sib(i,2))=[];
                set(set==sib(i,1))=[];
            else %important condition if there are more than 2 siblings
                if (numel(find(check==sib(i,1)))>1)
                    [x,y]=find(A(sib(i,1),:)==1);
                    for j=1:length(y)
                        if (ismember(y,head))
                            A(y,sib(i,2))=1;A(sib(i,2),y)=1;
                            set(set==sib(i,2))=[];
                        end
                    end
                end
                if (numel(find(check==sib(i,2)))>1)
                    [x,y]=find(A(sib(i,2),:)==1);
                    for j=1:length(y)
                        if (ismember(y,head))
                            A(y,sib(i,1))=1;A(sib(i,1),y)=1;
                            set(set==sib(i,1))=[];
                        end
                    end
                end
            end
        end
    end
    %-----------
    %PART D
    %Updating the Original Matrix
    for i=1:length(head)
        [x,y]=find(A(head(i),:)==1);
        for j=1:length(y)-1
            index = find((ismember(ind,[y(j),y(j+1)],'rows')==1));
            D(y(j),head(i)) = 0.5 * ( D(y(j),y(j+1)) + mean(phi(index,:)));
            D(y(j+1),head(i)) = 0.5 * ( D(y(j),y(j+1)) - mean(phi(index,:)));
            D(head(i),1:length(D(:,head(i)))) = D(:,head(i))';
        end
        for k=1:length(D)
            if (~ismember(y,k))
                D(k,head(i)) = D(y(1),k) - D(y(1),head(i));
                D(head(i),k) = D(y(1),k) - D(y(1),head(i));
                if (D(k,head(i)) <= 0) %THIS CONDITION IS IMPORTANT TO CHECK
                    %It might be better to compare it to a percentage
                    %around zero but its risky if the impedance is very
                    %close to zero
                    D(k,head(i)) = D(y(2),k) - D(y(2),head(i));
                    D(head(i),k) = D(y(2),k) - D(y(2),head(i));
                end
            end
        end
    end
    %------------------------
    %END CONDITION FOR DEBUGGING
    set=unique([set par_nodes head])
    %RESETTING VARIABLES
    phi=[];ind=[];data =[];sib=[];par=[];
end

%-------------------
%NOTE:
%Due to graph limitation, the final parent node cannot be distinguised if
%there are only 2 siblings; i.e, the final parent node must have a minimum
%degree of 3------> 
%This is the reason the D matrix cannot be updated
%but the graph can be deduced
%-------------------
% %FINAL NODES CONSIDERATION
%
if length(set)>1
    x=1;y=1;
    for i=1:length(set)
        for j = i+1:length(set)
            for k = 1:length(D)
                if (k ~=set(i) && k ~= set(j))
                    phi(y,x) = (D(set(i),k) - D(set(j),k));
                    ind(y,:) = [set(i) set(j)];
                    x = x+1;
                end
            end
            y=y+1;    x=1;
        end
    end
    %contains the index and phi values
    data = [ind phi];
    [r,c] = size(phi);
    %
    if ((abs(abs(phi(:)) - abs (phi(1))) < tol )& (phi(:)~=0)) %ABS WAS ADDED HERE
        %that means they are siblings to a new parent
        %creating the new parent
        h = length(A) + 1;
        A(h,ind(1))=1;A(ind(1),h)=1;
        A(h,ind(2))=1;A(ind(2),h)=1;
    else
        %that means they are connected to each other
        A(ind(1),ind(2)) = 1;
        A(ind(2),ind(1)) = 1;
    end
end
%DISPLAYING RESULTS
clear set
D;
id = string(cell2mat(idA'));
% id = strcat([id' length(id)+1:length(A)])
% id = string(cell2mat(idB'));
% id = strcat([id' length(id)+1:length(A)])
% id = string(cell2mat(idC'));
% id = strcat([id' length(id)+1:length(A)])
% T = triu(A.*D);
% T(T==0)=[];
G=graph(A);
h = plot(G)
h.EdgeColor = 'k';
h.NodeFontSize = 18
h.NodeFontWeight = 'bold'
h.NodeFontName = 'Times New Roman';
h.LineWidth = 1;
% h.Marker = 's';
h.MarkerSize = 10;
ax = gca;
outerpos = ax.OuterPosition;
ti = ax.TightInset; 
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3);
ax_height = outerpos(4) - ti(2) - ti(4);
ax.Position = [left-0.005 bottom-0.005 ax_width+0.008 ax_height+0.009];



%print to pdf
% str = sprintf('Phase A Topology, Tolerance = %f',tol);
% str = sprintf('Phase B Topology, Tolerance = %f',tol);
% str = sprintf('Phase C Topology, Tolerance = %f',tol);
% t = title(str)
% t.FontSize = 24;
% 
% h=gcf;
% set(h,'PaperPositionMode','auto');
% set(h,'PaperOrientation','landscape');
% set(h,'Position',[50 50 1200 800]);
% print(gcf, '-dpdf', 'phaseA.pdf')