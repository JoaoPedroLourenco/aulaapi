import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:money_search/data/MoneyController.dart';
import 'package:money_search/data/cache.dart';
import 'package:money_search/data/internet.dart';
import 'package:money_search/data/string.dart';
import 'package:money_search/model/MoneyModel.dart';
import 'package:money_search/model/listPersonModel.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}



/// instancia do modelo para receber as informações
List<ListPersonModel> model = [];

class _HomeViewState extends State<HomeView> {



checkconnection() async {
  internet = await CheckInternet().checkConnection();
  setState(() {});
}
  
  bool internet = true;

@override
initState() {
  checkconnection();
  super.initState();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Lista de pessoas'),
          centerTitle: true,
          backgroundColor: Colors.lightGreen,
          actions: [
            Visibility(child: Icon(Icons.network_cell_outlined)
        )],
        ),
        body: FutureBuilder<List<ListPersonModel>>(
          future: MoneyController().getListPerson(),
          builder: (context, snapshot) {
            /// validação de carregamento da conexão
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            /// validação de erro
            if (snapshot.error == true) {
              return SizedBox(
                height: 300,
                child: Text("Vazio"),
              );
            }
//  List<ListPersonModel> model = [];
            /// passando informações para o modelo criado
            /// 
            model = snapshot.data ?? model;
            model.add(ListPersonModel(avatar: "https://i1.sndcdn.com/artworks-iEBoUoJhkodCKbIl-zLXabQ-t500x500.jpg", id: "777", name: "Ednaldo Moreira"));
            model.sort(
              (a, b) => a.name!.compareTo(b.name!),
            );
            model.removeWhere((pessoa) => pessoa.id=="64");
            model.removeWhere((pessoa) => pessoa.name=="Miss Kim Keebler");
            model.forEach((element) {
              if (element.id=="9"){
                element.avatar="";
              }
            });
          
            return ListView.builder(
                itemCount: model.length,
                itemBuilder: (context, index) {
                  ListPersonModel item = model[index];
                  return ListTile(
                    leading: Image.network(
                       errorBuilder: (context, error, stackTrace)
                       {
                        return Container();
                       }, item.avatar ?? ""),
                    title: Text(item.name ?? ""),
                    trailing: Text(item.id ?? ""),
                  );
                });
            // ListView.builder(
            //   shrinkWrap: true,
            //   // physics: NeverScrollableScrollPhysics(),
            //   itemCount: model.length,
            //   itemBuilder: (BuildContext context, int index) {
            //     ListPersonModel item = model[index];
            //     // tap(ListPersonModel item) {
            //     //   Navigator.push(
            //     //       context,
            //     //       MaterialPageRoute(
            //     //           builder: (context) => Person(
            //     //                 item: item,
            //     //               )));
            //     // }

            //     return GestureDetector(
            //       // onTap: (() => tap(item)),
            //       child: ListTile(
            //         leading: Image.network(item.avatar ?? ""),
            //         title: Text(item.name ?? ""),
            //         trailing: Text(item.id ?? ""),
            //       ),
            //     );
            //   },
            // );
          },
        ));
  }
    verifyData(AsyncSnapshot snapshot) async {
      try {
        model.clear();
        model.addAll(snapshot.data ?? []);
        await SecureStorage()
          .writeSecureData(pessoas, json.encode(snapshot.data));

      } catch (e) {
        print("erro ao salvar lista");
      }

    }

    readMemory() async {
      var result = await SecureStorage().readSecureData(pessoas);
      if (result == null) return;
      List<ListPersonModel> lista = (json.decode(result) as List)
      .map((e) => ListPersonModel.fromJson(e))
      .toList();
      model.addAll(lista);
    }


  Future<Null> refresh() async {
    setState(() {});
  }
}


