import 'parents/model.dart';

class Faq extends Model {
  String id;
  String question;
  String answer;

  Faq({this.id, this.question, this.answer});

  Faq.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    question = transStringFromJson(json, 'question');
    answer = transStringFromJson(json, 'answer');
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['question'] = this.question;
    data['answer'] = this.answer;
    return data;
  }
}
