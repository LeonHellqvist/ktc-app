class Food {
  Food({
    required this.menu,
  });
  late final Menu menu;

  Food.fromJson(Map<String, dynamic> json) {
    menu = Menu.fromJson(json['menu']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['menu'] = menu.toJson();
    return data;
  }
}

class Menu {
  Menu({
    required this.isFeedbackAllowed,
    required this.weeks,
    required this.station,
    required this.id,
    required this.bulletins,
  });
  late final bool isFeedbackAllowed;
  late final List<Weeks> weeks;
  late final Station station;
  late final int id;
  late final List<dynamic> bulletins;

  Menu.fromJson(Map<String, dynamic> json) {
    isFeedbackAllowed = json['isFeedbackAllowed'];
    weeks = List.from(json['weeks']).map((e) => Weeks.fromJson(e)).toList();
    station = Station.fromJson(json['station']);
    id = json['id'];
    bulletins = List.castFrom<dynamic, dynamic>(json['bulletins']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['isFeedbackAllowed'] = isFeedbackAllowed;
    data['weeks'] = weeks.map((e) => e.toJson()).toList();
    data['station'] = station.toJson();
    data['id'] = id;
    data['bulletins'] = bulletins;
    return data;
  }
}

class Weeks {
  Weeks({
    required this.days,
    required this.weekOfYear,
    required this.year,
  });
  late final List<Days> days;
  late final int weekOfYear;
  late final int year;

  Weeks.fromJson(Map<String, dynamic> json) {
    days = List.from(json['days']).map((e) => Days.fromJson(e)).toList();
    weekOfYear = json['weekOfYear'];
    year = json['year'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['days'] = days.map((e) => e.toJson()).toList();
    data['weekOfYear'] = weekOfYear;
    data['year'] = year;
    return data;
  }
}

class Days {
  Days({
    required this.meals,
    required this.month,
    required this.day,
    required this.year,
  });
  late final List<Meals> meals;
  late final int month;
  late final int day;
  late final int year;

  Days.fromJson(Map<String, dynamic> json) {
    try {
      meals = List.from(json['meals']).map((e) => Meals.fromJson(e)).toList();
    } catch (e) {
      json['meals'] = {"attributes": [], "value": json['reason']};
      meals = List.from([json['meals']]).map((e) => Meals.fromJson(e)).toList();
    }

    month = json['month'];
    day = json['day'];
    year = json['year'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['meals'] = meals.map((e) => e.toJson()).toList();
    data['month'] = month;
    data['day'] = day;
    data['year'] = year;
    return data;
  }
}

class Meals {
  Meals({
    required this.attributes,
    required this.value,
  });
  late final List<dynamic> attributes;
  late final String value;

  Meals.fromJson(Map<String, dynamic> json) {
    attributes = List.castFrom<dynamic, dynamic>(json['attributes']);
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['attributes'] = attributes;
    data['value'] = value;
    return data;
  }
}

class Station {
  Station({
    required this.urlName,
    required this.id,
    required this.district,
    required this.name,
  });
  late final String urlName;
  late final int id;
  late final District district;
  late final String name;

  Station.fromJson(Map<String, dynamic> json) {
    urlName = json['urlName'];
    id = json['id'];
    district = District.fromJson(json['district']);
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['urlName'] = urlName;
    data['id'] = id;
    data['district'] = district.toJson();
    data['name'] = name;
    return data;
  }
}

class District {
  District({
    required this.province,
    required this.urlName,
    required this.id,
    required this.name,
  });
  late final Province province;
  late final String urlName;
  late final int id;
  late final String name;

  District.fromJson(Map<String, dynamic> json) {
    province = Province.fromJson(json['province']);
    urlName = json['urlName'];
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['province'] = province.toJson();
    data['urlName'] = urlName;
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class Province {
  Province({
    required this.urlName,
    required this.id,
    required this.name,
  });
  late final String urlName;
  late final int id;
  late final String name;

  Province.fromJson(Map<String, dynamic> json) {
    urlName = json['urlName'];
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['urlName'] = urlName;
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
