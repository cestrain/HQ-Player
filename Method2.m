% Read Questions and answers
% [q,a1,a2,a3]=image_text();
[q,a1,a2,a3,flag_not]=image_text_quotes();

[maxno1,maxno2,maxno3,percentres] = result_get(q,a1,a2,a3);

if flag_not
    maxno = find(min([maxno1 maxno2 maxno3])==[maxno1 maxno2 maxno3]);
    sprintf('Not in answer, looking for least results')
else 
    maxno = find(max([maxno1 maxno2 maxno3])==[maxno1 maxno2 maxno3]);
end

% [t1,t2,t3,percentword] = wordsearch(q,a1,a2,a3);
[total_word,total_wordlucky,percentword,percent_wordlucky] = wordsearch(q,a1,a2,a3);
as = {a1 a2 a3};
res_answer = as{maxno};

% Display answers
Result_Percentage = percentres';
Answers = as';
Word_Percentage = percentword';
Word_Lucky_Percentage = percent_wordlucky';
table=table(Answers,Result_Percentage,Word_Percentage,Word_Lucky_Percentage)

out = find_best_answer(percentres,percentword,percent_wordlucky);
all_ans=strcat('Overall answer:',{' '},as(out));
res_answer=strcat('Result answer:',{' '},as(maxno));
[res_answer;all_ans]
%% Inclusions?
% If keyword 'NOT', find lowest result?

