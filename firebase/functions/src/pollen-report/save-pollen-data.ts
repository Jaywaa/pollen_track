import { firestore } from 'firebase-admin';
import { logger } from 'firebase-functions';
import { CityPollenLevel } from './domain/types';

export async function savePollenData(cityPollenLevels: CityPollenLevel[]) {
    logger.log('Saving pollen data.');
    return cityPollenLevels.forEach(addIfNotExists);
}

async function addIfNotExists(cityPollenLevel: CityPollenLevel): Promise<void> {
    const query = await firestore().collection('reports')
        .where('reportDate', '==', cityPollenLevel.reportDate)
        .where('cityName', '==', cityPollenLevel.cityName)
        .get();

    if (!query.empty) {
        logger.log(`Found existing report for ${cityPollenLevel.cityName} for ${cityPollenLevel.reportDate}`);
        return;        
    }

    logger.log(`No report found for ${cityPollenLevel.cityName} for ${cityPollenLevel.reportDate}`);

    const reportDoc = await firestore().collection('reports')
        .add(cityPollenLevel);

    await firestore().collection('cities')
        .doc(cityPollenLevel.cityName)
        .set({
            latest_report_date: cityPollenLevel.reportDate,
            latest_report: (await reportDoc.get()).ref,
        });
}