%计算适应度
%输入变量：
%pop:种群
%n:楼层f所含店铺数量
%f:楼层数
%s:楼层f店铺面积矩阵
%rB:1楼每平方米每月基本租金
%x:楼层f店铺中心点x坐标
%y:楼层f店铺中心点y坐标
%elevx:楼层f电梯中心点x坐标
%elevy:楼层f电梯中心点y坐标
%entrx:1楼入口x坐标
%entry:1楼入口y坐标
%G:楼层f可出租总面积
%n_i:购物中心i零售类型的潜在消费者人数矩阵
%cost_i:i零售类型的潜在消费者每年愿意在i商品上花费的金额矩阵
%f_theme:%楼层主题

function [objvalue, fit_mean] = cal_objvalue(ShMve, ShMph, entrx, entry, Fn, rB,...
    n_i, cost_i, f_t)
for ftemp = 1:Fn
    %disp('正在执行cal_objvalue.m子函数，现在的楼层为：');ftemp
%%
%楼层系数解析
pop = [ShMve{ftemp, 1}, ShMve{ftemp, 2}];%将该楼层的业态和等级拼接起来
[popsize, py] = size(pop);
n = py/2;
f_theme = f_t(ftemp, :);
i = pop(:, 1:n);%分离出业态i矩阵
h = pop(:, n+1:2*n);%分离出店铺等级h矩阵
G = ShMph{ftemp, 1};
s = ShMph{ftemp, 2};
x = ShMph{ftemp, 3};
y = ShMph{ftemp, 4};
elevx = ShMph{ftemp, 5};
elevy = ShMph{ftemp, 6};
elev_area = ShMph{ftemp, 7};
%%

%系数定义
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
];%阈值以上缴纳租金收入比例（超额租金扣点）
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
];%各业态类型单位营业额调整比例
I = [1, 2, 3, 0, 0, 0;
    4, 5, 6, 7, 8, 9;
    10, 11, 0, 0, 0, 0;
    12, 13, 14, 0, 0, 0;
    15, 16, 0, 0, 0, 0;
    17,18, 19, 0, 0, 0;
    20, 0, 0 ,0 ,0 ,0;
    21, 0, 0 ,0 ,0 ,0;
    22, 0, 0, 0, 0, 0
    ];%业态大类
%%

%---------------------------开始执行计算-----------------------------%
%基本租金计算
%基本租金影响因素:s(AREA),rB,cf(FLOOR),ch(LEVEL),cpo(POSITION)
%计算系数cf
f = ftemp;
if f == 6
    cf = 0.5^(2-1);
else
    cf = 0.5^(f-1);%楼层调整系数
end
ch = [];%基本租金店铺等级调整系数
cs = [];%面积调整系数
celev = [];
centr = [];
cpo = [];%cpo = celev+centr%位置调整系数
%计算系数ch，cs
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
%计算系数celev,centr,cpo
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
cpo = celev + centr;%cpo是一个n*1向量，只跟店铺坐标位置有关


%超额租金定义
w1 = [];%主力店外部性系数
%%%w2 = [];%集聚外部性系数
p = [];%某一店铺单位面积销售额
%%%s_trav = [];%各种业态的最大旅行面积
s_i = [];%统计购物中心内各业态的总面积
s_f = [];%第f层主题业态的总面积
%s_f示例：s_f = [0, 0, 100, 4000, 0, 0,.....]

%计算主力店外部性系数w1
%计算每个个体anchor在染色体中的位置
[lib, lic] = find(h==1);
liblic = [lib, lic];
if isempty(liblic)
    h_anchor = zeros(popsize, 1);%anchor位置矩阵全部置零，表示无anchor
    %disp('该楼层所有个体都没有anchor，liblic矩阵为空')
else
    liblic = sortrows(liblic, 1);%按第一列大小升序排序
    h_anchor = zeros(popsize, 1);%每个个体中anchor的位置
    %计算每个个体anchor的位置
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
%计算d_anchor和s_anchor
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
        %计算w_anchor
        if jtemp == h_anchor(itemp)
            w_anchor(itemp, jtemp) = 1;
        else
            w_anchor(itemp, jtemp) = (s(jtemp)*s_anchor)/((d_anchor(itemp, jtemp))^2);
        end
    end
end
w1 = w_anchor;

%计算集聚外部性影响下的单个店铺单位面积销售额p
%计算s_f
%s_f用来储存本层各种业态的面积,其大小为popsize*22
theme_number = find(f_theme>0);%找出本层主题业态有哪几个
znumber = size(theme_number);%本层主题业态有几个
s_f = zeros(popsize, 22);%所有个体各业态面积的空矩阵
for itemp = 1:popsize
    for ztemp = 1:22
        s_f(itemp, ztemp) = sum(s(find(i(itemp, :) == ztemp)));
    end
end
%计算s_i
%s_i用来储存整个购物中心内各业态的面积，因此它的大小为popsize*22
%决定使用元胞数组来储存所有的楼层，元胞见函数charac.m
%算法：对于第i个个体的第n个业态来说，它的购物中心总面积等于对
%每一层的第i个体进行搜寻，然后相加。

%shMph:楼层的物理特征元胞数组
%ShMve:楼层的店铺业态及等级元胞数组
s_i = zeros(popsize, 22);
yt = [];
area = [];
for xtemp1 = 1:popsize
    for ftemp1 = 1:Fn%Fn是楼层数
        for ztemp1 = 1:22
            yt = ShMve{ftemp1, 1};%yt是表示ftemp层业态各店铺业态的矩阵
            area = ShMph{ftemp1, 2};%area是表示ftemp层各店铺面积的列向量
            s_i(xtemp1, ztemp1) = s_i(xtemp1, ztemp1) + ...
                sum(area(find(yt(xtemp1, :) == ztemp1)));
            %s_i是计算出的第xtemp个体中购物中心内各业态所占面积
        end
    end
end
if s_f == s_i
    %disp('这两个矩阵完全一样');
else
    %disp('这两个矩阵不一样');
end
%计算集聚外部性影响下的单个店铺单位面积销售额p
%楼层主题业态店铺单位面积销售额p
%需要定义S_thre(),n_i(),cost_i(),alp,beta,phi
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
%计算超额租金和基本租金
base = [];
overal = [];
rent = [];
for chrom = 1:popsize
    for shop = 1:n
        base(chrom, shop) = s(shop)*rB*ch(chrom, shop);
        overal(chrom, shop) = p(chrom, shop)*a(i(chrom, shop));%这里暂时删了*s(shop)，看看到底p是不是...
        %单位面积的销售额
        rent(chrom, shop) = (base(chrom, shop)+overal(chrom, shop))...
            *cf*cpo(shop);%每个商店的租金
        %【cf有问题，应该乘到每一楼层】，嗷没问题
    end
end
Z = isnan(rent);
objvalue_each{ftemp, 1} = sum(rent, 2);%Fn层的总租金，是一个chrom*1的向量
% e_ceshi{ftemp, 1} = overal;
% e_ceshi{ftemp, 2} = p;
% e_ceshi{ftemp, 3} = base;
end



%定义objvalue为整个购物中心的总租金，即每一层的租金总和
%objvalue等于objvalue_each的对应个体求和
objvalue = zeros(popsize, 1);%创建一个popsize*1的零矩阵
for xtemp = 1:popsize
    for ftemp2 = 1:Fn
        the_floor = objvalue_each{ftemp2, 1};
        objvalue(xtemp, 1) = objvalue(xtemp, 1) + the_floor(xtemp, 1);
        %objvalue是整个购物中心的租金
    end
end

% k = find(objvalue == max(objvalue));
% k = k(1,:);
% for eror = 1:Fn
%     disp('现在是楼层：');eror
%     gecengzuida = objvalue_each{eror, 1}(k, 1)
%     gecengzuida_chaoe = e_ceshi{eror, 1}(k, 1)
%     gecengzuida_xiaoshou = e_ceshi{eror, 2}(k, 1)
%     gecengzuida_jiben = e_ceshi{eror, 3}(k, 1)
%     gecengzuida_geti = ShMve{eror, 1}(k, :)
%     max_objvalue = max(objvalue)
%     geti_zuobiao = k
% end
    


fit_mean = mean(objvalue);%对列求平均值
fit_mean; 




%方案：
%1、对所有的楼层进行循环计算
%2、在循环结束前相加成列向量
%3、然后对不同楼层的对应个体进行相加
%4、最后输出的是楼层相加后的列向量
            
            
            
            
            
