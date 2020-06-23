%变异
%输入变量：
%ShMve:交叉变化后的购物中心种群
%Fn:楼层数
%pm:变异概率
%ShMph:购物中心物理属性
%f_theme:主题矩阵
%输出变量：
%newShMve:变异后的新购物中心种群
function newShMve = mutation(ShMve, Fn, pm, ShMph, f_t)

h_huge = [2, 3, 4];%除了主力店以外的大店

i_1 = [15, 16];
i_2 = [5, 6, 7, 8, 9];
i_3 = [17, 18, 19, 20, 21];
i_3huge = [17, 19];
i_3middle = [17, 18, 19];
i_3small = [20, 21];
i_4 = [11, 12, 13, 14];%没有10？？？？嗷，在下面
i_5 = [1, 2, 3, 22];

myrand = rand;

for ftemp = 1:Fn
    pop = [ShMve{ftemp, 1}, ShMve{ftemp, 2}];
    [px, py] = size(pop);
    py = py/2;
    pop1 = pop(:, 1:py);
    pop2 = pop(:, py+1:2*py);
    newpop1 = [];
    newpop2 = [];
    G = ShMph{ftemp, 1};
    s = ShMph{ftemp, 2};
    f_theme = f_t(ftemp, :);
    for jtemp = 1:px
        if myrand < pm
            mpoint = round(rand*py);
            if mpoint <= 0
                mpoint = 1;
            end
            
            newpop2(jtemp, :) = pop2(jtemp, :);
            if s(mpoint)<0.05*G
                newpop2(jtemp, mpoint) = unidrnd(3)+2;
            elseif s(mpoint)<0.1*G && s(mpoint)>=0.05*G
                newpop2(jtemp, mpoint) = unidrnd(4)+1;
            elseif s(mpoint)>=0.1*G && s(mpoint) ~= max(s)
                newpop2(jtemp, mpoint) = h_huge(unidrnd(3));
            elseif s(mpoint) == max(s)
                if s(mpoint) <0.4*G
                    newpop2(jtemp, mpoint) = h_huge(unidrnd(3));
                elseif s(mpoint) >=0.4*G
                    newpop2(jtemp, mpoint) = unidrnd(2);
                end
            end
            
            newpop1(jtemp, :) = pop1(jtemp, :);
            %这里要根据h来改
            if newpop2(jtemp, mpoint) == 1
                newpop1(jtemp, mpoint) = i_1(unidrnd(2));
            elseif newpop2(jtemp, mpoint) == 2
                if s(mpoint) == max(s)
                    if s(mpoint) >= 0.4*G
                        i(jtemp, mpoint) = 4;
                    elseif s(mpoint) < 0.4*G
                        i(jtemp, mpoint) = i_2(unidrnd(5));
                    end
                elseif s(mpoint) > 0.05*G && s(mpoint) ~= max(s)
                    newpop1(jtemp, mpoint) = i_2(unidrnd(5));
                end
            elseif newpop2(jtemp, mpoint) ==3 
                if s(mpoint) > 0.1*G && s(mpoint) ~= max(s)
                    i(jtemp, mpoint) = i_3huge(unidrnd(2));
                elseif s(mpoint) == max(s)
                    if s(mpoint) < 0.4*G
                        i(jtemp, mpoint) = i_3huge(unidrnd(2));
                    elseif s(mpoint) >= 0.4*G
                        pause
                    end
                elseif s(mpoint) <= 0.1*G && s(mpoint) >20
                    i(jtemp, mpoint) = i_3(unidrnd(5));
                elseif s(mpoint) <= 20
                    i(jtemp, mpoint) = i_3small(unidrnd(2));
                end
            elseif newpop2(jtemp, mpoint) == 4
                if s(mpoint) < 0.01*G%或者把0.01*G改成20也可以
                    i(jtemp, mpoint) = 10;
                elseif s(mpoint) >= 0.01*G && s(mpoint) ~= max(s)
                    i(jtemp, mpoint) = i_4(unidrnd(4));
                elseif s(mpoint) == max(s)
                    if s(mpoint) < 0.4*G
                        i(jtemp, mpoint) = i_4(unidrnd(4));
                    elseif s(mpoint) >= 0.4*G
                        pause
                    end
                end
            elseif newpop2(jtemp, mpoint) == 5
                newpop1(jtemp, mpoint) = i_5(unidrnd(4));
            end
        else
            newpop2(jtemp, :) = pop2(jtemp, :);%不变异
            newpop1(jtemp, :) = pop1(jtemp, :);
        end
    end
    newpop = [newpop1, newpop2];
    ShMve{ftemp, 1} = newpop(:, 1:py);
    ShMve{ftemp, 2} = newpop(:, py+1:2*py);
end
newShMve = ShMve;