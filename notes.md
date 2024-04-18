#### 18/04/2024

Curso de Swift: aplicando o padrão arquitetural MVVM e boas práticas de separação de responsabilidades

@01-Analise de projeto 

@@01
Apresentação

Olá!
Eu sou o Ândriu Coelho e gostaria de dar as boas-vindas a mais um curso de iOS aqui na Alura.

Audiodescrição: Ândriu se declara como um homem branco de cabelo castanho claro curtos. Possui uma barba também curta. Está usando uma camiseta azul escuro com a logo da Alura e está sentado em uma cadeira com um encosto alto preto. Atrás dele, à esquerda, tem uma estante com diversos objetos de decoração, como lâmpadas, quadros, vasos e livros. Ao fundo, a parede está iluminada por uma luz LED roxa.
A ideia desse curso é continuarmos o desenvolvimento do app Voll Med, que já foi iniciado nos cursos anteriores, mas dessa vez com um olhar um pouco mais arquitetural. Então, entenderemos qual é o benefício de utilizarmos um padrão arquitetural em nosso projeto.

Nós vamos utilizar o MVVM (Model-View-ViewModel), com o qual conseguiremos desacoplar algumas partes do Voll. Todas as camadas de requisição, de serviços para APIs, validações, entre outros, será tratado com o MVVM. Também criaremos uma camada de networking, para separar as chamadas de APIs do nosso projeto por funcionalidade. É muito comum que, ao longo do tempo, que o projeto cresça e as pessoas coloquem tudo dentro de um só arquivo. Então, discutiremos os benefícios de conseguirmos separar isso.

A ideia do curso é realmente ter um projeto funcional, mas com um olhar sobre o aspecto de arquitetura, de modo que possamos melhorar a testabilidade do projeto, a organização do código e a reutilização do código. Como pré-requisito, é importante que você já tenha feito os cursos dessa formação para compreender o projeto.

Esse é o conteúdo que veremos durante o curso, e espero você.

@@02
Preparando o ambiente: projeto

Esse projeto será uma continuação da Vollmed e partiremos do ponto em que o cursoiOS com SwiftUI: autenticação de usuários em uma aplicação parou. Por isso, é importante que você já tenha o projeto em sua máquina.
Baixe o projeto inicial ou acesse o repositório no GitHub e pegue o projeto da branch main.

Xcode 15
Certifique-se de que tem a IDE XCode instalado na sua máquina. Caso ainda não tenha, pode baixá-lo diretamente da AppStore ou no site oficial da Apple para desenvolvedores.

Lembrando que o Xcode só está disponível para sistema operacional MacOS!
Neste curso, estaremos utilizando o Xcode na versão 15. No momento de gravação deste curso, a versão 15 ainda estava em beta, ou seja, não estava disponível para todo mundo ainda.

Entretanto, quando você estiver assistindo este curso, muito provavelmente a versão 15 já estará disponível para todos os usuários e você poderá fazer o download tranquilamente.

https://github.com/alura-cursos/swiftui-vollmed-authentication.git

https://cursos.alura.com.br/course/ios-swiftui-autenticacao-usuarios-aplicacao

https://github.com/alura-cursos/swiftui-vollmed-authentication/archive/refs/heads/main.zip

https://github.com/alura-cursos/swiftui-vollmed-authentication/tree/main

https://apps.apple.com/br/app/xcode/id497799835

https://developer.apple.com/xcode/

@@03
Introdução à arquitetura MVVM em iOS

Para iniciar o nosso curso, eu gostaria de analisar algumas implementações feitas nos cursos anteriores. Eu já estou com o projeto Vollmed aberto e vou abrir o simulador. Quando iniciamos o simulador, nos deparamos com a tela principal, ou seja, a home do aplicativo Vollmed.
No canto superior direito está o botão de logout, no centro superior está a logo do aplicativo seguida de duas etiquetas: "Boas-vindas!" e uma mensagem informando sobre a lista de profissionais da medicina, onde a pessoa usuária pode agendar uma consulta conforme a necessidade da especialidade que ela procura. Essa é a tela inicial.

Voltando para o XCode, observamos que, nesse código, temos o HomeView e, a partir da linha 39, temos o body. Já sabemos que em SwiftUI, tudo que desenhamos na tela fica dentro do body. Nesse caso, temos um ScrollView uma imagem (Image()), os textos (Text()) e tudo que encontramos visualmente no simulador, representado em código.

Um ponto de atenção são os métodos da linha 17 e da linha 27, sucessivamente getSpecialists() e logout(). No getSpecialists(), fazemos um get dos especialistas, ou seja, fazemos uma requisição para buscar no servidor a lista de especialistas, e aguardamos uma resposta para mostrar isso no aplicativo. E o logout() é usado para pessoa usuária sair do aplicativo.

Esse é o primeiro ponto que eu queria começar a discutir com vocês. A ideia de arquivos do tipo view, em iOS, é apenas mostrar a parte visual para o usuário, como criar uma lista, colocar uma imagem, colocar uma etiqueta, enfim, todos os elementos visuais realmente ficam na view.

Porém, se começarmos a colocar outras responsabilidades nessa view, como chamadas HTTP, validação de regra de negócio, ou até mesmo validação de elementos visuais dentro da própria view, começamos a deixar essa view com muita responsabilidade e a longo prazo o nosso projeto fica mais difícil de escalar. Então, a ideia desse curso é começarmos a analisar a estrutura do que desenvolvemos e pensarmos como podemos melhorar isso, pensando no nosso projeto a longo prazo, em termos de escalabilidade e testabilidade.

Portanto, deixar chamadas HTTP em uma view talvez não seja a melhor solução. Também vamos analisar o arquivo WebService.swift. Esse arquivo possui todas as chamadas de APIs do aplicativo:

Na linha 15 temos o método que faz logoutPatient(), que faz o logout;
Na linha 41 temos o loginPatient(), que faz login;
Na linha 65 temos o registerPatient(), onde cadastramos a pessoa paciente;
Na linha 87 temos o cancelAppointment(), onde cancelamos uma consulta.
Portanto, o WebService.swift possui todas as chamadas para APIs. E quando o aplicativo crescer, ou seja, tiver mais telas, provavelmente terá mais métodos de requisição para o servidor, será que é interessante deixar tudo em um arquivo só? É isso que vamos discutir ao longo do curso: como melhorar essa organização e como dividir a responsabilidade das nossas classes para melhorar o acoplamento.

Vamos começar estudando o primeiro padrão de projeto que vamos aplicar, que se chama ViewModel. A ideia é tornar esse projeto MVVM (Model-View-ViewModel), que é um padrão arquitetural bem comum no desenvolvimento iOS. Há vários padrões, temos MVP, Viper e Clean Architecture, mas entre eles está o MVVM. Então, começaremos criando um ViewModel para separar essas responsabilidades da View.

Essa é a discussão inicial que eu queria trazer para vocês, de como podemos melhorar alguns pontos do nosso projeto, que são muito importantes de se pensar à medida que o projeto for crescendo. A partir do próximo vídeo, iniciaremos a criação do nosso primeiro ViewModel.

@@04
Criando o HomeViewModel

É hora de criarmos nosso primeiro ViewModel. Para isso, criaremos uma pasta chamada "ViewModels". Então, na coluna da esquerda, clicaremos com o botão direito na pasta "Vollmed", selecionaremos "New Group" (Novo Grupo), e escreveremos o nome de "ViewModels". Feito isso, arrastaremos a essa pasta para ficar abaixo de "Extensions".
Após movermos a pasta, criaremos um novo arquivo dentro dela. Então clicaremos com o botão direito em "ViewModels" e selecionamos "New File" (Novo Arquivo). Na janela que abre no centro da tela, selecionaremos a opção "Swift File" e clicaremos no botão, "Next", no canto inferior direito da tela. Na nova janela que se abre no centro da tela, nomearemos o arquivo como HomeViewModel e clicaremos no botão "Create", no canto inferior da janela.

As janelas abertas se fecham e um arquivo vazio, chamado HomeViewModel.swift, é aberto no XCode. Precisamos criar uma estrutura nesse arquivo, então, abaixo do import Foundation, criaremos a struct HomeViewModel{}. Voltaremos para "Views > Components > HomeView.swift" e, como comentamos no vídeo anterior, a ideia é começarmos refatorar esse arquivo, tirando as chamadas de APIs e colocando isso na pasta "ViewModels".

O primeiro método que vamos refatorar é o da linha 17: getSpecialists(), que usamos para buscar os especialistas. Abrindo o simulador, reparamos que é esse método que apresenta a de profissionais da medicina na Home. Portanto, vamos tirar da View a responsabilidade de realizar uma chamada HTTP. Teremos a referência do nosso HomeViewModel dentro da HomeView, e nele vamos colocar a lógica para fazer a chamada HTTP.

Sendo assim, voltaremos ao HomeViewModel que acabamos de criar. Primeiro, precisamos ter acesso ao arquivo WebService.swift, onde tem o método, de fato, que buscar as pessoas especialistas. Sendo assim, dentro da estrutura HomeViewModel criaremos um marcador para organizar nosso arquivo, escrevendo // MARK: - Attributes (MARCO: - Atributos). Na linha abaixo, criaremos uma referência que chamaremos de service para o Webservice. Que é a classe que tem todos os métodos de API do nosso projeto.

import Foundation

struct HomeViewModel {
    
    // MARK: - Attributes
    
    let service = WebService()
    
}
COPIAR CÓDIGO
Com essa referência, já podemos criar os métodos de dentro do nosso ViewModel. Então, abaixo do service, escreveremos outro marco: // MARK: - Class methods (MARCO: - Métodos da classe). Esses marcos não fazem nada na execução de código, mas deixam nosso arquivo um pouco mais organizado. Essa é a sua função.

Embaixo desse marco, criaremos o método onde buscamos os especialistas. Para isso, retornaremos ao HomeView.swift, copiaremos o código da linha 17, com "Cmd + C", e colaremos abaixo do último marco do HomeViewModel.swift. A única diferença é que, antes de abrir chaves, escreveremos throws, que será mais uma anotação nesse método.

import Foundation

struct HomeViewModel {
    
    // MARK: - Attributes
    
    let service = WebService()
    
    // MARK: - Class methods
    
    func getSpecialists() async throws {
    
    }
    
}
COPIAR CÓDIGO
O Throws (Lançar) significa que o método pode lançar uma exceção. Ou seja, caso ocorra algum problema na requisição, ele me devolverá um erro, e eu podemos manipular esse erro de alguma forma no aplicativo, como mostrar para o usuário ou realizar qualquer outra ação. Em contrapartida, quando implementarmos esse método na View, precisaremos utilizar aquela estrutura do do-catch, que é onde conseguimos fazer o tratamento caso ocorra um erro.

Sendo assim, dentro do getSpecialists(), chamaremos o do {} e, embaixo, o catch{}. Dentro do do, faremos uma verificação com if let fetchedSpecialists = try await service.getAllSpecialists() {}, ou seja, ele vai buscar os especialistas esperando a resposta do método getAllSpecialists do nosso serviço. Se ele conseguir obter algum valor, ele entrará nesse if e poderemos retornar essa variável que acabamos de criar, a fetchedSpecialists.

Caso ocorra um erro, ele cairá no catch, onde podemos imprimir uma mensagem, por exemplo, print("Ocorreu um problema para obter os especialistas"). E, na linha abaixo, exibimos o erro, através do throw error.

//código omitido

// MARK: - Class methods

func getSpecialists() async throws {
    do {
        if let fetchedSpecialists = try await service.getAllSpecialists() {
            return fetchedSpecialists
        }
    } catch {
        print("Ocorreu um problema para obter os especialistas")
        throw error
    }
}
COPIAR CÓDIGO
Essa função precisa retornar a lista de especialistas que temos. Então, na declaração da função, após o throws, escreveremos -> [Specialist], que é uma lista, ou seja, um array, de especialistas. Com isso, finalizamos nosso método.

import Foundation

struct HomeViewModel {
    
    // MARK: - Attributes
    
    let service = WebService()

    // MARK: - Class methods

    func getSpecialists() async throws -> [Specialist] {
        do {
            if let fetchedSpecialists = try await service.getAllSpecialists() {
                return fetchedSpecialists
            }
        } catch {
            print("Ocorreu um problema para obter os especialistas")
            throw error
        }
    }
COPIAR CÓDIGO
Agora precisamos utilizar esse método lá na HomeView, porém ainda aparece um erro no HomeViewModel porque, caso não consigamos obter a lista, esquecemos de pedir para ele retornar uma lista vazia. Então vamos corrigir isso após if. Caso não entre no if, não retorna nada.

import Foundation

struct HomeViewModel {
    
    // MARK: - Attributes
    
    let service = WebService()

    // MARK: - Class methods

    func getSpecialists() async throws -> [Specialist] {
        do {
            if let fetchedSpecialists = try await service.getAllSpecialists() {
                return fetchedSpecialists
            }
            
            return []
        } catch {
            print("Ocorreu um problema para obter os especialistas")
            throw error
        }
    }
COPIAR CÓDIGO
Agora vamos voltar no arquivo HomeView.swift, onde já precisaremos ter uma referência do HomeViewModel. Logo no começo da estrutura HomeView, na linha 12, temos o service. A ideia é removê-lo quando terminarmos de refatorar, porque o HomeView vai mais receber nenhuma chamada para API. Também removeremos o authManager, que está na linha 13, porque não faz parte da View saber manejar o token do usuário.

Então, no próximo vídeo, usaremos o model que acabamos de criar.

@@05
Para saber mais: criando o seu primeiro ViewModel

Hey! Se você está tentando aprofundar seus conhecimentos em arquitetura de software, certamente já ouviu falar do padrão MVVM, certo? Este é o acrônimo para Model-View-ViewModel e é um padrão arquitetural muito adotado na construção de aplicativos. Então, vamos detalhá-lo da maneira mais simples possível! Vamos lá?
O que é MVVM?
MVVM é um padrão de design estrutural que divide a lógica de programação do aplicativo em três partes interconectadas: Model, View e ViewModel.

Model: esta é a camada de dados da sua aplicação. Ele contém os objetos de domínio e os dados do banco da aplicação.
View: esta é a parte visível da sua aplicação, ou seja, a interface do usuário (UI).
ViewModel: esta é a parte lógica da aplicação. Ele recebe os dados do Model e os envia para a View.
O objetivo principal deste padrão é separar a lógica de apresentação dos dados do modelo de negócios, permitindo projetos mais limpos e organizados, facilitando o desenvolvimento e a manutenção do código.

Vantagens do MVVM
A primeira grande vantagem deste padrão arquitetural é o desacoplamento do código. Como a lógica é separada em diferentes partes, o código pode ser desenvolvido, testado e mantido de forma mais eficiente.

Outra vantagem é a facilidade com que a interface do usuário pode ser atualizada sem afetar a lógica do aplicativo. Isso inclui a possibilidade de criarmos vários tipos de views para o mesmo data model.

Por fim, MVVM também permite o desenvolvimento simultâneo de diferentes componentes da aplicação. Por exemplo, enquanto um programador trabalha na interface do usuário, outro pode estar trabalhando na lógica da aplicação.

Desvantagens do MVVM
A principal desvantagem do padrão MVVM é a sua complexidade inicial. O aprendizado é maior comparado a outros padrões arquiteturais.

Além disso, pode ser um exagero para projetos pequenos devido a sua estrutura elaborada. Também pode ser que exista uma pequena sobrecarga de processamento para executar a "binding" de dados entre a View e o ViewModel.

Exemplos Práticos
Vamos a um exemplo básico em Swift com SwiftUI de como implementar o MVVM:

Model:

import Foundation

struct Pessoa {
    var nome: String
    var idade: Int
}
COPIAR CÓDIGO
ViewModel:

import Foundation

class PessoaViewModel: ObservableObject {
    @Published var pessoa: Pessoa

    init() {
        pessoa = Pessoa(nome: "Antônio", idade: 30)
    }

    var info: String {
        return "\(pessoa.nome) tem \(pessoa.idade) anos!"
    }
}
COPIAR CÓDIGO
View:

import SwiftUI

struct PessoaView: View {
    @ObservedObject var viewModel: PessoaViewModel

    init(viewModel: PessoaViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        Text(viewModel.info)
    }
}

struct ContentView: View {
    var viewModel = PessoaViewModel()

    var body: some View {
        PessoaView(viewModel: viewModel)
    }
}

@main
struct AppMain: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
COPIAR CÓDIGO
Aqui, nossa classe Pessoa é o Model, a classe PessoaViewModel é o ViewModel e a classe PessoaView é nossa View.

Lembre-se: o exemplo acima é muito simplificado e em projetos reais, as coisas podem ser muito mais complexas.

Espero que este texto tenha ajudado você a compreender melhor o padrão MVVM. Continue estudando e pesquisando, pois a prática é essencial para dominar esses conceitos. Boa sorte no seu aprendizado!

@@06
Usando o ViewModel na View

Com o ViewModel criado, vamos utilizá-lo dentro do HomeView, então acessaremos o arquivo HomeView.swift e, na linha 13, temos o authManager, onde obtemos o Token do usuário. Ao final dessa linha, pressionaremos "Enter" e, na linha 14, criaremos uma nova variável chamada ViewModel, que será igual ao HomeViewModel.
import SwiftUI

struct HomeView: View {
    let service = WebService()
    var authManager = AuthenticationManager.shared
    var viewModel = HomeViewModel()
    
    //código omitido
COPIAR CÓDIGO
Abrindo o simulador, notamos que, ao entramos no aplicativo, ou seja, quando a View vai ser construída, é disparado um método. Nesse método, conseguimos fazer uma solicitação para o servidor para obter a lista de especialistas. Isso é feito através do método onAppear(), que está na linha 66 do HomeView.swift.

No onAppear(), temos a chamada do getSpecialists() dentro da própria View. Então, quando pressionamos a tecla "Command" e clicamos no getSpecialists(), vamos para alinha 18, onde temos a função getSpecialists(). Começaremos apagando toda essa função, que vai da linha 18 a 26, removendo essa implementação da View.

Agora, vamos fazer uma solicitação para o nosso ViewModel, que fará uma solicitação para o servidor. Para isso, retornaremos para o onAppear(), que agora está na linha 58, onde temos um erro, porque esse método não existe mais na HomeView. Sendo assim, mudaremos a implementação.

Como utilizamos uma Throw Function (Função Lançadora) no nosso HomeViewModel, usando a anotação throws, esse método que pode disparar exceção. Para usá-lo na HomeView, precisamos de um do-catch. Portanto, dentro da Task{} do onAppear, criaremos a estrutura do{}catch{}, onde conseguimos chamar nosso ViewModel.

//código omitido

.onAppear {
    Task {
        do {
        
        } catch {
        
        }
    }
}

//código omitido
COPIAR CÓDIGO
Dentro do do, começaremos criando uma constante chamada response, codando let response = try await viewModel.getSpecialists(). Ele vai invocar o método getSpecialists do nosso ViewModel, que fará a requisição para o servidor e, quando estiver pronto, por isso usamos o await, ele preencherá a variável response caso ocorra sucesso. Se tudo correr bem, podemos usar esse resultado como a lista de especialistas que já estávamos utilizando no projeto. Para isso, codamos self.specialists = response, retornando o que o servidor nos devolveu.

//código omitido

.onAppear {
    Task {
        do {
            let response = try await viewModel.getSpecialists()
            self.specialists = response
        } catch {
        
        }
    }
}

//código omitido
COPIAR CÓDIGO
No catch, por enquanto, não trataremos o erro. Vamos apenas exibi-lo no console, usando o print(). No canto inferior direito do XCode tem um botão que, ao clicarmos, abre o console, onde são exibidos os prints que colocamos no código. Isso é bom para devs terem uma noção de se funcionou ou não, mas a ideia é tratar esses erros posteriormente. Por enquanto, nosso print() vai chamar o (error.localizeDescription) para mostrar o erro, caso ele ocorra, e sua descrição.

//código omitido

.onAppear {
    Task {
        do {
            let response = try await viewModel.getSpecialists()
            self.specialists = response
        } catch {
            print(error.localizeDescription)
        }
    }
}

//código omitido
COPIAR CÓDIGO
Para analisarmos se tudo funcionou, faremos build. No centro superior do XCode, consigo visualizar que estou com a aba do iPhone 15 aberta. Então, na coluna da esquerda, vou clicar no botão "Run", que tem o ícone de play e está no canto superior direito da coluna.

[Tela de carregamento com som de circuitos]
Após o carregamento, a tela Home do app carregou e notamos que continua funcionando da mesma forma que estava, ou seja, a refatoração está funcionando. O ganho que tivemos foi realmente tirar a responsabilidade de requisição HTTP da View e colocar isso em um ViewModel.

Esse foi apenas o primeiro caso de uso que pegamos como exemplo sobre boas práticas e porque é bom utilizar um padrão arquitetural no nosso projeto, dividindo as responsabilidades de cada classe no nosso projeto.

A seguir, continuamos.

@@07
Importância do padrão arquitetural

De acordo com a análise que fizemos na primeira aula do projeto VollMed, identificamos alguns débitos técnicos, e iniciamos a discussão sobre o uso de um padrão arquitetural. Marque as alternativas que explicam a importância de um padrão arquitetural no projeto:

Testabilidade
 
Um bom padrão arquitetural facilita a escrita de testes para o aplicativo. Testar partes isoladas do código se torna mais simples, o que é fundamental para garantir a qualidade do software.
Alternativa correta
Separação de responsabilidade
 
Os aplicativos mobile têm várias camadas, incluindo a interface do usuário, a lógica de negócios e o acesso a dados. Um padrão arquitetural ajuda a separar essas preocupações de forma que cada componente tenha uma responsabilidade clara e isolada. Isso torna o código mais organizado e fácil de entender.
Alternativa correta
Desempenho
 
Alternativa correta
Manutenção e Escalabilidade
 
Aplicativos mobile geralmente crescem e evoluem ao longo do tempo. Um padrão arquitetural bem escolhido facilita a manutenção e a escalabilidade do aplicativo. Isso significa que você pode adicionar novos recursos ou fazer alterações sem afetar negativamente outras partes do aplicativo
Alternativa correta
Reutilização de Código
 
Com a separação de responsabilidades, é possível evitar duplicidade de código, e ao invés disso, reaproveitar componentes em diferentes partes do aplicativo.

@@08
Faça como eu fiz: buscando especialistas VollMed

Uma Clínica Médica chamada Vollmed precisa aprimorar seu controle interno de especialistas. Por isso, ela necessita de uma função que possa buscar todos os especialistas cadastrados na sua plataforma.
Usando Swift, crie um tipo struct 'HomeViewModel' que contém um atributo 'service' do tipo 'WebService'. Dentro dessa struct, crie um método assíncrono chamado 'getSpecialists' que vai buscar a lista de todos os especialistas através de 'service'. Este método deve manipular erros e retornar uma lista vazia caso não haja especialistas.

Uma vez que a struct e o método estejam implementados, dentro do método 'onAppear' de 'HomeView', implemente uma task que irá chamar o método 'getSpecialists' do 'HomeViewModel' e atribuirá o resultado à variável 'specialists'. Trate o erro lançado pelo método 'getSpecialists' dentro da task.

Nesse exercício, utilizamos a funcionalidade assíncrona do Swift para buscar uma lista de especialistas de uma clínica médica. Dentro do método 'getSpecialists', utilizamos a cláusula 'do-catch' para tratar quaisquer erros que possam ocorrer ao chamar 'service.getAllSpecialists()'. Caso a chamada seja bem sucedida, retornamos a lista de especialistas. Se não houver especialistas, retornamos uma lista vazia. Se um erro ocorrer, imprimimos uma mensagem de erro e lançamos o erro.
No método 'onAppear' da 'HomeView', criamos uma task assíncrona que chamará o método 'getSpecialists' e tratará qualquer erro lançado por ele.

import Foundation

struct HomeViewModel {
    let service = WebService()

    func getSpecialists() async throws -> [Specialist] {
        do {
            if let fetchedSpecialists = try await service.getAllSpecialists() {
                return fetchedSpecialists
            }

            return []
        } catch {
            print("Ocorreu um problema para obter os especialistas")
            throw error
        }
    }
}

struct HomeView: View {
    var viewModel = HomeViewModel()

    @State private var specialists: [Specialist] = []

     // código omitido ...

    .onAppear {
        Task {
            do {
                let response = try await viewModel.getSpecialists()
                self.specialists = response
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

@@09
O que aprendemos?

Nessa aula, você aprendeu como:
Revisar as estruturas e as implementações feitas nos cursos anteriores, em particular, a aplicação Vollmed, que é um aplicativo para agendamento de consultas médicas.
A identificar os potenciais problemas de escalabilidade e testabilidade quando colocamos muitas responsabilidades, como chamadas HTTP e validações, dentro de uma view.
Entender sobre a importância dos padrões arquiteturais, como MVVM, MVP, Viper e Clean, no desenvolvimento iOS.
Entender o que é o MVVM, sendo ele um padrão arquitetural comum no desenvolvimento iOS, e como este pode ser aplicado para melhorar a organização e a divisão de responsabilidades em nosso projeto.
Analisar sobre a organização das chamadas de APIs e como isso pode afetar a escalabilidade à medida que a aplicação cresce, em especial com o arquivo webservice que centraliza todas as chamadas para APIs.