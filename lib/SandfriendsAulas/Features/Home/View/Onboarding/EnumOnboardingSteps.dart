import 'package:flutter/material.dart';

enum OnboardingSteps { Profile, ClassPlans, Team, School }

extension OnboardingStepsExtension on OnboardingSteps {
  String get title {
    switch (this) {
      case OnboardingSteps.Profile:
        return 'Complete seu perfil';
      case OnboardingSteps.ClassPlans:
        return 'Adicione seus planos de aula';
      case OnboardingSteps.Team:
        return 'Crie uma turma';
      case OnboardingSteps.School:
        return 'Seja convidado por uma escola';
    }
  }

  String get description {
    switch (this) {
      case OnboardingSteps.Profile:
        return 'Complete seu perfil. Não esqueça de colocar uma foto e informar seu WhatsApp.';
      case OnboardingSteps.ClassPlans:
        return 'Crie as regras de preço das suas aulas. ';
      case OnboardingSteps.Team:
        return 'Voçê precisa de, pelo menos, uma turma para atribuir suas aulas';
      case OnboardingSteps.School:
        return 'Seu perfil está completo! Fale com sua escola perceira e peça que te adicione ao quadro de professores.';
    }
  }

  String get icon {
    switch (this) {
      case OnboardingSteps.Profile:
        return 'assets/icon/user.svg';
      case OnboardingSteps.ClassPlans:
        return 'assets/icon/class_plans_color.svg';
      case OnboardingSteps.Team:
        return 'assets/icon/team_color.svg';
      case OnboardingSteps.School:
        return 'assets/icon/court.svg';
    }
  }

  Function(BuildContext) get onNavigate {
    switch (this) {
      case OnboardingSteps.Profile:
        return (context) => Navigator.of(context).pushNamed("/teacher_details");
      case OnboardingSteps.ClassPlans:
        return (context) => Navigator.of(context).pushNamed("/class_plans");
      case OnboardingSteps.Team:
        return (context) => Navigator.of(context).pushNamed("/teams");
      case OnboardingSteps.School:
        return (context) => Navigator.of(context).pushNamed("/classes");
    }
  }
}
