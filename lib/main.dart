import 'package:flutter/material.dart';

void main() {
  runApp(const CollegeApp());
}

class CollegeApp extends StatefulWidget {
  const CollegeApp({super.key});

  @override
  State<CollegeApp> createState() => _CollegeAppState();
}

class _CollegeAppState extends State<CollegeApp> {
  bool _isDarkMode = false;

  void _toggleTheme(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'College Notes',
      theme: _isDarkMode
          ? ThemeData.dark().copyWith(
        primaryColor: Colors.deepPurple,
        colorScheme: ColorScheme.dark(
          primary: Colors.deepPurple,
          secondary: Colors.tealAccent,
        ),
        cardTheme: CardThemeData(
          color: Colors.grey[400],
          elevation: 4,
          margin: const EdgeInsets.all(8),
        ),
      )
          : ThemeData.light().copyWith(
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.light(
          primary: Colors.blue,
          secondary: Colors.green,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 4,
          margin: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: MainScreen(toggleTheme: _toggleTheme, isDarkMode: _isDarkMode),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  final Function(bool) toggleTheme;
  final bool isDarkMode;

  const MainScreen({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Map<String, dynamic>> _bookmarks = [];
  final List<Map<String, dynamic>> _notes = [];
  final List<Map<String, dynamic>> _opportunities = [];

  @override
  void initState() {
    super.initState();
    // Sample data
    _notes.addAll([
      {'id': '1', 'title': 'Data Structures', 'subject': 'Computer Science', 'isBookmarked': false},
      {'id': '2', 'title': 'Calculus', 'subject': 'Mathematics', 'isBookmarked': false},
    ]);
    _opportunities.addAll([
      {'id': '101', 'title': 'Summer Internship', 'company': 'Tech Corp', 'isBookmarked': false},
      {'id': '102', 'title': 'Research Assistant', 'company': 'University', 'isBookmarked': false},
    ]);
  }

  void _toggleBookmark(Map<String, dynamic> item) {
    setState(() {
      item['isBookmarked'] = !(item['isBookmarked'] ?? false);
      if (item['isBookmarked']) {
        _bookmarks.add(item);
      } else {
        _bookmarks.removeWhere((element) => element['id'] == item['id']);
      }
    });
  }

  void _addNote(String title, String subject) {
    setState(() {
      _notes.add({
        'id': DateTime.now().toString(),
        'title': title,
        'subject': subject,
        'isBookmarked': false
      });
    });
  }

  void _addOpportunity(String title, String company) {
    setState(() {
      _opportunities.add({
        'id': DateTime.now().toString(),
        'title': title,
        'company': company,
        'isBookmarked': false
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(notes: _notes, opportunities: _opportunities, toggleBookmark: _toggleBookmark),
      NotesScreen(notes: _notes, toggleBookmark: _toggleBookmark, addNote: _addNote),
      OpportunitiesScreen(opportunities: _opportunities, toggleBookmark: _toggleBookmark, addOpportunity: _addOpportunity),
      ProfileScreen(bookmarks: _bookmarks, toggleTheme: widget.toggleTheme, isDarkMode: widget.isDarkMode),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Colors.white.withOpacity(0.7),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.note), label: 'Notes'),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Opportunities'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> notes;
  final List<Map<String, dynamic>> opportunities;
  final Function(Map<String, dynamic>) toggleBookmark;

  const HomeScreen({
    super.key,
    required this.notes,
    required this.opportunities,
    required this.toggleBookmark,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('College Hub'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: SimpleSearchDelegate(notes: notes, opportunities: opportunities),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome!', style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  )),
                  SizedBox(height: 8),
                  Text('Find notes and opportunities', style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  )),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('Recent Notes', style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            )),
          ),
          ...notes.take(2).map((note) => NoteCard(
            note: note,
            toggleBookmark: toggleBookmark,
          )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('Latest Opportunities', style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            )),
          ),
          ...opportunities.take(2).map((opp) => OpportunityCard(
            opportunity: opp,
            toggleBookmark: toggleBookmark,
          )),
        ],
      ),
    );
  }
}

class SimpleSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> notes;
  final List<Map<String, dynamic>> opportunities;

  SimpleSearchDelegate({required this.notes, required this.opportunities});

  @override
  List<Widget> buildActions(BuildContext context) => [
    IconButton(
      icon: const Icon(Icons.clear),
      onPressed: () => query = '',
    ),
  ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, null),
  );

  @override
  Widget buildResults(BuildContext context) {
    final noteResults = notes.where((note) =>
        note['title'].toLowerCase().contains(query.toLowerCase())).toList();
    final oppResults = opportunities.where((opp) =>
        opp['title'].toLowerCase().contains(query.toLowerCase())).toList();

    return ListView(
      children: [
        if (noteResults.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Notes', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ...noteResults.map((note) => ListTile(
            title: Text(note['title']),
            subtitle: Text(note['subject']),
          )),
        ],
        if (oppResults.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Opportunities', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ...oppResults.map((opp) => ListTile(
            title: Text(opp['title']),
            subtitle: Text(opp['company']),
          )),
        ],
        if (noteResults.isEmpty && oppResults.isEmpty)
          const Center(child: Text('No results found')),
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final allItems = [...notes, ...opportunities];
    final suggestions = query.isEmpty
        ? []
        : allItems.where((item) =>
        item['title'].toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(suggestions[index]['title']),
        subtitle: Text(suggestions[index]['subject'] ?? suggestions[index]['company']),
        onTap: () {
          query = suggestions[index]['title'];
          showResults(context);
        },
      ),
    );
  }
}

class NotesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> notes;
  final Function(Map<String, dynamic>) toggleBookmark;
  final Function(String, String) addNote;

  const NotesScreen({
    super.key,
    required this.notes,
    required this.toggleBookmark,
    required this.addNote,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        children: [
          ...notes.map((note) => NoteCard(
            note: note,
            toggleBookmark: toggleBookmark,
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showAddNoteDialog(context),
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context) {
    final titleController = TextEditingController();
    final subjectController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: subjectController,
              decoration: const InputDecoration(labelText: 'Subject'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              addNote(titleController.text, subjectController.text);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Note added')),
              );
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class NoteCard extends StatelessWidget {
  final Map<String, dynamic> note;
  final Function(Map<String, dynamic>) toggleBookmark;

  const NoteCard({
    super.key,
    required this.note,
    required this.toggleBookmark,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(note['title'], style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        )),
        subtitle: Text(note['subject'], style: TextStyle(
          color: Colors.grey[600],
        )),
        trailing: IconButton(
          icon: Icon(
            note['isBookmarked'] ? Icons.bookmark : Icons.bookmark_border,
            color: note['isBookmarked'] ? Colors.amber : Colors.grey,
          ),
          onPressed: () => toggleBookmark(note),
        ),
      ),
    );
  }
}

class OpportunitiesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> opportunities;
  final Function(Map<String, dynamic>) toggleBookmark;
  final Function(String, String) addOpportunity;

  const OpportunitiesScreen({
    super.key,
    required this.opportunities,
    required this.toggleBookmark,
    required this.addOpportunity,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Opportunities'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        children: [
          ...opportunities.map((opp) => OpportunityCard(
            opportunity: opp,
            toggleBookmark: toggleBookmark,
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showAddOpportunityDialog(context),
      ),
    );
  }

  void _showAddOpportunityDialog(BuildContext context) {
    final titleController = TextEditingController();
    final companyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Opportunity'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: companyController,
              decoration: const InputDecoration(labelText: 'Company'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              addOpportunity(titleController.text, companyController.text);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opportunity added')),
              );
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class OpportunityCard extends StatelessWidget {
  final Map<String, dynamic> opportunity;
  final Function(Map<String, dynamic>) toggleBookmark;

  const OpportunityCard({
    super.key,
    required this.opportunity,
    required this.toggleBookmark,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(opportunity['title'], style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.green[700],
        )),
        subtitle: Text(opportunity['company'], style: TextStyle(
          color: Colors.grey[600],
        )),
        trailing: IconButton(
          icon: Icon(
            opportunity['isBookmarked'] ? Icons.bookmark : Icons.bookmark_border,
            color: opportunity['isBookmarked'] ? Colors.amber : Colors.grey,
          ),
          onPressed: () => toggleBookmark(opportunity),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final List<Map<String, dynamic>> bookmarks;
  final Function(bool) toggleTheme;
  final bool isDarkMode;

  const ProfileScreen({
    super.key,
    required this.bookmarks,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: SwitchListTile(
              title: Text('Dark Mode', style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              )),
              value: isDarkMode,
              onChanged: toggleTheme,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Your Bookmarks', style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            )),
          ),
          if (bookmarks.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text('No bookmarks yet', style: TextStyle(
                color: Colors.grey,
              )),
            ),
          ...bookmarks.map((item) => Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(item['title'], style: TextStyle(
                fontWeight: FontWeight.bold,
              )),
              subtitle: Text(item['subject'] ?? item['company'], style: TextStyle(
                color: Colors.grey[600],
              )),
            ),
          )),
        ],
      ),
    );
  }
}