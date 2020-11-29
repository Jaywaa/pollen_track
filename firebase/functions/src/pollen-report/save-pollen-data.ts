import { firestore } from 'firebase-admin';
import { logger } from 'firebase-functions';
import { CityPollenLevel } from './domain/types';

export async function savePollenData(cityPollenLevels: CityPollenLevel[]) {
    logger.log('Saving pollen data.');
    return cityPollenLevels.forEach(addIfNotExists);
}

async function addIfNotExists(cityPollenLevel: CityPollenLevel): Promise<void> {

    const cityTitle = cityPollenLevel.cityName;
    const cityName = cityPollenLevel.cityName.toLowerCase();

    const query = await firestore().collection('reports')
        .where('reportDate', '==', cityPollenLevel.reportDate)
        .where('cityName', '==', cityName)
        .get();

    if (!query.empty) {
        logger.log(`Found existing report for ${cityName} for ${cityPollenLevel.reportDate}`);
        return;        
    }

    logger.log(`Adding report for ${cityName} for ${cityPollenLevel.reportDate}`);

    const reportDoc = await firestore()
        .collection('reports')
        .add({ ...cityPollenLevel, cityId: cityName });

    await firestore().collection('cities')
        .doc(cityName)
        .set({
            cityName: cityTitle,
            latestReportDate: cityPollenLevel.reportDate,
            latestReport: (await reportDoc.get()).ref,
        });
}