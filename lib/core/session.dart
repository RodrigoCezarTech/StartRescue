// lib/core/session.dart
import 'package:flutter/foundation.dart';

/// Dados do formulário/sessão (aparece na tela final e na exportação)
@immutable
class SessionForm {
  final String name;   // Nome do aluno/usuário
  final String sector; // Setor/curso/turma
  final String id;     // RA/ID

  const SessionForm({
    required this.name,
    required this.sector,
    required this.id, required int timeLimitSec, required int total,
  });
}

/// Linha de resposta de 1 questão
///
/// Campos batendo com o que o ResultView/Export esperam:
/// - q: número da questão
/// - your: sua resposta (string da cor: VERDE/AMARELO/VERMELHO/ÓBITO ou "—")
/// - correct: resposta correta (string da cor)
/// - explain: justificativa textual
@immutable
class AnswerRow {
  final int q;
  final String? your;
  final String? correct;
  final String? explain;

  const AnswerRow({
    required this.q,
    this.your,
    this.correct,
    this.explain,
  });
}
