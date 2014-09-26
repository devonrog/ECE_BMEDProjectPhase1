%initialize time
d = 1; %step size
t = [0:d:100];
z = length(t);
%constants:
gK = 36;
gNa = 120;
gL = 0.3;
Ek = -12; %mV  Nernst Potential for K
ENa = 115; %mV Nernst Potential for K
EL = 10.6; %mV Leakage Nernst Potential
Vrest = -70; % in miliVolts
Vm = Vrest; %set membrane potential to resting potential
Cm = 2;
%gating variables:
am = 0.1*((25-Vm)/(exp((25-Vm)/10) - 1));
Bm = 4*exp(-Vm/18); 
an = .01 * ((10-Vm)/(exp((10-Vm)/10) - 1));
Bn = .125*exp(-Vm/80);
ah = .07*exp(-Vm/20);
Bh = 1/(exp((30-Vm)/10) + 1);
%initialize m,nh:
m0 = am/(am + Bm);
n0 = an/(an + Bn);
h0 = ah/(ah + Bh);
m=m0;
n=n0;
h=h0;
%define currents
INa = m^3*gNa*h*(Vm-ENa);%Na current
IK = n^4*gK*(Vm-Ek); %K current
IL = gL*(Vm-EL); %Leakage current.  Includes Cl
Iinj = zeros(1,z); %injected current.  start with all values at 0 Amps
Iion = Iinj-IK-INa-IL;
%Euler's method:
Vm = [Vm zeros(1,z-1)]; %concatonate initial Vm value with a vector of zeros filling the rest
    for q = 1:z
        Vm(q+1) = Vm(q) + h*Iion(q)/Cm;  %Eulers for Vm.  dVm/dt = Iion/Cm
    end
    




















