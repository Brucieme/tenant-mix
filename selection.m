%ѡ���¸���
%���������
%ShMve:����Ӧ�ȴ�С�������е���Ⱥ
%fitvalue:����Ӧ�ȴ�С�������е���Ӧ��
%iter:��������
%�������
%newpop:����ѡ������Ⱥ

function newShMve = selection(ShMve, ShMph, Fn, popsize, fitvalue, iter, f_t)

%����˵��
newpop = [];
newpop1 = [];
fitvalue_mean = mean(fitvalue);
luanxu = randperm(popsize);%����¥��Ҳ��������������˳��
for ftemp = 1:Fn
    pop = [ShMve{ftemp, 1}, ShMve{ftemp, 2}];
    [popsize, py] = size(pop);
    py = py/2;
    G = ShMph{ftemp, 1};
    s = ShMph{ftemp, 2};
    f_theme = f_t(ftemp, :);
%     if iter>= 20
        %250������ʹ�����̶ķ�
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
%         %ѡ�����ƽ����Ӧ�ȵĸ��壬����newpop1����һ��֮һ��
%         for temp = 1:popsize
%             if fitvalue(temp) >= fitvalue_mean
%                 fitvalue_mean;
%                 newpop1 = pop(1:temp, :);
%             end
%         end
%         [px1, ~] = size(newpop1);
%         if px1 < 0.4*popsize
%             %�������ƽ����Ӧ�ȵĸ���С��0.4*popsize������Ϊ
%             %�ӵ�0.4*popsize
%             temp_popsize = round(0.4*popsize);
%             newpop1 = pop(1:temp_popsize, :);
%             [px1, ~] = size(newpop1);
%         end
%         free_space = popsize - px1;
%         if free_space > 210
%             %��ʼ��200���¸��壬����newpop2����һ��֮����
%             newpop2 = initpop(200, py, s, G, f_theme);
%             %���о����ǿ��԰�initpop��Ϊ���ɵ���¥��ġ�
%             [px2, ~] = size(newpop2);
%             %����ÿһ���ľ�Ӣ������100��������newpop3(��һ��֮��)
%             %������newpop3����û��ͬ����¥�㡿
%             newpop3 = [];
%             for temp2 = 1:100
%                 newpop3(temp2, :) = pop(1, :);
%             end
%             [px3, ~] = size(newpop3);
%             
%             %��ʣ�¿�ȱ�ĸ��������̶ķ�����
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
%             %ֱ�������¸������Ӷ�����
%             newpop2 = initpop(free_space, py, s, G, f_theme);
%             newpop = [newpop1; newpop2];
%         end
        newpop = newpop(luanxu, :);
        ShMve{ftemp, 1} = newpop(:, 1:py);
        ShMve{ftemp, 2} = newpop(:, py+1:2*py);
    end
%end
newShMve = ShMve;
                
