import { firestore } from 'firebase-admin';
import { logger } from 'firebase-functions';
import { CityPollenLevel } from './domain/types';

export async function savePollenData(cityPollenLevels: CityPollenLevel[]): Promise<boolean> {
    logger.log('Saving pollen data.');
    return cityPollenLevels
        .map(addIfNotExists)
        .some(async x => await x === true);
}

async function addIfNotExists(cityPollenLevel: CityPollenLevel): Promise<boolean> {

    const cityTitle = cityPollenLevel.cityName;
    const cityName = cityPollenLevel.cityName.toLowerCase();

    const query = await firestore().collection('reports')
        .where('reportDate', '==', cityPollenLevel.reportDate)
        .where('cityName', '==', cityName)
        .get();

    if (!query.empty) {
        logger.log(`Found existing report for ${cityName} for ${cityPollenLevel.reportDate}`);
        return false;        
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
    
    return true;
}