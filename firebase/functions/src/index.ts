import { logger, region } from 'firebase-functions';
import { isAuthorized } from './auth/authorize-request';
import processPollenReport from './pollen-report/process-pollen-report';
import * as admin from "firebase-admin";
import { savePollenData } from './pollen-report/save-pollen-data';
import sendNotification from './notification/send-notification';

const everyFridayAt9amCAT = '0 8 * * *';

// Get firebase ready
admin.initializeApp();

const messaging = admin.messaging();

// CRON trigger of fetching and parsing pollen report
export const scheduledPollenReport = region('europe-west1')
  .pubsub.schedule(everyFridayAt9amCAT)
  .timeZone('UTC')
  .onRun(async _ => {

  logger.log(`[START] - ${new Date().toISOString()}`);
  const start = new Date().getTime();
  
  const pollenData = await processPollenReport();

  logger.log('Saving pollen data');
  const isNewReport = await savePollenData(pollenData);

  if (isNewReport) {
    await sendNotification('New pollen data available.');
  }

  logger.info(`[END] Elapsed: ${new Date().getTime() - start}ms`);
});

// Manually trigger fetching and parsing of pollen reporting
/*
  Example body: {
    "secret": string,
    "save": boolean
  }
*/
export const httpPollenReport = region('europe-west1').https.onRequest(async (request, response) => {
  const authorized = isAuthorized(request);

  if (!authorized) {
    logger.error(`Unauthorized ${request.method.toLocaleUpperCase()} - ${(request.body ? JSON.stringify(request.body) : 'no request body.')}`);
    response.status(401).send('Unauthorized');
    return;
  }
  const start = new Date().getTime();
  logger.info(`[START] - ${new Date().toISOString()}`);

  const pollenData = await processPollenReport();

  if (request.body.save === true) {
    logger.log('Saving pollen data.');
    const isNewReport = await savePollenData(pollenData);
    
    if (isNewReport) {
      logger.info('Sending notification');
      await sendNotification('New pollen data available.');
    }
  }

  logger.info(`[END] Elapsed: ${new Date().getTime() - start}ms`);

  response.send({ pollenData });
});


// Send new report notification to devices
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