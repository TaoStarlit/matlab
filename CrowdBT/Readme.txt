��ϸ����һ�£����Ч������Ĵ��룬��online_update������ʲô��
�������ʱ��
c=0.1
kappa=1.0e-04
taylor=1

mu sigma ��������ͷ����ˣ����� ����̩�ռ���������C1 C2 Ȼ�󷵻��µ� alpha beta




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


�������еĴ���
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Crowd-BT Algorithm
%%%%%%%%%%%%%%%%%%%%%%%%%%%
Active Learning
% data 360 K*N(�������)= 8*(10*9/2/1)ò��û��ʵ�����ݣ�ֻ�ж�Ӧ��ϵ��  data �ֶ�1��worker;  �ֶ�2��3����Ʒ��ŵ���ϣ�ÿ��worker��ȫһ�����ظ���
% score 360 
% try result �����м����� ÿ�����������ȫ���� sigma mu 1 2,  alpha, beta

% ����������� (Dir����8����ÿ��worker��Ӧһ��alpha,beta,���ư����ֵı���)alpha, beta   (Gaussian ����10��)mu sigma 

����������ģ�͵Ĳ��������Ϊ��ʵ���� 
% ���Ǳ����ֲ������ģ������ߵ�����  eg 0.78 	0.83 	0.26 	0.93 	0.85 	0.89 	0.99 	0.99 
% ����dirchelet�ֲ������ģ�ÿ����Ʒ/��Ŀ�ķ���   eg 0.047 	0.013 	0.063 	0.066 	0.410 	0.067 	0.050 	0.125 	0.149 	0.011 

�����buget����ָʾ��Ҫ���㼸�Σ�����˵���뼸������
�����м������mu��������ԭʼ��theta���Ա�

ÿ������������׼������ʱ���ʹ��ϴεĽ������ȡ���������
        % �������� ������ mu sigma
        mu(i) = try_result{r,1}.mu1;
        mu(j) = try_result{r,1}.mu2;
        sigma(i) = try_result{r,1}.sigma1;
        sigma(j) = try_result{r,1}.sigma2;




���ߵ��к��벻ͬ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
How to leverage Crowded Source
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
���ϣ� 
BCI multi-Channels -- the events      a group of annotators -- the items
events (baseline signal + RT)         items (pairwise preference + real score)
ÿ����Ӧʱ��response time ��RT��      theta����ʵ����
ÿ��ͨ���ӱ任�����Ա�                 pairwise input
ÿ��ͨ���ӱ仯�ĶԽṹ�Ĳο���         etha��ÿ�������ߵ�רҵ�̶�

��ͬ��
theta = drchrnd(ones(1,n_obj),1); % generate items    dirchelet �ֲ�����
rho = betarnd(u,v,1,n_anno); % generate workers     beta�ֲ�����       the quanlity of workers
% ���Ǳ����ֲ������ģ������ߵ�����  eg 0.78 	0.83 	0.26 	0.93 	0.85 	0.89 	0.99 	0.99 
% ����dirchelet�ֲ������ģ�ÿ����Ʒ/��Ŀ�ķ���   eg 0.047 	0.013 	0.063 	0.066 	0.410 	0.067 	0.050 	0.125 	0.149 	0.011 
�����Ե粨��RT��ô������dirchelet�ֲ��� ����ͨ������������eta����ô������·ֲ���
ANS:   ����ֻ�ǲ�����ʼ��˳��������������ԣ�������˵����Ҫ����ʲô�ֲ��������� uniform ��������������� eta�Խ��û���κ�Ӱ��




��:
����ֲ�ָ���ǣ�  10��theta ~ mu siga   8��eta ~ alpha, beta �԰� 
��:
������� 10��theta֮�䣬  8��eta֮�䣬���������κηֲ���ϵ
��:
����ǵĻ����������ͺ�˳��
:
��
��:
��ô���⣬������ 10��theta����ԴԴ���ϵ� RT
��:
���Ҫ��ô��


 