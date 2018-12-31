import json
import socket
import time
import sys
import os

TCP_IP = os.environ['PTAIP']
TCP_PORT = os.environ['PTAPort'] # PTA Port
BUFFER_SIZE = 1024

def sendData(sock, msg):
    try:
        sock.sendall(msg)
    except:
        print ("Failed to send data!")
    
def lambda_handler(event, context):
    tcp_port = int(TCP_PORT) 
    sock = 0
    print(event);
    for record in event["Records"]: 
        
        print ("Connecting to: " + TCP_IP + " Port: " + str(TCP_PORT))

        try:
            message = parse_json(record) # Validate that the message was sent from SNS
            print ("Sending message: {0}".format(message))
            sock = socket.socket( socket.AF_INET, socket.SOCK_STREAM ) # Open Socket with PTA PORT
            sock.connect((TCP_IP, tcp_port))
            b_event = str.encode(message)
            sendData(sock, b_event)
            print (b_event)
            
        except Exception as e:
            print ('exception, connection failure: '+ str(e))
            sock = socket.socket( socket.AF_INET, socket.SOCK_STREAM )
            sock.connect((TCP_IP, tcp_port))
            sendData(sock, b_event)
        
    return {
        'statusCode': 200,
        'body': json.dumps('Lambda to PTA completed successfuly!')
    }

def parse_json(record):
    #data = json.load(jsonData)
    #print (data)
    #for record in data["Records"]:
    print("Record data: {0}".format(record))
    if (record["EventSource"] == 'aws:sns'):
        print ("The event source is aws:sns")
        return record["Sns"]["Message"]
        
    else:
        print ("The event source is {0}".format(record["EventSource"]))
        return record