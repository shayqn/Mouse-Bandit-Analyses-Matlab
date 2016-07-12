function plotMasterStructure(masterStructure, mouseOrAll, category)
%PLOTMASTERSTRUCTURE takes in a struct as outputted by the
%function createMasterStructure, a string of either a mouse's name or the
%word 'all', as specified by the user, and a category that the user wants
%to look at. The outputs are as follows:
%If the user inputs 'all', the data for all of the mice in masterStructure
%plotted for whatever category the user specified
%If the user inputs a mouse's name and that mouse is in
%masterStructure.byMouse, then the function plots a graph for that mouse in
%that category alone
%NOTE: for the 'all' option, the standard error is plotted as an errorbar
%with the mean
%ALSO NOTE: for the mouse name option, if the category is blockAccuracy,
%errorsPostFirstReward, or errors preFirstReward (the fields containing
%matrices with 2 rows), then the graph will display the standard deviation
%of the mouse's data

%'all' option
if strcmp(mouseOrAll, 'all')
    %sets data equal to the contents of whatever category in byCategory
    %that the user selected
    data = masterStructure.byCategory.(category);
    %sets the dates to be looked at
    dates = data(1,2:end);
    %prepares the variable key, which will be passed as the legend of the
    %graph
    key = [data(2:end-1, 1)];
    %calculates the number of mice
    numMice = size(key,1) - 2;
    %topLeft will be used as the category to be plotted
    topLeft = data(1,1);
    %number of rows in data
    numRows = size(data,1);
    %for loop will iterate over the second row to the end to extract and plot
    %the data for this graph - each iteration another mouse will be added
    %to the graph - the avg line is plotted on the last iteration
    for i = 2:numRows - 2
        points = [data{i,2:end}];
        plot(points);
        hold on;
    end
    %calculates the number of columns in data
    numCols = size(data,2);
    %instantiates the vector to be used for the standard error
    se = zeros(1,numCols-1);
    %instantiates the vector to be used for the avg of each date
    avgArr = zeros(1,numCols-1);
    %iterates over the second column in data to the end (for each date) to
    %fill the arrays avgArr and se (average and standard error)
    for col = 2:numCols
        %stores the average for the date that the loop is on
        avgArr(col-1) = [data{numRows - 1,col}];
        %uses the average and number of mice on the current date to
        %calculate the standard error and store that in the se array
        se(col-1) = [data{numRows,col} / sqrt(numMice)];
    end
    %plots an errorbar for the average on each day and the standard error -
    %formats it such that this error bar is black and thicker than the rest
    %of the mice on the graph
    h = errorbar(avgArr,se);
    h.Color = 'k';
    h.LineWidth = 2;
    %sets the legend
    legend(key);
    %sets the title
    firstDate = dates(1);
    lastDate = dates(end);
    titleArray = [topLeft, ' FROM ', firstDate, ' TO ', lastDate];
    t = strcat(titleArray(1),titleArray(2),titleArray(3),titleArray(4),titleArray(5));
    title(t(1));
    %sets the axes labels
    xlabel('DATES');
    ylabel(topLeft);
    ax = gca;
    set(ax,'XTickLabel',dates);
    hold off;
    
%individual mouse option
else
    %stores the mouse's name as inputted by the user in the variable
    %mouseName and uses that to access the field (which is a struct)
    %mouseField, containing all of the different categories under the
    %mouse's name
    mouseName = mouseOrAll;
    mouseField = masterStructure.byMouse.(mouseName);
    %stores the dates in the variable dates and the data to be plotted in
    %the variable data, using the inputted category to be looked at as
    %specified by the user
    dates = mouseField.dates;
    data = [(mouseField.(category))];
    %if-else statement to deal with the varying dimensions of the matrices
    %that data could be
    %if data has only 1 row, it will be plotted normally
    if size(data,1) == 1 
        h = plot(data);
        h.Color = 'k';
        h.LineWidth = 2;
    %otherwise, the mean will be plotted for each date with the standard
    %deviation taken into account in the errorbar
    else
        h = errorbar(data(1,:),data(2,:), 'k');
        h.Color = 'k';
        h.LineWidth = 2;
    end
    %sets the title of the graph
    titleArray = [{upper(category)},' FOR ',{upper(mouseName)}];
    t = strcat(titleArray(1),titleArray(2),titleArray(3));
    title(t(1));
    %sets the labels of the graph
    xlabel('DATES');
    ylabel(upper(category));
    ax = gca;
    set(ax,'XTickLabel',dates);
    hold off;
end


end

