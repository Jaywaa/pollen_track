import { initializeApp } from 'firebase-admin';
import { https, logger, pubsub } from 'firebase-functions';
import fetch from 'node-fetch';
import { isAuthorized } from './auth/authorize-request';
import { fetchPollenHtml } from './pollen-report/http/fetch-pollen-html';
import { parsePollenHtml } from './pollen-report/parsers/parse-pollen-html';
import { savePollenData } from './pollen-report/save-pollen-data';

const everyFridayAt12pm = '0 12 * * 5';

export const scheduledPollenReport = pubsub.schedule(everyFridayAt12pm).onRun(async (context) => {
  logger.log(`[Executing Scheduled Job] - ${new Date().toISOString()}`);
  const start = new Date().getTime();

  await processPollenReport();

  logger.info('Executing notification webhook');
  await fetch('https://maker.ifttt.com/trigger/pollen_function/with/key/pLu_Qi5b0U7ctKFeTjlJV');

  logger.info(`[END] ${new Date().getTime() - start}ms`);
});

export const httpPollenReport = https.onRequest(async (request, response) => {
  const authorized = isAuthorized(request);

  if (!authorized) {
    logger.error(`Unauthorized ${request.method.toLocaleUpperCase()} - ${(request.body ? JSON.stringify(request.body) : 'no request body.')}`);
    response.status(401).send('Unauthorized');
    return;
  }
  
  logger.info(`[BEGIN] - ${new Date().toISOString()}`);
  const start = new Date().getTime();

  const pollenData = await processPollenReport();

  response.send(pollenData);

  logger.info(`[END] ${new Date().getTime() - start}ms`);
});

async function processPollenReport() {
  // get firebase ready
  initializeApp();

  const html = await fetchPollenHtml();
  const pollenData = await parsePollenHtml(html);

  await savePollenData(pollenData);

  return pollenData;
}