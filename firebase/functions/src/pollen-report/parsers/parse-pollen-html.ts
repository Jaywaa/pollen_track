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

function parseReportDate(selector: cheerio.Selector): string {
    const reportDateText = selector('.col-sm-12 > h3').html();
    const reportDateMatch = reportDateText?.match(/Report Date:\s([A-Za-z0-9 ]+)/);

    if (!reportDateMatch) {
        throw new Error(`Failed to parse report date. HTML: ${reportDateText}`);
    }

    // DD Month YYYY
    const dateString = reportDateMatch[1].trim();

    // DD/MM/YYYY
    return new Date(dateString).toISOString().split('T')[0];
}

export async function parsePollenHtml(html: string): Promise<CityPollenLevel[]> {
    const $ = load(html);

    // const report date
    const reportDate = parseReportDate($);

    logger.info('Report date:', reportDate);

    // Extract the city rows from the table. [row, ...]
    const cityRows =
        $('.row')
            .toArray()
            .slice(3);

    logger.debug(`Found ${cityRows.length} city rows.`);
    
    const cityPollenLevels = cityRows.map(row => parseCityPollenCount($, row, reportDate));

    logger.debug('Parsed city pollen levels:', cityPollenLevels);
    
    return cityPollenLevels.filter(x => x.cityName !== undefined);
}

function parseCityPollenCount($: cheerio.Root, rowElement: cheerio.Element, reportDate: string): CityPollenLevel {
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
        description: '',
        reportDate,
        overallRisk: pollenLevels[0] as RiskLevel,
        treePollen: pollenLevels[1] as RiskLevel,
        grassPollen: pollenLevels[2] as RiskLevel,
        weedPollen: pollenLevels[3] as RiskLevel,
        mouldSpores: pollenLevels[4] as RiskLevel,
    };
}