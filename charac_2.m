%购物中心信息储存
%输入变量：
%pop:种群
%Fn:楼层数
%输出变量：
%ShMve:楼层的店铺业态及等级元胞数组
function [ShMve] = charac_2(ShMph, Fn, popsize, f_t)
ShMve = cell(Fn, 2);%楼层的店铺业态及等级元胞数组，是随着迭代变化的
%ShMve:（业态），（店铺等级）
%------通过initpop输入店铺信息--------%
for ftemp = 1:Fn%通过这个循环，我们生成了整个购物中心所有楼层的个体
    px = length(ShMph{ftemp, 2});%楼层ftemp所包含的店铺数量
    G = ShMph{ftemp, 1};%楼层ftemp的总可出租面积
    s = ShMph{ftemp, 2};%楼层ftemp的各店铺面积
    f_theme = f_t(ftemp, :);%楼层ftemp的主题
    %这里添加一段非自动化的主题业态等级
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
    %以上这一段是根据主题业态已知我们自己手动输入的
    
    ve = initpop(popsize, px, s, G, f_theme, fh_theme);%对楼层ftemp进行初始化
    ShMve{ftemp, 1} = ve(:, 1:px);
    ShMve{ftemp, 2} = ve(:, px+1:2*px);
end

end
