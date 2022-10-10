import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

admin.initializeApp();

export const sendPasswordChangedAlert = functions.firestore
  .document('users/{userId}')
  .onUpdate(async (snap) => {
    const user = snap.after.data();
    const lastPasswordUpdate: admin.firestore.Timestamp =
      user?.lastPasswordUpdate;

    await admin
      .firestore()
      .collection('messages')
      .add({
        from: `whatsapp:+${process.env.TWILIO_FROM_NUMBER}`,
        to: `whatsapp:${user.phoneNumber}`,
        body:
          'Your password has been updated on ' +
          lastPasswordUpdate.toDate().toString() +
          ', if you did not do this, please contact support immediately.',
      });
  });
