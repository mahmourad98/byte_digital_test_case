class Node<T> {
  T value;
  Node(this.value);

  factory Node.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) converter,) {
    return Node<T>(converter(Map.of(json['node']).cast<String, dynamic>()));
  }
}