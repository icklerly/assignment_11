import java.io.{PrintWriter, File, FileWriter}
import grizzled.slf4j.Logging
import org.apache.flink.api.common.functions.RichMapFunction
import org.apache.flink.api.scala.DataSet
import org.apache.flink.configuration.Configuration
import org.apache.flink.ml.common.LabeledVector
import org.apache.flink.ml.math.{DenseVector, SparseVector}
import org.apache.flink.ml.regression.MultipleLinearRegression
import org.apache.flink.ml.classification.SVM
import org.apache.flink.ml.evaluation._
import org.apache.flink.api.scala._


/**
 * Created by Lydia Ickler on 16.07.15.
 *
 * This Application reads in a File "subset.csv" that consists of 1791 patients(rows) their cancer type (first column)
 * and their 500 normalized mRNA-Level3 counts (columns 2-501) -> DataSet[String]
 *
 * It then converts the DataSet[String] to either a DataSet[LabeledVector] suitable for either SVM or MLR
 *  - convertSVM()
 *  - convertMLR()
 *
 *  Finally it performs SVM and MLR with specified parameters and a 10-fold cross validation
 *
 *  The results are stored in Output-Files that are named according to the used stepSize
 */

object ML{

  val DIMENSION = "dimension"

  private var dataType: String = null
  private var method: String = null
  private var outputPath: String = null

  private var stepSize: Double = 0

  /*
    //methods to append results to existing file
    def using[A <: {def close() : Unit}, B](resource: A)(f: A => B): B =
      try f(resource) finally resource.close()
    def writeStringToFile(file: File, data: Double, appending: Boolean = false) =
      using(new FileWriter(file, appending))(_.write(data.toString+", "))
  */
  //start of the main program
  def main(args: Array[String]) {

    val env: ExecutionEnvironment = ExecutionEnvironment.getExecutionEnvironment

    if(args.length > 2 && args.length < 5){

      if(args(0).equals("SVM") || args(0).equals("MLR")){
        method=args(0)

        if(args(1).equals("methylation") || args(1).equals("mRNA") || args(1).equals("mixed") || args(1).equals("sparse") ){
          dataType=args(1)

          if(args.length==3){
            if(args(0).equals("MLR")){
              stepSize=0.00000000001
            }
            else{
              stepSize=0.01
            }
          }
          else{
            stepSize=args(3).toDouble
          }

        }
        else{
          System.err.println("<data type> has to be either methylation, mRNA, mixed or sparse")
          return
        }
      }
      else{
        System.err.println("<method> has to be either MLR or SVM")
        return
      }
    }
    else{
      System.err.println("Usage: <method> <data type> <output path> [optional: <stepSize>]")
      return
    }
    //read in the CSV-file
    //val input: DataSet[String] = env.readTextFile("./methylation_subset_Flink.csv")
    outputPath=args(2)
    var input: DataSet[String] = env.readTextFile("hdfs://localhost:9000/users/icklerly/Assignment11/Input/ML/"+dataType+"_Flink.csv")
    //val input: DataSet[String] = env.readTextFile("./"+dataType+"_Flink.csv")

    /*
    *** MLR ***
    */

    //convert input for MLR
    if(method.equals("MLR")){

      val vector1: DataSet[LabeledVector] = convertMLR(input)

      val mlr = MultipleLinearRegression()
        .setIterations(10)
        .setStepsize(stepSize)
        .setConvergenceThreshold(0.001)


      //initialize the scorer -> MeanSquaredError
      //val squaredScorer = new Scorer(RegressionScores.squaredLoss)
      val signumScorer = new Scorer(RegressionScores.zeroOneSignumLoss)

      //start the 10-fold cross validation
      val cvScore1 = CrossValidation.crossValScore(mlr, vector1, scorerOption = Some(signumScorer), cv = KFold(10), seed = 0L)

      //System.out.println(cvScore1.map(ds => ds.collect().head).sum/10)
      mlr.weightsOption.get.writeAsCsv(outputPath+"/"+dataType+"_"+method+"_weights")

      //collect results from the 10 runs and calculate the mean
      //val x1 = cvScore1.map(ds => ds.collect().head).sum
      //val labeledVectorsDS = env.fromCollection(Seq("Error rate: "+x1/10))
      //labeledVectorsDS.writeAsText(outputPath+"/"+dataType+"_"+method+"_errorRate")
      //print("\"Error rate: "+x1/10+"\n")




    }


    /*
    *** SVM ***
   */

    if(method.equals("SVM")){

      //convert input for SVM
      val vector2: DataSet[LabeledVector] = convertSVM(input)
      //
      //initialize the SVM-Learner
      val svm = SVM()
        .setBlocks(env.getParallelism)
        .setIterations(10)
        .setStepsize(stepSize)
        .setRegularization(0.001)
        .setSeed(42)

      //initialize the scorer -> if same sign -> 0 else 1
      val signumScorer = new Scorer(RegressionScores.zeroOneSignumLoss)

      //start the 10-fold cross validation
      val cvScore2 = CrossValidation.crossValScore(svm, vector2, scorerOption = Some(signumScorer), cv = KFold(10), seed = 0L)


      //vector2.writeAsCsv("hdfs://localhost:9000/users/icklerly/alt/bla6887.csv")
      svm.weightsOption.get.writeAsCsv(outputPath + "/" + dataType + "_" + method + "_weights")

      //collect results from the 10 runs and calculate the mean
      //val x2 = cvScore2.map(ds => ds.collect().head).sum

      //print("Error rate: " + x2 / 10 + "\n")

      //write results to file
      //writeStringToFile(new File(outputPath+"/"+dataType+"_"+method+"_result.txt"), (x2 / 10), true)
    }



    env.execute()
  }

  // method to convert DataSet[String] to DataSet[LabeledVector] suitable for the MLR
  def convertMLR(set:DataSet[String]): DataSet[LabeledVector] = {

    val labelCOODS = set.flatMap {
      line =>
        // remove all comments which start with a '#'
        val commentFreeLine = line.takeWhile(_ != '#').trim

        if(commentFreeLine.nonEmpty) {
          val splits = commentFreeLine.split('\t')
          val label = splits.head.toDouble
          val sparseFeatures = splits.tail
          val coos = sparseFeatures.map {
            str =>
              // libSVM index is 1-based, but we expect it to be 0-based
              val value = str.toDouble
              (value)
          }

          Some((label, coos))
        } else {
          None
        }
    }

    labelCOODS.map{ new RichMapFunction[(Double, Array[(Double)]), LabeledVector] {
      var dimension = 0

      override def map(value: (Double, Array[(Double)])): LabeledVector = {
        new LabeledVector(value._1, DenseVector(value._2))
      }
    }}

  }

  // method to convert DataSet[String] to DataSet[LabeledVector] suitable for the SVM
  def convertSVM(set:DataSet[String]): DataSet[LabeledVector] = {

    val labelCOODS =set.flatMap {
      line =>
        // remove all comments which start with a '#'
        val commentFreeLine = line.takeWhile(_ != '#').trim

        if(commentFreeLine.nonEmpty) {
          val splits = commentFreeLine.split('\t')
          val label = splits.head.toDouble
          val sparseFeatures = splits.tail
          var a=1
          val coos = sparseFeatures.map {
            str =>
              // libSVM index is 1-based, but we expect it to be 0-based
              val index = a - 1
              val value = str.toDouble
              a = a+1
              (index, value)
          }

          Some((label, coos))
        } else {
          None
        }
    }

    // Calculate maximum dimension of vectors
    val dimensionDS = labelCOODS.map {
      labelCOO =>
        labelCOO._2.map( _._1 + 1 ).max
    }.reduce(scala.math.max(_, _))


    labelCOODS.map{ new RichMapFunction[(Double, Array[(Int, Double)]), LabeledVector] {
      var dimension = 0

      override def open(configuration: Configuration): Unit = {
        dimension = getRuntimeContext.getBroadcastVariable(DIMENSION).get(0)
      }

      override def map(value: (Double, Array[(Int, Double)])): LabeledVector = {
        new LabeledVector(value._1, SparseVector.fromCOO(dimension, value._2))
      }
    }}.withBroadcastSet(dimensionDS, DIMENSION)

  }
}
