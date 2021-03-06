% collect and plot for exp06
exp06 = 0;
if (exp06)
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
end

% plot data from extract feasible python script
close all;
FILE = 'ext_fea_out_v1';
figure(1);
colormap = hsv(10);
global dat;
dat = dlmread(FILE);
e = 10^-4;
for i = 1:size(dat, 1)
% 1
    if (abs(dat(i,3)-1) < e && abs(dat(i,4)-1) < e && abs(dat(i,5)-0.5) < e && abs(dat(i,6)-0.5) < e)
        p1 = plot(dat(i, 1),dat(i, 2), '*', 'Marker', 'o', 'LineWidth', 3, 'Color', colormap(1,:));
        hold on;
    end
% 1
    if (abs(dat(i,3)-1) < e && abs(dat(i,4)-1) < e && abs(dat(i,5)-2/3) < e && abs(dat(i,6)-0.5) < e)
        p2 = plot(dat(i, 1),dat(i, 2), '*', 'Marker', 'o', 'LineWidth', 3, 'Color', colormap(2,:));
        hold on;
    end
% 1
    if (abs(dat(i,3)-1) < e && abs(dat(i,4)-1) < e && abs(dat(i,5)-2/3) < e && abs(dat(i,6)-2/3) < e)
        p3 = plot(dat(i, 1),dat(i, 2), '*', 'Marker', 'o', 'LineWidth', 3, 'Color', colormap(3,:));
        hold on;
    end
% 1
    if (abs(dat(i,3)-1) < e && abs(dat(i,4)-1) < e && abs(dat(i,5)-0.5) < e && abs(dat(i,6)-2/3) < e)
        p4 = plot(dat(i, 1),dat(i, 2), '*', 'Marker', 'o', 'LineWidth', 3, 'Color', colormap(4,:));
        hold on;
    end
% 1
    if (abs(dat(i,3)-2) < e && abs(dat(i,4)-1) < e && abs(dat(i,5)-0.5) < e && abs(dat(i,6)-0.5) < e)
        p5 = plot(dat(i, 1),dat(i, 2), '*', 'Marker', 'o', 'LineWidth', 3, 'Color', colormap(5,:));
        hold on;
    end
% 1
    if (abs(dat(i,3)-2) < e && abs(dat(i,4)-1) < e && abs(dat(i,5)-2/3) < e && abs(dat(i,6)-0.5) < e)
        p6 = plot(dat(i, 1),dat(i, 2), '*', 'Marker', 'o', 'LineWidth', 3, 'Color', colormap(6,:));
        hold on;
    end
% 1
    if (abs(dat(i,3)-2) < e && abs(dat(i,4)-1) < e && abs(dat(i,5)-2/3) < e && abs(dat(i,6)-2/3) < e)
        p7 = plot(dat(i, 1),dat(i, 2), '*', 'Marker', 'o', 'LineWidth', 3, 'Color', colormap(7,:));
        hold on;
    end
% 1
    if (abs(dat(i,3)-2) < e && abs(dat(i,4)-1) < e && abs(dat(i,5)-0.5) < e && abs(dat(i,6)-2/3) < e)
        p8 = plot(dat(i, 1),dat(i, 2), '*', 'Marker', 'o', 'LineWidth', 3, 'Color', colormap(8,:));
        hold on;
    end
% 1
    if (abs(dat(i,3)-2) < e && abs(dat(i,4)-2) < e && abs(dat(i,5)-2/3) < e && abs(dat(i,6)-0.5) < e)
        p9 = plot(dat(i, 1),dat(i, 2), '*', 'Marker', 'o', 'LineWidth', 3, 'Color', colormap(9,:));
        hold on;
    end
% 1
    if (abs(dat(i,3)-2) < e && abs(dat(i,4)-2) < e && abs(dat(i,5)-2/3) < e && abs(dat(i,6)-2/3) < e)
        p10 = plot(dat(i, 1),dat(i, 2), '*', 'Marker', 'o', 'LineWidth', 3, 'Color', colormap(10,:));
        hold on;
    end
% 1
    if (abs(dat(i,3)-2) < e && abs(dat(i,4)-2) < e && abs(dat(i,5)-0.5) < e && abs(dat(i,6)-2/3) < e)
        plot(dat(i, 1),dat(i, 2), '*', 'Marker', 'o', 'LineWidth', 3, 'Color', 'g');
        hold on;
    end
end
L = legend([p1,p2,p3,p4,p5,p6,p7,p8,p9,p10],...
    'QPSK 1/2, QPSK 1/2', 'QPSK 2/3, QPSK 1/2','QPSK 2/3, QPSK 2/3','QPSK 1/2, QPSK 2/3',...
    '16QAM 1/2, QPSK 1/2','16QAM 2/3, QPSK 1/2','16QAM 2/3, QPSK 2/3','16QAM 1/2, QPSK 2/3',...
    '16QAM 2/3, 16QAM 1/2', '16QAM 2/3, 16QAM 2/3');
set(L,'FontSize',12, 'Location', 'SouthEast');
set(gca,'fontsize',14);
xlabel('Pathloss UE 1(-dB)','FontSize',14,'Color','k');
ylabel('Pathloss UE 2(-dB)','FontSize',14,'Color','k');
grid on;
box on;
saveas(gcf,'fig1','epsc');
close all;

%% exhaustive search
global UE;
global best;
global best_cs;
best = 0;
% UE = randi([250 1400],12,2);
UE =  [1139         395;
        1051         404;
         394         363;
         399         413;
         356         443;
         259         475;
         736         615;
        1004         614;
        1082         500;
         861         538;
         375        1277;
         977        1059];
[sortedUE sort_idx] = sort((UE(:,1).^2+UE(:,2).^2).^0.5);
% (UE(:,1).^2+UE(:,2).^2).^0.5
UE_idx = 1:size(UE,1);
csgDive(UE_idx , {});
% for i = 1:length(best_cs)
%     best_cs{i}
% end
% best
% get_cs_value( {[sort_idx(1) sort_idx(10)] [sort_idx(2) sort_idx(9)] [sort_idx(3) sort_idx(8)] [sort_idx(4) sort_idx(7)] [sort_idx(5) sort_idx(6)] }) / best
get_cs_value( {[sort_idx(1) sort_idx(12)] [sort_idx(2) sort_idx(11)] [sort_idx(3) sort_idx(10)] [sort_idx(4) sort_idx(9)] [sort_idx(5) sort_idx(8)] [sort_idx(6) sort_idx(7)]}) / best

figure(2);
rot_factor = rand(1,12);
rot_factor = [0.3981    0.5154    0.6575    0.9509    0.7223    0.4001    0.8319    0.1343    0.0605    0.0842    0.1639    0.3242];
labels = cellstr( num2str([1:12]') );
plot(0, 0, '.','Marker', 'x', 'LineWidth', 3, 'Color', 'r'); hold on;
for i = 1:12
    rot_matrix = [cos(2*pi*rot_factor(i)) -sin(2*pi*rot_factor(i)); sin(2*pi*rot_factor(i)) cos(2*pi*rot_factor(i))];
    UE_new = UE(i,:)*rot_matrix;
    p_handle(i) = plot(UE_new(1), UE_new(2), '.','Marker', 'o', 'LineWidth', 3, 'Color', 'b');
    text(UE_new(1), UE_new(2), labels{i}, 'VerticalAlignment','bottom', ...
                             'HorizontalAlignment','right','FontSize',14,'FontWeight','bold')
    hold on;
    l_handle(i) = line([UE_new(1) 0], [UE_new(2) 0]);
end
axis equal
set(gca,'fontsize',14);
% best_cs = {[sort_idx(1) sort_idx(12)] [sort_idx(2) sort_idx(11)] [sort_idx(3) sort_idx(10)] [sort_idx(4) sort_idx(9)] [sort_idx(5) sort_idx(8)] [sort_idx(6) sort_idx(7)]};
colormap = hsv(length(best_cs));
for i = 1:length(best_cs)
    set(p_handle(best_cs{i}(1)), 'Color', colormap(i,:));
    set(p_handle(best_cs{i}(2)), 'Color', colormap(i,:));
    set(l_handle(best_cs{i}(1)), 'Color', colormap(i,:));
    set(l_handle(best_cs{i}(2)), 'Color', colormap(i,:));
end
xlabel('(m)','FontSize',14,'Color','k');
ylabel('(m)','FontSize',14,'Color','k');
grid on;
box on;
hold off;
saveas(gcf,'fig2','epsc');








