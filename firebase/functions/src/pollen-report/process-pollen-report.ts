import { initializeApp } from "firebase-admin";
import { logger } from "firebase-functions";
import sendNotification from "../notification/send-notification";
import { fetchPollenHtml } from "./http/fetch-pollen-html";
import { parsePollenHtml } from "./parsers/parse-pollen-html";
import { savePollenData } from "./save-pollen-data";

export default async function processPollenReport() {
    const start = new Date().getTime();

    // get firebase ready
    initializeApp();

    const html = await fetchPollenHtml();
    const pollenData = await parsePollenHtml(html);

    await savePollenData(pollenData);

    await sendNotification();

    logger.info(`[END] ${new Date().getTime() - start}ms`);

    return pollenData;
}