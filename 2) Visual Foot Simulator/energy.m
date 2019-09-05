function [E] = energy(dynamics,p)

E = [p.m_foot*p.g*dynamics(:,4)+ p.m_leg*p.g*dynamics(:,2) 1/2*p.k_foot*(min(dynamics(:,4)-p.L_foot,0)).^2+1/2*p.k_leg*(dynamics(:,2)-p.L_leg-dynamics(:,4)).^2 1/2*p.m_foot*(dynamics(:,5)).^2+1/2*p.m_leg*(dynamics(:,3)).^2];

end