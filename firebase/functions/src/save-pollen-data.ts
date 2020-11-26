import { initializeApp } from 'firebase-admin';
import { logger } from 'firebase-functions';
import { CityPollenLevel } from './domain/types';

export async function savePollenData(cityPollenLevels: CityPollenLevel[]) {
    logger.log('Saving pollen data.');
    return cityPollenLevels.forEach(addIfNotExists);
}

async function addIfNotExists(cityPollenLevel: CityPollenLevel): Promise<void> {
    // get firestore ready
    const app = initializeApp();

    const query = await app.firestore().collection('reports')
        .where('reportDate', '==', cityPollenLevel.reportDate)
        .where('cityName', '==', cityPollenLevel.cityName)
        .get();

    if (!query.empty) {
        logger.log(`Found existing report for ${cityPollenLevel.cityName} for ${cityPollenLevel.reportDate}`);
        return;        
    }

    logger.log(`No report found for ${cityPollenLevel.cityName} for ${cityPollenLevel.reportDate}`);
    await app.firestore().collection('reports')
        .add(cityPollenLevel);
}