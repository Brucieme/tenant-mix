%ѡ�����Ÿ���
%�����������ȺShMve,��Ⱥ��Ӧ��fitvalue
%�����������ѹ������ĸ���bestindividual�������Ӧ��bestfit

function [bestindividual, bestfit, shenxupop, fitvalue] = best(ShMve, fitvalue, Fn)
bestindividual = cell(Fn, 2);
shenxupop = cell(Fn, 2);
for i = 1:Fn
    [px, py] = size(ShMve{i,1});%py�Ǹò���̵�����
    merge = [fitvalue, ShMve{i, 1}, ShMve{i, 2}];
    merge = sortrows(merge, -1);%���յ�һ�еĴ�С��������
    bestfit = merge(1, 1);
    bestindividual{i, 1} = merge(1, 2:py+1);
    bestindividual{i, 2} = merge(1, py+2:2*py+1);
    shenxupop{i, 1} = merge(:, 2:py+1);
    shenxupop{i, 2} = merge(:, py+2:2*py+1);
    fitvalue1 = merge(:, 1);
end
fitvalue = fitvalue1;