## 20171213 result
#babyface result:
list the rank:<br/>
 what we get Rank:09 06 15 18 03 05 10 01 04 16 02 14 11 12 08 17 13 07   By CrowdBT, after fit 1500 3-ray preference  <br/>
 ground-true Rank:09 06 03 15 18 14 01 04 11 02 08 16 10 05 12 17 07 13   the uainmous preference of myself, not very accurate <br/>

accuray:<br/>
Babyface：
![Image of babyface accuracy](https://github.com/TaoStarlit/matlab/blob/Babyface/CrowdBT/baby%20face%20accuracy-budget.png)
Simulated data (alpha = [23 4 2 1]):
![Image of Simulated data accuracy](https://github.com/TaoStarlit/matlab/blob/conciseCrowdBT/CrowdBT/simulated%20result.png)

## for the ROPAL Ranking
As the simulated datas of origin source code are not found now, I must generate the data by myself, need repeated comfirm with the Auther.

Finish: generate 3-ray perference <-- eta of W work, (ground-true) Scores of L object. each worker has T task of annotating the 3-ray object.

But using the data, I run the original project, the performance was not very well, so must comfirm the data again with the Auther



# 20171213
when after when I fix the CrowdBT in ROPAL project, accurary is also very low; 
So let me try to edit the CrowBT by myself
First, try to run my data, base on the current project




## Pairwise Crowdsource Ranking

1. 10 object VS many many echochs of EEG:
    计划，里面10个object，现在试着对第0个替换新的数据（theta0），然后重新训练（mu sigma try result 通通都要更新）
    显示他们的mu
1. 完成从数据文件，转化为频谱图信息（频率点，赋值 -- Frequence Amplitude），可以选择去掉高频，减少数据量
    多次测试过频谱函数；可一选择处理过程画出频谱图
