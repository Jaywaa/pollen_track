import fetch from 'node-fetch';

const url = 'https://pollencount.co.za';

export async function fetchPollenHtml(): Promise<string> {
    const result = await fetch(url);

    if (!result.ok) {
        throw new Error(`Failed to fetch HTML from ${url}. ${result.status} - ${await result.text()}`)
    }

    return result.text();
}