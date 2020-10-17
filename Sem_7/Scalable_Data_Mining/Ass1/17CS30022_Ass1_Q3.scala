import java.util.TimeZone
import java.text.SimpleDateFormat
import java.util.Date
import org.apache.spark.rdd.RDD
import collection.mutable.HashSet
import java.io.Serializable

val DATA1 = "ghtorrent-logs.txt"
val DATA2 = "important-repos.csv"

case class ghtorrent(
	debug_level: String,
	timestamp: Date,
	download_id: String,
	retrieval_stage: String,
	rest: String
)

case class important_repos(
	id: String,
	url: String,
	owner_id: String,
	name: String,
	language: String,
	created_at: String,
	forked_from: String,
	deleted: String,
	updated_at: String
)

def repoName(data: String): String = {
	try {
		if (!data.contains("repos")) {
			val f = data.split(" ")
			return f(f.indexOf("Repo") + 1)
		} else {
			val f = data.split("github.com/repos/")(1).split("\\?")(0).split("/")
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
val assignment_1 = (sc.textFile(DATA1)
                    .filter(line => line.size > 0)
                    .map(line => line.split(", | -- ", 4))
                    .filter(info => info.size == 4)
                    .map(info => {
                            val temp = info(3).split(": ", 2)
                            try {
                                ghtorrent(info(0), dateTime.parse(info(1)), info(2), temp(0), temp(1))
                            } catch {
                                case e:Exception => ghtorrent(info(0), null, info(2), temp(0), temp(1))
                            }
                        }
                    ))
val assignment_2 = (sc.textFile(DATA2)
                    .filter(line => line.size > 0)
                    .map(line => line.split(","))
                    .filter(info => info.size == 9 && info(0) != "id")
                    .map(z => {
                            try {
                                important_repos(z(0), z(1), z(2), z(3), z(4), z(5), z(6), z(7), z(8))
                            } catch {
                                case e:Exception => important_repos(null, null, null, null, null, null, null, null, null)
                            }
                        }
                    ))

// Joined records
val logs = (assignment_1.filter(data => data.rest != null &&
                            "Repo|repos".r.findFirstIn(data.rest) != None &&
                            repoName(data.rest) != null)
                        .map(data => (repoName(data.rest), data)))

println(logs.count())
val record = (assignment_2.filter(data => repoName(data.url) != null)
                        .map(data => (repoName(data.url), data)))
val joined = record.join(logs)

// Question 3a) (Number of records)
println("a) The number of records: " + assignment_2.count())

// Question 3b) (Number of records in both the files)
println("b) The number of records in both files: " + joined.count())

// Question 3c) (Most failed api requests in the joined record)
val maxFailed = (joined.filter(both => both._2._2.retrieval_stage == "api_client.rb" &&
                                                both._2._2.rest.contains("Failed request"))
                                        .map(both => (both._1, 1))
                                        .reduceByKey(_ + _)
                                        .collect()
                                        .maxBy(_._2))
println("c) The repository that has the most failed API calls in assignment_2 is " + maxFailed._1 + " (" + maxFailed._2 + ")" )


