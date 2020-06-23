%����ҵ̬����
%��initpop�����ɵĸ��壬�޸�Ϊ������ҵ̬�����ĸ���
%���������
%popsize:��Ⱥ��С
%chromlength:Ⱦɫ�峤��
%s:¥���������
%G:f��ɳ������
%i:��initpop�ӳ������ɵ�ҵ̬����
%h:��initpop�ӳ������ɵ�Ʒ�Ƶȼ�
%f_theme:¥���������
%fh_theme:¥����������Ӧ��
%���������
%themepop:��������ҵ̬�������Ⱥҵ̬��Ʒ�Ƶȼ�

function themepop = init_theme(popsize, chromlength, s, G, i, h, f_theme, fh_theme)
%%
%¥������������Ӧ����������λ��
%��������һ����������70%
for vtemp = 1:popsize
    theme_number = find(f_theme>0);
    S_theme = 0;%����ҵ̬�������
    N_theme = 0;%����ҵ̬��������
    len_theme = length(theme_number);
    for lengthtemp = 1:len_theme%����ҵ̬�����е�������
        pos_theme = find(i(vtemp, :) == theme_number(lengthtemp));%���������и�����ҵ̬����λ��
        S1(lengthtemp) = sum(s(pos_theme));%����ø����и�����ҵ̬���������
        N1(lengthtemp) = length(pos_theme);%����ø����и��������������
    end
    S_theme = sum(S1);%����ø���������ҵ̬�����
    N_theme = sum(N1);%����ø���������ҵ̬������
    bu = ~(N_theme >= 0.5*chromlength || S_theme >= 0.7*G);
    %�����һ�������겻�ܶ�
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
                    i(vtemp, sel(lengthtemp3)) = clas(l_a);%����������⣬�϶����Ƿ��κ�һ��
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
            elseif ismember(the_theme, [17, 19])%�������ҵ̬��17��19֮��
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
        if N_theme >= 0.5*chromlength || S_theme >= 0.7*G%�����������������...
            %�ɳ������������һ�룬��������������ڿɳ��������70%
            break;
        end
    end
end

themepop = [i, h];
end
                
                
                
                
                
            
                    
