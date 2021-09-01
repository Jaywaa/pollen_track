import { logger } from "firebase-functions";
import { CityPollenLevel } from "./domain/types";
import { fetchHomePageHtml, fetchPollenReportHtml } from "./http/fetch-pollen-html";
import { addPollenDescriptions, parsePollenHtml, parseReportUrl } from "./parsers/parse-pollen-html";

export default async function processPollenReport(): Promise<CityPollenLevel[]> {
    logger.info('Fetching pollen HTML');
    const homeHtml = await fetchHomePageHtml();

    logger.info('Parsing pollen HTML');
    const pollenData = await parsePollenHtml(homeHtml);

    try {
        const reportUrl = parseReportUrl(homeHtml);
        const reportHtml = await fetchPollenReportHtml(reportUrl);

        logger.info('Adding city pollen descriptions');
        addPollenDescriptions(pollenData, reportHtml);
    } catch (e) {
        // notification webhook
        logger.error(e);
    }

    return pollenData;
}