enum Product {
  Sandfriends,
  SandfriendsQuadras,
}

extension ProductString on Product {
  String get productString {
    switch (this) {
      case Product.Sandfriends:
        return '';
      case Product.SandfriendsQuadras:
        return 'quadras';
    }
  }
}
