import { https, logger } from 'firebase-functions';
import { isAuthorized } from './auth/authorize-request';
import { fetchPollenHtml } from './http/fetch-pollen-html';
import { parsePollenHtml } from './parsers/parse-pollen-html';
import { savePollenData } from './save-pollen-data';


// export const scheduledFunc = pubsub.schedule('0 12 * * 5').onRun((context) => {
//   logger.log('HELLO ITS ME THE SCHEDULED BOI');
// });
export const savePollenReport = https.onRequest(async (request, response) => {
  const authorized = isAuthorized(request);

  if (!authorized) {
    logger.error(`Unauthorized ${request.method.toLocaleUpperCase()} - ${(request.body ? JSON.stringify(request.body) : 'no request body.')}`);
    response.status(401).send('Unauthorized');
    return;
  }

  logger.info(`[BEGIN] - ${new Date().toISOString()}`);
  const start = new Date().getTime();

  const html = await fetchPollenHtml();
  const pollenData = await parsePollenHtml(html);

  await savePollenData(pollenData);

  logger.info('Pollen data:', pollenData);
  response.send(pollenData);

  logger.info(`[END] ${new Date().getTime() - start}ms`);
});
