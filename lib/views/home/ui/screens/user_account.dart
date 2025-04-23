import 'package:flutter/material.dart';
import 'package:gradprj/core/theming/my_colors.dart';

class ProfilePage extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onToggleTheme;

  const ProfilePage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool showEditFields = false;

  final TextEditingController nameController = TextEditingController(
    text: "Jonathan Patterson",
  );
  final TextEditingController emailController = TextEditingController(
    text: "hello@reallygreatsite.com",
  );
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), leading: const BackButton()),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Stack(
              children: [
                const CircleAvatar(
                  radius: 40,
                backgroundColor: MyColors.button1Color,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      // هنا ممكن تفتحي Dialog لاختيار صورة
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Change profile picture')),
                      );
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.edit,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              nameController.text,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(emailController.text),
            const SizedBox(height: 20),

            /// Edit Profile section
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.green),
              title: const Text('Edit Profile'),
              trailing: Icon(
                showEditFields
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
              ),
              onTap: () {
                setState(() {
                  showEditFields = !showEditFields;
                });
              },
            ),
            if (showEditFields) ...[
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // هنا ممكن تحفظ التعديلات
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile updated')),
                  );
                  setState(() {});
                },
                child: const Text("Save Changes"),
              ),
            ],

            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Mode'),
              subtitle: const Text('Dark & Light'),
              trailing: Switch(
                value: widget.isDarkMode,
                onChanged: widget.onToggleTheme,
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.help, color: Colors.purple),
              title: const Text('About'),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),

            const Spacer(),
            Center(
              child: TextButton.icon(
                onPressed: () {
                  // Sign out action
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Signed out')));
                },
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  'Sign Out',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
