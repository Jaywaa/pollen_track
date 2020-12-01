import { firestore } from 'firebase-admin';
import { logger } from 'firebase-functions';
import { CityPollenLevel } from './domain/types';

export async function savePollenData(cityPollenLevels: CityPollenLevel[]): Promise<boolean> {
    logger.log('Saving pollen data.');

    const mappings = await Promise.all(cityPollenLevels.map(addIfNotExists));

    return mappings.some(x => x === true);
}

async function addIfNotExists(cityPollenLevel: CityPollenLevel): Promise<boolean> {

    const cityName = cityPollenLevel.cityName;
    const cityId = cityPollenLevel.cityName.toLowerCase().replace(/\s/g, '');

    const query = await firestore().collection('reports')
        .where('reportDate', '==', cityPollenLevel.reportDate)
        .where('cityId', '==', cityId)
        .get();

    if (!query.empty) {
        logger.log(`Found existing report for ${cityId} for ${cityPollenLevel.reportDate}`);
        return false;        
    }

    logger.log(`Adding report for ${cityId} for ${cityPollenLevel.reportDate}`);

    const reportDoc = await firestore()
        .collection('reports')
        .add({ 
            cityId: cityId,
            reportDate: cityPollenLevel.reportDate,
            description: cityPollenLevel.description,
            overallRisk: cityPollenLevel.overallRisk,
            treePollen: cityPollenLevel.treePollen,
            grassPollen: cityPollenLevel.grassPollen,
            weedPollen: cityPollenLevel.weedPollen,
            mouldSpores: cityPollenLevel.mouldSpores,
        });

    await firestore().collection('cities')
        .doc(cityId)
        .set({
            cityName: cityName,
            latestReportDate: cityPollenLevel.reportDate,
            latestReport: (await reportDoc.get()).ref,
        });
    
    return true;
}