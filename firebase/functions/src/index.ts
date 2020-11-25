import { https, logger } from 'firebase-functions';
import { fetchPollenHtml } from './http/fetch-pollen-html';
import { parsePollenHtml } from './parsers/parse-pollen-html';
import * as cors from 'cors';

// export const scheduledFunc = pubsub.schedule('* * * * *').onRun((context) => {
//   logger.log('HELLO ITS ME THE SCHEDULED BOI');
// });

export const savePollenReport = https.onRequest(async (request, response) => {
  cors({ origin: true })(request, response, async () => {
    const start = new Date().getTime();
    logger.info(`[BEGIN] - ${new Date().toISOString()}`);

    const html = await fetchPollenHtml();
    const pollenData = await parsePollenHtml(html);

    logger.info('Pollen data:', pollenData);
    response.send(pollenData);

    logger.info(`[END] ${new Date().getTime() - start}ms`);
  });
});