import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as accents from "remove-accents";
import {FieldValue, UpdateData} from "firebase-admin/firestore";
admin.initializeApp();

// // Start writing functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from GiapSoft!");
// });

export const onUpdateCollection = functions.firestore
    .document("{rootCollection}/{rootId}").onWrite(async (snap, context) => {
      // eslint-disable-next-line @typescript-eslint/no-var-requires
      const vnAccents = require("vn-remove-accents");
      try {
        const rootCollection = context.params.rootCollection;
        if (rootCollection !== "updater") {
          const isDelete = !snap.after.exists;
          const collectionPath = context.params.rootCollection;
          const songUpdater = admin.firestore()
              .doc(`updater/${collectionPath}`);
          const data: UpdateData = {};
          const time = new Date().valueOf();
          data["updater"] = time;
          if (isDelete) {
            data[snap.before.id] = FieldValue.delete();
            console.log(`deleted ${snap.before.id}`);
          } else {
            if (rootCollection === "perfect_song") {
              const snapData = snap.after.data();
              data[snap.after.id] = [time.toString(),
                vnAccents(accents.remove(snapData?.name ?? "")).toLowerCase(),
                vnAccents(accents.remove(snapData?.owner ?? "")).toLowerCase()];
            } else {
              data[snap.after.id] = [time.toString()];
            }
            console.log(`updated ${snap.after.id}`);
          }
          await songUpdater.set(data, {merge: true});
        }
      } catch (error) {
        console.log(error);
      }
    });
