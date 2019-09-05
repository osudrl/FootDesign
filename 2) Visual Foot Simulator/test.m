
clear; clc; clf; close all;

fig = figure(56);
set(fig,'units','normalized','outerposition',[0 0 1 1])

x=1:10;
y=1:10;

plot(x,y)
xlabel('x axis')
set(gca,'xtick',[])
