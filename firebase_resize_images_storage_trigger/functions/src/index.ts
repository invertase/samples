import * as admin from "firebase-admin";
import * as functions from "firebase-functions";

admin.initializeApp();

export const updateThumbnailLink = functions.storage
  .object()
  .onFinalize(async (object) => {
    functions.logger.info({ object });
    const bucket = admin.storage().bucket();

    if (!object.name) return;

    const file = bucket.file(object.name);

    if (file.name.includes("thumbnail")) {
      const imageUrl = await file.publicUrl();

      functions.logger.info(
        `The public url for ${object.name} is ${imageUrl}.`
      );

      if (object.name) {
        const parts = object.name.split("/");
        const docId = parts[parts.length - 1].split(".")[0].split("_")[0];
        functions.logger.info(`The docId is ${docId}.`);
        const docRef = admin.firestore().doc(`stories/${docId}`);

        await docRef.update({ imageUrl: imageUrl });
      }
    }
  });
