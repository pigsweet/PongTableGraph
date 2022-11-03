import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pongtablegraph/controllers/app_controller.dart';
import 'package:pongtablegraph/utility/my_constant.dart';
import 'package:pongtablegraph/utility/my_dialog.dart';
import 'package:pongtablegraph/utility/my_service.dart';
import 'package:pongtablegraph/widgets/widget_button.dart';
import 'package:pongtablegraph/widgets/widget_form.dart';
import 'package:pongtablegraph/widgets/widget_text.dart';

class MyTable extends StatefulWidget {
  const MyTable({super.key});

  @override
  State<MyTable> createState() => _MyTableState();
}

class _MyTableState extends State<MyTable> {
  String? number;
  TextEditingController textEditingController = TextEditingController();

  final appController = Get.put(AppController());

  @override
  void initState() {
    super.initState();
    appController.readAllNumber();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
      return GetX(
        init: AppController(),
        builder: (controller) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
          child: SizedBox(
            width: boxConstraints.maxWidth,
            height: boxConstraints.maxHeight,
            child: Stack(
              children: [
                SizedBox(height: boxConstraints.maxHeight-80,
                  child: ListView(
                    children: [
                      head(),
                      listNumber(controller),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 8,
                  child: Row(
                    children: [
                      valueForm(boxConstraints),
                      addButtom(boxConstraints),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  ListView listNumber(AppController controller) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: controller.numberModels.length,
      itemBuilder: (context, index) => Column(
        children: [
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      WidgetText(text: controller.numberModels[index].id),
                    ],
                  )),
              Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      WidgetText(text: controller.numberModels[index].number),
                    ],
                  ))
            ],
          ),
          const Divider(
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  Container head() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(color: Color.fromARGB(255, 183, 182, 182)),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                WidgetText(
                  text: 'id',
                  textStyle: MyConstant().h21Style(),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: WidgetText(
              text: 'Number',
              textStyle: MyConstant().h21Style(),
            ),
          ),
        ],
      ),
    );
  }

  Container addButtom(BoxConstraints boxConstraints) {
    return Container(
      padding: const EdgeInsets.only(right: 16),
      width: boxConstraints.maxWidth * .25,
      height: 50,
      child: WidgetButton(
        label: 'Add',
        pressFunc: () {
          if (number?.isEmpty ?? true) {
            print('Have Space');
            MyDialog(context: context).normalDialog(
                title: 'Have Space', message: 'Please Fill Every Blank');
          } else {
            print('No space');
            processInsertValueTpApi();
          }
        },
      ),
    );
  }

  Container valueForm(BoxConstraints boxConstraints) {
    return Container(
      padding: const EdgeInsets.only(
        left: 16,
        top: 8,
        bottom: 8,
        right: 8,
      ),
      width: boxConstraints.maxWidth * 0.75,
      child: WidgetForm(
        textEditingController: textEditingController,
        hint: 'Number',
        textInputType: TextInputType.number,
        changeFunc: (String string) {
          number = string.trim();
        },
      ),
    );
  }

  Future<void> processInsertValueTpApi() async {
    await MyService().insertNumber(number: number!).then((value) {
      textEditingController.text = ' ';
      appController.readAllNumber();
    });
  }
}
