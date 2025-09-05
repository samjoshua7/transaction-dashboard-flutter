class TransactionModel {
  String id;
  String name;
  double amount;
  String date;
  String status; // pending, completed, flagged

  TransactionModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.date,
    required this.status,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      name: json['name'],
      amount: json['amount'],
      date: json['date'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'amount': amount,
        'date': date,
        'status': status,
      };
}
