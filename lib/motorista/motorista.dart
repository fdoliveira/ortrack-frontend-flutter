
class Motorista {

  static final String motoristaTable = "motoristaTable";
  static final String idColumn = "idColumn";
  static final String nomeColumn = "nomeColumn";
  static final String cpfColumn = "cpfColumn";

  String id;
  String nome;
  String cpf;

  Motorista();

  Motorista.fromMap(Map map) {
    id = map[idColumn];
    nome = map[nomeColumn];
    cpf = map[cpfColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      idColumn: id,
      nomeColumn: nome,
      cpfColumn: cpf,
    };

    return map;
  }

  @override
  String toString() {
    return "Motorista(id: ${id}, nome: ${nome}, cpf: ${cpf})";
  }

}