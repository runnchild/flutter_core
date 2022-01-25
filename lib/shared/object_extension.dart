extension ObjectExt<E> on E {
  T map<T>(T Function(E e) block) {
    return block(this);
  }
}
