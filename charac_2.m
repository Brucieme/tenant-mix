%����������Ϣ����
%���������
%pop:��Ⱥ
%Fn:¥����
%���������
%ShMve:¥��ĵ���ҵ̬���ȼ�Ԫ������
function [ShMve] = charac_2(ShMph, Fn, popsize, f_t)
ShMve = cell(Fn, 2);%¥��ĵ���ҵ̬���ȼ�Ԫ�����飬�����ŵ����仯��
%ShMve:��ҵ̬���������̵ȼ���
%------ͨ��initpop���������Ϣ--------%
for ftemp = 1:Fn%ͨ�����ѭ������������������������������¥��ĸ���
    px = length(ShMph{ftemp, 2});%¥��ftemp�������ĵ�������
    G = ShMph{ftemp, 1};%¥��ftemp���ܿɳ������
    s = ShMph{ftemp, 2};%¥��ftemp�ĸ��������
    f_theme = f_t(ftemp, :);%¥��ftemp������
    %�������һ�η��Զ���������ҵ̬�ȼ�
    if ftemp == 1
        fh_theme = [3, 5];
    elseif ftemp == 2
        fh_theme = 3;
    elseif ftemp == 3
        fh_theme = [3,3];
    elseif ftemp == 4
        fh_theme = [4, 3, 3];
    elseif ftemp == 5
        fh_theme = [4, 4];
%     elseif ftemp == 6
%         fh_theme = [2, 4, 4, 4, 1, 1];
    end
    %������һ���Ǹ�������ҵ̬��֪�����Լ��ֶ������
    
    ve = initpop(popsize, px, s, G, f_theme, fh_theme);%��¥��ftemp���г�ʼ��
    ShMve{ftemp, 1} = ve(:, 1:px);
    ShMve{ftemp, 2} = ve(:, px+1:2*px);
end

end
