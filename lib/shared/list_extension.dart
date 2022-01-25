extension IterableExt<E> on Iterable<E> {
  Iterable<T> mapIndex<T>(T Function(E e, int) toElement) {
    var index = 0;
    return map((e) {
      return toElement(e, index++);
    });
  }

  eachIndex(Function(E, int) func) {
    var index = 0;
    for (var e in this) {
      func(e, index);
      index++;
    }
  }

  List<E> filter(bool Function(E e) block) {
    var list = <E>[];
    forEach((e) {
      if (block(e)) {
        list.add(e);
      }
    });
    return list;
  }

  List<T> filterMap<T>(T? Function(E e) block) {
    var list = <T>[];
    forEach((e) {
      var t = block(e);
      if (t != null) {
        list.add(t);
      }
    });
    return list;
  }

  E? get firstOrNull {
    try {
      return first;
    } catch (e) {
      return null;
    }
  }


  E? get lastOrNull {
    try {
      return last;
    } catch (e) {
      return null;
    }
  }
}

extension ListExt on List {
  swap(int pre, item, [int after = -1]) {
    if (after == -1) {
      after = length - 1;
    }
    removeAt(pre);
    insert(after, item);
  }
}