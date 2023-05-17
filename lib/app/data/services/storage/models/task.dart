import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String title;
  final int icon;
  final String color;
  final List<dynamic>? todos; //클래스의 속성 선언

  const Task(
      {required this.title,
      required this.icon,
      required this.color,
      this.todos}); //생성자 선언

  Task copyWith({
    String? title,
    int? icon,
    String? color,
    List<dynamic>? todos,
  }) =>
      Task(
        title: title ?? this.title,
        icon: icon ?? this.icon,
        color: color ?? this.color,
        todos: todos ?? this.todos,
      );

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        //팩토리 생성자는 Json파싱과 인스턴스 생성 로직을 한 곳에 집중하여 코드를 깔끔하게 유지가능
        title: json['title'],
        icon: json['icon'],
        color: json['color'],
        todos: json['todos'],
      ); //Json의 속성들을 추출하여서 Task클래스의 인스턴스 생성
  Map<String, dynamic> toJson() => {
        'title': title,
        'icon': icon,
        'color': color,
        'todos': todos,
      }; //클래스를 Json형식으로 인코딩하는 매소드

  @override
  List<Object?> get props => [title, icon, color];
}
