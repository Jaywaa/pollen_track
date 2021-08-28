import { logger } from "firebase-functions";
import { CityPollenLevel } from "./domain/types";
import { fetchPollenHtml } from "./http/fetch-pollen-html";
import { parsePollenHtml } from "./parsers/parse-pollen-html";

export default async function processPollenReport(): Promise<CityPollenLevel[]> {
    logger.info('Fetching pollen HTML');
    const html = await fetchPollenHtml();

    logger.info('Parsing pollen HTML');
    const pollenData = await parsePollenHtml(html);

    return pollenData;
}