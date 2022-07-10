import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../model/report.dart';
import '../services/app_service.dart';
import '../widgets/app_title.dart';
import '../widgets/back_button.dart';
import '../widgets/checkbox_form_input.dart';
import '../widgets/email_input.dart';
import '../widgets/footer.dart';
import '../widgets/form_input_divider.dart';
import '../widgets/policy_button.dart';
import '../widgets/privacy_button.dart';
import '../widgets/text_area_input.dart';
import '../utils/constants.dart';

class ReportPage extends StatefulWidget {
  static String routeName = '/report';
  const ReportPage({Key? key}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final _form = GlobalKey<FormState>();
  bool isLoading = false;
  final _descriptionController = TextEditingController();
  final _emailController = TextEditingController();
  bool confirm = false;

  Future<void> _report(AppLocalizations appLocalizations, AppService appService,
      String advertId) async {
    setState(() {
      isLoading = true;
    });

    if (_form.currentState != null && _form.currentState!.validate()) {
      _form.currentState!.save();

      if (confirm == false) {
        context.showErrorSnackBar(
            message: appLocalizations.unconfirmed_privacy);
      }

      if (confirm == true) {
        final model = Report(
          advertId: advertId,
          email: _emailController.text,
          description: _descriptionController.text,
        );

        final response = await appService.createReport(model);
        final error = response.error;
        if (response.hasError) {
          if (!mounted) return;
          context.showErrorSnackBar(message: error!.message);
        } else {
          if (!mounted) return;
          context.showSnackBar(message: appLocalizations.report_thanks);
          Navigator.of(context).pop();
        }
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String advertId =
        ModalRoute.of(context)!.settings.arguments as String;

    final appService = context.read<AppService>();
    final appLocalization = AppLocalizations.of(context) as AppLocalizations;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        children: [
          Column(
            children: [
              const AppTitle(),
              const FormInputDivider(),
              Text(
                appLocalization.report_text,
                textAlign: TextAlign.justify,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const FormInputDivider(),
              Form(
                key: _form,
                child: Column(
                  children: [
                    EmailInput(
                      controller: _emailController,
                      isLoading: isLoading,
                    ),
                    const FormInputDivider(),
                    TextAreaInput(
                      name: appLocalization.description,
                      controller: _descriptionController,
                      validator: RequiredValidator(
                          errorText: appLocalization.description_required),
                      isLoading: isLoading,
                    ),
                    const FormInputDivider(),
                    const PrivacyButton(),
                    const PolicyButton(),
                    CheckboxFormInput(
                      title: appLocalization.privacy_confirm_text,
                      onSaved: (val) => confirm = val ?? false,
                      enabled: !isLoading,
                      initialValue: false,
                    ),
                    const FormInputDivider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () => _report(
                                  appLocalization, appService, advertId),
                          child: Text(isLoading
                              ? appLocalization.loading
                              : appLocalization.report),
                        ),
                        const SizedBox(width: 10),
                        const BackToPageButton(),
                      ],
                    ),
                  ],
                ),
              ),
              const FormInputDivider(),
              const Footer(),
            ],
          ),
        ],
      ),
    );
  }
}
