import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      home: const MyHomePage(title: 'Add item to the ToDo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _texts = [];
  // ignore: prefer_typing_uninitialized_variables
  var _hoveredIndex;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleButtonClick() {
    setState(() {
      if (_controller.text.isNotEmpty) {
        _texts.insert(
            0, _controller.text); // Add new text to the beginning of the list
        _controller.clear(); // Clear the text field after submitting
      }
    });
  }

  void _handleTextClick(int index) {
    setState(() {
      _controller.text = _texts[index];
      _texts.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter ToDo item',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _handleButtonClick,
              child: const Text('Add item'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _texts.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      _handleTextClick(index);
                    }, // You can add functionality for a tap if needed
                    onHover: (isHovered) {
                      setState(() {
                        _hoveredIndex = isHovered ? index : -1;
                      });
                    },
                    child: Container(
                      color: _hoveredIndex == index
                          ? Colors.grey[300]
                          : Colors.transparent,
                      child: ListTile(
                        title: Text(_texts[index]),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
