import shutil
import sqlite3
import math
import hashlib
from binaryornot.check import is_binary
import base64
import os
import re
import sys
import logging
import constants
import json
# import p2p.constants as constants
import threading

# TODO: REPLICATION
# TODO: --> Set ParentID and RequestId properly
# TODO: --> request removal of replication when removing content
# TODO: saving states of dicts
# TODO: load states using
# TODO: clean code
# TODO: return None at proper places instead of false

logger = logging.getLogger('fileSystem')
logger.setLevel(logging.INFO)

fh = logging.FileHandler(os.path.join(constants.LOG_PATH, constants.LOG_FILE))
formatter = logging.Formatter(
    '%(asctime)s - %(name)s - %(threadName)s - %(levelname)s - %(message)s'
)
fh.setFormatter(formatter)
logger.addHandler(fh)


class fileSystem(object):
    """
        Initialises an FileSystem object
        If already present at set location, then loads from directory
        Else creates a new database with set columns
    """

    def __init__(self):
        super().__init__()
        self.reqIdDict = {}
        self.downloadComplete = {}
        self.fileIdcache = {}
        self.databaseLock = threading.RLock()
        self.fsLocation = constants.FILESYS_PATH
        if not os.path.exists(constants.DOWNLOAD_FOLDER):
            os.makedirs(constants.DOWNLOAD_FOLDER)
        if not os.path.exists(constants.INCOMPLETE_FOLDER):
            os.makedirs(constants.INCOMPLETE_FOLDER)
        try:
            self.fs_db = sqlite3.connect(
                constants.DB_NAME, check_same_thread=False)
            self.fs_db_cursor = self.fs_db.cursor()
            logger.info("DATABASE: Exists")
            # print("DATABASE: EXISTS")
            logger.info("DATABASE: Creating Table if not exists")
            # print("DATABASE: CREATING TABLE")
            query = "CREATE TABLE IF NOT EXISTS "+constants.DB_TABLE_FILE+" ( "\
                + constants.FT_ID + " INTEGER PRIMARY KEY AUTOINCREMENT,"\
                + constants.FT_NAME+" VARCHAR(100) NOT NULL, "\
                + constants.FT_PATH+" VARCHAR(255) UNIQUE, "\
                + constants.FT_SIZE+" INT(255), "\
                + constants.FT_CHECKSUM + " VARCHAR(255), "\
                + constants.FT_PARENTID + " VARCHAR(255), "\
                + constants.FT_REQUESTID + " INT(255), "\
                + constants.FT_STATUS + " VARCHAR(255), "\
                + constants.FT_REPLICATED_TO + " VARCHAR(255)"\
                + ")"
            logger.info('EXECUTING: {}'.format(query))
            # print("EXECUTING :", query)
            with self.databaseLock:
                self.fs_db_cursor.execute(query)
                self.fs_db.commit()
            # print(*self.view_table(constants.DB_TABLE_FILE), sep='\n')
        except Exception as ex:
            # print(ex)
            logger.warning("{}".format(ex))
            pass

    def load_state(self):
        logger.info("Loading States from file")
        self.load_state_reqIdDict()
        self.load_state_downloadComplete_dict()
        self.load_state_fileIdCache()
        return True

    def load_state_reqIdDict(self):
        path = os.path.join(constants.STATE_PATH, constants.STATE_REQ_ID)
        if os.path.exists(path):
            with open(path) as load:
                self.reqIdDict = json.load(load)
            logger.info("Loaded ReqIdDict from json")
        tempDict = {int(k): v for k, v in self.reqIdDict.items()}
        self.reqIdDict = tempDict

    def save_state_reqIdDict(self):
        path = os.path.join(constants.STATE_PATH, constants.STATE_REQ_ID)
        with open(path, 'w') as save:
            json.dump(self.reqIdDict, save)
        logger.info("Saved ReqIdDict to json")

    def load_state_downloadComplete_dict(self):
        path = os.path.join(constants.STATE_PATH,
                            constants.STATE_DOWNLOAD_COMPLETE)
        if os.path.exists(path):
            with open(path) as load:
                self.downloadComplete = json.load(load)
            logger.info("Loaded DownloadCompleteDict from json")
        tempDict = {int(k): v for k, v in self.downloadComplete.items()}
        self.downloadComplete = tempDict

    def save_state_downloadComplete_dict(self):
        path = os.path.join(constants.STATE_PATH,
                            constants.STATE_DOWNLOAD_COMPLETE)
        with open(path, 'w') as save:
            json.dump(self.downloadComplete, save)
        logger.info("Saved DownloadCompleteDict to json")

    def load_state_fileIdCache(self):
        path = os.path.join(constants.STATE_PATH,
                            constants.STATE_FILE_ID_CACHE)
        if os.path.exists(path):
            with open(path) as load:
                self.fileIdcache = json.load(load)
            logger.info("Loaded FileIdCache from json")
        tempDict = {int(k): v for k, v in self.fileIdcache.items()}
        self.fileIdcache = tempDict

    def save_state_fileIdCache(self):
        path = os.path.join(constants.STATE_PATH,
                            constants.STATE_FILE_ID_CACHE)
        with open(path, 'w') as save:
            json.dump(self.fileIdcache, save)
        logger.info("Saved FileIdCache to json")

    def add_entry(self, table_name, name, path, size, checksum, parentID, randomID, status, replication):
        query = "INSERT INTO "+table_name+"(" + constants.FT_NAME+"," + constants.FT_PATH+", "\
                + constants.FT_SIZE+", " + constants.FT_CHECKSUM + ", " + constants.FT_PARENTID + ", " \
                + constants.FT_REQUESTID + ", " + constants.FT_STATUS + ", " + constants.FT_REPLICATED_TO + ")"\
                + "VALUES ('%s','%s','%d','%s','%s','%s','%s','%s')" % (name,
                                                                        path, size, checksum, parentID, randomID, status, replication)
        logger.info('EXECUTING: {}'.format(query))

        try:
            with self.databaseLock:
                self.fs_db_cursor.execute(query)
                self.fs_db.commit()
            logger.info("Commit Successful")
            logger.info("{} record inserted".format(
                self.fs_db_cursor.rowcount))
        except Exception as ex:
            # TODO ADD SOME LOGGING MECHANISM
            logger.warning("{}".format(ex))
            # print(Ex)
            self.fs_db.rollback()
            logger.info("Rolling back Successful")

    def remove_entry(self, table_name, what, what_value):
        query = "DELETE from "+table_name+" where "+what+" = '"+what_value+"'"
        self.execute_query(query)
        return True

    def view_table(self, table_name):
        query = "SELECT * FROM "+table_name
        # print(query)
        response = []
        try:
            with self.databaseLock:
                self.fs_db_cursor.execute(query)
                logger.info('EXECUTING: {}'.format(query))
                result = self.fs_db_cursor.fetchall()
            for r in result:
                response.append(self.get_list_item_to_fileSys_item(r))
            return response
        except Exception as Ex:
            logger.warning("{}".format(Ex))
            # print(Ex)
            return None

    def search(self, word):
        query = 'SELECT %s,%s,%s,%s FROM %s WHERE (%s LIKE ' % (
            constants.FT_ID, constants.FT_NAME, constants.FT_SIZE, constants.FT_CHECKSUM, constants.DB_TABLE_FILE, constants.FT_NAME)
        query += "'%"+word+"%' "
        query += " OR "+constants.FT_PATH+" LIKE '%"+word+"%')"
        response = []
        try:
            with self.databaseLock:
                self.fs_db_cursor.execute(query)
                logger.info('EXECUTING: {}'.format(query))
                result = self.fs_db_cursor.fetchall()
            for r in result:
                response.append({
                    constants.FILE_ID: r[0],
                    constants.FT_NAME: r[1],
                    constants.NUM_CHUNKS: int(math.ceil(r[2]/constants.CHUNK_SIZE)),
                    constants.FT_CHECKSUM: r[3],
                    constants.FT_SIZE: r[2]
                })
        except Exception as Ex:
            # print(Ex)
            logger.warning("{}".format(Ex))
            self.fs_db.rollback()
        finally:
            return response

    def getContent(self, fileId, chunkNumber):
        """
            Returns as chunk of predefined ChunkSize from file using input FileID

            Inputs:
                fileId
                chunkNumber
            Returns:
                Chunk, if accessible
                False, if File DNE or File is not Binary
        """
        try:
            if fileId not in self.fileIdcache.keys():
                response = self.get_fileDetails_from_fileID(fileId)
                if response:
                    self.fileIdcache[fileId] = response
                self.save_state_fileIdCache()

            fileDetails = self.fileIdcache[fileId]
        except KeyError as ker:
            logger.warning("FileId {} Does not exists".format(fileId))
            return None
        file_path = fileDetails[constants.FT_PATH]
        if is_binary(file_path) == False:
            logger.warning("File {} is not a binary file".format(file_path))
            return None
        else:
            try:
                with open(file_path, "rb") as f:
                    f.seek(constants.CHUNK_SIZE * chunkNumber, 0)
                    readChunk = f.read(constants.CHUNK_SIZE)
                    logger.info(
                        "Read Chunk {} Successfull".format(chunkNumber))
                    return {
                        constants.CNT_CHUNK: readChunk,
                        constants.CNT_FILENAME: fileDetails[constants.FT_NAME],
                        constants.CNT_CHECKSUM: self.checksum(readChunk),
                        constants.CNT_FILEPATH: fileDetails[constants.FT_PATH],
                        constants.CNT_SIZE: fileDetails[constants.FT_SIZE]
                    }
            except Exception as Ex:
                logger.warning("{}".format(Ex))
                # print(Ex)
                return None

    def get_list_item_to_fileSys_item(self, a):
        a_dict = {
            constants.FT_ID: a[0],
            constants.FT_NAME: a[1],
            constants.FT_PATH: a[2],
            constants.FT_SIZE: a[3],
            constants.FT_CHECKSUM: a[4],
            constants.FT_PARENTID: a[5],
            constants.FT_REQUESTID: a[6],
            constants.FT_STATUS: a[7],
            constants.FT_REPLICATED_TO: a[8]
        }
        return a_dict

    def get_fileDetails_from_fileID(self, fileId):
        query = "SELECT * from "+constants.DB_TABLE_FILE + \
            " where "+constants.FT_ID+" = "+str(fileId)
        result = self.execute_query(query, True)
        if len(result) > 0:
            result = result[0]
            return self.get_list_item_to_fileSys_item(result)
        else:
            return {}

    def get_fileDetails_from_reqID(self, reqId):
        query = "SELECT * from "+constants.DB_TABLE_FILE + \
            " where "+constants.FT_REQUESTID+" = "+str(reqId)
        result = self.execute_query(query, True)
        if len(result) > 0:
            result = result[0]
            return self.get_list_item_to_fileSys_item(result)
        else:
            return {}

    def remove_table(self, table_name):
        query = "DROP TABLE "+table_name
        self.execute_query(query)

    def remove_database(self, database_name):
        query = "DROP DATABASE "+database_name
        self.execute_query(query)

    def execute_query(self, query, response=False):
        if response == True:
            try:
                with self.databaseLock:
                    logger.info('EXECUTING: {}'.format(query))
                    self.fs_db_cursor.execute(query)
                    result = self.fs_db_cursor.fetchall()
                return result
            except Exception as Ex:
                # TODO ADD SOME LOGGING MECHANISM
                logger.warning("{}".format(Ex))
                # print(Ex)
                self.fs_db.rollback()
        else:
            try:
                with self.databaseLock:
                    logger.info('EXECUTING: {}'.format(query))
                    self.fs_db_cursor.execute(query)
                    self.fs_db.commit()
                # print("Commit Successful")
            except Exception as Ex:
                # TODO ADD SOME LOGGING MECHANISM
                logger.warning("{}".format(Ex))
                # print(Ex)
                self.fs_db.rollback()

    def checksum(self, chunk):
        md5_hash = hashlib.md5()
        md5_hash.update(chunk)
        return md5_hash.hexdigest()

    def checksum_large(self, path):
        md5_obj = hashlib.md5()
        blockSize = constants.CHUNK_SIZE
        with open(path, "rb") as a:
            chunk = a.read(constants.CHUNK_SIZE)
            while chunk:
                md5_obj.update(chunk)
                chunk = a.read(constants.CHUNK_SIZE)
            cSum = md5_obj.hexdigest()
        return cSum

    def writeChunk(self, mssg):
        logger.info("Writing Chunk {} for Request Id: {}".format(str(mssg[constants.CHUNK_NO]),
                                                                 mssg[constants.REQUEST_ID]))
        try:
            content = mssg[constants.CONTENT]
            fileName = str(mssg[constants.REQUEST_ID])+"_" + \
                content[constants.CNT_FILENAME]
            chunk = content[constants.CNT_CHUNK]
            filepath = content[constants.CNT_FILEPATH]
            checkSum_rec = content[constants.CNT_CHECKSUM]
        except Exception as Ex:
            logger.warning("Error in content of message")
            logger.warning(Ex)
            return False

        if self.checksum(chunk) != checkSum_rec:
            logger.warning("Checksum for Request Id: {} Do not match".format(
                mssg[constants.REQUEST_ID]))
            return False
        else:
            if mssg[constants.REQUEST_ID] not in self.reqIdDict.keys():
                self.reqIdDict[mssg[constants.REQUEST_ID]
                               ] = filepath.split("/")[-1]
                logger.info("Added {} to Request_Id_Dictionary".format(
                    mssg[constants.REQUEST_ID]))
                self.save_state_reqIdDict()
            if not os.path.exists(constants.INCOMPLETE_FOLDER + fileName):
                os.makedirs(constants.INCOMPLETE_FOLDER+fileName)
                logger.info("Created Folder {}".format(
                    constants.INCOMPLETE_FOLDER + fileName))
            with open(constants.INCOMPLETE_FOLDER+fileName+"/"+str(mssg[constants.CHUNK_NO]), "wb") as f:
                f.write(chunk)
                logger.info("Writing Chunk Number {} to {} is Successfull".format(
                    str(mssg[constants.CHUNK_NO]), fileName))
            return True

    def done(self, reqId):
        folderName = constants.INCOMPLETE_FOLDER + \
            str(self.get_foldername_using_reqId(reqId))
        filename = self.reqIdDict[reqId]
        # filename = self.reqIdDict[reqId]
        self.join_chunks(folderName, constants.DOWNLOAD_FOLDER + filename)
        filepath = constants.DOWNLOAD_FOLDER + filename
        self.add_entry(constants.DB_TABLE_FILE, filename.split(".")[0], filepath, os.stat(
            filepath).st_size, self.checksum_large(filepath), 0, 0, constants.FS_DOWNLOAD_COMPLETE, None)
        logger.info(
            "Entry for download of file {} made in database".format(filename))
        self.downloadComplete[reqId] = filename
        self.save_state_downloadComplete_dict()
        self.reqIdDict.pop(reqId)
        self.save_state_reqIdDict()
        shutil.rmtree(folderName)
        logger.info(
            "Incomplete folder {} deleted successfully".format(folderName))
        return True

    def get_foldername_using_reqId(self, request_id):
        for x in os.listdir(constants.INCOMPLETE_FOLDER):
            if os.path.isdir(constants.INCOMPLETE_FOLDER+x) and x.startswith(str(request_id)+"_"):
                return x

    def join_chunks(self, fromdir, toFile):
        logger.info("Joining chunks from {} to {}".format(fromdir, toFile))
        with open(toFile, 'wb+') as output:
            parts = os.listdir(fromdir)
            parts.sort(key=lambda f: int(re.sub('\D', '', f)))
            for filename in parts:
                filepath = os.path.join(fromdir, filename)
                with open(filepath, 'rb') as input:
                    output.write(input.read())
        logger.info("Joining chunks for {} completed".format(toFile))

    def update_status_using_reqId(self, table_name, reqId, newStatus):
        if reqId > 0:
            query = "UPDATE "+table_name+"SET "+constants.FT_STATUS+" = " + \
                newStatus+" WHERE "+constants.FT_REQUESTID+"="+str(reqId)
            self.execute_query(query)

    def isFinished(self, reqId):
        if reqId not in self.downloadComplete.keys():
            return False
        else:
            return True

    def add(self, path):
        """
            Make content available for download
            Add entry to table with Status as UPLOAD

            Returns
                TRUE on success
                FALSE on failure
        """
        if (not os.path.exists(path)) or (os.path.isfile(path) and not is_binary(path)):
            logger.warning(
                "Path: Does not Exists or Is not a Binary File".format(path))
            return False
        elif (os.path.isdir(path)):
            logger.info("Sharing all files of folder {}".format(path))
            for file in os.listdir(path):
                file = path+"/"+file
                if os.path.isfile(file):
                    # print(file)
                    self.add(file)
            return True
        else:
            logger.info("Request to Share file: {}".format(path))
            filename = os.path.splitext(path)[0].split("/")[-1]
            file_stat = os.stat(path)
            size = file_stat.st_size
            cSum = self.checksum_large(path)
            parentId = "0"
            randId = 0
            status = constants.FS_UPLOADED
            replication = None
            self.add_entry(constants.DB_TABLE_FILE, filename, path,
                           size, cSum, parentId, randId, status, replication)
            logger.info("File Share Done for {}".format(path))
            return True

    def abort_download(self, reqId):
        logger.info("Abort Requested for Request Id {}".format(reqId))
        try:
            folderName = self.get_foldername_using_reqId(reqId)
            self.reqIdDict.pop(reqId)
            self.save_state_reqIdDict()
            shutil.rmtree(constants.INCOMPLETE_FOLDER+folderName)
            logger.info(
                "Removed All Temporary files for Abort Request Id {}".format(reqId))
            return True
        except Exception as Ex:
            logger.warning(Ex)
            return False

    def removeShare(self, path):
        logger.info("Received Request to unshare {}".format(path))
        if (not os.path.exists(path)):
            logger.info("Path {} does not exists".format(path))
            return False
        elif (os.path.isdir(path)):
            logger.info("Unsharing contents of {}".format(path))
            for file in os.listdir(path):
                file = path+"/"+file
                if os.path.isfile(file):
                    # print(file)
                    self.removeShare(file)
            logger.info("Unshare completed for {}".format(path))
            return True
        else:
            self.remove_entry(constants.DB_TABLE_FILE, constants.FT_PATH, path)
            logger.info("Unshared {}".format(path))
            return True

    def reqId_to_name(self, reqId):
        if reqId in self.reqIdDict.keys():
            return self.reqIdDict[reqId]
        else:
            return None

    def test_done(self):
        import time
        for i in range(math.ceil(422898/constants.CHUNK_SIZE)):
            chunk = self.getContent(4, i)
            mssg = {
                'Data': chunk,
                'Chunk number': i,
                'Request ID': 124
            }
            self.writeChunk(mssg)
            time.sleep(2)
        # self.abort_download(124)
        print(self.done(124))
        pass
