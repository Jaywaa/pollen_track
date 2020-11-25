import { logger } from 'firebase-functions';
import { load } from 'cheerio';

const pollenLevelMap: { [K: string]: string } = {
    'grey': 'no_data',
    'green': 'very_low',
    'yellow': 'low',
    'lightorange': 'moderate',
    'darkorange': 'high',
    'red': 'very_high'
};

function parseReportDate(selector: cheerio.Selector): Date {
    const reportDateText = selector('.col-sm-12 > h3').html();
    const reportDateMatch = reportDateText?.match('Report Date:\s([A-Za-z0-9 ]+)');

    if (!reportDateMatch) {
        throw new Error(`Failed to parse report date. HTML: ${reportDateText}`);
    }

    // "DD Month YYYY"
    const dateString = reportDateMatch[1].trim();

    return new Date(`${dateString}Z`);
}

export async function parsePollenHtml(html: string): Promise<{ reportDate: Date, cityPollenLevels: string[][] }> {
    logger.info('Parsing pollen HTML');

    const selector = load(html);

    // const report date
    const reportDate = parseReportDate(selector);

    logger.info('Report date:', reportDate.toISOString());
    
    // Extract the city rows from the table. [row, ...]
    const cityRows =
        selector('#wpv-view-layout-300 > div > div > div')
            .toArray()
            .slice(2);

    // Pulls out the city and pollen classnames for each city. [[city, overall, tree, grass, weed, mould], ...]
    const cityPollenLevels = cityRows.map(rowElement => {
        const row = selector(rowElement);
        const nodes = row.find('.col-xs-2 > *').toArray();

        return nodes.map(node => {
            const column = selector(node);
            const outerHtml = selector.html(column);

            // city name
            if (outerHtml.includes('h5')) {
                const city = column.html();

                if (!city) {
                    logger.warn('No city found in <h5> tag.');
                    return 'unknown_city';
                }

                return city;
            }

            // pollen column
            const pollenLevel = column.attr('class')?.replace('pollen-', '');

            if (!pollenLevel) {
                logger.warn('Failed to parse pollen level.');
                return 'unknown';
            }

            return pollenLevelMap[pollenLevel];
        });
    });

    return {
        reportDate,
        cityPollenLevels
    };
}