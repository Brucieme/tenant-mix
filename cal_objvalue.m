%������Ӧ��
%���������
%pop:��Ⱥ
%n:¥��f������������
%f:¥����
%s:¥��f�����������
%rB:1¥ÿƽ����ÿ�»������
%x:¥��f�������ĵ�x����
%y:¥��f�������ĵ�y����
%elevx:¥��f�������ĵ�x����
%elevy:¥��f�������ĵ�y����
%entrx:1¥���x����
%entry:1¥���y����
%G:¥��f�ɳ��������
%n_i:��������i�������͵�Ǳ����������������
%cost_i:i�������͵�Ǳ��������ÿ��Ը����i��Ʒ�ϻ��ѵĽ�����
%f_theme:%¥������

function [objvalue, fit_mean] = cal_objvalue(ShMve, ShMph, entrx, entry, Fn, rB,...
    n_i, cost_i, f_t)
for ftemp = 1:Fn
    %disp('����ִ��cal_objvalue.m�Ӻ��������ڵ�¥��Ϊ��');ftemp
%%
%¥��ϵ������
pop = [ShMve{ftemp, 1}, ShMve{ftemp, 2}];%����¥���ҵ̬�͵ȼ�ƴ������
[popsize, py] = size(pop);
n = py/2;
f_theme = f_t(ftemp, :);
i = pop(:, 1:n);%�����ҵ̬i����
h = pop(:, n+1:2*n);%��������̵ȼ�h����
G = ShMph{ftemp, 1};
s = ShMph{ftemp, 2};
x = ShMph{ftemp, 3};
y = ShMph{ftemp, 4};
elevx = ShMph{ftemp, 5};
elevy = ShMph{ftemp, 6};
elev_area = ShMph{ftemp, 7};
%%

%ϵ������
a = [0.24
0.25
0.25
0.16
0.19
0.19
0.19
0.2
0.23
0.25
0.22
0.2
0.22
0.21
0.16
0.16
0.28
0.28
0.28
0.3
0.2
0.3
];%��ֵ���Ͻ����������������������۵㣩
ci = [6
4
6
5.5
4
6
5
5
5
15
12
14
10
12
10
10
18
16
16
25
50
5.5
];%��ҵ̬���͵�λӪҵ���������
I = [1, 2, 3, 0, 0, 0;
    4, 5, 6, 7, 8, 9;
    10, 11, 0, 0, 0, 0;
    12, 13, 14, 0, 0, 0;
    15, 16, 0, 0, 0, 0;
    17,18, 19, 0, 0, 0;
    20, 0, 0 ,0 ,0 ,0;
    21, 0, 0 ,0 ,0 ,0;
    22, 0, 0, 0, 0, 0
    ];%ҵ̬����
%%

%---------------------------��ʼִ�м���-----------------------------%
%����������
%�������Ӱ������:s(AREA),rB,cf(FLOOR),ch(LEVEL),cpo(POSITION)
%����ϵ��cf
f = ftemp;
if f == 6
    cf = 0.5^(2-1);
else
    cf = 0.5^(f-1);%¥�����ϵ��
end
ch = [];%���������̵ȼ�����ϵ��
cs = [];%�������ϵ��
celev = [];
centr = [];
cpo = [];%cpo = celev+centr%λ�õ���ϵ��
%����ϵ��ch��cs
for m = 1:popsize
    for j = 1:n
        if h(m, j) == 1
            ch(m, j) = 0.2;
        elseif h(m, j) == 2
            ch(m, j) = 0.4;
        elseif h(m, j) == 3
            ch(m, j) = 0.6;
        elseif h(m, j) == 4
            ch(m, j) = 0.8;
        elseif h(m, j) == 5
            ch(m, j) = 1;
        end
    end
end
for z = 1:n
    if s(z)<0.05*G
        cs(z) = 1;
    elseif s(z)<0.1*G && s(z)>=0.05*G
        cs(z) = 0.7;
    elseif s(z)>0.1*G
        cs(z) = 0.5;
    end
end
%����ϵ��celev,centr,cpo
store_elev = [];
for jtemp2 = 1:n
    for vtemp = 1:length(elevx)
        store_elev(jtemp2, vtemp) = 1/sqrt((x(jtemp2)-elevx(vtemp))^2+...
            (y(jtemp2)-elevy(vtemp))^2);
    end
    celev(jtemp2) = max(store_elev(jtemp2, :));
    if ftemp == 1 
        for wtemp = 1:length(entrx)
            store_entr(jtemp2, wtemp) = 1/sqrt((x(jtemp2)-entrx(vtemp))^2+...
                (y(jtemp2)-entry(vtemp))^2);
        end
        centr(jtemp2) = max(store_entr(jtemp2, :));
    else
        centr(jtemp2)=0;
    end
end
cpo = celev + centr;%cpo��һ��n*1������ֻ����������λ���й�


%���������
w1 = [];%�������ⲿ��ϵ��
%%%w2 = [];%�����ⲿ��ϵ��
p = [];%ĳһ���̵�λ������۶�
%%%s_trav = [];%����ҵ̬������������
s_i = [];%ͳ�ƹ��������ڸ�ҵ̬�������
s_f = [];%��f������ҵ̬�������
%s_fʾ����s_f = [0, 0, 100, 4000, 0, 0,.....]

%�����������ⲿ��ϵ��w1
%����ÿ������anchor��Ⱦɫ���е�λ��
[lib, lic] = find(h==1);
liblic = [lib, lic];
if isempty(liblic)
    h_anchor = zeros(popsize, 1);%anchorλ�þ���ȫ�����㣬��ʾ��anchor
    %disp('��¥�����и��嶼û��anchor��liblic����Ϊ��')
else
    liblic = sortrows(liblic, 1);%����һ�д�С��������
    h_anchor = zeros(popsize, 1);%ÿ��������anchor��λ��
    %����ÿ������anchor��λ��
    llc = 1;
    for c = 1:popsize
        if llc <= length(lib)
            if c == liblic(llc, 1)
                h_anchor(c) = liblic(llc, 2);
                llc = llc + 1;
            else
                continue
            end
        end
    end
end
%����d_anchor��s_anchor
d_anchor = [];
w1 = [];
w_anchor = [];
for itemp = 1:popsize
    for jtemp = 1:n
        if h_anchor(itemp) ~= 0
            d_anchor(itemp, jtemp) = sqrt((x(jtemp)-x(h_anchor(itemp)))^2 +...
                (y(jtemp) - y(h_anchor(itemp)))^2);
            s_anchor = s(h_anchor(itemp));
        else
            d_anchor(itemp, jtemp) = 1;
            s_anchor = 0;
        end
        %����w_anchor
        if jtemp == h_anchor(itemp)
            w_anchor(itemp, jtemp) = 1;
        else
            w_anchor(itemp, jtemp) = (s(jtemp)*s_anchor)/((d_anchor(itemp, jtemp))^2);
        end
    end
end
w1 = w_anchor;

%���㼯���ⲿ��Ӱ���µĵ������̵�λ������۶�p
%����s_f
%s_f�������汾�����ҵ̬�����,���СΪpopsize*22
theme_number = find(f_theme>0);%�ҳ���������ҵ̬���ļ���
znumber = size(theme_number);%��������ҵ̬�м���
s_f = zeros(popsize, 22);%���и����ҵ̬����Ŀվ���
for itemp = 1:popsize
    for ztemp = 1:22
        s_f(itemp, ztemp) = sum(s(find(i(itemp, :) == ztemp)));
    end
end
%����s_i
%s_i���������������������ڸ�ҵ̬�������������Ĵ�СΪpopsize*22
%����ʹ��Ԫ���������������е�¥�㣬Ԫ��������charac.m
%�㷨�����ڵ�i������ĵ�n��ҵ̬��˵�����Ĺ���������������ڶ�
%ÿһ��ĵ�i���������Ѱ��Ȼ����ӡ�

%shMph:¥�����������Ԫ������
%ShMve:¥��ĵ���ҵ̬���ȼ�Ԫ������
s_i = zeros(popsize, 22);
yt = [];
area = [];
for xtemp1 = 1:popsize
    for ftemp1 = 1:Fn%Fn��¥����
        for ztemp1 = 1:22
            yt = ShMve{ftemp1, 1};%yt�Ǳ�ʾftemp��ҵ̬������ҵ̬�ľ���
            area = ShMph{ftemp1, 2};%area�Ǳ�ʾftemp������������������
            s_i(xtemp1, ztemp1) = s_i(xtemp1, ztemp1) + ...
                sum(area(find(yt(xtemp1, :) == ztemp1)));
            %s_i�Ǽ�����ĵ�xtemp�����й��������ڸ�ҵ̬��ռ���
        end
    end
end
if s_f == s_i
    %disp('������������ȫһ��');
else
    %disp('����������һ��');
end
%���㼯���ⲿ��Ӱ���µĵ������̵�λ������۶�p
%¥������ҵ̬���̵�λ������۶�p
%��Ҫ����S_thre(),n_i(),cost_i(),alp,beta,phi
%S_trav = [12280, 12280, 12280, 12280, 12280, 12280, 12280, 12280, ...
%    12280, 12280, 12280, 12280, 12280, 12280, 12280, 12280, 12280, ...
%    12280, 12280, 12280, 12280, 12280, 12280];
S_trav = [2700, 2700, 2700, 3000, 2500, 2700, 2700, 2700, 4000, ...
    4000, 4000, 4000, 4000, 3000, 5000, 5000, 4000, 3000, 3000, ...
    4000, 3000, 2700];
alp = 0.07;beta = 0.08;
phi = 0.02;
for itemp1 = 1:popsize
    for jtemp1 = 1:n
        theme_area(itemp1) = sum(s_f(itemp1, theme_number));
        if ismember(i(itemp1, jtemp1), theme_number)
            i(itemp1, jtemp1);
            p(itemp1, jtemp1) = ((1 + (s_i(itemp1, i(itemp1, jtemp1))/S_trav(i(itemp1, jtemp1)))*...
                (s_f(itemp1, i(itemp1, jtemp1))/s_i(itemp1, i(itemp1, jtemp1)))*...
                (s(jtemp1)+(alp-beta)*(s_f(itemp1, i(itemp1, jtemp1))-...
                s(jtemp1)))/S_trav(i(itemp1, jtemp1))) + w1(itemp1, jtemp1))*...
                n_i(i(itemp1, jtemp1))*cost_i(i(itemp1, jtemp1));
            
            ceshi1(itemp1, jtemp1) = (s_i(itemp1, i(itemp1, jtemp1))/S_trav(i(itemp1, jtemp1)));
            ceshi2(itemp1, jtemp1) = (s_f(itemp1, i(itemp1, jtemp1))/s_i(itemp1, i(itemp1, jtemp1)));
            ceshi3(itemp1, jtemp1) = (s(jtemp1)+(alp-beta)*(s_f(itemp1, i(itemp1, jtemp1))-...
                s(jtemp1)))/S_trav(i(itemp1, jtemp1));
            this(itemp1, jtemp1) = ceshi1(itemp1, jtemp1)*ceshi2(itemp1, jtemp1)*ceshi3(itemp1, jtemp1);
            w2(itemp1, jtemp1) = (1+(s_i(itemp1, i(itemp1, jtemp1))/S_trav(i(itemp1, jtemp1)))*...
                (s_f(itemp1, i(itemp1, jtemp1))/s_i(itemp1, i(itemp1, jtemp1)))*...
                (s(jtemp1)+(alp-beta)*(s_f(itemp1, i(itemp1, jtemp1))-...
                s(jtemp1)))/S_trav(i(itemp1, jtemp1)));
        else
            i(itemp1, jtemp1);
            p(itemp1, jtemp1) = (((s_i(itemp1, i(itemp1, jtemp1))/S_trav(i(itemp1, jtemp1)))*...
                (s_f(itemp1, i(itemp1, jtemp1))/s_i(itemp1, i(itemp1, jtemp1)))*...
                (s(jtemp1)+(alp-beta)*(s_f(itemp1, i(itemp1, jtemp1))-...
                s(jtemp1))+phi*theme_area(itemp1))/S_trav(i(itemp1, jtemp1)))+w1(itemp1, jtemp1))*...
                n_i(i(itemp1, jtemp1))*cost_i(i(itemp1, jtemp1));
        end
    end
end
%���㳬�����ͻ������
base = [];
overal = [];
rent = [];
for chrom = 1:popsize
    for shop = 1:n
        base(chrom, shop) = s(shop)*rB*ch(chrom, shop);
        overal(chrom, shop) = p(chrom, shop)*a(i(chrom, shop));%������ʱɾ��*s(shop)����������p�ǲ���...
        %��λ��������۶�
        rent(chrom, shop) = (base(chrom, shop)+overal(chrom, shop))...
            *cf*cpo(shop);%ÿ���̵�����
        %��cf�����⣬Ӧ�ó˵�ÿһ¥�㡿���û����
    end
end
Z = isnan(rent);
objvalue_each{ftemp, 1} = sum(rent, 2);%Fn����������һ��chrom*1������
% e_ceshi{ftemp, 1} = overal;
% e_ceshi{ftemp, 2} = p;
% e_ceshi{ftemp, 3} = base;
end



%����objvalueΪ�����������ĵ�����𣬼�ÿһ�������ܺ�
%objvalue����objvalue_each�Ķ�Ӧ�������
objvalue = zeros(popsize, 1);%����һ��popsize*1�������
for xtemp = 1:popsize
    for ftemp2 = 1:Fn
        the_floor = objvalue_each{ftemp2, 1};
        objvalue(xtemp, 1) = objvalue(xtemp, 1) + the_floor(xtemp, 1);
        %objvalue�������������ĵ����
    end
end

% k = find(objvalue == max(objvalue));
% k = k(1,:);
% for eror = 1:Fn
%     disp('������¥�㣺');eror
%     gecengzuida = objvalue_each{eror, 1}(k, 1)
%     gecengzuida_chaoe = e_ceshi{eror, 1}(k, 1)
%     gecengzuida_xiaoshou = e_ceshi{eror, 2}(k, 1)
%     gecengzuida_jiben = e_ceshi{eror, 3}(k, 1)
%     gecengzuida_geti = ShMve{eror, 1}(k, :)
%     max_objvalue = max(objvalue)
%     geti_zuobiao = k
% end
    


fit_mean = mean(objvalue);%������ƽ��ֵ
fit_mean; 




%������
%1�������е�¥�����ѭ������
%2����ѭ������ǰ��ӳ�������
%3��Ȼ��Բ�ͬ¥��Ķ�Ӧ����������
%4������������¥����Ӻ��������
            
            
            
            
            
