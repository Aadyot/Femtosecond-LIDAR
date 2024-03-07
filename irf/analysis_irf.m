clc;clear;close;clc;

data = load("irf/hist_IRF_10ps_50ns_100sec.txt");
data = data + load("irf/hist_IRF_10ps_50ns_100sec_2.txt") + ...
 load("irf/hist_IRF_10ps_50ns_100sec_3.txt") +  load("irf/hist_IRF_10ps_50ns_100sec_4.txt")...
 +  load("irf/hist_IRF_10ps_50ns_100sec_5.txt");

% 10ps bin width, 50ns temporal extent, 100sec of data at 1kHz rep rate

time = data(:,1) / 5; % in ps
counts = data(:,2); 


% region of interest: bins 2600 to 3000

t = time(2600:3000);
n = counts(2600:3000);

% % now try and fit a gaussian to this
% 
gaussian = @(x,t) x(1)*exp(-x(2)*(t-x(3)).^2);
x0 = [max(n),2e-8,2.8e4];
x = lsqcurvefit(gaussian,x0,t,n);

figure(1);
plot(t,gaussian(x,t)); hold on; plot(t, n)
title("gaussian fit")
% emg:

emg = @(y,t) y(4)*exp(y(1)/2 * (2*y(2) + y(1)*(y(3)^2) -2*t)).*erfc((y(2) + y(1)*(y(3))^2 - t)/y(3)/sqrt(2));
y0 = [1/200,2.8e4,1000,20000];
y = lsqcurvefit(emg,y0,t,n);

figure(2);
plot(t,emg(y,t)); hold on; plot(t,n);
title("exponentially modified gaussian fit")


% Params of EMG:
stdev = sqrt(1/y(1)^2 + y(3)^2);
meanval = 1/y(1) + y(2);

