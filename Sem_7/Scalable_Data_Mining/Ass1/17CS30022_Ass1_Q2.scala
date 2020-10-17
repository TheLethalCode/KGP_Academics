import java.util.TimeZone
import java.text.SimpleDateFormat
import java.util.Date
import org.apache.spark.rdd.RDD
import collection.mutable.HashSet
import java.io.Serializable

val DATA = "ghtorrent-logs.txt"
val COL = "download_id"

case class ghtorrent(
	debug_level: String,
	timestamp: Date,
	download_id: String,
	retrieval_stage: String,
	rest: String
)

def repoName(data: ghtorrent): String = {
	try {
		if (!data.rest.contains("repos")) {
			val f = data.rest.split(" ")
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

// Config Time
TimeZone.setDefault(TimeZone.getTimeZone("GMT"))
val dateTime = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssX")

// Load the data
val lines = sc.textFile(DATA).filter(line => line.size > 0)
val data = lines.map(line => line.split(", | -- ", 4))
val assignment_1 = data.filter(info => info.size == 4).map(info =>
                {
					val temp = info(3).split(": ", 2)
					try {
						ghtorrent(info(0), dateTime.parse(info(1)), info(2), temp(0), temp(1))
					}
					catch {
						case e:Exception => ghtorrent(info(0), null, info(2), temp(0), temp(1))
					}
				}
            )

// Question 2a) (Calculate inverted index)
val invertedIndices = (assignment_1.map(data => 
							(
								if(COL == "debug_level") (data.debug_level, data)
								else if(COL == "timestamp") (data.timestamp, data)
								else if(COL == "download_id") (data.download_id, data)
								else if(COL == "retrieval_stage") (data.retrieval_stage, data)
								else (data.rest, data)
							)
						).aggregateByKey(HashSet.empty[ghtorrent])(_ += _, _ ++= _))

// Question 2b) (Calculate number repos accessed by gh22 without inverted index)
val gh22_count = (assignment_1.filter(data => data.download_id == "ghtorrent-22" &&
								repoName(data) != null)
						.map(data => (repoName(data), 1))
						.reduceByKey(_ + _)
						.count())		
println("b) Number of different repositories accessed by the client ghtorrent-22 (without inverted index): " +  gh22_count)

// Question 2c) (Calculate number repos accessed by gh22 with inverted index)
val gh22_count1 = (sc.parallelize((invertedIndices.filter(kv => kv._1.toString() == "ghtorrent-22").first()._2
								.map(data => repoName(data))
								.filter(data => data != null).toSeq))
								.map(data => (data, 1))
								.reduceByKey(_+_)
								.count())
println("c) Number of different repositories accessed by the client ghtorrent-22 (with inverted index): " +  gh22_count1)								