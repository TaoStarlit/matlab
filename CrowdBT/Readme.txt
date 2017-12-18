仔细分析一下，这个效果不错的代码，在online_update都做了什么：
这里进入时：
c=0.1
kappa=1.0e-04
taylor=1

mu sigma 参数很早就返回了，接着 处理泰勒级数，更新C1 C2 然后返回新的 alpha beta




====================
 Crowd-BT Algorithm
=====================

1. General Information

This package implements the Crowd-BT algorithm for crowdsourced ranking inference.


2. Usage

To run a simulated experiment, open and run the file 'main.m'. You can change the first portion of 'main.m' (Basic inputs) for different experimental setups. The averaged accuracy will be saved.

Options of basic inputs include:

n_anno = number of workers
n_obj = number of items
budget = total available budget 
trials = number of independent trials to run

u, v = Beta(u,v) is the generating distribution of workers' reliability
alpha0, beta0 = Beta(alpha0,beta0) is the prior of workers' reliability

gamma = exploration-exploitaion tradeoff


分析现有的代码
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Crowd-BT Algorithm
%%%%%%%%%%%%%%%%%%%%%%%%%%%
Active Learning
% data 360 K*N(两两组合)= 8*(10*9/2/1)貌似没有实际内容，只有对应关系。  data 字段1，worker;  字段2，3，物品编号的组合（每个worker完全一样的重复）
% score 360 
% try result 两对中间结果， 每个结果，里面全都是 sigma mu 1 2,  alpha, beta

% 先验参数，就 (Dir产生8个，每个worker对应一个alpha,beta,类似棒球手的表现)alpha, beta   (Gaussian 产生10个)mu sigma 

这里是生成模型的参数，理解为真实参数 
% ρ是贝塔分布产生的，评论者的素质  eg 0.78 	0.83 	0.26 	0.93 	0.85 	0.89 	0.99 	0.99 
% θ是dirchelet分布产生的，每个物品/项目的分数   eg 0.047 	0.013 	0.063 	0.066 	0.410 	0.067 	0.050 	0.125 	0.149 	0.011 

里面的buget就是指示你要计算几次，或者说输入几个样本
过程中计算出的mu，会与最原始的theta做对比

每次输入样本，准备计算时，就从上次的结果，提取出先验参数
        % 更新先验 超参数 mu sigma
        mu(i) = try_result{r,1}.mu1;
        mu(j) = try_result{r,1}.mu2;
        sigma(i) = try_result{r,1}.sigma1;
        sigma(j) = try_result{r,1}.sigma2;




两者的切合与不同：
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
How to leverage Crowded Source
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
契合： 
BCI multi-Channels -- the events      a group of annotators -- the items
events (baseline signal + RT)         items (pairwise preference + real score)
每个响应时间response time （RT）      theta，真实分数
每个通道加变换函数对比                 pairwise input
每个通道加变化的对结构的参考性         etha，每个评论者的专业程度

不同：
theta = drchrnd(ones(1,n_obj),1); % generate items    dirchelet 分布产生
rho = betarnd(u,v,1,n_anno); % generate workers     beta分布产生       the quanlity of workers
% ρ是贝塔分布产生的，评论者的素质  eg 0.78 	0.83 	0.26 	0.93 	0.85 	0.89 	0.99 	0.99 
% θ是dirchelet分布产生的，每个物品/项目的分数   eg 0.047 	0.013 	0.063 	0.066 	0.410 	0.067 	0.050 	0.125 	0.149 	0.011 
但是脑电波的RT怎么会满足dirchelet分布？ 各个通道的评分质量eta，怎么会满足β分布呢
ANS:   这里只是参数初始化顺便控制样本的特性，而不是说样本要满足什么分布，我用了 uniform 随机函数，来产生 eta对结果没有任何影响




我:
先验分布指的是？  10个theta ~ mu siga   8个eta ~ alpha, beta 对吧 
我:
至于这个 10个theta之间，  8个eta之间，不用满足任何分布关系
我:
如果是的话，接下来就很顺了
:
对
我:
那么问题，就在于 10个theta，与源源不断的 RT
我:
这个要怎么整


 