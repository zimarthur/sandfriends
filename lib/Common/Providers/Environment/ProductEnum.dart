enum Product {
  Sandfriends,
  SandfriendsAulas,
  SandfriendsQuadras,
  SandfriendsWebPage,
}

extension ProductString on Product {
  String get productString {
    switch (this) {
      case Product.Sandfriends:
        return '';
      case Product.SandfriendsAulas:
        return 'aulas';
      case Product.SandfriendsQuadras:
        return 'quadras';
      case Product.SandfriendsWebPage:
        return 'web';
    }
  }

  String get productUrl {
    switch (this) {
      case Product.Sandfriends:
        return 'app';
      case Product.SandfriendsAulas:
        return 'app';
      case Product.SandfriendsQuadras:
        return 'quadras';
      case Product.SandfriendsWebPage:
        return 'app';
    }
  }
}
