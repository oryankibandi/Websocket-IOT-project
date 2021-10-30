import time
from datetime import datetime, timedelta
from uuid import uuid4

import firebase_admin

#from firebase import firestore
from firebase_admin import credentials, firestore

GOOGLE_APPLICATION_CREDENTIALS = 'credentials/credentials.json'

cred = credentials.Certificate(GOOGLE_APPLICATION_CREDENTIALS)

__all__ = 'post_to_firebase', 'update_firebase_snapshot'

firebase_admin.initialize_app(cred)


def post_to_firebase(temp):
    db = firestore.client()
    start = time.time()
    print('f{}', str(uuid4()))
    uid = str(uuid4())
    today = datetime.now()
    doc_ref = db.collection(u'data').document(uid)
    doc_ref.set({
        u'temperature': temp,
        u'timestamp': today
    })
    end = time.time()
    spend_time = timedelta(seconds=end-start)
