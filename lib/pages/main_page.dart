import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/category.dart';
import '../services/app_service.dart';
import '../utils/constants.dart';
import '../widgets/greeting.dart';
import '../widgets/menuitem_count_by_category.dart';
import 'add_page.dart';
import 'city_page.dart';
import 'my_adverts_page.dart';

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
                leading: const Icon(Icons.my_library_books),
                title: const Text('My items'),
                onTap: () {
                  Navigator.of(context)
                      .popAndPushNamed(MyAdvertsPages.routeName);
                },
              ),
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
        future: context.read<AppService>().getCategories(),
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
                        onTap: () => Navigator.of(context)
                            .pushNamed(CityPage.routeName, arguments: category),
                        trailing: MenuItemCountByCategory(category.id),
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
