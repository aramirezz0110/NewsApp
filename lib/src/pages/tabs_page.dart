import 'package:flutter/material.dart';
import 'package:newsapp/src/pages/tab1_page.dart';
import 'package:newsapp/src/pages/tab2_page.dart';
import 'package:newsapp/src/services/news_service.dart';
import 'package:provider/provider.dart';

class TabsPage extends StatelessWidget {
  const TabsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _NavegacionModel(),
      child: Scaffold(
        body: _Paginas(),
        bottomNavigationBar: _Navegacion(),
      ),
    );
  }
}

class _Navegacion extends StatelessWidget {
  const _Navegacion({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //instanciacion del modelo de provider
    final navegacionModel = Provider.of<_NavegacionModel>(context);
    //instanciacion del modelo global que esta dentro del multiprovider
    final newsService = Provider.of<NewsService>(context);
    return BottomNavigationBar(
      //para actualizar la pagina actual usando provider
      currentIndex: navegacionModel.paginaActual,
      //actualizacion de informacion en el modelo
      onTap: (i) => navegacionModel.paginaActual = i,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), label: "Para ti"),
        BottomNavigationBarItem(icon: Icon(Icons.public), label: "Encabezados"),
      ],
    );
  }
}

class _Paginas extends StatelessWidget {
  const _Paginas({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navegacionModel = Provider.of<_NavegacionModel>(context);
    return PageView(
      controller: navegacionModel.pageController,
      //para el rebote al llegar al limite
      //physics: BouncingScrollPhysics(),
      physics: NeverScrollableScrollPhysics(),
      children: [
        Tab1Page(),
        Tab2Page(),
      ],
    );
  }
}

//CLASE PARA USO DE PROVIDER
class _NavegacionModel with ChangeNotifier {
  int _paginaActual = 0;
  PageController _pageController = new PageController(initialPage: 0);
  //establecer setters y getters
  int get paginaActual => this._paginaActual;
  set paginaActual(int valor) {
    this._paginaActual = valor;
    //para animar la transicion entre pantallas
    _pageController.animateToPage(valor,
        duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    //para propagar los cambios
    notifyListeners();
  }

  PageController get pageController => this._pageController;
}
