% collect and plot for exp06
close all;
FILE = {'./output2.txt', './output1.txt', './output.txt'};
COLOR = {'r', 'g', 'b'};
MARK = {'o', 'o', 'o'};
fg = 1;
container = {[] [] []};
figure(fg); fg = fg + 1;
for i = 1:size(FILE,2)
    dat = dlmread(FILE{i});
    for j = 1:size(dat, 1)
        if(dat(j,5) == 1)
            container{i} = [container{i} j];
%             plot(dat(j,1),dat(j,2),'Marker',MARK{i},'LineWidth',3,'Color',[i/size(FILE,2) 0 0]);
%             hold on;
        end
    end
%     plot(dat(container{i},1),dat(container{i},2),'*','Marker',MARK{i},'LineWidth',3,'Color',[i/size(FILE,2) 0 0]);
    plot(dat(container{i},1),dat(container{i},2),'*','Marker',MARK{i},'LineWidth',3,'Color',COLOR{i});
    hold on;
end
set(gca, 'yScale', 'linear', 'yMinorTick','on');
set(gca, 'xLim', [100 1500], 'yLim',[100 1500]);
L = legend('QPSK, QPSK', '16QAM, QPSK', '16QAM, 16QAM');
set(L,'FontSize',14, 'Location', 'SouthEast');
xlabel('Near-end user position (m)','FontSize',14,'Color','k');
ylabel('Far-end user position (m)','FontSize',14,'Color','k');
set(gca,'fontsize',14);
grid on;
box on;
saveas(gcf,'fig1','epsc');