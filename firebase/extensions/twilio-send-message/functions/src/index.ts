import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

admin.initializeApp();

export const sendPasswordChangedAlert = functions.firestore
  .document('users/{userId}')
  .onUpdate(async (snap) => {
    const user = snap.after.data();
    const lastPasswordUpdate: admin.firestore.Timestamp =
      user?.lastPasswordUpdate;
    const oldLastPasswordUpdate: admin.firestore.Timestamp =
      snap.before.data()?.lastPasswordUpdate;

    if (
      !lastPasswordUpdate ||
      lastPasswordUpdate.isEqual(oldLastPasswordUpdate)
    ) {
      return;
    }

    const body =
      'Your password has been updated on ' +
      lastPasswordUpdate.toDate().toString() +
      ', if you did not do this, please contact support immediately.';

    const smsBody = {
      to: `${user.phoneNumber}`,
      body: body,
    };

    const whatsappBody = {
      from: `whatsapp:${process.env.TWILIO_FROM_NUMBER}`,
      to: `whatsapp:${user.phoneNumber}`,
      body: body,
    };

    const messagesCollection = admin.firestore().collection('messages');

    await messagesCollection.add(smsBody);
    await messagesCollection.add(whatsappBody);
  });
