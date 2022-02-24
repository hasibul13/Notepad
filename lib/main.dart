import 'package:flutter/material.dart';
import 'package:flutter_sqlite/sqlite_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Map<String,dynamic>> _dataList = [];

  getAllData() async{
    var list = await SQLHelper.getAllData();
    setState(()  {
      _dataList = list;

    });
  }

  addItems(int ?id,String ?title,String ?description) {
    TextEditingController titleController = TextEditingController();
    TextEditingController desController = TextEditingController();

    if(id !=null){
      titleController.text = title!;
      desController.text= description!;
    }
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context){
        return Container(
          padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: "title"
                  ),
                ),
                TextField(
                  controller: desController,
                  decoration: const InputDecoration(
                    hintText: "description"

            ),
                ),

                ElevatedButton(
                  onPressed: (){
                    var title = titleController.text.toString();
                    var des = desController.text.toString();

                    if(id==null){
                      SQLHelper.insertData(title, des).then((value) => {
                        if(value != -1){
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Data inserted Successfully"))),
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("failed to inserted")))
                        }
                      });
                    }else{
                      SQLHelper.updateData(id,title,des);
                    }


                    Navigator.of(context).pop(context);
                    getAllData();

                  },
                  child: id==null?Text("insert data") : Text("update data")
                )

              ],

            ),

        );

      }
    );
  }
  @override
  void initState() {
    super.initState();
    getAllData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _dataList.isNotEmpty ?ListView.builder(
          itemCount: _dataList.length,
          itemBuilder: (context, position) {
              return ListTile(
                title: Text(_dataList[position]["title"].toString()),
                subtitle: Text(_dataList[position]["description"].toString()),
                trailing: Wrap(
                  spacing: 20,
                  children: [
                    GestureDetector(
                        onTap: () {
                          addItems(
                              _dataList[position]["id"],
                              _dataList[position]["title"],
                              _dataList[position]["description"].toString()
                          );
                        },
                        child: Icon(Icons.edit)
                    ),
                    GestureDetector(
                        onTap: () {
                          SQLHelper.deleteData(_dataList[position]["id"]);
                          getAllData();
                        },
                        child: Icon(Icons.delete)
                    ),
                  ],
                ),
              );
          }

      ) : const Center(child: Text("No Data Found"),),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addItems(null,null,null);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
  }

