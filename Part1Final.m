%initialize time
d = .001; %step size
t = [0:d:100];
z = length(t);
%constants:
gbarK = 36;
gbarNa = 120;
gbarL = 0.3;
Ek = -12; %mV  Nernst Potential for K
ENa = 115; %mV Nernst Potential for K
EL = 10.6; %mV Leakage Nernst Potential
Vrest = -70; % in miliVolts
Vm = 0; %set membrane potential to resting potential
Cm = 2; %in uF
%gating variables:
am = 0.1*((25-Vm)/(exp((25-Vm)/10) - 1));
Bm = 4*exp(-Vm/18); 
an = .01 * ((10-Vm)/(exp((10-Vm)/10) - 1));
Bn = .125*exp(-Vm/80);
ah = .07*exp(-Vm/20);
Bh = 1/(exp((30-Vm)/10) + 1);
%initialize m,n,h:
m0 = am/(am + Bm);
n0 = an/(an + Bn);
h0 = ah/(ah + Bh);
m=m0;
n=n0;
h=h0;

Vmvec = [Vm zeros(1,z-1)]; %concatonate initial Vm value with a vector of zeros filling the rest.
                            %will plot this vector against time at the end.
gK = zeros(1,z);  %initialize gK, gNa into a vector to record their values.
gNa = zeros(1,z);
    for q = 1:z
        %update alpha and Beta Constants based on new Vm value.
        am = 0.1*((25-Vm)/(exp((25-Vm)/10) - 1));
        Bm = 4*exp(-Vm/18); 
        an = .01 * ((10-Vm)/(exp((10-Vm)/10) - 1));
        Bn = .125*exp(-Vm/80);
        ah = .07*exp(-Vm/20);
        Bh = 1/(exp((30-Vm)/10) + 1);
        m = m + d*(am*(1-m)-Bm*m);%Eulers for m.  d is step size
        n = n+ d*(an*(1-n)-Bn*n);%Eulers for n.  d is step size
        h = h+ d*(ah*(1-h)-Bh*h);%Eulers for h.  d is step size
        %update currents
        INa = (m^3)*gbarNa*h*(Vm-ENa);%Na current
        IK = (n^4)*gbarK*(Vm-Ek); %K current
        IL = gbarL*(Vm-EL); %Leakage current.  Includes Cl
        Iinj = 0; %injected current.  start with all values at 0 Amps
        Iion = Iinj-IK-INa-IL;
        %update Vm
        Vm = Vm + d*Iion/Cm;  %Eulers for Vm.  dVm/dt = Iion/Cm
        Vmvec(q) = Vm;  %record Vm in a vector to be used for plotting later on
        gNa(q) = (m^3)*gbarNa*h; %record gNa in a vector to be used for plotting later on
        gK(q)= (n^4)*gbarK;   %record gK in a vector to be used for plotting later on
    end
   Vmvec = Vmvec + Vrest; %move the action potential down the y axis to
%center on resting potential
%plot membrane potential
plot(t, Vmvec)
axis([0,100,-100,40]);
xlabel('Time (in milisec)')
ylabel('Membrane voltage Vm (in mV)')
title('Membrane Potential')
title('Membrane Potential')
legend('Voltage')
%plot conductances
figure
plot(t, gNa,t,gK)
axis([0,100,0,40]);
xlabel('Time (in milisec)')
ylabel('Conductance (in mS/cm^2)')
title('gK and gNa')
title('gK and gNa')
legend('gNa','gK')

