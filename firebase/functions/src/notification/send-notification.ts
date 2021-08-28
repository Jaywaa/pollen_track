import { config, logger } from "firebase-functions";
import fetch from 'node-fetch';

export default async function sendNotification(message?: string) {
    try {
        const webhookUrl = config().admin.notification.webhookurl;

        if (!webhookUrl) {
            logger.error('Failed to call notification webhook. URL in config was undefined.');
            return;
        }
    
        await fetch(webhookUrl, { method: 'POST', body: JSON.stringify({ value1: message }) });
    }
    catch (e) {
        logger.error(`Error calling notification webhook: ${e}`);
    }
}