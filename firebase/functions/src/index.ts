import { https, logger, pubsub } from 'firebase-functions';
import { isAuthorized } from './auth/authorize-request';
import processPollenReport from './pollen-report/process-pollen-report';

const everyFridayAt12pm = '0 12 * * *';

export const scheduledPollenReport = pubsub.schedule(everyFridayAt12pm).onRun(async (context) => {
  logger.log(`[Executing Scheduled Job] - ${new Date().toISOString()}`);
  
  await processPollenReport();
});

export const httpPollenReport = https.onRequest(async (request, response) => {
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