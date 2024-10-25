import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final String _correctUsername = 'hermawansopian';
  final String _correctPassword = '123';

  void _login() {
    if (_usernameController.text == _correctUsername &&
        _passwordController.text == _correctPassword) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              DashboardPage(username: _usernameController.text),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(' 404 Not Found'),
          content: Text('Masukan Nama dan Password dengan benar'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  final String username;

  DashboardPage({required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$username'),
      ),
      body: Center(
        child: Text('Welcome, $username!'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_a_photo),
            label: 'Photo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(),
              ),
            );
          }
        },
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userId = '12345';
  String userName = 'Your Name';
  String userDescription = 'Your Description';
  String userPhotoUrl = '';

  void updateProfile(
      String id, String name, String description, String photoUrl) {
    setState(() {
      userId = id;
      userName = name;
      userDescription = description;
      userPhotoUrl = photoUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(userId),
        actions: [
          Icon(Icons.menu),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[300],
            backgroundImage:
                userPhotoUrl.isNotEmpty ? NetworkImage(userPhotoUrl) : null,
            child: userPhotoUrl.isEmpty
                ? Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.white,
                  )
                : null,
          ),
          SizedBox(height: 10),
          Text(
            userName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            userDescription,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StatWidget(number: '0', label: 'Posts'),
              SizedBox(width: 30),
              StatWidget(number: '124', label: 'Followers'),
              SizedBox(width: 30),
              StatWidget(number: '166', label: 'Following'),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ActionButton(
                text: 'Edit Profile',
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(
                        id: userId,
                        name: userName,
                        description: userDescription,
                        photoUrl: userPhotoUrl,
                      ),
                    ),
                  );

                  if (result != null) {
                    updateProfile(result['id'], result['name'],
                        result['description'], result['photoUrl']);
                  }
                },
              ),
              SizedBox(width: 10),
              ActionButton(
                text: 'Promotions',
                onPressed: () {},
              ),
              SizedBox(width: 10),
              ActionButton(
                text: 'Insights',
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StatWidget extends StatelessWidget {
  final String number;
  final String label;

  StatWidget({required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          number,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  ActionButton({required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        side: BorderSide(color: Colors.grey),
      ),
      child: Text(text),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  final String id;
  final String name;
  final String description;
  final String photoUrl;

  EditProfilePage(
      {required this.id,
      required this.name,
      required this.description,
      required this.photoUrl});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _idController;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _photoUrlController;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(text: widget.id);
    _nameController = TextEditingController(text: widget.name);
    _descriptionController = TextEditingController(text: widget.description);
    _photoUrlController = TextEditingController(text: widget.photoUrl);
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _photoUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Edit Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Save Changes'),
                    content: Text('Apakah kamu yakin ingin mengubah ini?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('BATAL '),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop({
                            'id': _idController.text,
                            'name': _nameController.text,
                            'description': _descriptionController.text,
                            'photoUrl': _photoUrlController.text,
                          });
                        },
                        child: Text('SIMPAN'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _idController,
              decoration: InputDecoration(labelText: 'ID'),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _photoUrlController,
              decoration: InputDecoration(labelText: 'Photo URL'),
            ),
          ],
        ),
      ),
    );
  }
}
