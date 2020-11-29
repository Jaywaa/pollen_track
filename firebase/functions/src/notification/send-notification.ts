import { config, logger } from "firebase-functions";
import fetch from 'node-fetch';

export default async function sendNotification() {
    try {
        const webhookUrl = config().admin.notification.webhookurl;

        if (!webhookUrl) {
            logger.error('Failed to call notification webhook. URL in config was undefined.');
            return;
        }
    
        logger.info('Executing notification webhook');
        await fetch(webhookUrl);
    }
    catch (e) {
        logger.error(`Error calling notification webhook: ${e}`);
    }
}