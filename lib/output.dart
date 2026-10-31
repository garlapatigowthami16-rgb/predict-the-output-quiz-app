
import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const PredictOutputApp());

class PredictOutputApp extends StatelessWidget {
  const PredictOutputApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Predict the Output',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurpleAccent,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF101522),
      ),
      home: const HomePage(),
    );
  }
}

const Map<String, List<String>> topicMap = {
  'C': ['Variables', 'Data Types', 'Operators', 'If-Else', 'Loops', 'Arrays', 'Strings', 'Functions', 'Pointers', 'Recursion'],
  'C++': ['Variables', 'Data Types', 'Operators', 'If-Else', 'Loops', 'Arrays', 'Strings', 'Functions', 'Classes', 'Inheritance'],
  'Java': ['Variables', 'Data Types', 'Operators', 'If-Else', 'Loops', 'Arrays', 'Strings', 'Methods', 'Classes', 'Inheritance'],
  'Python': ['Variables', 'Data Types', 'Operators', 'If-Else', 'Loops', 'Lists', 'Tuples', 'Strings', 'Functions', 'Dictionaries'],
  'HTML': ['Elements', 'Headings', 'Links', 'Images', 'Lists', 'Tables', 'Forms', 'Attributes'],
  'CSS': ['Selectors', 'Colors', 'Box Model', 'Margins', 'Padding', 'Flexbox', 'Grid', 'Positioning'],
  'JavaScript': ['Variables', 'Data Types', 'Operators', 'If-Else', 'Loops', 'Arrays', 'Strings', 'Functions', 'Objects', 'DOM'],
  'HTTP': ['HTTP Methods', 'Status Codes', 'Request', 'Response', 'Headers', 'Cookies', 'HTTPS'],
  'SQL queries': ['SELECT', 'WHERE', 'ORDER BY', 'GROUP BY', 'HAVING', 'INSERT', 'UPDATE', 'DELETE', 'Subqueries', 'Aggregate Functions'],
  'Keys': ['Primary Key', 'Foreign Key', 'Candidate Key', 'Super Key', 'Composite Key', 'Unique Key'],
  'Joins': ['INNER JOIN', 'LEFT JOIN', 'RIGHT JOIN', 'FULL JOIN', 'CROSS JOIN', 'SELF JOIN'],
  'Normalization': ['Functional Dependencies', '1NF', '2NF', '3NF', 'BCNF', 'Decomposition'],
  'ACID': ['Atomicity', 'Consistency', 'Isolation', 'Durability', 'Transactions'],
  'DSA': ['Arrays', 'Linked Lists', 'Stacks', 'Queues', 'Trees', 'Graphs', 'Hashing', 'Searching', 'Sorting', 'Time Complexity'],
  'OS': ['Processes', 'Threads', 'CPU Scheduling', 'Deadlocks', 'Memory Management', 'Paging', 'Virtual Memory', 'File Systems'],
  'Computer Networks': ['OSI Model', 'TCP/IP', 'IP Addressing', 'Routing', 'TCP vs UDP', 'DNS', 'HTTP', 'Subnetting'],
  'OOP': ['Classes', 'Objects', 'Encapsulation', 'Inheritance', 'Polymorphism', 'Abstraction', 'Constructors'],
  'Algorithms': ['BFS', 'DFS', 'Binary Search', 'Linear Search', 'Bubble Sort', 'Merge Sort', 'Quick Sort', 'Greedy Algorithms'],
};

class Question {
  final String id;
  final String subject;
  final String topic;
  final String difficulty;
  final String code;
  final List<String> options;
  final int answer;
  final String explanation;

  const Question({
    required this.id,
    required this.subject,
    required this.topic,
    required this.difficulty,
    required this.code,
    required this.options,
    required this.answer,
    required this.explanation,
  });
}

// History is kept separately for every subject/topic/difficulty.
final Map<String, Set<String>> playedQuestions = {};

final Random randomGenerator = Random();

List<Question> generateQuestions(
  String subject,
  String topic,
  String difficulty,
) {
  final questions = <Question>[];

  // Create a large question pool for C Variables.
  if (subject == 'C' && topic == 'Variables') {
    for (int i = 1; i <= 300; i++) {
      final a = randomGenerator.nextInt(100) + 1;
      final b = randomGenerator.nextInt(50) + 1;
      final operation = i % 8;

      late String code;
      late int result;
      late String explanation;

      switch (operation) {
        case 0:
          code = 'int x = $a;\nprintf("%d", x);';
          result = a;
          explanation = 'x is initialized to $a, so the output is $a.';
          break;
        case 1:
          code = 'int x = $a;\nx = x + $b;\nprintf("%d", x);';
          result = a + b;
          explanation = '$a + $b equals ${a + b}.';
          break;
        case 2:
          code = 'int x = $a;\nx = x - $b;\nprintf("%d", x);';
          result = a - b;
          explanation = '$a - $b equals ${a - b}.';
          break;
        case 3:
          code = 'int a = $a, b = $b;\nprintf("%d", a * b);';
          result = a * b;
          explanation = '$a multiplied by $b equals ${a * b}.';
          break;
        case 4:
          code = 'int x = $a;\nx++;\nprintf("%d", x);';
          result = a + 1;
          explanation = 'x++ increments $a to ${a + 1}.';
          break;
        case 5:
          code = 'int x = $a;\nx--;\nprintf("%d", x);';
          result = a - 1;
          explanation = 'x-- decrements $a to ${a - 1}.';
          break;
        case 6:
          code = 'int x = $a;\nint y = x;\nprintf("%d", y);';
          result = a;
          explanation = 'The value of x is copied into y.';
          break;
        default:
          code = 'int x = $a;\nprintf("%d", x % $b);';
          result = a % b;
          explanation = '$a modulo $b gives remainder $result.';
      }

      final optionSet = <int>{
        result,
        result + 1,
        result - 1,
        result + 2,
      }.toList()
        ..shuffle(randomGenerator);

      questions.add(Question(
        id: 'C_Variables_$i',
        subject: subject,
        topic: topic,
        difficulty: difficulty,
        code: code,
        options: optionSet.map((v) => v.toString()).toList(),
        answer: optionSet.indexOf(result),
        explanation: explanation,
      ));
    }

    return questions;
  }

  // Starter question templates for other topics.
  // Add curated, topic-specific questions here to improve coverage.
  final data = _topicData(topic);

  for (int i = 0; i < 60; i++) {
    final index = i % data.$1.length;
    final correct = data.$2[index];

    final options = <String>[
      correct,
      'None of the above',
      'Always causes an error',
      'Has no effect',
    ]..shuffle(randomGenerator);

    questions.add(Question(
      id: '${subject}_${topic}_${difficulty}_$i',
      subject: subject,
      topic: topic,
      difficulty: difficulty,
      code: '${data.$1[index]}\n\n'
          'Subject: $subject\n'
          'Topic: $topic\n'
          'Difficulty: $difficulty',
      options: options,
      answer: options.indexOf(correct),
      explanation: 'Correct answer: $correct. '
          'This is related to $topic in $subject.',
    ));
  }

  return questions;
}

(List<String>, List<String>) _topicData(String topic) {
  const data = <String, List<List<String>>>{
    'Variables': [
      ['What is a variable used for?', 'What assigns a value to a variable?', 'Why use variable names?'],
      ['Store values', 'Assignment', 'Refer to stored data'],
    ],
    'Data Types': [
      ['What does a data type specify?', 'Which C type stores whole numbers?', 'Why choose a suitable data type?'],
      ['The kind of value', 'int', 'To represent values correctly'],
    ],
    'Operators': [
      ['Which operator performs addition?', 'Which operator checks equality in C?', 'What does % calculate for integers?'],
      ['+', '==', 'The remainder'],
    ],
    'If-Else': [
      ['When does an else branch run?', 'What does an if statement do?', 'What determines which branch runs?'],
      ['When the if condition is false', 'Executes code conditionally', 'The condition result'],
    ],
    'Loops': [
      ['What is a loop used for?', 'Which loop checks its condition before its body?', 'What can cause an infinite loop?'],
      ['Repeat instructions', 'while loop', 'A condition that never becomes false'],
    ],
    'Arrays': [
      ['What does an array store in C?', 'What is an array index used for?', 'What is the first C array index?'],
      ['Elements of the same type', 'Select an element', '0'],
    ],
    'Strings': [
      ['What does a string represent?', 'What terminates a C string?', 'What does concatenation do?'],
      ['Text', 'The null character \\0', 'Combines strings'],
    ],
    'Functions': [
      ['Why use a function?', 'What does return do?', 'What is a benefit of functions?'],
      ['Reuse code', 'Returns a value or ends a function', 'Code reuse'],
    ],
    'Pointers': [
      ['What does a pointer store?', 'What does & obtain in C?', 'What does * do when dereferencing a pointer?'],
      ['A memory address', 'A variable address', 'Accesses the value at an address'],
    ],
    'Recursion': [
      ['What is recursion?', 'Why is a base case needed?', 'What if recursion never stops?'],
      ['A function calling itself', 'To stop recursive calls', 'It may cause stack overflow'],
    ],
    'SELECT': [
      ['Which SQL command retrieves rows?', 'Which part specifies columns to retrieve?', 'Which SQL command reads table data?'],
      ['SELECT', 'The SELECT list', 'SELECT'],
    ],
    'WHERE': [
      ['What does WHERE do?', 'Which clause filters rows?', 'Why use WHERE in SQL?'],
      ['Filters rows', 'WHERE', 'Select rows matching a condition'],
    ],
    'INNER JOIN': [
      ['What does INNER JOIN return?', 'Which join returns matching rows?', 'Why use a join condition?'],
      ['Rows matching in both tables', 'INNER JOIN', 'Match related rows'],
    ],
    'Primary Key': [
      ['What does a primary key identify?', 'Can a primary key have duplicate values?', 'Which properties apply to a primary key?'],
      ['A row uniquely', 'No', 'Unique and not NULL'],
    ],
    '1NF': [
      ['What is a basic 1NF requirement?', 'What should each field contain in 1NF?', 'Which normal form requires atomic values?'],
      ['Atomic attribute values', 'A single value', 'First Normal Form'],
    ],
    'Atomicity': [
      ['What does atomicity mean?', 'What happens if an atomic transaction fails?', 'Which ACID property means all-or-nothing?'],
      ['All-or-nothing execution', 'The transaction is rolled back', 'Atomicity'],
    ],
    'Processes': [
      ['What is a process?', 'What does an operating system manage?', 'How does a process differ from a program?'],
      ['A program in execution', 'Processes and resources', 'A process is a running instance'],
    ],
    'OSI Model': [
      ['How many OSI layers are there?', 'Which OSI layer handles routing?', 'Which OSI layer provides end-to-end transport?'],
      ['7', 'Network layer', 'Transport layer'],
    ],
    'BFS': [
      ['Which data structure is commonly used by BFS?', 'How does BFS explore a graph?', 'Which algorithm finds shortest paths in unweighted graphs?'],
      ['Queue', 'Level by level', 'Breadth-First Search'],
    ],
    'Classes': [
      ['What is a class in OOP?', 'What can an object contain?', 'What is an object an instance of?'],
      ['A blueprint for objects', 'Fields and methods', 'A class'],
    ],
  };

  if (data.containsKey(topic)) {
    return (data[topic]![0], data[topic]![1]);
  }

  return (
    [
      'What is the purpose of $topic?',
      'Which statement best describes $topic?',
      'Why is $topic useful in computer science?',
    ],
    [
      'It performs its intended role',
      'It is a computer science concept',
      'It helps solve relevant problems',
    ],
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String subject = 'C';
  String topic = 'Variables';
  String difficulty = 'Easy';

  Widget dropdown(
    String label,
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF1D2638),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          items: items.map((v) => DropdownMenuItem(
            value: v,
            child: Text(v),
          )).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  void startQuiz() {
    final key = '$subject|$topic|$difficulty';
    final allQuestions = generateQuestions(subject, topic, difficulty);
    final played = playedQuestions.putIfAbsent(key, () => <String>{});

    var available = allQuestions
        .where((q) => !played.contains(q.id))
        .toList();

    // Reset this selection's history only after all its questions were used.
    if (available.length < 15) {
      played.clear();
      available = List<Question>.from(allQuestions);
    }

    available.shuffle(Random());
    final selectedQuestions = available.take(15).toList();

    played.addAll(selectedQuestions.map((q) => q.id));

    Navigator.push(context, MaterialPageRoute(
      builder: (_) => QuizPage(
        questions: selectedQuestions,
        subject: subject,
        topic: topic,
        difficulty: difficulty,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Predict the Output'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.code_rounded,
                    size: 72, color: Colors.deepPurpleAccent),
                const SizedBox(height: 14),
                const Text(
                  'Test Your Coding Skills',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 28),
                dropdown('Subject', subject, topicMap.keys.toList(), (value) {
                  if (value == null) return;
                  setState(() {
                    subject = value;
                    topic = topicMap[value]!.first;
                  });
                }),
                const SizedBox(height: 18),
                dropdown('Topic', topic, topicMap[subject]!, (value) {
                  if (value != null) setState(() => topic = value);
                }),
                const SizedBox(height: 18),
                dropdown('Difficulty', difficulty,
                    const ['Easy', 'Medium', 'Hard'], (value) {
                  if (value != null) setState(() => difficulty = value);
                }),
                const SizedBox(height: 28),
                ElevatedButton.icon(
                  onPressed: startQuiz,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start 15-Question Quiz'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 17),
                    backgroundColor: Colors.deepPurpleAccent,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  final List<Question> questions;
  final String subject, topic, difficulty;

  const QuizPage({
    super.key,
    required this.questions,
    required this.subject,
    required this.topic,
    required this.difficulty,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int index = 0;
  int score = 0;
  int? selected;
  bool answered = false;

  Question get q => widget.questions[index];

  void choose(int i) {
    if (answered) return;
    setState(() {
      selected = i;
      answered = true;
      if (i == q.answer) score++;
    });
  }

  void next() {
    if (index < widget.questions.length - 1) {
      setState(() {
        index++;
        selected = null;
        answered = false;
      });
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (_) => ResultPage(
          score: score,
          total: widget.questions.length,
          subject: widget.subject,
          topic: widget.topic,
          difficulty: widget.difficulty,
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.subject} • ${widget.topic}')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('${widget.difficulty} • Question ${index + 1} of 15'),
              const SizedBox(height: 10),
              LinearProgressIndicator(value: (index + 1) / 15, minHeight: 7),
              const SizedBox(height: 24),
              const Text(
                'Predict the output / answer the question:',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF080C14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: SelectableText(
                  q.code,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 16,
                    height: 1.6,
                    color: Color(0xFF9DE7B0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ...List.generate(q.options.length, (i) {
                Color color = const Color(0xFF1D2638);
                if (answered && i == q.answer) color = Colors.green.shade800;
                if (answered && i == selected && i != q.answer) {
                  color = Colors.red.shade800;
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: () => choose(i),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 15,
                            child: Text(String.fromCharCode(65 + i)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: Text(q.options[i])),
                          if (answered && i == q.answer)
                            const Icon(Icons.check_circle, color: Colors.white),
                          if (answered && i == selected && i != q.answer)
                            const Icon(Icons.cancel, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              if (answered) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1D2638),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selected == q.answer
                            ? 'Correct answer!'
                            : 'Correct answer: ${q.options[q.answer]}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(q.explanation),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: next,
                  child: Text(index == 14 ? 'See Results' : 'Next Question'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class ResultPage extends StatelessWidget {
  final int score, total;
  final String subject, topic, difficulty;

  const ResultPage({
    super.key,
    required this.score,
    required this.total,
    required this.subject,
    required this.topic,
    required this.difficulty,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (score * 100 / total).round();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_events, size: 90, color: Colors.amber),
              const SizedBox(height: 20),
              const Text(
                'Quiz Completed!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text('$subject • $topic • $difficulty'),
              const SizedBox(height: 24),
              Text(
                '$score / $total',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('$percent% correct',
                  style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Choose Another Quiz'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}