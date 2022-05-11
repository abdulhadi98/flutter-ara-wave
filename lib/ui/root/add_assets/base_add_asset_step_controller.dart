import 'package:rxdart/rxdart.dart';

abstract class BaseAddAssetStepController {
  final BehaviorSubject<bool> _validationController = BehaviorSubject.seeded(false);
  get validationStream => _validationController.stream;
  bool getValidationState() => _validationController.value;
  setValidationState(bool type) => _validationController.sink.add(type);

  final BehaviorSubject<bool> _loadingController = BehaviorSubject.seeded(false);
  get loadingStream => _loadingController.stream;
  bool getLoadingState() => _loadingController.value;
  setLoadingState(bool state) => _loadingController.sink.add(state);

  bool validateInputs();

  updateValidationState() {
    bool isValid = validateInputs();
    setValidationState(isValid);
  }

  /// This the method you must use to dispose streams and controller
  /// after finish using it.
  disposeParent() {
    _validationController.close();
    _loadingController.close();
    dispose();
  }

  dispose();
}