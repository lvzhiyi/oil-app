import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/models/vehicle_model.dart';
import 'package:oil_business_app/pages/oil_pickup/model/withdraw_data.dart';
import 'package:oil_business_app/pages/oil_pickup/widgets/station_selector_button.dart';
import 'package:oil_business_app/pages/oil_pickup_detail/controller.dart';
import 'package:oil_business_app/pages/oil_pickup_detail/state.dart';
import 'package:oil_business_app/pages/oil_pickup_detail/widgets/smart_parse_card.dart';
import 'package:oil_business_app/pages/oil_pickup_detail/widgets/vehicle_info_form.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/fuel_type_helper.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/button/common_button.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';
import 'package:oil_business_app/widgets/common/global_update_ui.dart';
import 'package:oil_business_app/widgets/popup/toast.dart';

class OilPickupDetailScreen extends StatefulWidget {
  final OilPickupDetailState state;
  final OilPickupDetailCtrl controller;

  const OilPickupDetailScreen({
    Key? key,
    required this.state,
    required this.controller,
  }) : super(key: key);

  @override
  State<OilPickupDetailScreen> createState() => _OilPickupDetailScreenState();
}

class _OilPickupDetailScreenState extends State<OilPickupDetailScreen> {
  late TextEditingController _oilAmountController;
  
  // Form Controllers
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _driverNameController;
  late TextEditingController _plateNumberController;
  late TextEditingController _idCardController;
  late TextEditingController _phoneController;
  late TextEditingController _loadCapacityController;
  late TextEditingController _tank1CapacityController;
  late TextEditingController _tank2CapacityController;
  
  // New Fields
  late TextEditingController _vehicleTypeController;
  late TextEditingController _driverLicenseController;
  late TextEditingController _vehicleLicenseController;
  late TextEditingController _tankTypeController;
  late TextEditingController _hasPumpController;

  @override
  void initState() {
    super.initState();
    _oilAmountController = TextEditingController(text: widget.state.oilAmount);
    
    // Init Form Controllers
    _driverNameController = TextEditingController();
    _plateNumberController = TextEditingController();
    _idCardController = TextEditingController();
    _phoneController = TextEditingController();
    _loadCapacityController = TextEditingController();
    _tank1CapacityController = TextEditingController();
    _tank2CapacityController = TextEditingController();
    
    _vehicleTypeController = TextEditingController();
    _driverLicenseController = TextEditingController();
    _vehicleLicenseController = TextEditingController();
    _tankTypeController = TextEditingController();
    _hasPumpController = TextEditingController();
    
    // If there's initial data (unlikely on fresh load, but good practice)
    if (widget.state.vehicleModel != null) {
      _populateForm(widget.state.vehicleModel!);
    }
  }

  @override
  void dispose() {
    _oilAmountController.dispose();
    _driverNameController.dispose();
    _plateNumberController.dispose();
    _idCardController.dispose();
    _phoneController.dispose();
    _loadCapacityController.dispose();
    _tank1CapacityController.dispose();
    _tank2CapacityController.dispose();
    
    _vehicleTypeController.dispose();
    _driverLicenseController.dispose();
    _vehicleLicenseController.dispose();
    _tankTypeController.dispose();
    _hasPumpController.dispose();
    super.dispose();
  }
  
  void _populateForm(VehicleModel model) {
    _driverNameController.text = model.driverName ?? '';
    _plateNumberController.text = model.plateNumber ?? '';
    _idCardController.text = model.driverIdCard ?? '';
    _phoneController.text = model.driverPhone ?? '';
    _loadCapacityController.text = model.loadCapacity ?? '';
    _tank1CapacityController.text = model.tank1Capacity ?? '';
    _tank2CapacityController.text = model.tank2Capacity ?? '';
    
    _vehicleTypeController.text = model.vehicleType ?? '';
    _driverLicenseController.text = model.driverLicense ?? '';
    _vehicleLicenseController.text = model.vehicleLicense ?? '';
    _tankTypeController.text = model.tankType ?? '';
    _hasPumpController.text = model.hasPump ?? '';
    
    // Also update the main oil amount if parsed
    if (model.oilAmount != null && model.oilAmount!.isNotEmpty) {
      // Always update if parser found an amount, assuming "Intelligent Fill" takes precedence
      _oilAmountController.text = model.oilAmount!;
      widget.controller.updateOilAmount(model.oilAmount!);
    }
  }

  void _handleGenerateCertificate() {
    if (!_formKey.currentState!.validate()) {
      SportsToast.showWarning('请完善车辆及司机信息');
      return;
    }

    final currentOilAmount = _oilAmountController.text.trim();
    
    // Construct VehicleModel from form
    final vehicleModel = VehicleModel(
      driverName: _driverNameController.text.trim(),
      plateNumber: _plateNumberController.text.trim(),
      driverIdCard: _idCardController.text.trim(),
      driverPhone: _phoneController.text.trim(),
      oilAmount: currentOilAmount, // Use the main oil amount as the definitive one
      loadCapacity: _loadCapacityController.text.trim(),
      tank1Capacity: _tank1CapacityController.text.trim(),
      tank2Capacity: _tank2CapacityController.text.trim(),
      
      vehicleType: _vehicleTypeController.text.trim(),
      driverLicense: _driverLicenseController.text.trim(),
      vehicleLicense: _vehicleLicenseController.text.trim(),
      tankType: _tankTypeController.text.trim(),
      hasPump: _hasPumpController.text.trim(),
    );
    
    final baseModel = widget.state.vehicleModel ?? VehicleModel();
    final finalModel = baseModel.copyWith(
       driverName: _driverNameController.text.trim(),
       plateNumber: _plateNumberController.text.trim(),
       driverIdCard: _idCardController.text.trim(),
       driverPhone: _phoneController.text.trim(),
       oilAmount: currentOilAmount,
       loadCapacity: _loadCapacityController.text.trim(),
       tank1Capacity: _tank1CapacityController.text.trim(),
       tank2Capacity: _tank2CapacityController.text.trim(),
       
       vehicleType: _vehicleTypeController.text.trim(),
       driverLicense: _driverLicenseController.text.trim(),
       vehicleLicense: _vehicleLicenseController.text.trim(),
       tankType: _tankTypeController.text.trim(),
       hasPump: _hasPumpController.text.trim(),
    );

    widget.controller.generateCertificate(
      context, 
      currentOilAmount: currentOilAmount,
      vehicleModel: finalModel,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OilPickupDetailCtrl, OilPickupDetailState>(
      listenWhen: (previous, current) => previous.vehicleModel != current.vehicleModel,
      listener: (context, state) {
        if (state.vehicleModel != null) {
          _populateForm(state.vehicleModel!);
          
          // Trigger validation to clear errors if fields are now filled,
          // or to highlight what is still missing.
          // Using addPostFrameCallback to ensure UI is ready if needed, 
          // though for FormState synchronous call is usually fine.
          WidgetsBinding.instance.addPostFrameCallback((_) {
             _formKey.currentState?.validate();
          });
        }
      },
      child: GlobalUpdateUi(
        builder: (context, appCtrl) {
          final selectedStation = appCtrl.state.selectedStation;
          final currentState = widget.state.copyWith(selectedStation: selectedStation);

          return Scaffold(
            backgroundColor: CustomAppColor.of(context).bgScaffold,
            appBar: AppBar(
              backgroundColor: CustomAppColor.of(context).bgScaffold,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: CustomAppColor.of(context).txtBlack,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: CommonText(
                text: '提油详情',
                fontSize: AppSizes.setFontSize(18),
                fontWeight: FontWeight.w600,
                textColor: CustomAppColor.of(context).txtBlack,
              ),
              centerTitle: true,
            ),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (currentState.inventory != null) ...[
                          _buildInventoryInfoCard(context, currentState.inventory!),
                        ],
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppSizes.setWidth(16)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: AppSizes.setHeight(16)),
                              _buildOilAmountInput(context),
                              SizedBox(height: AppSizes.setHeight(12)),
                              _buildArrowDown(context),
                              SizedBox(height: AppSizes.setHeight(12)),
                              StationSelectorButton(
                                station: currentState.selectedStation,
                                onTap: () => widget.controller.selectStation(context),
                              ),
                              SizedBox(height: AppSizes.setHeight(24)),
                              
                              // Smart Parse Card
                              SmartParseCard(
                                onParse: (text) => widget.controller.onVehicleInfoPasted(text),
                              ),
                              
                              SizedBox(height: AppSizes.setHeight(16)),
                              
                              // Structured Form
                              Form(
                                key: _formKey,
                                child: VehicleInfoForm(
                                  driverNameController: _driverNameController,
                                  plateNumberController: _plateNumberController,
                                  idCardController: _idCardController,
                                  phoneController: _phoneController,
                                  loadCapacityController: _loadCapacityController,
                                  tank1CapacityController: _tank1CapacityController,
                                  tank2CapacityController: _tank2CapacityController,
                                  
                                  vehicleTypeController: _vehicleTypeController,
                                  driverLicenseController: _driverLicenseController,
                                  vehicleLicenseController: _vehicleLicenseController,
                                  tankTypeController: _tankTypeController,
                                  hasPumpController: _hasPumpController,
                                ),
                              ),
                              
                              SizedBox(height: AppSizes.setHeight(20)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: AppSizes.setWidth(16),
                    right: AppSizes.setWidth(16),
                    top: AppSizes.setHeight(12),
                    bottom: AppSizes.setHeight(12) + MediaQuery.of(context).padding.bottom,
                  ),
                  decoration: BoxDecoration(
                    color: CustomAppColor.of(context).bgScaffold,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CommonButton(
                          btnText: '生成提油凭证',
                          height: AppSizes.setHeight(52),
                          fontSize: AppSizes.setFontSize(15),
                          isLoading: currentState.isLoading,
                          onTap: _handleGenerateCertificate,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInventoryInfoCard(BuildContext context, InventoryModel inventory) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.setHeight(16)),
      padding: EdgeInsets.only(
        top: AppSizes.setHeight(16),
        bottom: AppSizes.setHeight(24),
        left: AppSizes.setWidth(16),
        right: AppSizes.setWidth(16),
      ),
      decoration: BoxDecoration(
        color: CustomAppColor.of(context).white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -AppSizes.setWidth(16),
            bottom: -AppSizes.setHeight(16),
            child: Icon(
              Icons.warehouse,
              size: AppSizes.setWidth(144),
              color: CustomAppColor.of(context).txtGrey.withValues(alpha: 0.1),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText(
                          text: inventory.depotName ?? '',
                          fontSize: AppSizes.setFontSize(20),
                          fontWeight: FontWeight.w700,
                          textColor: CustomAppColor.of(context).txtBlack,
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: AppSizes.setHeight(4)),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.setWidth(12),
                      vertical: AppSizes.setHeight(4),
                    ),
                    decoration: BoxDecoration(
                      color: CustomAppColor.of(context).txtBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSizes.setWidth(4)),
                    ),
                    child: CommonText(
                      text: FuelTypeHelper.getDisplayName(inventory.fuelType),
                      fontSize: AppSizes.setFontSize(14),
                      fontWeight: FontWeight.w700,
                      textColor: CustomAppColor.of(context).txtBlue,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.setHeight(16)),
              CommonText(
                text: '当前剩余库存',
                fontSize: AppSizes.setFontSize(14),
                textColor: CustomAppColor.of(context).txtGrey,
                textAlign: TextAlign.left,
              ),
              SizedBox(height: AppSizes.setHeight(4)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CommonText(
                    text: '${(inventory.availableTon ?? 0).toInt()}',
                    fontSize: AppSizes.setFontSize(36),
                    fontWeight: FontWeight.w700,
                    textColor: CustomAppColor.of(context).txtBlack,
                    textAlign: TextAlign.left,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: AppSizes.setWidth(4),
                      bottom: AppSizes.setHeight(4),
                    ),
                    child: CommonText(
                      text: '吨',
                      fontSize: AppSizes.setFontSize(14),
                      fontWeight: FontWeight.w400,
                      textColor: CustomAppColor.of(context).txtGrey,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOilAmountInput(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.setWidth(24)),
      decoration: BoxDecoration(
        color: CustomAppColor.of(context).white,
        borderRadius: BorderRadius.circular(AppSizes.setWidth(12)),
        border: Border.all(
          color: CustomAppColor.of(context).containerBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          CommonText(
            text: '请输入本次提油量',
            fontSize: AppSizes.setFontSize(12),
            textColor: CustomAppColor.of(context).txtGrey,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSizes.setHeight(8)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  controller: _oilAmountController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppSizes.setFontSize(30),
                    fontWeight: FontWeight.w700,
                    color: CustomAppColor.of(context).txtBlack,
                    fontFamily: 'Arial',
                  ),
                  decoration: InputDecoration(
                    hintText: '0.00',
                    hintStyle: TextStyle(
                      fontSize: AppSizes.setFontSize(30),
                      fontWeight: FontWeight.w700,
                      color: CustomAppColor.of(context).txtGrey.withValues(alpha: 0.3),
                      fontFamily: 'Arial',
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (value) => widget.controller.updateOilAmount(value),
                ),
              ),
              SizedBox(width: AppSizes.setWidth(8)),
              CommonText(
                text: '吨',
                fontSize: AppSizes.setFontSize(18),
                fontWeight: FontWeight.w700,
                textColor: CustomAppColor.of(context).txtBlack,
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildArrowDown(BuildContext context) {
    return Center(
      child: Icon(
        Icons.arrow_downward,
        size: AppSizes.setWidth(24),
        color: CustomAppColor.of(context).txtGrey.withValues(alpha: 0.3),
      ),
    );
  }
}
