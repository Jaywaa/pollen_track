export type RiskLevel 
    = 'no_data'
    | 'very_low'
    | 'low'
    | 'moderate'
    | 'high'
    | 'very_high';

export type City
    = 'cape town'
    | 'johannesburg'
    | 'bloemfontein'
    | 'durban'
    | 'pretoria'
    | 'port elizabeth'
    | 'kimberly';

export type CityPollenLevel = {
    cityName: City,
    reportDate: string, // DD/MM/YYYY
    description: string,
    overallRisk: RiskLevel,
    treePollen: RiskLevel,
    grassPollen: RiskLevel,
    weedPollen: RiskLevel,
    mouldSpores: RiskLevel
}