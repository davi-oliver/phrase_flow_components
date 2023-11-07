import 'package:phrase_flow_components/app/services/questionary/answer_idea2/answer_idea2_widget.dart';
import 'package:phrase_flow_components/app/services/questionary/questionary_home/questionary_page.dart';
import 'package:phrase_flow_components/app/services/questionary/questionary_tipe_select_image/questionary_tipe_select_image_widget.dart';
import 'package:phrase_flow_components/app/services/questionary/questionary_type_select_option/questionary_type_select_option_widget.dart';
import 'package:phrase_flow_components/app/success_page/success_page_widget.dart';

import '../../../../components/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class QuestionarioHomeFunctions extends FlutterFlowModel<QuestionarioTipos> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  /// Initialization and disposal methods.
  Future<PageController> initPageController() async {
    PageController pageControllerAux = PageController(initialPage: 0);

    return pageControllerAux;
  }

  void initState(BuildContext context) {
    unfocusNode.addListener(() {
      if (!unfocusNode.hasFocus) {
        unfocusNode.unfocus();
      }
    });
  }

  List<Widget> pagesList = [
    // QuestionaryTypeWriteWidget(),
    QuestionaryTypeSelectOptionWidget(),
    QuestionaryTipeSelectImageWidget(),
    AnswerIdea2Widget(),
    SuccessPageWidget(),
  ];

  @override
  void dispose() {
    // TODO: implement dispose
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
