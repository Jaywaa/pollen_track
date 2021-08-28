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
    
    // Pulls out the city and pollen classnames for each city. [[city, overall, tree, grass, weed, mould], ...]
    const cityPollenLevelsArray = cityRows.map(row => parseCityPollenCount($, row));

    const cityPollenLevels = mapArrayToType(reportDate, cityPollenLevelsArray);

    logger.debug('Parsed city pollen levels:', cityPollenLevels);
    return cityPollenLevels;
}

function parseCityPollenCount($: cheerio.Root, rowElement: cheerio.Element): string[] {
    const row = $(rowElement);
    const nodes = row.find('.col-xs-2 > *').toArray();

    const cityName = $(nodes[1]).text() ?? 'unknown_city';
    if (cityName === 'unknown_city') {
        logger.warn('No city found in row:', row.html());
    }

    const pollenLevels = nodes.slice(2).map(node => {
        const cell = $(node);

        // pollen node
        const color = cell.attr('class')?.replace('pollen-', '');

        if (!color) {
            logger.warn('Failed to parse pollen level color. Node:', cell.html());
            return 'unknown';
        }

        return colorToPollenLevelMap[color];
    });

    return [cityName, ...pollenLevels];
}

// [[city, overall, tree, grass, weed, mould], ...]
function mapArrayToType(reportDate: string, cityPollenLevels: string[][]): CityPollenLevel[] {
    return cityPollenLevels.map(cityPollenLevel => (
        {
            cityName: cityPollenLevel[0] as City,
            reportDate,
            description: '',
            overallRisk: cityPollenLevel[1] as RiskLevel,
            treePollen: cityPollenLevel[2] as RiskLevel,
            grassPollen: cityPollenLevel[3] as RiskLevel,
            weedPollen: cityPollenLevel[4] as RiskLevel,
            mouldSpores: cityPollenLevel[5] as RiskLevel,
        })
    );
}