import { logger } from 'firebase-functions';
import { load } from 'cheerio';
import { City, CityPollenLevel, RiskLevel } from '../domain/types';

const colorToPollenLevelMap: { [K: string]: string } = {
    'grey': 'no_data',
    'green': 'very_low',
    'yellow': 'low',
    'lightorange': 'moderate',
    'darkorange': 'high',
    'red': 'very_high',
};

export function parseReportDate(html: string): Date {
    const $ = load(html);
    const reportHeading = $('h3').text();
    const reportDateMatch = reportHeading.match(/Report Date:\s([A-Za-z0-9 ]+)/);

    if (!reportDateMatch) {
        throw new Error(`[${parseReportDate.name}] Failed to parse report date. HTML: ${html}`);
    }

    // DD Month YYYY
    const dateString = reportDateMatch[1].trim();

    // DD/MM/YYYY
    return new Date(dateString);
}

export async function parsePollenHtml(html: string): Promise<CityPollenLevel[]> {
    const $ = load(html);

    // const report date
    const reportDate = parseReportDate(html);

    logger.info('Report date:', reportDate);

    // Extract the city rows from the table.
    const cityRows =
        $('.row')
            .toArray()
            .slice(3);

    logger.debug(`${[parsePollenHtml.name]} Found ${cityRows.length} city rows.`);
    
    const cityPollenLevels = cityRows.map(row => ({ 
        ...parseCityPollenCount($, row),
        reportDate: reportDate.toISOString().split('T')[0],
    }));

    return cityPollenLevels.filter(x => x.cityName !== undefined);
}

function parseCityPollenCount($: cheerio.Root, rowElement: cheerio.Element) {
    const row = $(rowElement);
    const nodes = row.find('.col-xs-2 > *').toArray();

    const cityName = $(nodes[1]).text();
    if (!cityName) {
        logger.error('No city name found in row:', row.html());
    }

    const pollenLevels = nodes.slice(2).map(node => {
        const cell = $(node);

        // pollen node
        const color = cell.attr('class')?.replace('pollen-', '');

        if (!color) {
            logger.warn('Failed to parse pollen level color. Node:', cell.html());
            return 'unknown';
        }

        const pollenLevel = colorToPollenLevelMap[color] ?? 'no_data';

        if (pollenLevel === 'no_data') {
            logger.error(`Failed to convert color '${color}' to one of ${Object.values(colorToPollenLevelMap)}`);
        }

        return pollenLevel ?? 'unknown';
    });

    return {
        cityName: cityName as City,
        overallRisk: pollenLevels[0] as RiskLevel,
        treePollen: pollenLevels[1] as RiskLevel,
        grassPollen: pollenLevels[2] as RiskLevel,
        weedPollen: pollenLevels[3] as RiskLevel,
        mouldSpores: pollenLevels[4] as RiskLevel,
    };
}

export function addPollenDescriptions(cityPollenCounts: CityPollenLevel[], reportHtml: string) {
    const $ = load(reportHtml);

    const rows = $('p').toArray().slice(3);

    // iterate through the rows and find the matching city names. When found, add the description (the subsequent 'p' element) to the city pollen count
    for (let i = 0; i < rows.length; i+=2) {
        const rowText = $(rows[i]).text();
        logger.debug('testing row:', rowText);

        const cityIndex = cityPollenCounts.findIndex(x => x.cityName.toLowerCase() === rowText.toLowerCase());
        if (cityIndex >= 0) {
            logger.debug(`${[addPollenDescriptions.name]} Found city: ${rowText}`);

            const description = $(rows[i+1]).text();
            cityPollenCounts[cityIndex].description = description;
        }
    }
}

export function parseReportUrl(html: string) {
    const $ = load(html);

    const url = $('h3 > a').attr('href');

    if (!url) {
        throw new Error(`Failed to parse report URL. HTML: ${html}`);
    }

    return url;
}