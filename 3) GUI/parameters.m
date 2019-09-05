function [param] = parameters(k_foot)

param.g = 9.8;
param.L_leg = .7; %.8
param.k_leg = 2150;%3000
param.m_leg = 30; %30
param.c_leg = 0; %30

param.L_foot = .25; %.07
param.m_foot = 1; %1
param.c_foot = 0; %14.5
param.k_foot = k_foot;

param.hard_stop = .0481; %.0481 Spring Compression to Hard Stop