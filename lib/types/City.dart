enum CityId { 
  capetown,
  bloemfontein,
  durban,
  portelizabeth,
  pretoria,
  johannesburg,
  kimberley
}

class City {
  final CityId id;
  final String name;

  City(this.id, this.name);
}

Map<CityId, String> cityNameByIdMap = {
  CityId.capetown: 'Cape Town',
  CityId.durban: 'Durban',
  CityId.bloemfontein: 'Bloemfontein',
  CityId.pretoria: 'Pretoria',
  CityId.portelizabeth: 'Gqeberha',
  CityId.kimberley: 'Kimberley',
  CityId.johannesburg: 'Johannesburg',
};