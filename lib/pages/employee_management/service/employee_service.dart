import 'package:dio/dio.dart';
import 'package:lottery_app/net/net_manager.dart';
import 'package:lottery_app/net/response.dart';
import 'package:lottery_app/pages/employee_management/model/employee_type.dart';
import 'package:retrofit/retrofit.dart';

part 'employee_service.g.dart';

@RestApi()
abstract class EmployeeService {
  factory EmployeeService(Dio dio, {String baseUrl}) = _EmployeeService;

  /// 获取员工列表
  @GET('/employees')
  Future<EmployeeListResponse> getEmployeeList({
    @Query('orderByType') String? orderByType,
    @Query('orderByName') String? orderByName,
    @Query('current') int? current,
    @Query('pageSize') int? pageSize,
    @Query('username') String? username,
    @Query('phone') String? phone,
  });

  /// 创建员工
  @POST('/employees')
  Future<CreateEmployeeResponse> createEmployee(
      @Body() Map<String, dynamic> body);

  /// 获取当前登录员工信息
  @GET('/employees/me')
  Future<CurrentEmployeeResponse> getCurrentEmployee();

  /// 更新员工信息
  @PATCH('/employees/{uuid}')
  Future<CreateEmployeeResponse> updateEmployee(
      @Path('uuid') String uuid, @Body() Map<String, dynamic> body);

  /// 获取单个员工详情
  @GET('/employees/{uuid}')
  Future<EmployeeDetailResponse> getEmployeeDetail(@Path('uuid') String uuid);

  /// 删除员工
  @DELETE('/employees/{uuid}')
  Future<BaseResponse> deleteEmployee(@Path('uuid') String uuid);

  /// 重置员工密码
  @POST('/employees/{uuid}/pwd')
  Future<RestEmployeePasswordResponse> resetEmployeePassword(
      @Path('uuid') String uuid);
}

/// 获取EmployeeService实例，确保网络管理器已初始化
EmployeeService get employeeService {
  if (netManager.clientDio == null) {
    throw Exception('网络管理器未初始化，请稍后重试');
  }
  return EmployeeService(netManager.clientDio!);
}
