enum ClassView { Classes, RecurrentClasses }

extension ClassViewExtension on ClassView {
  String get title {
    switch (this) {
      case ClassView.Classes:
        return 'Aulas por dia';
      case ClassView.RecurrentClasses:
        return 'Aulas fixas';
    }
  }
}
