import json
import os
import sys
import time
import threading
import copy
import network
from constants import *


# TODO:- Manage log(N) entries

logger = logging.getLogger('routingTable')
logger.setLevel(logging.INFO)

fh = logging.FileHandler(os.path.join(LOG_PATH, LOG_FILE))
formatter = logging.Formatter(
    '%(asctime)s - %(name)s - %(threadName)s - %(levelname)s - %(message)s'
)
fh.setFormatter(formatter)
logger.addHandler(fh)


class routingTable(object):
    def __init__(self, isBootstrap, GUID):
        self.isBootstrap = isBootstrap
        self.myGUID = GUID
        self.updateFreq = UPDATE_FREQ
        self.inactiveLimit = INACTIVE_LIMIT

        self.mutex = threading.Lock()  # for locking rt
        self.mutexPP = threading.Lock()  # for locking sentPing and recvPong

        self.sentPing = []
        self.recvPong = []

        self.RT = dict()

        self.StayActive = True  # Destructor sets it to false, thread then exits loop and joins
        self.thread = threading.Thread(target=self.periodicActivityCheck, args=())
        self.thread.daemon = True
        self.thread.start()
        

    def __del__(self):
        self.StayActive = False
        self.thread.join()

    def initialise(self, rt, myGUID, Central_GUID, Central_IP):
        if len(self.RT) != 0:
            print('Warning: Overriding routing Table')
        self.RT = rt
        self.myGUID = myGUID
        self.addPeer(GUID=Central_GUID, IPAddr=Central_IP, IsCentre=True)
        self.save_state()
        

    def getTable(self):
        self.mutex.acquire()
        RT_Temp = copy.deepcopy(self.RT)
        self.mutex.release()
        return RT_Temp

    # Save RT to json
    def save_state(self):
        fileName = os.path.join(STATE_PATH, STATE_RT)
        
        with open(fileName, 'w') as save:
            json.dump(self.RT, save)

    # Load RT from json
    def load_state(self, isBootstrap, GUID):
        fileName = os.path.join(STATE_PATH, STATE_RT)
        with self.mutex:
            if os.path.exists(fileName):        # If the file exists, load it
                with open(fileName) as load:
                    self.RT = json.load(load)
            self.isBootstrap = isBootstrap
            self.myGUID = GUID
        

    def addPeer(self, GUID, IPAddr='0', Port=APP_PORT, IsCentre=False):
        self.mutex.acquire()
        if GUID in self.RT.keys():
            # safety in case that GUID is already present
            self.mutex.release()
            self.updatePeer(GUID, IPAddr, Port)
        else:
            # Since we are inserting new node, we assume its active
            self.RT[GUID] = dict()
            self.RT[GUID][IP_ADDR] = IPAddr
            self.RT[GUID][RT_PORT] = Port
            self.RT[GUID][RT_ISACTIVE] = True
            self.RT[GUID][RT_INACTIVE] = 0
            self.RT[GUID][RT_ISCENTRE] = IsCentre
            self.save_state()
            self.mutex.release()

    def deletePeer(self, GUID):
        self.mutex.acquire()
        if GUID in self.RT.keys():
            self.RT.pop(GUID)
        self.save_state()
        self.mutex.release()

    def updatePeer(self, GUID, IPAddr, Port=APP_PORT, ActiveBool=True, InactiveTime=0, IsCentre=False):
        # Used to update change in port/ipaddress and to reset bool and inactivetime.
        self.mutex.acquire()
        if GUID in self.RT.keys():
            self.RT[GUID][IP_ADDR] = IPAddr
            self.RT[GUID][RT_PORT] = Port
            self.RT[GUID][RT_ISACTIVE] = ActiveBool
            self.RT[GUID][RT_INACTIVE] = InactiveTime
            self.RT[GUID][RT_ISCENTRE] = IsCentre

            self.save_state()
            self.mutex.release()
        else:
            self.mutex.release()
            # safety in case that GUID is already present
            self.addPeer(GUID=GUID, IPAddr=IPAddr,
                         Port=Port, IsCentre=IsCentre)

    def handlePing(self, pingMsg):
        # Handle incoming Ping
        if pingMsg[TYPE] != PING:
            print('Warning HandlePing has not received PING message')
            return
        self.updatePeer(GUID=pingMsg[SEND_GUID], IPAddr=pingMsg[SEND_IP])

    def handlePong(self, pongMsg):
        # Handle incoming Pong
        if pongMsg[TYPE] != PONG:
            print('Warning HandlePing has not received PING message')
            return
        self.updatePeer(GUID=pongMsg[SEND_GUID], IPAddr=pongMsg[SEND_IP])
        self.mutexPP.acquire()
        self.recvPong.append(pongMsg[SEND_GUID])
        self.mutexPP.release()

    def sendPing(self, destGUID, destIP):
        pingMsg = {
            TYPE: PING,
            SEND_IP: MY_IP,
            SEND_GUID: self.myGUID,
            DEST_IP: destIP,
            DEST_GUID: destGUID
        }
        network.send(pingMsg[DEST_IP], **pingMsg)
        self.mutexPP.acquire()
        self.sentPing.append(destGUID)
        self.mutexPP.release()

    def neighbours(self):
        self.mutex.acquire()
        nbr = []
        for guid in self.RT:
            if self.RT[guid][RT_ISACTIVE]:
                nbr.append((self.RT[guid][IP_ADDR], guid))
        self.mutex.release()
        return nbr
    
    def neighbours2(self):
        self.mutex.acquire()
        nbr = []
        for guid in self.RT:
            nbr.append((self.RT[guid][IP_ADDR], guid))
        self.mutex.release()
        return nbr

    def periodicActivityCheck(self):
        sentPingTemp = []
        recvPongTemp = []
        while(self.StayActive):
            time.sleep(self.updateFreq)
            # print('UPDATING')
            self.mutexPP.acquire()
            sentPingTemp = copy.deepcopy(self.sentPing)
            recvPongTemp = copy.deepcopy(self.recvPong)
            self.sentPing = []
            self.recvPong = []
            self.mutexPP.release()
            for guid in sentPingTemp:
                if guid in self.RT.keys():
                    obj = copy.deepcopy(self.RT[guid])
                else:
                    continue

                if guid in recvPongTemp:
                    self.updatePeer(
                        GUID=guid, IPAddr=obj[IP_ADDR], Port=obj[RT_PORT], IsCentre=obj[RT_ISCENTRE])
                else:
                    if obj[RT_INACTIVE]+1 > self.inactiveLimit:
                        logger.info("Deleting peer: {}".format(obj[IP_ADDR]))
                        self.deletePeer(guid)
                    else:
                        logger.info("Peer {} is inactive with RT_INACTIVE: {}".format(obj[IP_ADDR], obj[RT_INACTIVE]))
                        self.updatePeer(GUID=guid, IPAddr=obj[IP_ADDR], Port=obj[RT_PORT],
                                        ActiveBool=False, InactiveTime=obj[RT_INACTIVE]+1, IsCentre=obj[RT_ISCENTRE])


            nbr = self.neighbours2()
            # print(nbr)
            for (IPAddr, guid) in nbr:
                self.sendPing(guid, IPAddr)

    def findNearestGUID(self, GUID):
        pass
