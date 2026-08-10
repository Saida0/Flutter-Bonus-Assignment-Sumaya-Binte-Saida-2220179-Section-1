import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summer_iub_app/models/coffee_records_model.dart';
import 'package:summer_iub_app/state_management/coffee_state_management.dart';
import 'package:summer_iub_app/widgets/app_backgroud_design_widget.dart';

/// Reads coffee records LIVE from Firestore using snapshots + StreamBuilder.
/// Any change made in Firebase (or from another device) shows up here instantly.
class FirebaseCoffeeRecordsScreen extends StatelessWidget {
  const FirebaseCoffeeRecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final csm = Provider.of<CoffeeStateManagement>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Firebase Coffee Records",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.00),
        ),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: AppBackgroudDesignWidget(
        child: StreamBuilder<List<CoffeeRecordsModel>>(
          stream: csm.coffeeRecordsStream,
          builder: (context, snapshot) {
            // Loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // Error
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "Something went wrong:\n${snapshot.error}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              );
            }

            final records = snapshot.data ?? [];

            // Empty
            if (records.isEmpty) {
              return const Center(
                child: Text(
                  "No coffee records yet.\nTap + to add one.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.brown, fontSize: 18),
                ),
              );
            }

            // Data
            return ListView.builder(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              itemCount: records.length,
              itemBuilder: (context, index) {
                final record = records[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.coffee, color: Colors.brown),
                    title: Text(record.title),
                    subtitle: Text(
                      "${record.des}\nAmount: ${record.amount}",
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // UPDATE
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.brown),
                          onPressed: () =>
                              _showEditDialog(context, csm, record),
                        ),
                        // DELETE
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            if (record.docId != null) {
                              csm.deleteCoffeeRecord(record.docId!);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  /// Simple dialog to edit a record and push the UPDATE to Firestore.
  void _showEditDialog(
    BuildContext context,
    CoffeeStateManagement csm,
    CoffeeRecordsModel record,
  ) {
    final titleController = TextEditingController(text: record.title);
    final desController = TextEditingController(text: record.des);
    final amountController =
        TextEditingController(text: record.amount?.toString() ?? "");

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Coffee Record"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: desController,
                decoration: const InputDecoration(labelText: "Description"),
              ),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Amount"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final updated = record.copyWith(
                  title: titleController.text,
                  des: desController.text,
                  amount: double.tryParse(amountController.text) ?? 0.0,
                );
                csm.updateCoffeeRecord(updated);
                Navigator.of(context).pop();
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }
}
