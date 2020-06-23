%主题业态保护
%将initpop里生成的个体，修改为由主题业态保护的个体
%输入变量：
%popsize:种群大小
%chromlength:染色体长度
%s:楼层面积矩阵
%G:f层可出租面积
%i:由initpop子程序生成的业态类型
%h:由initpop子程序生成的品牌等级
%f_theme:楼层主题矩阵
%fh_theme:楼层主题所对应的
%输出变量：
%themepop:经过主题业态处理的种群业态和品牌等级

function themepop = init_theme(popsize, chromlength, s, G, i, h, f_theme, fh_theme)
%%
%楼层主题店铺面积应处于主导地位：
%数量大于一半或面积大于70%
for vtemp = 1:popsize
    theme_number = find(f_theme>0);
    S_theme = 0;%主题业态店铺面积
    N_theme = 0;%主题业态店铺数量
    len_theme = length(theme_number);
    for lengthtemp = 1:len_theme%主题业态矩阵中单个主题
        pos_theme = find(i(vtemp, :) == theme_number(lengthtemp));%单个个体中该主题业态店铺位置
        S1(lengthtemp) = sum(s(pos_theme));%计算该个体中该主题业态店铺总面积
        N1(lengthtemp) = length(pos_theme);%计算该个体中该主题店铺总数量
    end
    S_theme = sum(S1);%计算该个体中主题业态总面积
    N_theme = sum(N1);%计算该个体重主题业态总数量
    bu = ~(N_theme >= 0.5*chromlength || S_theme >= 0.7*G);
    %明天加一个主力店不能动
    while bu
        for lengthtemp2 = 1:len_theme
            the_theme = theme_number(lengthtemp2);
            if ismember(the_theme, [15, 16])
                pos2 = find(s>0.25*G & s==max(s))';
                probability = randn(1, length(pos2));
                sel = pos2(probability>0);
                cls = [15, 16];
                clas = cls(ismember([15, 16], theme_number));
                for lengthtemp3 = 1:length(sel)
                    l_a = unidrnd(length(clas));
                    i(vtemp, sel(lengthtemp3)) = clas(l_a);
                    h(vtemp, sel(lengthtemp3)) = 1;
                end
            elseif ismember(the_theme, [5, 6, 7, 8, 9])
                pos2 = find((s<0.25*G & s==max(s)) | (s>0.05*G & s~=max(s)))';
                probability = randn(1, length(pos2));
                sel = pos2(probability>0);
                cls = [5, 6, 7, 8, 9];
                clas = cls(ismember([5, 6, 7, 8, 9], theme_number));
                for lengthtemp3 = 1:length(sel)
                    l_a = unidrnd(length(clas));
                    i(vtemp, sel(lengthtemp3)) = clas(l_a);%这里出了问题，肯定不是放任何一个
                    h(vtemp, sel(lengthtemp3)) = 2;
                end
            elseif ismember(the_theme, [20, 21])
                pos2 = find(s<0.1*G)';
                probability = randn(1, length(pos2));
                sel = pos2(probability>0);
                cls = [20, 21];
                clas = cls(ismember([20, 21], theme_number));
                for lengthtemp3 = 1:length(sel)
                    l_a = unidrnd(length(clas));
                    i(vtemp, sel(lengthtemp3)) = clas(l_a);
                    h(vtemp, sel(lengthtemp3)) = 3;
                end
            elseif ismember(the_theme, [11, 12, 13, 14])
                pos2 = find((s>20 & s~= max(s)) | (s<0.25*G & s==max(s)))';
                probability = randn(1, length(pos2));
                sel = pos2(probability>0);
                cls = [11, 12, 13, 14];
                clas = cls(ismember([11, 12, 13, 14], theme_number));
                for lengthtemp3 = 1:length(sel)
                    l_a = unidrnd(length(clas));
                    i(vtemp, sel(lengthtemp3)) = clas(l_a);
                    h(vtemp, sel(lengthtemp3)) = 4;
                end
            elseif ismember(the_theme, 10)
                pos2 = find(s<20)';
                probability = randn(1, length(pos2));
                sel = pos2(probability>0);
                for lengthtemp3 = 1:length(sel)
                    i(vtemp, sel(lengthtemp3)) = 10;
                    h(vtemp, sel(lengthtemp3)) = 4;
                end
            elseif ismember(the_theme, [1, 2, 3, 22])
                pos2 = find(s<0.1*G)';
                probability = randn(1, length(pos2));
                sel = pos2(probability>0);
                cls = [1, 2, 3, 22];
                clas = cls(ismember([1, 2, 3, 22], theme_number));
                for lengthtemp3 = 1:length(sel)
                    l_a = unidrnd(length(clas));
                    i(vtemp, sel(lengthtemp3)) = clas(l_a);
                    h(vtemp, sel(lengthtemp3)) = 5;
                end
            elseif ismember(the_theme, 18)
                pos2 = find(s>20 & s<= 0.1*G)';
                probability = randn(1, length(pos2));
                sel = pos2(probability>0);
                for lengthtemp3 = 1:length(sel)
                    i(vtemp, sel(lengthtemp3)) = 18;
                    h(vtemp, sel(lengthtemp3)) = 3;
                end
            elseif ismember(the_theme, [17, 19])%如果主题业态在17、19之中
                pos2 = find((s>20 & s<= 0.1*G) | (s>0.1*G & s == max(s)) ...
                    | (s<0.25*G & s == max(s)))';
                probability = randn(1, length(pos2));
                sel = pos2(probability>0);
                cls = [17, 19];
                clas = cls(ismember([17, 19], theme_number));
                for lengthtemp3 = 1:length(sel)
                    l_a = unidrnd(length(clas));
                    i(vtemp, sel(lengthtemp3)) = clas(l_a);
                    h(vtemp, sel(lengthtemp3)) = 3;
                end
            end
        end
        S_theme = sum(s(find(ismember(i(vtemp, :), theme_number) == 1)));
        N_theme = sum(find(ismember(i(vtemp, :), theme_number) == 1));
        if N_theme >= 0.5*chromlength || S_theme >= 0.7*G%如果主题店的数量大于...
            %可出租店铺数量的一半，或主题店的面积大于可出租面积的70%
            break;
        end
    end
end

themepop = [i, h];
end
                
                
                
                
                
            
                    
