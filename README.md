#Technical Description

#Input Data
all input files are stored inside the HDFS which is accessible via: hdfs://localhost:9000/users/icklerly/assignment11/Input

Machine Learning Files:
    
    - ./methylation_Flink.csv
    - ./mRNA_Flink.csv
    - ./mixed_Flink.csv
    - ./sparse_Flink.csv

Network Files:
    
    - ./methylation_edges.csv
    - ./mRNA_edges.csv

#Programs

Matrix Completion:
0 2 0.001 10 1 1  ./persistence ./NaN_Flink.csv ./output_meth


