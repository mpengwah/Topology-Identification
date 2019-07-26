clc;clear all
%Written By Pengwah Abu
load datareal

phase = 1;

%Storing data in new variables
I = Ia;
pf = PFa;
pfcheck = pf;
V = Va;
% I = Inew;
% pf = PFnew;
% pfcheck = pf;
% V = Vnew;

% Calculating theta
pf = abs(pf);
pf = pf .* sign(I); %account for negative current implying power generation
I = abs(I);
theta = acos(pf);
theta = theta .* sign(pfcheck)*1; %account for the type of load
%---------

Ireal = real(I .* exp(j*theta)); %real
Iimag = imag(I.* exp(j*theta)); %imaginary

ir = diff(Ireal,1,2); 
v = diff(V,1,2);
iimag = diff(Iimag,1,2) * -1; %minus sign in the equation

A = [ir;iimag];

Y = v/A; %least squares solution
Yp = Y(1:end,1:length(Y)/2) *-1 %resistance values
Yq = Y(1:end,length(Y)/2 + 1:end) *-1; %reactance values