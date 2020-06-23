%种群生成
%初始化单个楼层的业态和等级排布
%输入变量：
%popsize:种群大小
%chromlength:染色体长度
%s:楼层面积矩阵
%G:f层可出租面积
%f:楼层数
%f_theme:楼层主题矩阵
%fh_theme:楼层主题所对应的
%输出面积：
%pop:单个楼层的业态和等级种群

function pop = initpop(popsize, chromlength, s, G,  f_theme, fh_theme)
%%
%phase2:商铺等级h的编码
h = zeros(popsize, chromlength);
s_small = [3, 4, 5];%小面积的店铺可以放的业态
s_middle = [2, 3, 4, 5];%中面积的店铺可以放的业态
s_huge = [1, 2, 3, 4];%大面积的店铺可以放的业态

h_huge = [2, 3, 4];%大面积店铺可以放的业态，但是面积没有超过主力店的阈值，不能放业态1

for mtemp = 1:popsize
    for ntemp = 1:chromlength
        if s(ntemp)<0.05*G%小
            h(mtemp, ntemp) = s_small(unidrnd(3));
        elseif s(ntemp)<0.1*G && s(ntemp)>=0.05*G%中
            h(mtemp, ntemp) = s_middle(unidrnd(4));
        elseif s(ntemp)>0.1*G && s(ntemp) ~= max(s)%大（第三等的大）
            h(mtemp, ntemp) = h_huge(unidrnd(3));
        elseif s(ntemp) == max(s)
            if s(ntemp)<0.25*G%大（第二等的大）
                h(mtemp, ntemp) = h_huge(unidrnd(3));
            elseif s(ntemp) >= 0.25*G%大（主力店之大）
                %主力店必须同时满足两个条件：
                %面积在楼层可出租店铺中最大、且大于0.2*G的阈值
                h(mtemp, ntemp) = unidrnd(2);
            end
        end
    end
end
%%
%phase1:零售类型i的编码
i = zeros(popsize, chromlength);
%共22种业态
i_1 = [15, 16];%当h取1时，i的取值为向量内的数
i_2 = [5, 6, 7, 8, 9];%4在第一个elseif里
i_3 = [17, 18, 19, 20, 21];%当店铺等级为3，店铺业态可以取向量内的
%类别，但是这里面的业态类型有的只能放小店铺，有的只能放中店铺，有的只能放
%大店铺
i_3huge = [17, 19];%【为什么这两个业态是huge，回去翻一下本子】
i_3middle = [17, 18, 19];
i_3small = [20, 21];%【为什么这两个业态只能是small】
i_4 = [11, 12, 13, 14];
i_5 = [1, 2, 3, 22];

for itemp = 1:popsize
    for jtemp = 1:chromlength
        if h(itemp, jtemp) == 1
            i(itemp, jtemp) = i_1(unidrnd(2));
        elseif h(itemp, jtemp) == 2
            if s(jtemp) == max(s)
                if s(jtemp) >= 0.25*G
                    i(itemp, jtemp) = 4;%业态类型4（影城）在这里
                elseif s(jtemp) <0.25*G
                    i(itemp, jtemp) = i_2(unidrnd(5));
                end
            elseif s(jtemp) > 0.05*G && s(jtemp) ~= max(s)%对中/大
                i(itemp, jtemp) = i_2(unidrnd(5));
            end
        elseif h(itemp, jtemp) == 3
            if s(jtemp) > 0.1*G && s(jtemp) ~= max(s)%大（第三等的大）
                i(itemp, jtemp) = i_3huge(unidrnd(2));
            elseif s(jtemp) == max(s)
                if s(jtemp) < 0.25*G%大（第二等的大）
                    i(itemp, jtemp) = i_3huge(unidrnd(2));
                elseif s(jtemp) >= 0.25*G%h=3时不能出现（主力店等级的大）
                    disp('h=3时生成业态出错');
                    pause
                end
            elseif s(jtemp) <= 0.1*G && s(jtemp) >20%小（次小）
                i(itemp, jtemp) = i_3(unidrnd(5));
            elseif s(jtemp) <= 20%小（最小）
                i(itemp, jtemp) = i_3small(unidrnd(2));
            end
        elseif h(itemp, jtemp) == 4
            if s(jtemp) < 0.01*G%小
                i(itemp, jtemp) = 10;%业态10（甜品）在这里
            elseif s(jtemp) >= 0.01*G && s(jtemp) ~= max(s)%？？？【我觉得一定的要把各个等级的面积大小等级给定下来】
                i(itemp, jtemp) = i_4(unidrnd(4));
            elseif s(jtemp) == max(s)
                if s(jtemp) < 0.25*G
                    i(itemp, jtemp) = i_4(unidrnd(4));
                elseif s(jtemp) >= 0.25*G
                    disp('h=4时业态生成出错');
                    pause
                end
            end
        elseif h(itemp, jtemp) == 5
            i(itemp, jtemp) = i_5(unidrnd(4));
        end
    end
end
                    
%%
%
%我们还有对楼层的最大店铺赋值为主题业态的一段没写
%
% %1218主题业态的初始化安排
% theme = find(f_theme > 0);
% l_t = length(theme);
% a = theme(1+round((l_t-1)*rand));
% i_theme = a*ones(popsize, 1);
% i(:, find(s == max(s))) = i_theme;
% if ismember(a, i_1)
%     b = 1;
% elseif ismember(a, i_2)||a == 4
%     b = 2;
% elseif ismember(a, i_3)
%     b = 3;
% elseif ismember(a, i_4)||a == 10
%     b = 4;
% elseif ismember(a, i_5)
%     b = 5;
% end
% h_theme = b*ones(popsize, 1);
% h(:, find(s == max(s))) = h_theme;
%%

pop = init_theme(popsize, chromlength, s, G, i, h, f_theme, fh_theme);

end







        
        
        

