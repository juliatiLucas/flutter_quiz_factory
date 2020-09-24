import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/questionario.m.dart';
import '../controllers/home.c.dart';
import '../components/questionario_card.dart';
import '../views/perfil.v.dart';
import '../utils/session.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomeController _homeController = Get.put(HomeController());

  void optionSelected(String option) async {
    switch (option) {
      case 'sair':
        this.confirmarSaida();
        break;
      case 'perfil':
        Get.to(PerfilView(userId: (await Session.getUserInfo())['id']));
        break;
    }
  }

  void confirmarSaida() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("Você tem certeza?"),
              actions: [
                FlatButton(
                  child: Text('CANCELAR'),
                  onPressed: () => Navigator.pop(context),
                ),
                FlatButton(
                  child: Text('SIM'),
                  onPressed: () => _homeController.logout(context),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: GetBuilder<HomeController>(
      init: Get.put(HomeController()),
      initState: (_) {
        HomeController.to.getQuestionarios(context);
      },
      builder: (ctr) => RefreshIndicator(
          onRefresh: () => ctr.getQuestionarios(context),
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowGlow();
              return null;
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(children: [
                Stack(children: [
                  Positioned(
                    child: Container(
                        decoration: BoxDecoration(color: Color(0xff3b7ce3)),
                        width: size.width,
                        height: 260,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: SafeArea(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Text('Quiz Factory',
                                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                                  PopupMenuButton<String>(
                                    onSelected: this.optionSelected,
                                    icon: Icon(Icons.more_vert, color: Colors.white),
                                    itemBuilder: (_) => [
                                      const PopupMenuItem<String>(
                                        value: "perfil",
                                        child: Text('Perfil'),
                                      ),
                                      const PopupMenuItem<String>(
                                        value: "sair",
                                        child: Text('Sair'),
                                      ),
                                    ],
                                  )
                                ]),
                                SizedBox(height: 120),
                              ],
                            ),
                          ),
                        )),
                  ),
                  Positioned(
                    child: Padding(
                        padding: EdgeInsets.only(left: 30, right: 30, top: 150, bottom: 50),
                        child: Container(
                            width: size.width,
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(2)),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 2),
                                    blurRadius: 2,
                                    color: Colors.black.withOpacity(0.3),
                                  )
                                ]),
                            height: 250,
                            child: Material(
                              color: Colors.transparent,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Opacity(
                                    opacity: 0.82,
                                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                      Text('Questionários', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                      Row(children: [
                                        Padding(
                                            padding: EdgeInsets.symmetric(vertical: 8),
                                            child: IconButton(
                                              icon: Icon(Icons.filter_list),
                                              onPressed: () {},
                                            )),
                                        Padding(
                                            padding: EdgeInsets.symmetric(vertical: 8),
                                            child: IconButton(
                                              icon: Icon(Icons.search),
                                              onPressed: () {},
                                            ))
                                      ]),
                                    ]),
                                  ),
                                  ctr.questionarios.value != null
                                      ? Expanded(
                                          child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: ctr.questionarios.value.length,
                                          itemBuilder: (_, index) {
                                            QuestionarioModel questionario = ctr.questionarios.value[index];
                                            return QuestionarioCard(questionario: questionario);
                                          },
                                        ))
                                      : SizedBox()
                                ],
                              ),
                            ))),
                  ),
                ]),
                Stack(children: [
                  Positioned(
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                        child: Container(
                            width: size.width,
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(2)),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 2),
                                    blurRadius: 2,
                                    color: Colors.black.withOpacity(0.3),
                                  )
                                ]),
                            height: 400,
                            child: Material(
                              color: Colors.transparent,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Opacity(
                                    opacity: 0.82,
                                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                      Text(
                                        'Suas respostas',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.symmetric(vertical: 8),
                                          child: IconButton(
                                            icon: Icon(Icons.search),
                                            onPressed: () {},
                                          ))
                                    ]),
                                  ),
                                ],
                              ),
                            ))),
                  ),
                ]),
                SizedBox(height: 40),
              ]),
            ),
          )),
    ));
  }
}
