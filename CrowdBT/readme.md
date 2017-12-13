# Plan: Concise CrowdBT

    input datafile:  preference + groundtrue, if there is no datafile, then generate by yourself
    output: the accuray, the rank result contrast with the groudtrue

    the online_train, give the   parameter, fit one preference data, and then return  updated the parameter


#babyface result:
list the rank:
 what we get Rank:09 06 15 18 03 05 10 01 04 16 02 14 11 12 08 17 13 07   By CrowdBT, after fit 1500 3-ray preference 
 ground-true Rank:09 06 03 15 18 14 01 04 11 02 08 16 10 05 12 17 07 13   the uainmous preference of myself, not very accurate

accuray:
![alt text](https://github.com/TaoStarlit/matlab/blob/Babyface/CrowdBT/baby%20face%20accuracy-budget.fig)