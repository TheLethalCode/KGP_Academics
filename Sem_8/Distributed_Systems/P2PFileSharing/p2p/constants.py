import logging
import os

#################### State Constants #################
STATE_PATH = '.state'                   # Folder path for state details
if not os.path.exists(STATE_PATH):
    os.makedirs(STATE_PATH)

STATE_REP_QUER = 'repQuerQueue.txt'     # Path for saving repeated queries
STATE_QUERY_RES = 'queryResQueue.txt'   # Path for saving the queue of queries
STATE_QUERY_RESDICT = 'queryRes.json'   # Path for saving the response to query
STATE_PENDING = 'pending.json'          # Path for saving download related stuff
STATE_NET_VARS = 'netvars.json'         # Path for saving state variables
STATE_RT = 'RT.json'                    # Path for saving Routing Table

STATE_UNSAVED_MAX = 20                  # Maximum number of unsaved chunks

STATE_REQ_ID = 'req_id_Dict.json'
STATE_DOWNLOAD_COMPLETE = 'download_complete_dict.json'
STATE_FILE_ID_CACHE = 'file_id_cache.json'


##################### Logger Constants #####################

LOG_PATH = "logs"
if not os.path.exists(LOG_PATH):
    os.makedirs(LOG_PATH)
LOG_FILE = "log.txt"

#################### Network Constants ##########################################

APP_PORT = 4001             # Default Port for creating socket connection.
ENCODING = 'utf-8'          # Default encoding.
MY_IP = '192.168.191.232'   # My IP address in the network
SOCKET_RECV_TIME = 15.0     # Time out for receiving message
SOCKET_SEND_TIME = 7.0      # Time out for sending messages
SOCKET_PING_TIME = 1.5      # Time out for ping messages
MSG_SIZE = 4096             # Amount to receive in one go
SOCK_SLEEP = 0.001          # Sleep in between consecutive receives

#################### FileSystem Constants #######################################

FILESYS_PATH = "fs.pkl"         #
CHUNK_SIZE = 65536             # Chunk Size (in Bytes) 65536 bytes = 64KB

DOWNLOAD_FOLDER = "downloads/"          # Download Folder
INCOMPLETE_FOLDER = ".incomplete/"      # Incomplete Folder

# Statuses
FS_UPLOADED = "UPLOADED"                     # Uploaded by current node
FS_REPLICATION_COMPLETE = "RPC"         # Replication - Download Complete
FS_REPLICATION_PROGRESS = "RIP"         # Replication - Download In Progress
FS_DOWNLOAD_COMPLETE = "DOWNLOAD COMPLETE"            # Download Complete
FS_DOWNLOAD_PROGRESS = "FDP"            # Download In-Progress

# Database Details
DB_HOST = "localhost"                   # The location of the database
DB_USERNAME = "root"                    # Usernmae for accessing the database
DB_NAME = "fsys"                        # Name of the database

# Table
DB_TABLE_FILE = "FILETABLE"             # Table Name
FT_NAME = "name"                        # Column Name for Name of file
FT_PATH = "path"                        # Column Name for Path of file
FT_SIZE = "size"                        # Column Name for Size of file
FT_CHECKSUM = "checksum"                # Column Name for Checksum of file
FT_PARENTID = "parent_id"               # Column Name for ParentId of file
FT_REQUESTID = "random_id"              # Column Name for RequestId of file
FT_STATUS = "status"                    # Column Name for Status of file
FT_REPLICATED_TO = "replication_node"   # Column Name for Replicated_to of file
FT_ID = "ID"                            # Column Name for Id

# Description of CONTENT, the attribute that holds the actual data transferred
# CONTENT = {
#     CHUNK,
#     FILENAME,
#     CHECKSUM
# }
CNT_CHUNK = "chunk"  # ChunkNo. (Int)
CNT_FILENAME = "filename"  # FileNmae (String)
CNT_CHECKSUM = "checksum"  # Checksum (String)
CNT_FILEPATH = "filepath"  # Filepath (String)
CNT_SIZE = "size"  # FileSize (Int)
######################## Message Constants ######################################

# Message Types
JOIN = 'Join'  # A message to join the network
JOIN_ACK = 'Join Ack'  # A message acknowledging the join with the GUID
PING = 'Ping'  # A ping message, heartbeat
PONG = 'Pong'  # Response to the ping, typically
QUERY = 'Query'  # Contains the query of the user
QUERY_RESP = 'Query Response'  # Response to the query
TRANSFER_REQ = 'Transfer Request'  # Request for a transfer of a chunk
TRANSFER_FILE = 'Transfer File'  # The actual content of the transfer

# Common Attributes
TYPE = 'Type'  # Type of the message (String)
SEND_IP = 'Sender IP'  # Sender's IP     (String)
SEND_GUID = 'Sender GUID'  # Sender's GUID   (String)
DEST_IP = 'Destination IP'  # Destination IP  (String)
DEST_GUID = 'Destination GUID'  # Destination     (String)

# Message Attributes

# JOIN MESSAGE = {
#     TYPE,
#     SEND_IP,
#     DEST_IP,
# }

# JOIN MESSAGE = {
#     TYPE,
#     SEND_IP,
#     DEST_IP,
# }

# JOIN_ACK MESSAGE = {
#     TYPE,
#     SEND_IP,
#     SEND_GUID,
#     DEST_IP,
#     DEST_GUID,
#     ROUTING,
# }
ROUTING = 'Routing Table'               # The Routing Table ({IP, GUID})

# PING MESSAGE = {
#     TYPE,
#     SEND_IP,
#     SEND_GUID,
#     DEST_IP,
#     DEST_GUID,
# }

# PONG MESSAGE = {
#     TYPE,
#     SEND_IP,
#     SEND_GUID,
#     DEST_IP,
#     DEST_GUID,
# }

# QUERY_MESSAGE = {
#     TYPE
#     SEND_IP
#     SEND_GUID
#     DEST_IP
#     DEST_GUID
#     SOURCE_IP
#     SOURCE_GUID
#     SEARCH
#     QUERY_ID
# }
SOURCE_IP = 'Source IP'                 # Ip of the query source (String)
SOURCE_GUID = 'Source GUID'             # GUID of the query source (String)
SEARCH = 'Search'                       # The query to search (String)
# The unique query id of the query (String)
QUERY_ID = 'Query ID'

# QUERY_RESP MESSAGE = {
#     TYPE,
#     SEND_IP,
#     SEND_GUID,
#     DEST_IP,
#     DEST_GUID,
#     QUERY_ID,
#     RESULTS,
# }
RESULTS = 'Results'             # The Results received from the file system
# ([{FILE_ID, FT_NAME, NUM_CHUNKS, FT_CHECKSUM}, ])
NUM_CHUNKS = 'Total Chunks'     # The total number of chunks in the file (Int)

# TRANSFER_REQ = {
#     TYPE,
#     SEND_IP,
#     SEND_GUID,
#     DEST_IP,
#     DEST_GUID,
#     REQUEST_ID,
#     FILE_ID,
#     CHUNK_NO,
# }
REQUEST_ID = 'Request ID'       # Request Id
FILE_ID = 'File ID'             # File Id of File
CHUNK_NO = 'Chunk number'       # Chunk Number of File

# TRANSFER_FILE = {
#     TYPE,
#     SEND_IP,
#     SEND_GUID,
#     DEST_IP,
#     DEST_GUID,
#     REQUEST_ID,
#     CHUNK_NO,
#     CONTENT,
# }
CONTENT = 'Data'

############################# Routing Table Constants ###############
UPDATE_FREQ = 30                # Frequency of Ping/Pong
INACTIVE_LIMIT = 5              # Number of Ping fails for node to become Inactive

IP_ADDR = 'IPAddr'              # IpAddr
RT_PORT = 'Port'                # Port Number
RT_ISACTIVE = 'ActiveBool'      # Testing Is Active
RT_INACTIVE = 'InactiveTime'    # Testing InActiveTime
RT_ISCENTRE = 'IsCentre'        # Testing IsCentre


############################# Node Constants ########################
LISTEN_QUEUE = 25               # The size of the connections queue
# The number of threads to use for the transfer per downloads
NUM_THREADS = 8
TRANS_WAIT = 4                  # The time a thread waits before retrying during transfer
DOWN_QUEUE = 6                  # The maximum number of inprogress downloads
QUERY_QUEUE = 8                 # The maximum number of different queries
REP_QUERY_CACHE = 1000          # Number of intermediate queries to hold
QUERY_MIN_SIZE = 3              # Min query size
ERROR_RETRY = 0.1               # Retry period after error

# Commands
HELP = 'help'                   # The Help Command
SEARCH_QUERY = 'search'         # Command to initiate search
DISPLAY = 'show'                # Command to display the results
CHOOSE = 'down'                 # Command to download the results
PROGRESS = 'progress'           # Command to display the progress
ABORT = 'abort'                 # Abort the download
SHARE = 'share'                 # Share Content
UNSHARE = 'remove'              # Unshare Content
LIST = 'list'                   # List Shared Files
PAUSE = 'pause'                 # Pause download
UNPAUSE = 'resume'            # Restart download
PENDING = 'pending'             # Pending downloads
