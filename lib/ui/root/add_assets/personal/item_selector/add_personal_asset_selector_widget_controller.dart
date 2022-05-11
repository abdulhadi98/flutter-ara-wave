import 'package:rxdart/rxdart.dart';

class AddPersonalAssetSelectorWidgetController<T> {
  static const String LOG_TAG = 'AddPersonalAssetSelectorWidgetController';

  final _selectedItemController = BehaviorSubject<T?>();
  get selectedItemStream => _selectedItemController.stream;
  T? getSelectedItem() => _selectedItemController.value;
  setSelectedItem(T? item) => _selectedItemController.sink.add(item);

  final BehaviorSubject<bool> _validationController = BehaviorSubject.seeded(false);
  get validationStream => _validationController.stream;
  bool getValidationState() => _validationController.value;
  setValidationState(bool state) => _validationController.sink.add(state);

  onGridItemClicked(T item) {
    setSelectedItem(item);
    _validateInputs();
  }

  _validateInputs() {
    bool isValid = _validateTypeSelection();
    setValidationState(isValid);
  }

  _validateTypeSelection() {
    return getSelectedItem()!=null;
  }

  dispose() {
    _selectedItemController.close();
    _validationController.close();
  }
}