part of 'navbar_cubit.dart';

enum PageStatus { homePage, mapPage, profilePage }

class NavbarState extends Equatable {
  const NavbarState({
    required this.pageStatus,
  });

  factory NavbarState.initial() {
    return const NavbarState(pageStatus: PageStatus.homePage);
  }

  final PageStatus pageStatus;

  @override
  String toString() => 'NavbarState(pageStatus: $pageStatus)';

  NavbarState copyWith({
    PageStatus? pageStatus,
  }) {
    return NavbarState(
      pageStatus: pageStatus ?? this.pageStatus,
    );
  }

  @override
  List<Object> get props => [pageStatus];
}
