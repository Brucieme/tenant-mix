%����任
%���������
%ShMve:����selection����Ⱥpop
%pc:�������
%���������
%newShMve:��������Ⱥ

function [newShMve] = crossover(ShMve, pc, Fn)

for i = 1:Fn
    pop = [ShMve{i, 1}, ShMve{i, 2}];
    [px, py] = size(pop);
    py = py/2;
    pop1 = pop(:, 1:py);
    pop2 = pop(:, py+1:2*py);
    newpop1 = [];
    newpop2 = [];
    myrand = rand;
    for itemp = 1 : 2 : px-1
        if myrand < pc
            %���㽻��
            cpoint = round(rand*py);
            newpop1(itemp, :) = [pop1(itemp, 1:cpoint), pop1(itemp+1, cpoint+1:py)];
            newpop1(itemp+1,:) = [pop1(itemp+1, 1:cpoint), pop1(itemp, cpoint+1:py)];
            
            newpop2(itemp, :) = [pop2(itemp, 1:cpoint), pop2(itemp+1, cpoint+1:py)];
            newpop2(itemp+1,:) = [pop2(itemp+1, 1:cpoint), pop2(itemp, cpoint+1:py)];
        else
            %������
            newpop1(itemp, :) = pop1(itemp, :);
            newpop1(itemp + 1, :) = pop1(itemp + 1, :);
            
            newpop2(itemp, :) = pop2(itemp, :);
            newpop2(itemp + 1, :) = pop2(itemp + 1, :);
            
        end
    end
    newpop = [newpop1, newpop2];
    newShMve{i, 1} = newpop(:, 1:py);
    newShMve{i, 2} = newpop(:, py+1:2*py);
end
            