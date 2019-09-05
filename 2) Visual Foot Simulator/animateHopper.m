function [] = animateHopper(dyn,groundforce)
    txt = 20;
	fig = figure(56);
	set(fig,'units','normalized','outerposition',[0 0 1 1])
	
    subplot(6,3,[1 4 7])
    image(imread('simple_model.png'));
    axis off
    
    subplot(6,3,[10 13 16])	
	axis([-1.5,1.5,0,2])
    line([-1.5,1.5],[0 0], 'Color',[.4940 .1840 .5560],'LineWidth',4)
    set(gca,'FontSize',txt,'xtick',[])
%     xlabel('X Position (m)', 'FontSize', txt)
    ylabel('Y Position (m)', 'FontSize', txt)
	axis square
% 	groundpatch = patch([-10,10,-10,10],[0,0,-10,-10],[1,1,1]*0.9);
	bodyx = [-1,1,1,-1]'*.5;
	bodyy = [0,0,1.37,1.37]'*.5;

% 	motorx = [-1,1,1,-1]'*0.15;
% 	motory = [-1,-1,1,1]'*0.05;
	
	toex = [-1,1,1,-1]'*0.1;
	toey = [0,0,1,1]'*.1;
	
	bodyPatch = patch(bodyx,bodyy,[1,1,1]*0.8, 'FaceColor', 'r');
% 	motorPatch = patch(motorx,motory,[1,1,1]*0.4);
	toePatch = patch(toex,toey,[1,1,1]*0.6, 'FaceColor', 'b');
	
% 	subplot(1,2,2)
% 	hold off
% % 	tracedBodyPlotinvis = plot(y(1,:),y(4,:),'-w');
% 	hold on
% % 	tracedBodyPlot = plot(dyn(:,2), dyn(:,4) ,'-b');
%   
% 	bodyPoint = plot(dyn(:,1),dyn(:,3),'-r');
% 	grid on
% 	ylabel('Body Velocity');
% 	xlabel('Body Position');
	
	fig.Position = [2084 296 1280 720];
	v = VideoWriter('newfile');
	v.Quality = 80;
	v.FrameRate = 10; % 10
	open(v);
	time = dyn(:,1);
    bodposition = dyn(:,2);
    bodvelocity = dyn(:,3);
    footposition = dyn(:,4);
    footvelocity = dyn(:,5);
    groundforcey = groundforce(:,2);
	for i = 1:2:length(dyn(:,1))
	   bodyPatch.YData = bodyy + dyn(i,2); 
% 	   motorPatch.YData = motory + 0.5 + y(1,i) - y(2,i); 
	   toePatch.YData = toey + dyn(i,4); 
	   
	   tracedBodyPlot.XData = dyn(i,2);
	   tracedBodyPlot.YData = dyn(i,4);
       
       subplot(6,3,[2 3 5 6])
       plot(time(1:i),bodposition(1:i),'-r','LineWidth',2);
       hold on
       plot(time(1:i),footposition(1:i),'-b','LineWidth',2);
       line([0,1],[.25 .25], 'LineStyle', '--', 'Color', 'k')
       set(gca,'FontSize',txt,'xtick',[])
%        axes('Color','none','XColor','none');
       axis([0 1 0 1.5])
%        xlabel('Time (s)');
       ylabel('Height (m)', 'FontSize', txt);
       title('Simulated Model Response', 'FontSize', txt)
%        axis square

       subplot(6,3,[8 9 11 12])
%        plot(time(1:i),bodvelocity(1:i),'-r','LineWidth',2);
       hold on
       plot(time(1:i),footvelocity(1:i),'-b','LineWidth',2);
       line([0,1],[0 0], 'LineStyle', '--', 'Color', 'k')
       set(gca,'FontSize',txt,'xtick',[])
%        grid on
	   ylabel('Velocity (m/s)', 'FontSize', txt);
% 	   xlabel('Time (s)');
% 	   bodyPoint.XData = dyn(i,1);
% 	   bodyPoint.YData = dyn(i,3);
       axis([0 1 -3 3])
%        axis square

       subplot(6,3,[14 15 17 18])
       plot(time(1:i),groundforcey(1:i),'Color',[.4940 .1840 .5560],'LineWidth',2);
       set(gca,'FontSize',txt)
%        plot(time(1:i),groundforcey(1:i),'-g');
	   axis([0 1 0 1000])
       xlabel('Time (s)', 'FontSize', txt)
       ylabel('Ground Reaction Force (N)', 'FontSize', txt)
%        axis square
	   drawnow();    
	   frame = getframe(fig);
	   writeVideo(v,frame);
	end
	
	v.close();