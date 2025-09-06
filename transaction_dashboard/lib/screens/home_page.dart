import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction.dart';
import '../widgets/transaction_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TransactionModel> transactions = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('transactions');

    if (savedData != null) {
      List list = jsonDecode(savedData);
      setState(() {
        transactions =
            list.map((item) => TransactionModel.fromJson(item)).toList();
      });
    } else {
      String jsonString =
          await DefaultAssetBundle.of(context).loadString("assets/transactions.json");
      List list = jsonDecode(jsonString);
      setState(() {
        transactions =
            list.map((item) => TransactionModel.fromJson(item)).toList();
      });
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
        'transactions',
        jsonEncode(
            transactions.map((transaction) => transaction.toJson()).toList()));
  }

  void _onDrop(TransactionModel t, String newStatus) {
    setState(() {
      t.status = newStatus;
    });
    _saveData();
  }

  // 🔹 Popup dialog for Add/Edit
  void _showTransactionDialog({TransactionModel? transaction}) {
    final nameController = TextEditingController(text: transaction?.name ?? "");
    final amountController = TextEditingController(
        text: transaction != null ? transaction.amount.toString() : "");
    final dateController = TextEditingController(text: transaction?.date ?? "");
    String status = transaction?.status ?? "pending";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(transaction == null ? "Add Transaction" : "Edit Transaction"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Name"),
                ),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Amount"),
                ),
                TextField(
                  controller: dateController,
                  decoration: const InputDecoration(labelText: "Date (YYYY-MM-DD)"),
                ),
                DropdownButtonFormField<String>(
                  initialValue: status,
                  items: const [
                    DropdownMenuItem(value: "pending", child: Text("Pending")),
                    DropdownMenuItem(value: "completed", child: Text("Completed")),
                    DropdownMenuItem(value: "flagged", child: Text("Flagged")),
                  ],
                  onChanged: (val) => status = val!,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                if (transaction == null) {
                  setState(() {
                    transactions.add(TransactionModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: nameController.text,
                      amount: double.tryParse(amountController.text) ?? 0,
                      date: dateController.text,
                      status: status,
                    ));
                  });
                } else {
                  setState(() {
                    transaction.name = nameController.text;
                    transaction.amount =
                        double.tryParse(amountController.text) ?? 0;
                    transaction.date = dateController.text;
                    transaction.status = status;
                  });
                }
                _saveData();
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = transactions
        .where((t) => t.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    List<TransactionModel> pending =
        filtered.where((t) => t.status == "pending").toList();
    List<TransactionModel> completed =
        filtered.where((t) => t.status == "completed").toList();
    List<TransactionModel> flagged =
        filtered.where((t) => t.status == "flagged").toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction Dashboard"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search transactions...",
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => setState(() => searchQuery = val),
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          _buildHorizontalSection("Pending", pending, "pending"),
          _buildHorizontalSection("Completed", completed, "completed"),
          _buildHorizontalSection("Flagged", flagged, "flagged"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showTransactionDialog(),
      ),
    );
  }

  Widget _buildHorizontalSection(
      String title, List<TransactionModel> items, String status) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          color: Colors.blue.shade100,
          child: Text(title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        SizedBox(
          height: 180, // adjust card row height
          child: 
          DragTarget<TransactionModel>(
            onAccept: (t) => _onDrop(t, status),
            builder: (context, candidateData, rejectedData) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  var t = items[index];
                  return Container(
                    width: 160,
                    margin: const EdgeInsets.all(8),
                    child: LongPressDraggable<TransactionModel>(
                      data: t,
                      feedback: Material(
                        child: SizedBox(
                          width: 160,
                          child: TransactionCard(
                            transaction: t,
                            onEdit: (tx) => _showTransactionDialog(transaction: tx),
                          ),
                        ),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.5,
                        child: TransactionCard(
                          transaction: t,
                          onEdit: (tx) => _showTransactionDialog(transaction: tx),
                        ),
                      ),
                      child: TransactionCard(
                        transaction: t,
                        onEdit: (tx) => _showTransactionDialog(transaction: tx),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // 🔹 Row Builder
  Widget _buildRow(TransactionModel t) {
    return LongPressDraggable<TransactionModel>(
      data: t,
      feedback: Material(
        child: SizedBox(
          width: 250,
          child: TransactionCard(
            transaction: t,
            onEdit: (tx) => _showTransactionDialog(transaction: tx),
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: Row(
          children: [
            _statusBox(t.status),
            Expanded(
              child: TransactionCard(
                transaction: t,
                onEdit: (tx) => _showTransactionDialog(transaction: tx),
              ),
            ),
          ],
        ),
      ),
      child: DragTarget<TransactionModel>(
        onAcceptWithDetails: (details) {
          setState(() {
            details.data.status = t.status; // ✅ use details.data
          });
          _saveData();
        },
        builder: (context, _, __) {
          return Row(
            children: [
              _statusBox(t.status),
              Expanded(
                child: TransactionCard(
                  transaction: t,
                  onEdit: (tx) => _showTransactionDialog(transaction: tx),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // 🔹 Small status box
  Widget _statusBox(String status) {
    Color color;
    switch (status) {
      case "completed":
        color = Colors.green.shade300;
        break;
      case "flagged":
        color = Colors.red.shade300;
        break;
      default:
        color = Colors.orange.shade300;
    }
    return Container(
      width: 100,
      padding: const EdgeInsets.all(8),
      color: color,
      child: Text(
        status.toUpperCase(),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}