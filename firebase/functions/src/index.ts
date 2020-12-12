import { logger, region, firestore } from 'firebase-functions';
import { isAuthorized } from './auth/authorize-request';
import processPollenReport from './pollen-report/process-pollen-report';
import * as admin from "firebase-admin";

const everyFridayAt9amCAT = '0 8 * * *';

// get firebase ready
admin.initializeApp();

const messaging = admin.messaging();

export const scheduledPollenReport = region('europe-west1')
  .pubsub.schedule(everyFridayAt9amCAT)
  .timeZone('UTC')
  .onRun(async _ => {
  logger.log(`[Executing Scheduled Job] - ${new Date().toISOString()}`);
  
  await processPollenReport();
});

export const httpPollenReport = region('europe-west1').https.onRequest(async (request, response) => {
  const authorized = isAuthorized(request);

  if (!authorized) {
    logger.error(`Unauthorized ${request.method.toLocaleUpperCase()} - ${(request.body ? JSON.stringify(request.body) : 'no request body.')}`);
    response.status(401).send('Unauthorized');
    return;
  }
  
  logger.info(`[Executing HTTP Job] - ${new Date().toISOString()}`);

  const pollenData = await processPollenReport();

  response.send(pollenData);
});

export const reportNotification = region('europe-west1').firestore.document('cities/{cityId}').onUpdate(async snapshot => {
  const cityId = snapshot.after.id;

  logger.log(`[Executing Report Notification] - ${new Date().toISOString()}`);

  const cityMessagePayload: admin.messaging.MessagingPayload = {
    notification: {
      title: 'New Pollen Readings',
      body: `There's a new pollen report for ${snapshot.after.get('cityName')}`,
    },
  }

  const multipleMessagePayload: admin.messaging.MessagingPayload = {
    notification: {
      title: 'New Pollen Readings',
      body: `There's a new pollen report for your cities`,
    },
  }

  const oneWeek = 604800;

  await messaging.sendToTopic(cityId, cityMessagePayload, { timeToLive: oneWeek } );
  await messaging.sendToTopic('multiple-cities', multipleMessagePayload, { timeToLive: oneWeek } );
});