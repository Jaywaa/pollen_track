import { https, logger, config } from 'firebase-functions';
import { fetchPollenHtml } from './http/fetch-pollen-html';
import { parsePollenHtml } from './parsers/parse-pollen-html';
import { pbkdf2Sync as hash } from 'pbkdf2';

// export const scheduledFunc = pubsub.schedule('* * * * *').onRun((context) => {
//   logger.log('HELLO ITS ME THE SCHEDULED BOI');
// });


function isAuthorized(request: https.Request): boolean {
  if (!request.secure) {
    logger.error('Request is not secure (https). Refusing to authorize.', { method: request.method, body: JSON.stringify(request.query) });
    return false;
  }

  const adminSecret = config().admin?.hashedsecret;
  const adminSalt = config().admin?.salt;  
  if (!adminSecret || !adminSalt) {
    logger.error('Failed to find secret or salt in config. Unable to authorize request.');
    return false;
  }

  const passphrase = parseAuthJson(request.query as string); 
  if (!passphrase) {
    logger.error('Failed to find passphrase in request. Unable to authorize.');
    return false;
  }

  const secret = hash(passphrase, "", 1, 32, 'sha256').toString('base64');
  
  if (secret === adminSecret) {
    logger.error(`Failed to match request secret ${secret} to admin secret. Unable to authorize.`);
    return false;
  }
  
  return true;
}

function parseAuthJson(jsonString: string): { secret: string } | undefined {
  try {
    const json = JSON.parse(jsonString);
    
    if (json.secret) {
      return json.secret;
    }
  } finally {
    return undefined;
  }
}

export const savePollenReport = https.onRequest(async (request, response) => {  
  const authorized = isAuthorized(request);

  if (!authorized) {
    logger.error(`Unauthorized ${request.method.toLocaleUpperCase()} - ${(request.body ? JSON.stringify(request.body) : 'no request body.')}`);
    response.status(401).send('Unauthorized');
    return;
  }

  const start = new Date().getTime();
  logger.info(`[BEGIN] - ${new Date().toISOString()}`);

  const html = await fetchPollenHtml();
  const pollenData = await parsePollenHtml(html);

  logger.info('Pollen data:', pollenData);
  response.send(pollenData);

  logger.info(`[END] ${new Date().getTime() - start}ms`);
});
