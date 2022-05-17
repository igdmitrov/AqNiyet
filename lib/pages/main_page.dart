import 'package:aqniyet/model/category.dart';
import 'package:aqniyet/pages/add_page.dart';
import 'package:aqniyet/services/app_service.dart';
import 'package:aqniyet/utils/constants.dart';
import 'package:aqniyet/widgets/greeting.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  static String routeName = '/main';
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AqNiyet'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed(AddPage.routeName),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            AppBar(title: Greeting(dateTime: DateTime.now())),
            const Divider(),
            if (isAuthenticated())
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: Text('Log off (${getCurrentUserEmail()})'),
                onTap: () {
                  setState(() {
                    supabase.auth.signOut();
                  });
                },
              ),
          ],
        ),
      ),
      body: FutureBuilder<List<Category>>(
        future: context.read<AppService>().getCategory(null),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  final category = snapshot.data![index];
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                    child: Card(
                      child: ListTile(
                        title: Text(category.name),
                      ),
                    ),
                  );
                });
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
