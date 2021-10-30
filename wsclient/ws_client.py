import json
import requests
import redis
from websocket import create_connection
import random
import time

# ws = websocket.WebSocket()

# ws.connect('ws://localhost:8000/ws/polData/')

# for i in range(1000):
#     time.sleep(3)
#     ws.send(json.dumps({'value': random.randint(1, 100)}),
#             opcode='ADcvn53_cds5')


ws = create_connection("ws://localhost:8000/ws/polData/")
for i in range(1000):
    time.sleep(3)
    value = json.dumps({'value': random.randint(1, 100)})
    ws.send(value)
    print(value)

ws.close()
