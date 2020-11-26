import { https, config, logger } from 'firebase-functions';
import { pbkdf2Sync as hash } from 'pbkdf2';

export function isAuthorized(request: https.Request): boolean {
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
  
    const passphrase = request.body.secret; 
    if (!passphrase) {
      logger.error('Failed to find passphrase in request. Unable to authorize.');
      return false;
    }
  
    const secret = hash(passphrase, "", 1, 32, 'sha256').toString('base64');
    
    if (secret !== adminSecret) {
      logger.error(`Failed to match request secret ${secret} to admin secret. Unable to authorize.`);
      return false;
    }
    
    return true;
  }