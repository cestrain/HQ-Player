function [no1,no2,no3,percent] = result_get(q,a1,a2,a3)

% Add quotation marks to answers
a1=strcat('"',a1,'"');
a2=strcat('"',a2,'"');
a3=strcat('"',a3,'"');

% Create queries for google search
query1 = strcat(q," ",a1);
query2 = strcat(q," ",a2);
query3 = strcat(q," ",a3);

% Get URLs for each query
url1 = strcat("https://www.google.com/search?q=",query1);
url2 = strcat("https://www.google.com/search?q=",query2);
url3 = strcat("https://www.google.com/search?q=",query3);

% Convert string to each word
html1 = webread(url1);
str1 = extractHTMLText(html1);
text1 = regexp(str1,'\S+','match');

html2 = webread(url2);
str2 = extractHTMLText(html2);
text2 = regexp(str2,'\S+','match');

html3 = webread(url3);
str3 = extractHTMLText(html3);
text3 = regexp(str3,'\S+','match');

% Find index of each result (no of results)
index=find(text1=="result" | text1=="results");
if isempty(index)
    no1=0;
else
    index=index(1)-1;
    no1 = str2double(text1{index});
end

index=find(text2=="result" | text2=="results");
if isempty(index)
    no2 = 0;
else
    index=index(1)-1;
    no2 = str2double(text2{index});
end

index=find(text3=="result" | text3=="results");
if isempty(index)
    no3=0;
else
    index=index(1)-1;
    no3 = str2double(text3{index});
end


totalres = no1+no2+no3;
percent(1) = no1/totalres*100;
percent(2) = no2/totalres*100;
percent(3) = no3/totalres*100;
