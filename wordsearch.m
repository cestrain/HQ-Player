function [total,total_lucky,percent,percent_lucky] = wordsearch(q,a1,a2,a3)

% Create queries for google search
query1 = string(q);

% Get URLs for each query
url1 = strcat("https://www.google.com/search?q=",query1);%,"&btnI");
url_lucky = strcat("https://www.google.com/search?q=",query1,"&btnI");

% Convert string to each word
html1 = webread(url1);
str1 = extractHTMLText(html1);
text1 = regexp(str1,'\S+','match');

html_lucky = webread(url_lucky);
str_lucky = extractHTMLText(html_lucky);
text_lucky = regexp(str_lucky,'\S+','match');

% sum(text1=

total(1) = sum(text1==string(a1));
total(2) = sum(text1==string(a2));
total(3) = sum(text1==string(a3));
totaltotal = total(1)+total(2)+total(3);

percent(1)=total(1)/totaltotal*100;
percent(2)=total(2)/totaltotal*100;
percent(3)=total(3)/totaltotal*100;

total_lucky(1) = sum(text_lucky==string(a1));
total_lucky(2) = sum(text_lucky==string(a2));
total_lucky(3) = sum(text_lucky==string(a3));
totaltotal_lucky=total_lucky(1)+total_lucky(2)+total_lucky(3);

percent_lucky(1)=total_lucky(1)/totaltotal_lucky*100;
percent_lucky(2)=total_lucky(2)/totaltotal_lucky*100;
percent_lucky(3)=total_lucky(3)/totaltotal_lucky*100;


% percent of total results for results method
% ratio of words appearing for wordsearch
