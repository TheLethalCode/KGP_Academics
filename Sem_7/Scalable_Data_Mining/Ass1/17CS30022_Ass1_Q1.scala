import java.util.TimeZone
import java.text.SimpleDateFormat
import java.util.Date
import org.apache.spark.rdd.RDD

val DATA = "ghtorrent-logs.txt"

case class ghtorrent(
	debug_level: String,
	timestamp: Date,
	download_id: String,
	retrieval_stage: String,
	rest: String
)

def maxCall(data: RDD[ghtorrent]) = {
    val temp = data.groupBy(x => x.download_id).map(x => (x._1, x._2.size))
    temp.max()(Ordering[Int].on(value => value._2))
}

def repoName(data: ghtorrent): String = {
	try {
		if (!data.rest.contains("repos")) {
			var f = data.rest.split(" ")
            return f(f.indexOf("Repo") + 1)
		} else {
			val f = data.rest.split("github.com/repos/")(1).split("\\?")(0).split("/")
			if (f.size == 1) return f(0)
			else return f(0) + "/" + f(1)
		}
	} catch {
		case e: Exception => return null
	}
}

def accessKey(data: ghtorrent): String = {
	try {
		if (data.rest.contains("Access:")) {
			var rest = data.rest.split(" ")
			return rest(rest.indexOf("Access:") + 1).split(",")(0)
		} else {
			return null
		}
	} catch {
		case e: Exception => return null
	}
}

// Config Time
TimeZone.setDefault(TimeZone.getTimeZone("GMT"))
val dateTime = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssX")

// Load the data
val lines = sc.textFile(DATA).filter(line => line.size > 0)
val data = lines.map(line => line.split(", | -- ", 4))
val assignment_1 = data.map(info =>
                (
                    if (info.size != 4) ghtorrent(null, null, null, null, null)
                    else {
                        val temp = info(3).split(": ", 2)
                        try {
                            ghtorrent(info(0), dateTime.parse(info(1)), info(2), temp(0), temp(1))
                        }
                        catch {
                            case e:Exception => ghtorrent(info(0), null, info(2), temp(0), temp(1))
                        }
                    } 
                )
            )

// Question 1a (Number of lines)
println("a) The number of lines in the RDD: " + assignment_1.count())

// Question 1b (Number of warn messages)
println("b) The number of WARN messages: " + assignment_1.filter(data => data.debug_level == "WARN").count())

// Question 1c (Number of different repos processed with api client)
val apiClient = assignment_1.filter(data => data.retrieval_stage == "api_client.rb")
println("c) Number of different repositories processed when retrieval stage is api_client: " + 
                                        apiClient.filter(data => "Repo|repos".r.findFirstIn(data.rest) != None)
                                                 .map(data => (repoName(data), 1))
                                                 .reduceByKey(_ + _)
                                                 .count()
                                             )

// Question 1d (Total http/https requests)
val links = apiClient.filter(data => "https?://".r.findFirstIn(data.rest) != None)
val mostCalls = maxCall(links)
val mostFailed = maxCall(links.filter(data => "Failed request".r.findFirstIn(data.rest) != None))
println("d) i) Client with most http/https requests is " + mostCalls._1 + "(" + mostCalls._2 + ")")
println("d) ii) Client with most failed http/https requests is " + mostFailed._1 + "(" + mostFailed._2 + ")")

// Question 1e (Busiest Hour and Repo)
val maxHr = (assignment_1.filter(data => data.timestamp != null)
                    .map(data => (data.timestamp.getHours(), 1))
                    .reduceByKey(_ + _)
                    .collect()
                    .maxBy(_._2))
var maxRepo = (links.filter(data => "Repo|repos".r.findFirstIn(data.rest) != None && repoName(data) != null) 
        .map(data => (repoName(data), 1))
        .reduceByKey(_ + _)
        .collect()
        .maxBy(_._2))
println("e) i) The most active hour is " + maxHr._1 + " (" + maxHr._2 + ")")
println("e) ii) The most active repo is " + maxRepo._1 + " (" + maxRepo._2 + ")")

// Question 1f (Most failed access key)
val maxKey = (assignment_1.filter(data => data.rest != null &&
                    "Failed request".r.findFirstIn(data.rest) != None &&
                    "Access:".r.findFirstIn(data.rest) != None &&
                    accessKey(data) != null)
                    .map(data => (accessKey(data),1))
                    .reduceByKey(_ + _)
                    .collect()
                    .maxBy(_._2))
println("f) The most failed access key is " + maxKey._1 + " (" + maxKey._2 + ")")
