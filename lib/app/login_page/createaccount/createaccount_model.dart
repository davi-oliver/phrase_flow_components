import 'dart:developer';

import 'package:phrase_flow_components/app/global/store/global_store.dart';
import 'package:phrase_flow_components/backend/datasource/post.dart';
import 'package:phrase_flow_components/model/user.dart';
import 'package:provider/provider.dart';

import '../../../components/flutter_flow/flutter_flow_util.dart';
import 'createaccount_widget.dart' show CreateaccountWidget;
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

TextEditingController nameController = TextEditingController();
TextEditingController emailAddressController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController passwordConfirmController = TextEditingController();
MaskedTextController controllerDataNasc =
    MaskedTextController(mask: '00/00/0000');
TextEditingController controllerNacionalidade = TextEditingController();

class CreateaccountModel extends FlutterFlowModel<CreateaccountWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for emailAddress widget.
  FocusNode? emailAddressFocusNode;
  // TextEditingController? emailAddressController;
  String? Function(BuildContext, String?)? emailAddressControllerValidator;

  // TextEditingController? nameController;
  String? Function(BuildContext, String?)? nameControllerValidator;
  FocusNode? nameControllerFocusNode;

  String? Function(BuildContext, String?)? controllerDataNascValidator;
  FocusNode? controllerDataNascFocusNode;

  // TextEditingController? controllerNacionalidade;

  String? Function(BuildContext, String?)? controllerNacionalidadeValidator;
  FocusNode? controllerNacionalidadeFocusNode;

  // State field(s) for password widget.
  FocusNode? passwordFocusNode;
  // TextEditingController? passwordController;
  late bool passwordVisibility;
  String? Function(BuildContext, String?)? passwordControllerValidator;
  // State field(s) for passwordConfirm widget.
  FocusNode? passwordConfirmFocusNode;
  // TextEditingController? passwordConfirmController;
  late bool passwordConfirmVisibility;
  String? Function(BuildContext, String?)? passwordConfirmControllerValidator;

  Future<Result> validateSubmit() async {
    if (emailAddressController.text.isEmpty ||
        passwordController.text.isEmpty ||
        passwordConfirmController.text.isEmpty) {
      // valida o email
      final kEmailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!kEmailRegex.hasMatch(emailAddressController.text)) {
        return Result(false, message: 'Email inválido');
      }

      // valida a senha

      return Result(false, message: 'Preencha todos os campos');
    } else {
      if (passwordController.text.length < 6 ||
          passwordConfirmController.text.length < 6) {
        return Result(false,
            message: 'A senha deve ter pelo menos 6 caracteres');
      }

      if (passwordController.text != passwordConfirmController.text) {
        return Result(false, message: 'As senhas não coincidem');
      }
    }
    return Result(true, message: 'Sucesso');
  }

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    passwordVisibility = false;
    passwordConfirmVisibility = false;
  }

  void dispose() {
    unfocusNode.dispose();
    emailAddressFocusNode?.dispose();
    emailAddressController.dispose();

    passwordFocusNode?.dispose();
    passwordController.dispose();

    passwordConfirmFocusNode?.dispose();
    passwordConfirmController.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}

class Result {
  bool isValid;
  String? message;
  Result(this.isValid, {this.message});
}

Future createUser(context) async {
  final globalInfo = Provider.of<GlobalStore>(context, listen: false);
  final httprequest = PostHttpRequestApp(context);

//2023-11-07T03:58:02.515Z
  var dataFormatada =
      controllerDataNasc.text.split("/").reversed.join('-') + 'T00:00:00.000Z';

  log("dataFormatada: $dataFormatada");

  final result =
      await httprequest.makeJsonRequestDynamc(url: "users/create", params: {
    "email": emailAddressController.text,
    "name": nameController.text,
    "password": passwordController.text,
    "birthDate": dataFormatada,
    "country": controllerNacionalidade.text,
    "sex": "M"
  });

  Result res = await result.fold((l) async {
    return Result(false, message: l.descricao);
  }, (r) async {
    if (r['error'] != null) {
      return Result(false, message: r['error']);
    }
    log("result: $r");

    globalInfo.setUser(ModelUser(
        name: nameController.text,
        email: emailAddressController.text,
        password: passwordController.text,
        birthDate: controllerDataNasc.text,
        country: controllerNacionalidade.text,
        sex: r["sex"]));

    return Result(true, message: 'Sucesso');
  });

  return res;
}
