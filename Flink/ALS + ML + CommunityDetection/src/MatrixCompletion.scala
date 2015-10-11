/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import org.apache.flink.api.scala._
import org.apache.flink.ml.recommendation.ALS

/**
 * Implements the "WordCount" program that computes a simple word occurrence histogram
 * over text files. 
 *
 * The input is a plain text file with lines separated by newline characters.
 *
 * Usage:
 * {{{
 *   WordCount <text path> <result path>>
 * }}}
 *
 * If no parameters are provided, the program is run with default data from
 *
 * This example shows how to:
 *
 *   - write a simple Flink program.
 *   - use Tuple data types.
 *   - write and use user-defined functions.
 *
 */
object MatrixCompletion {

  private var inputTrain: String = null
  private var inputPredict: String = null
  private var outputPath: String = null

  def main(args: Array[String]) {


    if(args.length == 3){

      inputTrain = args(0)
      inputPredict = args(1)
      outputPath = args(2)
    }
    else{
      System.err.println("Usage: <input path: train> <input path: predict> <output path/File>")
      return
    }

    val env = ExecutionEnvironment.getExecutionEnvironment

    val data2Predict: DataSet[(Int, Int)] = env.readCsvFile[(Int, Int)]("hdfs://localhost:9000/users/icklerly/Assignment11/Input/ALS/NaN_predict_Flink.csv")
    val inputDS: DataSet[(Int, Int, Double)] = env.readCsvFile[(Int, Int, Double)]("hdfs://localhost:9000/users/icklerly/Assignment11/Input/ALS/NaN_train_Flink.csv")


    val als = ALS()
      .setIterations(10)
      .setNumFactors(2)
      .setLambda(0.001)
      .setBlocks(1)
      .setSeed(1)

    als.fit(inputDS)


    val result  = als.predict(data2Predict)
    result.writeAsCsv("hdfs://localhost:9000/users/icklerly/Assignment11/Output/ALS.csv")

    env.execute("Matrix Completion - icklerly")


  }

}


