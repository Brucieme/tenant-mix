%��Ⱥ����
%��ʼ������¥���ҵ̬�͵ȼ��Ų�
%���������
%popsize:��Ⱥ��С
%chromlength:Ⱦɫ�峤��
%s:¥���������
%G:f��ɳ������
%f:¥����
%f_theme:¥���������
%fh_theme:¥����������Ӧ��
%��������
%pop:����¥���ҵ̬�͵ȼ���Ⱥ

function pop = initpop(popsize, chromlength, s, G,  f_theme, fh_theme)
%%
%phase2:���̵ȼ�h�ı���
h = zeros(popsize, chromlength);
s_small = [3, 4, 5];%С����ĵ��̿��Էŵ�ҵ̬
s_middle = [2, 3, 4, 5];%������ĵ��̿��Էŵ�ҵ̬
s_huge = [1, 2, 3, 4];%������ĵ��̿��Էŵ�ҵ̬

h_huge = [2, 3, 4];%��������̿��Էŵ�ҵ̬���������û�г������������ֵ�����ܷ�ҵ̬1

for mtemp = 1:popsize
    for ntemp = 1:chromlength
        if s(ntemp)<0.05*G%С
            h(mtemp, ntemp) = s_small(unidrnd(3));
        elseif s(ntemp)<0.1*G && s(ntemp)>=0.05*G%��
            h(mtemp, ntemp) = s_middle(unidrnd(4));
        elseif s(ntemp)>0.1*G && s(ntemp) ~= max(s)%�󣨵����ȵĴ�
            h(mtemp, ntemp) = h_huge(unidrnd(3));
        elseif s(ntemp) == max(s)
            if s(ntemp)<0.25*G%�󣨵ڶ��ȵĴ�
                h(mtemp, ntemp) = h_huge(unidrnd(3));
            elseif s(ntemp) >= 0.25*G%��������֮��
                %���������ͬʱ��������������
                %�����¥��ɳ������������Ҵ���0.2*G����ֵ
                h(mtemp, ntemp) = unidrnd(2);
            end
        end
    end
end
%%
%phase1:��������i�ı���
i = zeros(popsize, chromlength);
%��22��ҵ̬
i_1 = [15, 16];%��hȡ1ʱ��i��ȡֵΪ�����ڵ���
i_2 = [5, 6, 7, 8, 9];%4�ڵ�һ��elseif��
i_3 = [17, 18, 19, 20, 21];%�����̵ȼ�Ϊ3������ҵ̬����ȡ�����ڵ�
%��𣬵����������ҵ̬�����е�ֻ�ܷ�С���̣��е�ֻ�ܷ��е��̣��е�ֻ�ܷ�
%�����
i_3huge = [17, 19];%��Ϊʲô������ҵ̬��huge����ȥ��һ�±��ӡ�
i_3middle = [17, 18, 19];
i_3small = [20, 21];%��Ϊʲô������ҵֻ̬����small��
i_4 = [11, 12, 13, 14];
i_5 = [1, 2, 3, 22];

for itemp = 1:popsize
    for jtemp = 1:chromlength
        if h(itemp, jtemp) == 1
            i(itemp, jtemp) = i_1(unidrnd(2));
        elseif h(itemp, jtemp) == 2
            if s(jtemp) == max(s)
                if s(jtemp) >= 0.25*G
                    i(itemp, jtemp) = 4;%ҵ̬����4��Ӱ�ǣ�������
                elseif s(jtemp) <0.25*G
                    i(itemp, jtemp) = i_2(unidrnd(5));
                end
            elseif s(jtemp) > 0.05*G && s(jtemp) ~= max(s)%����/��
                i(itemp, jtemp) = i_2(unidrnd(5));
            end
        elseif h(itemp, jtemp) == 3
            if s(jtemp) > 0.1*G && s(jtemp) ~= max(s)%�󣨵����ȵĴ�
                i(itemp, jtemp) = i_3huge(unidrnd(2));
            elseif s(jtemp) == max(s)
                if s(jtemp) < 0.25*G%�󣨵ڶ��ȵĴ�
                    i(itemp, jtemp) = i_3huge(unidrnd(2));
                elseif s(jtemp) >= 0.25*G%h=3ʱ���ܳ��֣�������ȼ��Ĵ�
                    disp('h=3ʱ����ҵ̬����');
                    pause
                end
            elseif s(jtemp) <= 0.1*G && s(jtemp) >20%С����С��
                i(itemp, jtemp) = i_3(unidrnd(5));
            elseif s(jtemp) <= 20%С����С��
                i(itemp, jtemp) = i_3small(unidrnd(2));
            end
        elseif h(itemp, jtemp) == 4
            if s(jtemp) < 0.01*G%С
                i(itemp, jtemp) = 10;%ҵ̬10����Ʒ��������
            elseif s(jtemp) >= 0.01*G && s(jtemp) ~= max(s)%���������Ҿ���һ����Ҫ�Ѹ����ȼ��������С�ȼ�����������
                i(itemp, jtemp) = i_4(unidrnd(4));
            elseif s(jtemp) == max(s)
                if s(jtemp) < 0.25*G
                    i(itemp, jtemp) = i_4(unidrnd(4));
                elseif s(jtemp) >= 0.25*G
                    disp('h=4ʱҵ̬���ɳ���');
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
%���ǻ��ж�¥��������̸�ֵΪ����ҵ̬��һ��ûд
%
% %1218����ҵ̬�ĳ�ʼ������
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







        
        
        

