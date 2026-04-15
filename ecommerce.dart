import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

const List<Map<String, dynamic>> categories = [
  {
    'title': 'Electronics',
    'icon': Icons.electrical_services,
    'color': Colors.blueAccent,
  },
  {
    'title': 'Fashion',
    'icon': Icons.checkroom,
    'color': Colors.pinkAccent,
  },
  {
    'title': 'Home',
    'icon': Icons.chair,
    'color': Colors.green,
  },
  {
    'title': 'Books',
    'icon': Icons.book,
    'color': Colors.orange,
  },
  {
    'title': 'Sports',
    'icon': Icons.sports_soccer,
    'color': Colors.purple,
  },
];

// Sample items for each category
final Map<String, List<Map<String, dynamic>>> categoryItems = {
  'Electronics': [
    {'name': 'Smartphone', 'icon': Icons.phone_android, 'price': '\$699'},
    {'name': 'Laptop', 'icon': Icons.laptop, 'price': '\$1299'},
    {'name': 'Headphones', 'icon': Icons.headset, 'price': '\$199'},
    {'name': 'Camera', 'icon': Icons.photo_camera, 'price': '\$899'},
  ],
  'Fashion': [
    {'name': 'T-Shirt', 'icon': Icons.emoji_people, 'price': '\$25'},
    {'name': 'Jeans', 'icon': Icons.checkroom, 'price': '\$50'},
    {'name': 'Sneakers', 'icon': Icons.hiking, 'price': '\$80'},
    {'name': 'Watch', 'icon': Icons.watch, 'price': '\$120'},
  ],
  'Home': [
    {'name': 'Sofa', 'icon': Icons.weekend, 'price': '\$499'},
    {'name': 'Lamp', 'icon': Icons.light, 'price': '\$60'},
    {'name': 'Table', 'icon': Icons.table_bar, 'price': '\$150'},
    {'name': 'Curtains', 'icon': Icons.window, 'price': '\$70'},
  ],
  'Books': [
    {'name': 'Novel', 'icon': Icons.menu_book, 'price': '\$15'},
    {'name': 'Biography', 'icon': Icons.bookmark, 'price': '\$20'},
    {'name': 'Science', 'icon': Icons.science, 'price': '\$30'},
    {'name': 'Comics', 'icon': Icons.auto_stories, 'price': '\$10'},
  ],
  'Sports': [
    {'name': 'Football', 'icon': Icons.sports_football, 'price': '\$40'},
    {'name': 'Cricket Bat', 'icon': Icons.sports_cricket, 'price': '\$70'},
    {'name': 'Tennis Racket', 'icon': Icons.sports_tennis, 'price': '\$90'},
    {'name': 'Basketball', 'icon': Icons.sports_basketball, 'price': '\$50'},
  ],
};

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Commerce'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
            tooltip: 'Cart',
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
            tooltip: 'Profile',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          children: List.generate(categories.length, (index) {
            final category = categories[index];
            return CategoryCard(
              title: category['title'],
              icon: category['icon'],
              color: category['color'],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategoryPage(
                      categoryName: category['title'],
                      color: category['color'],
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 48),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryPage extends StatelessWidget {
  final String categoryName;
  final Color color;

  const CategoryPage({
    super.key,
    required this.categoryName,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final items = categoryItems[categoryName] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        backgroundColor: color,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            child: ListTile(
              leading: Icon(item['icon'], size: 32, color: color),
              title: Text(item['name']),
              subtitle: Text(item['price']),
              trailing: Icon(Icons.add_shopping_cart, color: color),
            ),
          );
        },
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: const Center(
        child: Text(
          'Your cart is empty!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: const Center(
        child: Text(
          'User Profile',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}