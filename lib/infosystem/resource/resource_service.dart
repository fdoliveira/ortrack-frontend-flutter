
const _BACKEND_URL =
    'https://ortrack.backend.homolog.objetorelacional.com.br/';

class ResourceService {

  String _resourceName;
  String _resourcesName;

  ResourceService(String resourceName, String resourcesName) {
    this._resourceName = resourceName;
    this._resourcesName = resourcesName;
  }

  String get resourceName {
    return this._resourceName;
  }

  String get resourcesName {
    return this._resourcesName;
  }

  String getURL() {
    return _BACKEND_URL + this._resourcesName;
  }
}