import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summer_iub_app/models/coffee_records_model.dart';
import 'package:summer_iub_app/state_management/coffee_state_management.dart';
import 'package:summer_iub_app/utility/vlaidators.dart';
import 'package:summer_iub_app/widgets/app_backgroud_design_widget.dart';
import 'package:summer_iub_app/widgets/core_input_widget.dart';

class CreateCoffeeRecordScreen extends StatelessWidget {
  const CreateCoffeeRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final TextEditingController titleController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    final csm = Provider.of<CoffeeStateManagement>(context, listen: false);



    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Coffee Record",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.00,
          ),
        ),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: AppBackgroudDesignWidget(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                CoreInputWidget(
                  controller: titleController,
                  labelText: "Title",
                  validator: CustomValidators.validateTitle,
                ),
            
                const SizedBox(height: 20.00,),
            
                CoreInputWidget(
                  controller: amountController,
                  labelText: "Amount",
                  keyboardType: TextInputType.number,
                  validator: CustomValidators.validateAmount,
                ),
            
            
                const SizedBox(height: 20.00,),
              
                CoreInputWidget(
                  controller: descriptionController,
                  labelText: "Description",
                  keyboardType: TextInputType.multiline,
                  maxLine: 5,
                  validator: CustomValidators.validateDescreption,
                ),
            
                const Spacer(),
                ElevatedButton.icon(
                    onPressed: (){
                      print(formKey.currentState!.validate());
                      if(formKey.currentState!.validate()){
                        CoffeeRecordsModel newRecord = CoffeeRecordsModel(
                        id: DateTime.now().microsecondsSinceEpoch,
                        title: titleController.text,
                        des: descriptionController.text,
                        amount: double.tryParse(amountController.text) ?? 0.0,
                        date: DateTime.now(),
                      );
            
                      // Save locally (original demo behaviour)...
                      csm.addCoffeeRecord(newRecord);
                      // ...and send the record to Firebase Firestore.
                      csm.addCoffeeRecordToFirebase(newRecord);


                      titleController.clear();
                      amountController.clear();
                      descriptionController.clear();
            
                      Navigator.of(context).pop();
                      }


                      
            
                    }, 
                    label: Text("Save Coffee Record", style: TextStyle(fontSize: 18.00, fontWeight: FontWeight.bold),),
                    icon: Icon(Icons.save , size: 30.00,),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 50.00),
                      padding: EdgeInsets.symmetric(horizontal: 50.00, vertical: 15.00
                    ),
                  )
                ),
            
              ],
            ),
          ),
        ),
      ),
    );
  }
}