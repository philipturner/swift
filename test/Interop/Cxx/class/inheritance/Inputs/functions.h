template <class From, class To>
To __swift_interopStaticCast(From from) {
  return static_cast<To>(from);
}

struct NonTrivial {
  NonTrivial() {}
  ~NonTrivial() {}

  inline const char *inNonTrivial() const { return "NonTrivial::inNonTrivial"; }
  inline const char *inNonTrivialWithArgs(int a, int b) const {
    return "NonTrivial::inNonTrivialWithArgs";
  }
};

struct Base {
  inline const char *mutatingInBase() { return "Base::mutatingInBase"; }
  inline const char *constInBase() const { return "Base::constInBase"; }
  // TODO: if these are unnamed we hit an (unrelated) SILGen bug. Same for
  // subscripts.
  inline const char *takesArgsInBase(int a, int b, int c) const {
    return "Base::takesArgsInBase";
  }

  inline const char *takesNonTrivialInBase(NonTrivial a) const {
    return "Base::takesNonTrivialInBase";
  }
  inline NonTrivial returnsNonTrivialInBase() const { return NonTrivial{}; }

  template <class T>
  inline const char *templateInBase(T t) const {
    return "Base::templateInBase";
  }

  static const char *staticInBase() { return "Base::staticInBase"; }
};

struct OtherBase {
  inline const char *inOtherBase() const { return "OtherBase::inOtherBase"; }
  // TODO: test private access
};

struct Derived : Base, OtherBase {
  inline const char *inDerived() const { return "Derived::inDerived"; }
};

struct DerivedFromDerived : Derived {
  inline const char *topLevel() const { return "DerivedFromDerived::topLevel"; }
};

struct DerivedFromNonTrivial : NonTrivial {};
