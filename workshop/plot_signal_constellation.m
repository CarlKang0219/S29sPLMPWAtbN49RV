%% collect and plot
close all;
FILE = {'star20.025000'};
fg = 1;

%% colour
n_colour = 2;
COLOUR_MAP = hsv(n_colour_group);
RED = [1 0 0];
GRN = [0 1 0];
BLU = [0 0 1];
ORIGIN = {RED, BLU, GRN};

%% marker
MARKER_SET = {'o', 's'};

%% line style
LINE_STYLE = {'-', '--'};

%% main
dat = dlmread(FILE{1});
plot(dat, '.')
z = [0.948683+0.948683i 0.316228+0.948683i -0.948683+0.948683i -0.316228+0.948683i 0.948683+0.316228i 0.316228+0.316228i -0.948683+0.316228i -0.316228+0.316228i 0.948683-0.948683i 0.316228-0.948683i -0.948683-0.948683i -0.316228-0.948683i 0.948683-0.316228i 0.316228-0.316228i -0.948683-0.316228i -0.316228-0.316228i];
hold on;
plot(z, '.', 'Color', 'r');
grid on;
box on;
axis equal;
set(gca,'fontsize',14);
xlabel('\alpha = 0.025 at UE1, PL ratio = 9.42dB','FontSize',14,'Color','k');
saveas(gcf,'fig','epsc');
return;
figure(fg); fg = fg + 1;
for i = 1:size(FILE,2)
    dat = dlmread(FILE{i});
    for j = 2:size(dat, 1)
        j_prime = j - 1; 
        line(dat(1,:), dat(j,:),...
            'Marker',MARKER_SET{i},...
            'LineWidth',2,...
            'LineStyle',LINE_STYLE{j_prime},...
            'MarkerFaceColor','none',...
            'MarkerSize',8,...
            'Color',ORIGIN{i});
    end
end
set(gca, 'yScale', 'log', 'yMinorTick','on');
L = legend('Near-end user', 'Far-end user','Near-end user (modified)', 'Far-end user (modified)');
set(L,'FontSize',14, 'Location', 'SouthEast');
xlabel('Power allocation factor (\alpha)','FontSize',14,'Color','k');
ylabel('Bit error rate','FontSize',14,'Color','k');
set(gca,'fontsize',14);
grid on;
box on;
saveas(gcf,'fig1','epsc');
