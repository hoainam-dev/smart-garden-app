import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';

class ChatGPT extends StatefulWidget {
  const ChatGPT({Key? key, required this.symptom}) : super(key: key);
  final String symptom;

  @override
  State<ChatGPT> createState() => _ChatGPTState();
}

class Chat {
  String text;
  bool amSender;
  Chat(this.text, this.amSender);
}

class _ChatGPTState extends State<ChatGPT> {
  String key = "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";
  late OpenAI openAI;

  final List<Chat> _conversation = [];
  final TextEditingController _controller = TextEditingController();

  bool hasSymptom = false;

  @override
  void initState() {
    super.initState();
    openAI = OpenAI.instance.build(token: key);
    if (widget.symptom.isNotEmpty) {
      hasSymptom = true;
      getInitialResponse(widget.symptom);
      // Call the function to get initial response using the symptom here
      // Example: getInitialResponse(widget.symptom);
    }
  }
// Function to get initial response using the symptom
  Future<void> getInitialResponse(String symptom) async {
    try {
      if (symptom.toLowerCase() == 'healthy') {
        // If the symptom is 'Healthy'
        String response = "Cây của bạn đang phát triển khỏe mạnh, hãy chăm sóc chúng thật tốt nhé. Chúc bạn thành công và bội thu !!!";
        setState(() {
          _conversation.add(Chat(response, false));
        });
      } else {
        // For other cases
        String prompt = "How to handle diseases when $symptom appear on plant leaves?";
        var resp = await openAI.onCompletion(
            request: CompleteText(prompt: prompt, model: Model.textBabbage001));
        if (resp != null && resp.choices.isNotEmpty) {
          setState(() {
            if (resp.choices.first != null) {
              _conversation.add(Chat(resp.choices.first.text, false)); // Use 'first' instead of 'last'
            }
          });
        }
      }
    } catch (e) {
      // Handle exceptions appropriately
      print('Error occurred: $e');
    }
  }

  Future<void> send() async {
    var text = _controller.text;
    print(text.toString());
    if (text.trim().isEmpty) {
      return;
    }

    setState(() {
      _conversation.add(Chat(text, true));
      print(_conversation.last.text);
    });
    _controller.clear();

    try {
      var resp = await openAI.onCompletion(
          request: CompleteText(prompt: text, model: Model.textBabbage001));
      if (resp != null && resp.choices.isNotEmpty) {
        setState(() {
          if (resp.choices.first != null) {
            _conversation.add(Chat(resp.choices.first.text, false)); // Use 'first' instead of 'last'
          }
        });
      }
    } catch (e) {
      // Handle exceptions appropriately
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(15),
            itemCount: _conversation.length,
            itemBuilder: (context, index) {
              var convo = _conversation[index];
              return Wrap(
                alignment: convo.amSender ? WrapAlignment.end : WrapAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: convo.amSender ? null : Theme.of(context).primaryColorLight,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(convo.text),
                  ),
                ],
              );
            },
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                scrollPhysics: ClampingScrollPhysics(),
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Type here ....",
                ),
              ),
            ),
            IconButton(onPressed: send, icon: Icon(Icons.send)),
          ],
        ),
      ],
    );
  }

}