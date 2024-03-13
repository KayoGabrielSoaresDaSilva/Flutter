import 'package:flutter/material.dart';

// Função principal que inicia o aplicativo
void main() {
  runApp(MeuAplicativo());
}

// Classe que define o aplicativo
class MeuAplicativo extends StatelessWidget {
  MeuAplicativo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cripto Moedas', // Título do aplicativo
      debugShowCheckedModeBanner: false, // Remove a faixa de debug no canto superior direito
      theme: ThemeData(primarySwatch: Colors.red), // Define o tema do aplicativo com a cor vermelha
      home: MoedasPage(), // Define a página inicial do aplicativo como MoedasPage
    );
  }
}

// Classe para a página de moedas
class MoedasPage extends StatefulWidget {
  MoedasPage({super.key});

  @override
  State<MoedasPage> createState() => _MoedasPageState(); // Cria o estado para a página de moedas
}

// Estado para a página de moedas
class _MoedasPageState extends State<MoedasPage> {
  final tabela = MoedaRepositorio.tabela; // Tabela de moedas
  List<Moeda> selecionadas = []; // Lista de moedas selecionadas

  // Método para construir a AppBar dinamicamente com base na seleção de moedas
  AppBar appBarDinamica() {
    if (selecionadas.isEmpty) {
      return AppBar(
        backgroundColor: Colors.blue, // Cor de fundo da barra de aplicativo
        title: const Center(child: Text('Moedas')), // Título da barra de aplicativo quando nenhuma moeda está selecionada
      );

    } else {
      return AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              selecionadas = []; // Limpa a lista de moedas selecionadas ao pressionar o botão de voltar
            });
          },
        ),
        title: Text('${selecionadas.length} selecionadas'), // Título da barra de aplicativo mostrando o número de moedas selecionadas
        backgroundColor: Colors.blueGrey, // Cor de fundo da barra de aplicativo quando moedas estão selecionadas
        iconTheme: IconThemeData(color: Colors.black), // Define a cor dos ícones na barra de aplicativo
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 20), // Define o estilo do texto do título
      );
    }
  }

  // Método para construir o corpo da página
  @override
  Widget build(BuildContext context) {
    final tabela = MoedaRepositorio.tabela; // Tabela de moedas
    String moeda = "R\$"; // Símbolo da moeda

    return Scaffold(
      appBar: appBarDinamica(), // Define a AppBar
      body: ListView.separated(
        itemBuilder: (BuildContext context, int moedaIndex) {
          return ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(13))), // Define a forma do tile
            leading: (selecionadas.contains(tabela[moedaIndex])) 
            ? CircleAvatar(child: Icon(Icons.check)) // Ícone de marca de seleção se a moeda estiver selecionada
            : SizedBox(width: 40, child: Image.asset(tabela[moedaIndex].icone),), // Ícone da moeda
                  
            title: Text(
              tabela[moedaIndex].nome, // Nome da moeda
              style: const TextStyle(fontSize: 14, color: Colors.indigo), // Estilo do texto do título
            ),

            trailing: Text(
              moeda + tabela[moedaIndex].preco.toString(), // Preço da moeda
            ),
            
            selected: selecionadas.contains(tabela[moedaIndex]), // Verifica se a moeda está selecionada

            selectedTileColor: Color.fromARGB(255, 235, 235, 235), // Cor do tile quando selecionado

            onLongPress: () {
              setState(() {
                (selecionadas.contains(tabela[moedaIndex]))
                ? selecionadas.remove(tabela[moedaIndex]) // Remove a moeda das selecionadas ao pressionar e segurar
                : selecionadas.add(tabela[moedaIndex]); // Adiciona a moeda às selecionadas ao pressionar e segurar
              });
            },
          );
        },

        padding: const EdgeInsets.all(16), // Preenchimento da lista
        separatorBuilder: (_, __) => const Divider(), // Constrói o separador entre os itens da lista
        itemCount: tabela.length, // Número total de itens na lista
      ),

      floatingActionButton: selecionadas.isNotEmpty // Verifica se há moedas selecionadas
      ? FloatingActionButton.extended( // Se houver moedas selecionadas, exibe um botão flutuante estendido
        onPressed: () {}, // Define a função a ser executada quando o botão for pressionado (no caso, uma função vazia)
        label: Text('favoritar'), // Define o texto exibido no botão
        icon: Icon(Icons.star), // Define o ícone exibido no botão (no caso, o ícone de estrela)
      )
      : null, // Se não houver moedas selecionadas, o botão flutuante não é exibido
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat, // Define a posição do botão flutuante (no centro inferior da tela)

    );
  }
}

// Classe que define uma moeda
class Moeda {
  String icone; // Ícone da moeda
  String nome; // Nome da moeda
  String sigla; // Sigla da moeda
  double preco; // Preço da moeda

  // Construtor da classe Moeda
  Moeda({required this.icone, required this.nome, required this.sigla, required this.preco});
}

// Repositório de moedas
class MoedaRepositorio {
  // Tabela de moedas
  static List<Moeda> tabela = [
    Moeda(icone: 'Imagens/bitcoin-icon_34487.png', nome: 'Bit Coin', sigla: 'BTC', preco: 300000),
    Moeda(icone: 'Imagens/ethereum_crypto_coin_eth_icon_256918.png', nome: 'Ethereum', sigla: 'ETH', preco: 10000)
  ];
}
