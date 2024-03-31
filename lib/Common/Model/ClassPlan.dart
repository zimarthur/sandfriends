import 'package:sandfriends/Common/Enum/EnumClassFormat.dart';
import 'package:sandfriends/Common/Enum/EnumClassFrequency.dart';
import 'package:sandfriends/Common/Utils/TypeExtensions.dart';

class ClassPlan {
  int? idClassPlan;
  EnumClassFormat format;
  EnumClassFrequency classFrequency;
  int price;

  String get priceDetail {
    if (classFrequency.value == 0) {
      return "${price.formatPrice()}/aula";
    } else {
      return "${price.formatPrice()}/aula (aprox. ${(price * classFrequency.value * 4).formatPrice()}/mês)";
    }
  }

  ClassPlan({
    required this.idClassPlan,
    required this.format,
    required this.classFrequency,
    required this.price,
  });

  factory ClassPlan.fromJson(Map<String, dynamic> json) {
    return ClassPlan(
      idClassPlan: json["IdTeacherPlan"],
      format: classFormatFromInt(
        json["ClassSize"],
      ),
      classFrequency: classFrequencyFromInt(
        json["TimesPerWeek"],
      ),
      price: json["Price"],
    );
  }

  factory ClassPlan.copyFrom(ClassPlan refClassPlan) {
    return ClassPlan(
      idClassPlan: refClassPlan.idClassPlan,
      format: refClassPlan.format,
      classFrequency: refClassPlan.classFrequency,
      price: refClassPlan.price,
    );
  }

  @override
  int get hashCode =>
      format.hashCode ^ classFrequency.hashCode ^ price.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is ClassPlan == false) return false;
    ClassPlan otherplan = other as ClassPlan;
    return idClassPlan == otherplan.idClassPlan &&
        format == otherplan.format &&
        classFrequency == otherplan.classFrequency &&
        price == otherplan.price;
  }
}
