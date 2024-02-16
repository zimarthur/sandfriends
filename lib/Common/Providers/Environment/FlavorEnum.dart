enum Flavor { Prod, Dev, Demo }

extension FlavorString on Flavor {
  String get flavorString {
    switch (this) {
      case Flavor.Prod:
        return '';
      case Flavor.Dev:
        return 'dev';
      case Flavor.Demo:
        return 'demo';
    }
  }
}
