import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// Função principal que inicia o aplicativo
void main() {
  runApp(const MeuAplicativo());
}

// Classe que define o aplicativo
class MeuAplicativo extends StatelessWidget {
  const MeuAplicativo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cripto Moedas', // Título do aplicativo
      debugShowCheckedModeBanner:
          false, // Remove a faixa de debug no canto superior direito
      theme: ThemeData(
          primarySwatch:
              Colors.red), // Define o tema do aplicativo com a cor vermelha

      home:
          const HomePage(), // Define a página inicial do aplicativo como MoedasPage
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int paginaAtual = 0;
  late PageController pc;

  @override
  void initState() {
    super.initState();
    pc = PageController(initialPage: paginaAtual);
  }

  setPaginaAtual(pagina) {
    setState(() {
      paginaAtual = pagina;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pc,
        children: const [
          MoedasPage(),
          FavoritasPage(),
        ],
        onPageChanged: setPaginaAtual,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaAtual,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Todas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favoritas',
          ),
        ],
        onTap: (pagina) {
          pc.animateToPage(pagina,
              duration: const Duration(milliseconds: 400), curve: Curves.ease);
        },
        backgroundColor: Colors.grey[100],
      ),
    );
  }
}

class FavoritasPage extends StatefulWidget {
  const FavoritasPage({super.key});

  @override
  State<FavoritasPage> createState() => _FavoritasPageState();
}

class _FavoritasPageState extends State<FavoritasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moedas Favoritas'),
      ),
    );
  }
}

// Classe para a página de moedas
class MoedasPage extends StatefulWidget {
  const MoedasPage({super.key});

  @override
  State<MoedasPage> createState() =>
      _MoedasPageState(); // Cria o estado para a página de moedas
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
        title: const Center(
            child: Text(
                'Moedas')), // Título da barra de aplicativo quando nenhuma moeda está selecionada
      );
    } else {
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              selecionadas =
                  []; // Limpa a lista de moedas selecionadas ao pressionar o botão de voltar
            });
          },
        ),

        title: Text(
            '${selecionadas.length} selecionadas'), // Título da barra de aplicativo mostrando o número de moedas selecionadas

        backgroundColor: Colors
            .blueGrey, // Cor de fundo da barra de aplicativo quando moedas estão selecionadas

        iconTheme: const IconThemeData(
            color:
                Colors.black), // Define a cor dos ícones na barra de aplicativo

        titleTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 20), // Define o estilo do texto do título
      );
    }
  }

  // Função responsável por navegar para a tela de detalhes de uma moeda
  // ignore: non_constant_identifier_names
  tela_de_detalhes(Moeda moeda) {
    // Utiliza o Navigator para navegar para a próxima tela
    Navigator.push(
        context,
        MaterialPageRoute(
            // Define a rota da próxima tela e passa a moeda como argumento
            builder: (_) => mostrar_detalhes(
                  moeda: moeda,
                )));
  }

  // Método para construir o corpo da página
  @override
  Widget build(BuildContext context) {
    final tabela = MoedaRepositorio.tabela; // Tabela de moedas
    String sifra = "R\$ "; // Símbolo da moeda

    return Scaffold(
      appBar: appBarDinamica(), // Define a AppBar

      body: ListView.separated(
        itemBuilder: (BuildContext context, int moeda) {
          return ListTile(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(13))), // Define a forma do tile

            leading: (selecionadas.contains(tabela[moeda]))
                ? const CircleAvatar(
                    child: Icon(Icons
                        .check)) // Ícone de marca de seleção se a moeda estiver selecionada

                : SizedBox(
                    width: 40,
                    child: Image.asset(tabela[moeda].icone),
                  ), // Ícone da moeda

            title: Text(
              tabela[moeda].nome, // Nome da moeda
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.indigo), // Estilo do texto do título
            ),

            trailing: Text(
              sifra + tabela[moeda].preco.toString(), // Preço da moeda
            ),

            selected: selecionadas.contains(
                tabela[moeda]), // Verifica se a moeda está selecionada

            selectedTileColor: const Color.fromARGB(
                255, 235, 235, 235), // Cor do tile quando selecionado

            onLongPress: () {
              setState(() {
                (selecionadas.contains(tabela[moeda]))
                    ? selecionadas.remove(tabela[
                        moeda]) // Remove a moeda das selecionadas ao pressionar e segurar

                    : selecionadas.add(tabela[
                        moeda]); // Adiciona a moeda às selecionadas ao pressionar e segurar
              });
            },

            onTap: () => tela_de_detalhes(
                // Quando o usuário tocar neste widget...
                tabela[
                    moeda] // ...chame a função tela_de_detalhes com o valor associado à chave 'moeda' na tabela.
                ),
          );
        },

        padding: const EdgeInsets.all(16), // Preenchimento da lista
        separatorBuilder: (_, __) =>
            const Divider(), // Constrói o separador entre os itens da lista
        itemCount: tabela.length, // Número total de itens na lista
      ),

      floatingActionButton: selecionadas
              .isNotEmpty // Verifica se há moedas selecionadas
          ? FloatingActionButton.extended(
              // Se houver moedas selecionadas, exibe um botão flutuante estendido
              onPressed:
                  () {}, // Define a função a ser executada quando o botão for pressionado (no caso, uma função vazia)

              label: const Text('favoritar'), // Define o texto exibido no botão

              icon: const Icon(Icons
                  .star), // Define o ícone exibido no botão (no caso, o ícone de estrela)
            )
          : null, // Se não houver moedas selecionadas, o botão flutuante não é exibido
      floatingActionButtonLocation: FloatingActionButtonLocation
          .centerFloat, // Define a posição do botão flutuante (no centro inferior da tela)
    );
  }
}

// ignore: must_be_immutable, camel_case_types
class mostrar_detalhes extends StatefulWidget {
  Moeda moeda;

  mostrar_detalhes({Key? key, required this.moeda}) : super(key: key);

  @override
  State<mostrar_detalhes> createState() => _mostrar_detalhesState();
}

// ignore: camel_case_types
class _mostrar_detalhesState extends State<mostrar_detalhes> {
  // Criando uma instância de NumberFormat para formatar valores monetários
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');

  // Chave global para o formulário
  final _form = GlobalKey<FormState>();

  // Controlador de texto para capturar a entrada do usuário
  final _valor = TextEditingController();

  // Variável para armazenar a quantidade, inicializada como 0
  double quantidade = 0;

  void comprar() {
    // Verifica se o formulário é válido
    if (_form.currentState!.validate()) {
      // Fecha a tela atual
      Navigator.pop(context);

      // Mostra uma snackbar informando que a compra foi realizada com sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Compra realizada com sucesso!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Retorna um widget Scaffold que fornece a estrutura básica para a tela

      appBar: AppBar(
        // Barra de aplicativo
        title: Text(// Título da barra de aplicativo
            widget.moeda.nome // Título dinâmico baseado no nome da moeda
            ),
      ),

      body: Padding(
        // Corpo da tela com um espaçamento ao redor
        padding: const EdgeInsets.all(24),

        child: Column(
          // Coluna para organizar os widgets verticalmente
          children: [
            Padding(
              // Padding ao redor do Row

              padding: const EdgeInsets.only(bottom: 24),

              child: Row(
                // Linha para exibir o ícone e o preço da moeda
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  SizedBox(
                    // Espaço reservado para o ícone da moeda
                    width: 50,
                    child: Image.asset(
                        widget.moeda.icone), // Exibe o ícone da moeda
                  ),
                  Container(
                    // Espaçador entre o ícone e o preço
                    width: 10,
                  ),
                  Text(
                    // Exibe o preço formatado da moeda
                    real.format(widget.moeda.preco), // Formata o preço da moeda

                    style: const TextStyle(
                        // Estilo do texto do preço
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -1,
                        color: Colors.grey),
                  ),
                ],
              ),
            ),
            (quantidade > 0) // Condição para exibir a quantidade comprada
                ? SizedBox(
                    // Espaçador para exibir a quantidade comprada
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      padding: const EdgeInsets.all(12),
                      alignment: Alignment.center,
                      decoration:
                          BoxDecoration(color: Colors.teal.withOpacity(0.05)),
                      child: Text(
                        '$quantidade ${widget.moeda.sigla}', // Exibe a quantidade comprada da moeda
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  )
                : Container(
                    // Contêiner vazio se a quantidade for 0
                    margin: const EdgeInsets.only(bottom: 24),
                  ),
            Form(
              // Formulário para inserir o valor da compra
              key: _form, // Chave global do formulário
              child: TextFormField(
                controller:
                    _valor, // Controlador de texto para capturar a entrada do usuário
                style: const TextStyle(fontSize: 22),

                decoration: const InputDecoration(
                  // Decoração do campo de entrada
                  border: OutlineInputBorder(),
                  labelText: 'Valor',
                  prefixIcon: Icon(Icons.monetization_on_outlined),

                  suffix: Text(
                    'Reais',
                    style: TextStyle(fontSize: 14),
                  ),
                ),

                keyboardType: TextInputType.number, // Tipo de teclado numérico
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ], // Formatação de entrada para aceitar apenas dígitos

                validator: (value) {
                  // Função de validação do campo de entrada
                  if (value!.isEmpty) {
                    // Verifica se o campo está vazio
                    return 'Digite o valor da compra'; // Retorna uma mensagem de erro
                  } else if (double.parse(value) < 50) {
                    // Verifica se o valor é menor que 50
                    return 'Valor mínimo para a compra é R\$ 50'; // Retorna uma mensagem de erro
                  }
                  return null; // Retorna nulo se a validação for bem-sucedida
                },

                onChanged: (value) {
                  // Função chamada sempre que o valor do campo é alterado
                  setState(() {
                    // Atualiza o estado do widget
                    quantidade = (value
                            .isEmpty) // Atualiza a quantidade com base no valor inserido
                        ? 0
                        : double.parse(value) / widget.moeda.preco;
                  });
                },
              ),
            ),
            Container(
              // Contêiner para o botão de compra
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.only(top: 24),

              child: ElevatedButton(
                  // Botão de compra
                  onPressed:
                      comprar, // Função chamada quando o botão é pressionado
                  child: const Row(
                    // Layout do botão
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check), // Ícone de marca de seleção

                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Comprar', // Texto do botão
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
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
  Moeda(
      {required this.icone,
      required this.nome,
      required this.sigla,
      required this.preco});
}

// Repositório de moedas
class MoedaRepositorio {
  // Tabela de moedas
  static List<Moeda> tabela = [
    Moeda(
        icone: 'Imagens/bitcoin-icon_34487.png',
        nome: 'Bit Coin',
        sigla: 'BTC',
        preco: 300000),
    Moeda(
        icone: 'Imagens/ethereum_crypto_coin_eth_icon_256918.png',
        nome: 'Ethereum',
        sigla: 'ETH',
        preco: 10000)
  ];
}
