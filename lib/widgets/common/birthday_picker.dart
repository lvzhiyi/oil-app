import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:gap/gap.dart';
import 'package:oil_business_app/utils/pt.dart';
import 'package:oil_business_app/utils/date_util.dart';
import 'package:oil_business_app/widgets/common/sports_date_picker.dart';

class BirthdayPicker extends FormBuilderField<String> {
  BirthdayPicker({
    super.key,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
    String? initialValue,
    bool? readOnly,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    required String name,
  }) : super(
          name: name,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          builder: (state) {
            List<Widget> _renderActionTextList(DateTime? selectedDate) {
              List<String> textList = ['Day', 'Month', 'Year'];
              List<int> values = [
                selectedDate?.day ?? 0,
                selectedDate?.month ?? 0,
                selectedDate?.year ?? 0,
              ];
              List<Widget> btnList = [];
              TextStyle hintStyle = TextStyle(
                fontSize: pt(12, isFontSize: true),
                fontWeight: FontWeight.w500,
                color: const Color(0xff979797),
              );
              List.generate(textList.length, (i) {
                if (i > 0) {
                  btnList.add(
                    Gap(
                      pt(18),
                    ),
                  );
                }
                btnList.add(
                  Expanded(
                    child: Container(
                      height: pt(52),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xffefefef),
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            pt(6),
                          ),
                        ),
                      ),
                      child: Text(
                        selectedDate != null
                            ? formatTime(values[i])
                            : textList[i],
                        style: hintStyle,
                      ),
                    ),
                  ),
                );
              });

              return btnList;
            }

            return SportsDatePicker(
              readOnly: readOnly ?? false,
              initialDate: (state.value != null && state.value != '')
                  ? DateTime.parse(state.value!)
                  : null,
              onChanged: (selectedDate) {
                state
                    .didChange(formatDate(selectedDate!, format: 'yyyy-MM-dd'));
                state.save();
              },
              childBuilder: (selectedDate) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: _renderActionTextList(selectedDate),
                    ),
                    if (state.errorText != null)
                      Padding(
                        padding: EdgeInsets.only(top: pt(10), left: pt(10)),
                        child: Text(
                          state.errorText!,
                          style: TextStyle(
                            fontSize: pt(10, isFontSize: true),
                            height: 1,
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                          ),
                        ),
                      ),
                  ],
                );
              },
            );
          },
        );
}
