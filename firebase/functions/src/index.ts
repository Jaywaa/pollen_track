import { logger, region } from 'firebase-functions';
import { isAuthorized } from './auth/authorize-request';
import processPollenReport from './pollen-report/process-pollen-report';
import { initializeApp } from "firebase-admin";

const everyFridayAt12pm = '0 12 * * *';

// get firebase ready
initializeApp();

export const scheduledPollenReport = region('europe-west1').pubsub.schedule(everyFridayAt12pm).onRun(async (context) => {
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