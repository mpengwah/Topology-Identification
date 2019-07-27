clc;clear all;close all

load data

node = 5;
v = diff(Va,1,2);
i = diff(Ia,1,2);
scatter(v(node,:),i(node,:))

Pa = Va .* Ia .* abs(PFa);
Qa = (Va.*Ia).^2 - Pa.^2;
p = diff(Pa,1,2);
q = diff(Qa,1,2);
figure
scatter(v(node,:),p(node,:))
% close all

%%
pf = PFa;
V = Va;
I = Ia;
pfcheck = PFa;
pf = abs(pf);
pf = pf .* sign(I);
check =isnan(pf); [r,c] = find(check==1);c = unique(c);
pf(:,c)=[]; V(:,c)=[];I(:,c)=[];pfcheck(:,c)=[];
I = abs(I);
theta = acos(pf);
theta = theta .* sign(pfcheck)*1;
Ireal = real(I .* exp(j*theta));
Iimag = imag(I.* exp(j*theta));

ir = diff(Ireal,1,2); 
v = diff(V,1,2);
iimag = diff(Iimag,1,2);
figure
scatter(v(node,:),iimag(node,:))
%%
k = randperm(length(Va));
V = Va(:,k);
I = Ia(:,k);
i_new = diff(I,1,2);
v_new = diff(V,1,2);
scatter(v_new(node,:),i_new(node,:))