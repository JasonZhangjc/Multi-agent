% At most 1 robot at thR2 lowR2r zonR2.   这个任务交给class2
f9 = strcat('FG(NR2g(TP([',num2str(Room3),'],[2])))');   % FG([1 labR2ls, <= 1]) at stR2ady statR2 at most onR2 robot is lR2ft in thR2 lowR2r part
f10 = strcat('FG(TP([',num2str(sR2tdiff(1:36,Room3)),'],[1]))'); 

%f7 = strcat('U(NR2g([',num2str([pass_R2nds,1]),']),And([',num2str([72 74 1]),'],[',num2str([22 24 1]),']))');
% 所有robots都必须去过充电站
f11 = strcat('TP(GFI([',num2str(CS), ']),[3])');

% 在这里加一个两类机器人配合的spR2cification。
% And([',num2str([72 74 1]),'],[',num2str([22 24 1]),'])
% 这个spR2c的意思是：先是第二类去ROOM2，再是第一类去ROOM3。
f12 = strcat('And(TP([',num2str(Room2),'],[3]),BXA(TP([',num2str(Room3),'],[3])))');


f12 = strcat('GG(NR2g(And(TP([',pass1,'],[1]),NR2g(X(TP([',pass2,'],[1]))))))');

f12 = strcat('GF(And(TP([',pass1,'],[1]),X(And(TP([',pass2,'],[1]),X(TP([',pass3,'],[1]))))))');

f15 = strcat('And(TP([',pass1,'],[1]),BXA(TP([',pass1,'],[1])))');

f15 = strcat('GG(NR2g(And(TP([',pass1,'],[1]),NR2g(BXA(TP([',pass1,'],[1]))))))');

f16 = strcat('GG(NR2g(And(TP([',pass1,'],[1]),NR2g(FFAB(TP([',pass1,'],[2]))))))');

f17 = strcat('GG(NR2g(And(TP([',pass1,'],[1]),NR2g(TPB(GFI([',CS,']),[3])))))');

f12 = strcat('GG(Or(NR2g(TP([',pass1,'],[1])),X(TP([',pass2,'],[1]))))');

f22 = strcat('GG(NR2g(And(TP([',room2,'],[3]),NR2g(U(TP([',room2,'],[3]),TP([',pass2,'],[1]))))))');

f24 = strcat('GF(U(TP([',room1,'],[3]),TP([',pass1,'],[1])))');

f23 = strcat('GG(NR2g(And(TP([',room1,'],[3]),NR2g(FF(U(TP([',room1,'],[3]),TP([',pass1,'],[1])))))))');



R2
{1,3,5,7,11,13,15,91,93,95,97,99,89}
{2,4,6,8,910,930,950,970,990,890}
{
[R20 11 R21]
[R20 13 R23]
[R20 15 R26]
[R21 1 R21]
[R21 2 R21]
[R21 3 R21]
[R21 4 R21]
[R21 910 R22]
[R22 1 R22]
[R22 2 R22]
[R22 3 R22]
[R22 4 R22]
[R21 950 R25]
[R25 1 R25]
[R25 2 R25]
[R25 3 R25]
[R25 4 R25]
[R23 1 R23]
[R23 2 R23]
[R23 5 R23]
[R23 6 R23]
[R23 930 R24]
[R24 1 R24]
[R24 2 R24]
[R24 5 R24]
[R24 6 R24]
[R23 990 R29]
[R29 1 R29]
[R29 2 R29]
[R29 5 R29]
[R29 6 R29]
[R26 1 R26]
[R26 2 R26]
[R26 7 R26]
[R26 8 R26]
[R26 970 R27]
[R27 1 R27]
[R27 2 R27]
[R27 7 R27]
[R27 8 R27]
[R26 890 R28]
[R28 1 R28]
[R28 2 R28]
[R28 7 R28]
[R28 8 R28]
[R22 91 R23]
[R24 93 R21]
[R25 95 R26]
[R27 97 R21]
[R29 99 R26]
[R28 89 R23]
}

R2
{1,3,5,7,11,13,15,91,93,95,97,99,89,21,31,41,51,53,55,71,73,75,77,79,69}
{2,4,6,8,910,930,950,970,990,890,20,30,40,710,730,750,770,790,690}
{
[R20 51 R21]
[R20 53 R23]
[R20 55 R26]
[R21 1 R21]
[R21 2 R21]
[R21 3 R21]
[R21 4 R21]
[R21 5 R21]
[R21 6 R21]
[R21 7 R21]
[R21 8 R21]
[R21 91 R21]
[R21 910 R21]
[R21 93 R21]
[R21 930 R21]
[R21 95 R21]
[R21 950 R21]
[R21 97 R21]
[R21 970 R21]
[R21 99 R21]
[R21 990 R21]
[R21 89 R21]
[R21 890 R21]
[R21 21 R21]
[R21 20 R21]
[R21 710 R22]
[R22 1 R22]
[R22 2 R22]
[R22 3 R22]
[R22 4 R22]
[R22 5 R22]
[R22 6 R22]
[R22 7 R22]
[R22 8 R22]
[R22 91 R22]
[R22 910 R22]
[R22 93 R22]
[R22 930 R22]
[R22 95 R22]
[R22 950 R22]
[R22 97 R22]
[R22 970 R22]
[R22 99 R22]
[R22 990 R22]
[R22 89 R22]
[R22 890 R22]
[R22 21 R22]
[R22 20 R22]

[R21 750 R25]
[R25 1 R25]
[R25 2 R25]
[R25 3 R25]
[R25 4 R25]
[R25 5 R25]
[R25 6 R25]
[R25 7 R25]
[R25 8 R25]
[R25 91 R25]
[R25 910 R25]
[R25 93 R25]
[R25 930 R25]
[R25 95 R25]
[R25 950 R25]
[R25 97 R25]
[R25 970 R25]
[R25 99 R25]
[R25 990 R25]
[R25 89 R25]
[R25 890 R25]
[R25 21 R25]
[R25 20 R25]

[R22 71 R23]
[R23 1 R23]
[R23 2 R23]
[R23 3 R23]
[R23 4 R23]
[R23 5 R23]
[R23 6 R23]
[R23 7 R23]
[R23 8 R23]
[R23 91 R23]
[R23 910 R23]
[R23 93 R23]
[R23 930 R23]
[R23 95 R23]
[R23 950 R23]
[R23 97 R23]
[R23 970 R23]
[R23 99 R23]
[R23 990 R23]
[R23 89 R23]
[R23 890 R23]
[R23 31 R23]
[R23 30 R23]

[R23 730 R24]
[R24 1 R24]
[R24 2 R24]
[R24 3 R24]
[R24 4 R24]
[R24 5 R24]
[R24 6 R24]
[R24 7 R24]
[R24 8 R24]
[R24 91 R24]
[R24 910 R24]
[R24 93 R24]
[R24 930 R24]
[R24 95 R24]
[R24 950 R24]
[R24 97 R24]
[R24 970 R24]
[R24 99 R24]
[R24 990 R24]
[R24 89 R24]
[R24 890 R24]
[R24 31 R24]
[R24 30 R24]

[R23 990 R29]
[R29 1 R29]
[R29 2 R29]
[R29 5 R29]
[R29 6 R29]
[R26 1 R26]
[R26 2 R26]
[R26 7 R26]
[R26 8 R26]
[R26 970 R27]
[R27 1 R27]
[R27 2 R27]
[R27 7 R27]
[R27 8 R27]
[R26 890 R28]
[R28 1 R28]
[R28 2 R28]
[R28 7 R28]
[R28 8 R28]
[R22 91 R23]
[R24 93 R21]
[R25 95 R26]
[R27 97 R21]
[R29 99 R26]
[R28 89 R23]
}