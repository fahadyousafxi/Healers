import 'package:get/get.dart';

import '../models/e_service_model.dart';
import '../models/option_group_model.dart';
import '../models/option_model.dart';
import '../models/review_model.dart';
import '../providers/laravel_provider.dart';

class EServiceRepository {
  LaravelApiClient _laravelApiClient;

  EServiceRepository() {
    this._laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future<List<EService>> search(String keywords, List<String> categories, {int page = 1}) {
    return _laravelApiClient.searchEServices(keywords, categories, page);
  }

  Future<EService> get(String id) {
    return _laravelApiClient.getEService(id);
  }

  Future<EService> create(EService eService) {
    return _laravelApiClient.createEService(eService);
  }

  Future<EService> update(EService eService) {
    return _laravelApiClient.updateEService(eService);
  }

  Future<bool> delete(String eServiceId) {
    return _laravelApiClient.deleteEService(eServiceId);
  }

  Future<List<Review>> getReviews(String eServiceId) {
    return _laravelApiClient.getEServiceReviews(eServiceId);
  }

  Future<List<OptionGroup>> getOptionGroups(String eServiceId) {
    return _laravelApiClient.getEServiceOptionGroups(eServiceId);
  }

  Future<List<OptionGroup>> getAllOptionGroups() {
    return _laravelApiClient.getOptionGroups();
  }

  Future<Option> createOption(Option option) {
    return _laravelApiClient.createOption(option);
  }

  Future<Option> updateOption(Option option) {
    return _laravelApiClient.updateOption(option);
  }

  Future<bool> deleteOption(String optionId) {
    return _laravelApiClient.deleteOption(optionId);
  }
}
