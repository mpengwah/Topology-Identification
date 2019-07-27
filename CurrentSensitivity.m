clc;clear all
load data

phase = 3;

switch(phase)
    case(1) %phase A
        pf = PFa;
        V = Va;
        I = Ia;
        pfcheck = PFa;
    case(2)%phase B
        [r,c] = find(Ib==0);
        edges = unique(r); counts = histc(r,edges);
        row = edges.*(counts>37870/2);
        row(row==0)=[];
        pf = PFb;
        V = Vb;
        I = Ib;
        pf(row,:)=[];
        V(row,:) = [];
        I(row,:) =[];
        pfcheck = pf;
    case(3)
        [r,c] = find(Ic==0);
        edges = unique(r); counts = histc(r,edges);
        row = edges.*(counts>37870/2);
        row(row==0)=[];
        pf = PFc;
        V = Vc;
        I = Ic;
        pf(row,:)=[];
        V(row,:) = [];
        I(row,:) =[];
        pfcheck = pf;
end
st = 1e3; fin = 40e3;
%try for different cases of powerfactor, that is, abs and current = abs
%try removing the negative current and try the equation
%---------
condition = 6
pf = abs(pf);
pf = pf .* sign(I);
check =isnan(pf); [r,c] = find(check==1);c = unique(c);
pf(:,c)=[]; V(:,c)=[];I(:,c)=[];pfcheck(:,c)=[];
I = abs(I);
theta = acos(pf);
theta = theta .* sign(pfcheck)*1;
%---------

Ireal = real(I .* exp(j*theta));
Iimag = imag(I.* exp(j*theta));

ir = diff(Ireal(:,st:fin),1,2); 
v = diff(V(:,st:fin),1,2);
iimag = diff(Iimag(:,st:fin),1,2);

A = [ir;iimag];

%SPECIAL FACTOR REMOVE NAN
% check =isnan(A); [r,c] = find(check==1);c = unique(c);
% A(:,c)=[]; v(:,c)=[];

Y = v/A;
Yp = Y(1:end,1:length(Y)/2) *-1
Yq = Y(1:end,length(Y)/2 + 1:end) *-1;