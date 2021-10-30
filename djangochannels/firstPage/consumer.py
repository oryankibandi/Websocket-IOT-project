from channels.generic.websocket import AsyncWebsocketConsumer
import json
from . import firebase


class DashConsumer(AsyncWebsocketConsumer):

    async def connect(self):
        self.group_name = 'dashboard'
        await self.channel_layer.group_add(
            self.group_name,
            self.channel_name,
        )
        await self.accept()

    async def disconnect(self, close_code):
        # await self.close
        pass

    async def receive(self, text_data):
        datapoint = json.loads(text_data)
        val = datapoint['value']

        print(">>>>", text_data)
        await self.channel_layer.group_send(
            self.group_name,
            {
                'type': 'deprocessing',
                'value': val
            }
        )

    async def deprocessing(self, event):
        valOther = event['value']
        firebase.post_to_firebase(valOther)
        await self.send(json.dumps({'value': valOther}))
        # await self.accept
