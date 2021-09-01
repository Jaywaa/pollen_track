import fetch from 'node-fetch';

const baseUrl = 'https://pollencount.co.za';

export async function fetchHomePageHtml(): Promise<string> {
    const result = await fetch(baseUrl);

    if (!result.ok) {
        throw new Error(`Failed to fetch HTML from ${baseUrl}. ${result.status} - ${await result.text()}`)
    }

    return result.text();
}

/// [reportDate]: 'DD Month YYYY'
export async function fetchPollenReportHtml(reportUrl: string) {
    const result = await fetch(reportUrl);

    if (!result.ok) {
        throw new Error(`Failed to fetch HTML from ${reportUrl}. ${result.status} - ${await result.text()}`)
    }

    return result.text();
}