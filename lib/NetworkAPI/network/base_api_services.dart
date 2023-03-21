

abstract class BaseApiServices {
  Future<dynamic> getGetApiResponse(String url,bool printLog);
  Future<dynamic> getPostApiResponse( String url, dynamic data,bool printLog);
  Future<dynamic> getFormDataApiResponse(String url,dynamic data,bool printlog);
}
