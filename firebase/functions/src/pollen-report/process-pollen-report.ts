import { logger } from "firebase-functions";
import sendNotification from "../notification/send-notification";
import { CityPollenLevel } from "./domain/types";
import { fetchPollenHtml } from "./http/fetch-pollen-html";
import { parsePollenHtml } from "./parsers/parse-pollen-html";
import { savePollenData } from "./save-pollen-data";

type PollenReportResult = {
    isNewReport: boolean,
    pollenData: CityPollenLevel[]
}

export default async function processPollenReport(): Promise<PollenReportResult> {
    const start = new Date().getTime();

    const html = await fetchPollenHtml();
    const pollenData = await parsePollenHtml(html);

    const isNewReport = await savePollenData(pollenData);

    await sendNotification(isNewReport ? 'New report data saved.' : 'No new report data.');

    logger.info(`[END] ${new Date().getTime() - start}ms`);

    return {
        isNewReport,
        pollenData,
    };
}