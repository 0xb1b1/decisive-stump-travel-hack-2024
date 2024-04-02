abstract class ViewModelHooks<ViewState> {
  void dispose();

  void init();

  ViewState get state;
}
