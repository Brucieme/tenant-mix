%选择新个体
%输入变量：
%ShMve:按适应度大小降序排列的种群
%fitvalue:按适应度大小降序排列的适应度
%iter:迭代次数
%输出变量
%newpop:进行选择后的种群

function newShMve = selection(ShMve, ShMph, Fn, popsize, fitvalue, iter, f_t)

%参数说明
newpop = [];
newpop1 = [];
fitvalue_mean = mean(fitvalue);
luanxu = randperm(popsize);%其他楼层也按照这个矩阵打乱顺序
for ftemp = 1:Fn
    pop = [ShMve{ftemp, 1}, ShMve{ftemp, 2}];
    [popsize, py] = size(pop);
    py = py/2;
    G = ShMph{ftemp, 1};
    s = ShMph{ftemp, 2};
    f_theme = f_t(ftemp, :);
%     if iter>= 20
        %250代后再使用轮盘赌法
        newpop_iter = [];
        totalfit1 = sum(fitvalue);
        p_fitvalue1 = fitvalue/totalfit1;
        p_fitvalue1 = cumsum(p_fitvalue1);
        ms1 = sort(rand(popsize, 1));
        fit_gamble1 = 1;
        new_gamble1 = 1;
        while new_gamble1 <= popsize
            if (ms1(new_gamble1)) < p_fitvalue1(fit_gamble1)
                newpop_iter(new_gamble1, :) = pop(fit_gamble1, :);
                new_gamble1 = new_gamble1 + 1;
            else
                fit_gamble1 = fit_gamble1 + 1;
            end
        end
            newpop = newpop_iter;
%     else
%         %选择大于平均适应度的个体，存入newpop1（下一代之一）
%         for temp = 1:popsize
%             if fitvalue(temp) >= fitvalue_mean
%                 fitvalue_mean;
%                 newpop1 = pop(1:temp, :);
%             end
%         end
%         [px1, ~] = size(newpop1);
%         if px1 < 0.4*popsize
%             %如果大于平均适应度的个体小于0.4*popsize，就人为
%             %加到0.4*popsize
%             temp_popsize = round(0.4*popsize);
%             newpop1 = pop(1:temp_popsize, :);
%             [px1, ~] = size(newpop1);
%         end
%         free_space = popsize - px1;
%         if free_space > 210
%             %初始化200个新个体，存入newpop2（下一代之二）
%             newpop2 = initpop(200, py, s, G, f_theme);
%             %【感觉还是可以把initpop改为生成单个楼层的】
%             [px2, ~] = size(newpop2);
%             %保存每一代的精英，复制100条，存入newpop3(下一代之三)
%             %【这里newpop3好像没有同步到楼层】
%             newpop3 = [];
%             for temp2 = 1:100
%                 newpop3(temp2, :) = pop(1, :);
%             end
%             [px3, ~] = size(newpop3);
%             
%             %将剩下空缺的个体用轮盘赌法补齐
%             newpop5 = [];
%             totalfit = sum(fitvalue);
%             p_fitvalue = fitvalue/totalfit;
%             p_fitvalue = cumsum(p_fitvalue);
%             ms = sort(rand(popsize, 1));
%             fit_gamble = 1;
%             new_gamble = 1;
%             while new_gamble <= popsize-px1-px2-px3
%                 if ms(new_gamble) < p_fitvalue(fit_gamble)
%                     newpop5(new_gamble, :) = pop(fit_gamble, :);
%                     new_gamble = new_gamble + 1;
%                 else
%                     fit_gamble = fit_gamble + 1;
%                 end
%             end
%             [px5, ~] = size(newpop5);
%             newpop = [newpop1; newpop3; newpop5; newpop2];
%         else
%             %直接生成新个体增加多样性
%             newpop2 = initpop(free_space, py, s, G, f_theme);
%             newpop = [newpop1; newpop2];
%         end
        newpop = newpop(luanxu, :);
        ShMve{ftemp, 1} = newpop(:, 1:py);
        ShMve{ftemp, 2} = newpop(:, py+1:2*py);
    end
%end
newShMve = ShMve;
                
