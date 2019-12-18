% Take current weather data over time 

% Current XML Lewisburg weather data API
url = "https://w1.weather.gov/xml/current_obs/KSEG.xml";

i = 0;    % Initial row number
t0 = clock;
var_humidity = zeros(1,1);
var_temp_f = zeros(1,1);       % Initialize variables
var_t1 = zeros(1,1);
var_epoch = zeros(1,1);
while etime(clock, t0) < 90000   % 86400 seconds for 24 hour loop (extra hour)
    i = i + 1;              % Increase row number by 1 each loop
    xml = webread(url);     % Get string of XML weather and time data
    tree = htmlTree(xml);   % Convert the XML string to HTML tree
    subtrees_temp_f = findElement(tree,'temp_f');   % Temperature (Fahrenheit)
    subtrees_humidity = findElement(tree,'relative_humidity');   % Humidity (percent)
    % Convert strings to doubles
    % Move to next row each loop
    var_humidity(i,1) = str2double(extractHTMLText(subtrees_humidity));
    var_temp_f(i,1) = str2double(extractHTMLText(subtrees_temp_f));
    % Take current date/time
    var_t1 = datetime('now','Format','dd-MM-yyyy HH:mm:ss');
    % Convert date/time to epoch time.
    % Cannot enter datetimes directly into arrays.
    var_epoch(i,1) = posixtime(var_t1);
    pause(3600);    % Wait 3600 seconds for one hour between loops
end

% Convert epoch times back to dates/times 
var_time = datetime(var_epoch,'convertfrom','posixtime');

% Plot the weather data

% Set axis colors before plotting
left_color = [0 0 0];
right_color = [0 0 0];
set(figure,'defaultAxesColorOrder',[left_color; right_color]);
% Plot humidity data
plot(var_time,var_humidity,'LineWidth',2,'color','black')
hold on
xlabel('Date/Time');
ylabel('Humidity (%)');

% Define limits of right side y-axis
yyaxis right
ylim([50 80])       % Bounds match left side y-axis
% Plot temperature data
plot(var_time,var_temp_f,'LineWidth',2,'Linestyle',':','color','k')
ylabel('Temperature (F)');
legend('Humidity','Temperature','Location','northwest');
