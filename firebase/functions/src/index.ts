import { https, logger, pubsub } from 'firebase-functions';
import { fetchPollenHtml } from './http/fetch-pollen-html';
import { parsePollenHtml } from './parsers/parse-pollen-html';

export const scheduledFunc = pubsub.schedule('* * * * *').onRun((context) => {
  logger.log('HELLO ITS ME THE SCHEDULED BOI');
});

export const savePollenReport = https.onRequest(async (request, response) => {
  const start = new Date().getTime();
  logger.info(`[BEGIN] - ${new Date().toISOString()}`);

  const html = await fetchPollenHtml();
  const pollenData = await parsePollenHtml(html);

  logger.info('Pollen data:', pollenData);
  response.send(pollenData);

  logger.info(`[END] ${new Date().getTime() - start}ms`);
});