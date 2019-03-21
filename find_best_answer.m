function outpos=find_best_answer(percent1,percent2,percent3)

max1pos=(max(percent1)==percent1);
max2pos=(max(percent2)==percent2);
max3pos=(max(percent3)==percent3);

outpos=find(max(sum([max1pos;max2pos;max3pos]))==sum([max1pos;max2pos;max3pos]));
