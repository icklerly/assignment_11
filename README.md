#Technical Description

#Input Data
all input files are stored inside the HDFS which is accessible at: hdfs://localhost:9000/users/icklerly/assignment11/Input

Matrix Completion Files:
    
    - ./ALS/NaN_predict_Flink.csv
    - ./ALS/NaN_train_Flink.csv

Machine Learning Files:
    
    - ./ML/methylation_Flink.csv
    - ./ML/mRNA_Flink.csv
    - ./ML/mixed_Flink.csv
    - ./ML/sparse_Flink.csv

Network File:
    
    - ./mRNA_edges.csv

#Program
The Jar "Assignment11_icklerly.jar" contains all methods:

1.
Matrix Completion:
-c MatrixCompletion [input path: train] [input path: predict] [output path/fileName]

e.g.    bin/flink run -c MatrixCompletion
        /tmp/icklerly/try999.jar 
        hdfs://localhost:9000/users/icklerly/Assignment11/Input/ALS/NaN_train_Flink.csv 
        hdfs://localhost:9000/users/icklerly/Assignment11/Input/ALS/NaN_predict_Flink.csv 
        hdfs://localhost:9000/users/icklerly/Assignment11/Output/NaN_predicted.csv

2.
Machine Learning:
-c ML [method] (MLR, SVM) [data type] (methylation, mRNA, mixed, sparse) [output path]

e.g.    bin/flink run -c ML /tmp/icklerly/try999.jar 
        MLR
        sparse
        hdfs://localhost:9000/users/icklerly/Assignment11/Output/ML

3.
Community Detection
-c Communitydetection [edge path] [output path/fileName] [num iterations] [delta]

e.g.    bin/flink run -c Communitydetection /tmp/icklerly/try999.jar 
        MLR
        sparse
        hdfs://localhost:9000/users/icklerly/Assignment11/Output/ML



