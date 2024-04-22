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


#### 20/04/2024

@02-Separação de responsabilidade

@@01
Projeto da aula anterior

Você pode revisar o seu código e acompanhar o passo a passo do desenvolvimento do nosso projeto e, se preferir, pode baixar o projeto da aula anterior.
Bons estudos!

@@02
Separando responsabilidades com MVVM

De volta com o nosso projeto, já temos o primeiro caso de uso, onde começamos a aplicar o MVVM. Criamos o arquivo HomeViewModel, onde temos o método getSpecialists(). Tiramos da View essa responsabilidade e colocamos no ViewModel.
Vamos abrir a pasta Views no explorador à esquerda e vamos abrir o arquivo HomeView novamente, porque ainda temos mais um caso de uso que precisamos refatorar.

Refatorando Outro Caso de Uso
Em seu interior, na linha let response = try await viewModel.getSpecialists(), temos a chamada para o nosso ViewModel, onde buscamos os especialistas. Um pouco mais abaixo, entre as chaves do bloco Task, temos a linha await logout() com outra chamada para a API que está dentro do arquivo HomeView.

Isso fere os princípios de responsabilidade que começamos a estudar aqui no curso. A ideia é deixar tudo que for de API dentro do ViewModel. E não só isso, o ViewModel pode ser utilizado para fazer verificações ou validação de regras de negócio. No nosso caso de uso atual, estamos tratando apenas as chamadas de API.

Na linha await logout(), se pressionarmos a tecla "Command" e clicar no método logout(), ele nos levará ao bloco func logout() async, no qual a lógica para fazer o logout está implementada. A ideia é apagar todo esse bloco depois que o colocarmos no ViewModel.

Vamos abrir novamente o arquivo HomeViewModel. Após a chave que encerra a implementação do método getSpecialists(), vamos pressionar "Enter" duas vezes. Nessa nova linha, vamos começar a refatoração adicionando o método de logout. Vamos criar uma nova função chamada logout(). Ela será uma função onde utilizaremos o Async/Await, então temos que adicionar a anotação async.

Quando chamamos os métodos, todos eles têm a anotação throws, então vamos ter que utilizar o método do-catch para verificar se a requisição contém erro ou não. E importante entender a assinatura do método para chamá-lo corretamente.

Entre as chaves do método novo, precisaremos da anotação do-catch. Entre as chaves do catch, vamos continuar apenas imprimindo o erro com um print(). Vamos colocar entre parênteses, por exemplo: "Ocorreu um erro no logout". Podemos concatenar o erro para ficar mais fácil de entender o que aconteceu. Para isso, vamos passar dois pontos e um \(error).

Entre as chaves do do, vamos começar criando uma constante, chamada response. Ela será igual à tentativa de solicitação que faremos, que está na classe Service. Então, adicionaremos try await service.logoutPatient().

func logout() async {
    do {
        let response = try await service.logoutPatient()
    } catch {
        print("ocorreu um erro no logout: \(error)")
    }
}
COPIAR CÓDIGO
Temos com isso uma chamada para uma API que faz o logout da pessoa usuária.

Abaixo da variável response, vamos usar a mesma lógica que temos na HomeView, por isso, vamos voltar a esse arquivo para verificá-la de novo.

Na HomeView, temos um if. Em seu interior, se o logout funcionar, vamos primeiro remover o token da pessoa usuária e, depois, remover esse PatientID.

func logout() async {
    do {
        let logoutSuccessful = try await service.logoutPatient()
        if logoutSuccessful {
            authManager.removeToken()
            authManager.removePatientID()
        }
    } catch {
        print("Ocorreu um erro no logout: \(error)")
    }
}
COPIAR CÓDIGO
Então vamos copiar as linhas authManager.removeToken() e authManager.removePatientID(), voltar ao nosso ViewModel e colá-las entre as chaves de um if response, abaixo da variável response.

func logout() async {
    do {
        let response = try await service.logoutPatient()
        if response {
            authManager.removeToken()
            authManager.removePatientID()
        }
    } catch {
        print("ocorreu um erro no logout: \(error)")
    }
}
COPIAR CÓDIGO
Temos então a implementação do método de logout. Ele não está encontrando esse authManager colado, do qual temos referência na View. Vamos voltar ao arquivo HomeView e procurar pela variável authManager que está abaixo da variável service, no topo do arquivo.

struct HomeView: View {

    let service = WebService()
    var authManager = AuthenticationManager.shared
    
// Código omitido
}
COPIAR CÓDIGO
Vamos recortar a linha var authManager = AuthenticationManager.shared com "Command+X", voltar ao HomeViewModel e colar essa referência abaixo da linha do Service ( let service = WebService().

struct HomeViewModel {

    // MARK: - Attributes

    let service = WebService()
    var authManager = AuthenticationManager.shared
    
// Código omitido
}
COPIAR CÓDIGO
Vamos descer até o final do arquivo para verificar que o erro parou. Agora está tudo certo.

O problema agora é no arquivo HomeView, no qual precisamos apagar todo o método de logout. Faz parte deste caso de uso apagar o método de logout, ou seja, estamos tirando da View a responsabilidade do logout.

Com isso, também não precisamos mais do authManager na HomeView, por isso o recortamos. Lembrando que a HomeView é uma View responsável apenas por mostrar os elementos visuais na tela.

Na linha await logout() da HomeView, temos um erro porque o método logout() não é mais encontrado, pois o apagamos. Ele não está mais diretamente na View, e sim em viewModel.logout(). É isso que vamos escrever nessa linha.

struct HomeView: View {

// Código omitido

    var body: some View {
        // Código omitido
        
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    Task {
                        await viewModel.logout()
                    }
                // Código omitido
                })
            }
        }
        
        // Código omitido	
    }

// Código omitido

}
COPIAR CÓDIGO
Temos o método de logout no arquivo HomeViewModel. Agora precisamos testá-lo e ver se continua funcionando, porque faz parte do processo: fazemos a refatoração e depois testamos para ver se está tudo funcionando.

Vamos executar o projeto clicando no botão "Play" na barra de ferramentas superior, no canto superior direito da aba do navegador. Com isso, vamos gerar um Build e subiremos o simulador.

Em seu interior, na parte superior direita, temos o botão de logout. Quando clicarmos nele, chamaremos o ViewModel e o método de logout. Então vamos fazer esse teste. Após o clique, ele voltou para a Home, ou seja, ele realmente removeu o token e apagou o PatientId.

Com isso concluímos mais um caso de uso e o primeiro tópico deste curso, que é entender a separação de responsabilidade entre a View, o Model e as regras de negócio. Para isso, fizemos uso de um padrão arquitetural chamado MVVM, ou seja, começamos a utilizar o MVVM em nosso projeto.

Vamos acessar o arquivo WebService pela aba do navegador. O próximo assunto que vamos tratar são as requisições que temos nesse arquivo. No início deste curso, começamos a questionar o problema de ter todas as requisições em um único arquivo.

A ideia é começar a melhorar essa separação de responsabilidade dentro do nosso projeto em relação aos métodos que fazem a requisição. Nesse código, temos muitas linhas repetidas, e vamos entender como podemos otimizar isso no próximo vídeo.

@@03
Refatorando código: MVVM e chamadas API

Acabamos de criar o nosso ViewModel, no qual implementamos a primeira refatoração do projeto. Vamos abrir novamente o arquivo HomeView, em cujo interior, tínhamos chamadas para APIs diretamente na View.
Começamos a discutir a importância de utilizar um padrão de projeto no nosso aplicativo. Estamos usando o MVVM. Com isso, todas as chamadas para APIs que tínhamos na View foram deslocadas para o arquivo HomeViewModel que criamos.

Vamos abrir esse ViewModel novamente. Em seu interior, estão os dois métodos que tínhamos na View. Essa é a primeira etapa da refatoração.

Outro ponto que comentamos era a duplicação de código que temos na classe WebService. Vamos dar uma olhada nele.

Na linha func logoutPatient(), temos o primeiro método, o método de logout. Entre suas chaves, temos um endpoint, montamos a url e verificamos se há token. Abaixo disso, criamos a requisição na linha var request = URLRequest(url: url) e a enviamos na linha let (_, response) = try await URLSession.shared.data(for: request).

Abaixo desse método, há o de login, na linha func loginPatient(). Entre suas chaves, temos algo parecido: um endpoint, uma url, a criação do URLRequest, a configuração do método da requisição para POST, além do cabeçalho e do corpo da requisição, nos quais estamos enviando os dados de pessoa usuária com jsonData.

Abaixo desse método, por sua vez, temos outro, chamado registerPatient() vemos novamente o endpoint, a url, o URLRequest, o método POST, o cabeçalho e o corpo da requisição. Resumindo, temos muito código duplicado em funções semelhantes. O que muda é o endpoint, entre /auth/logout,/auth/login e /paciente. A maioria das coisas estamos duplicando.

A ideia desta aula é começar a pensar em como podemos melhorar esse código e planejar nosso projeto a longo prazo. Abrindo o simulador, veremos na barra inferior os ícones das duas telas principais: se clicarmos em "Home", acessaremos essa página, que mostra a listagem de médicos e especialistas, em uma lista de cartões vertical. Ao clicar em "Minhas Consultas", veremos essa página, que mostra as consultas agendadas com uma pessoa especialista.

Temos duas telas e várias requisições: cancelAppointment() para cancelar consultas, rescheduleAppointment() para reagendar e getAllAppointmentsFromPatient() para buscar todos os compromissos da pessoa paciente. Podemos imaginar quantas requisições existem em aplicativos com 10, 20 ou 30 telas? Será que é interessante deixar tudo no mesmo arquivo WebService?

À medida que o aplicativo cresce, fica mais difícil encontrar a requisição necessária. Não sabemos que tela utiliza qual requisição, tornando tudo confuso.

Além da reutilização de código, a ideia é separar por funcionalidade (feature), facilitando a identificação de que tela faz qual requisição. Vamos começar a estudar como componentizar isso, criando uma estrutura reutilizável para evitar copiar e colar código, melhorando significativamente a solução.

Componentizando as Requisições
Para começar, vamos criar uma nova camada no nosso projeto. Acessando a aba do navegador de arquivos, na pasta do projeto, vamos criar mais uma pasta chamada "networking", onde colocaremos tudo relacionado a requisições HTTP. Para isso, clicaremos com o botão direito na pasta raiz do projeto, 'Vollmed", selecionaremos "New Group" (novo grupo) e o chamaremos de "Networking".

Vamos selecionar e arrastar essa pasta para baixo das outras que temos dentro de "VollMed". Dentro dessa nova pasta, criaremos mais três pastas que são os componentes que desenvolveremos. Para isso, clicaremos nela com o botão direito e selecionaremos novamente "New Group". A primeira pasta se chamará "Base". Em seguida, criaremos a pasta "Endpoints" e a terceira se chamará "Services".

Vamos reorganizar as três pastas de modo que "Base" fique no topo e "Services" no final. Abaixo temos a estrutura de pastas finalizada, com a qual vamos trabalhar para melhorar o arquivo WebServices e deixá-lo componentizado.

Networking
Base
Endpoints
Services
Dessa forma, teremos uma estrutura que evitará a duplicação de código. No próximo vídeo, começaremos criando o primeiro arquivo, o Endpoint.

@@04
Primeiros passos com camadas de networking

Já temos as pastas da camada de networking (rede) criadas. É hora de criar o primeiro arquivo dentro da pasta "Base".
Criando o Primeiro Arquivo
Clicaremos com o botão direito em cima da pasta "Base" por meio do navegador lateral, selecionando "New File" (novo arquivo). Na janela exibida, vamos escolher a opção "Swift File" (arquivo Swift) e clicar em "Next". No campo "Save as", o nome do arquivo será Endpoint. No canto inferior direito da janela, clicaremos em "Create".

Com isso, veremos que ele trará um arquivo vazio.

//
// Endpoint.swift
// Vollmed

// Created by ALURA on 06/10/23.

import Foundation
COPIAR CÓDIGO
A ideia é separar cada parte de uma requisição para deixar isso mais configurável e evitar a duplicidade de código. Para isso, abaixo do import, vamos criar um protocolo chamado Endpoint.

//
// Endpoint.swift
// Vollmed

// Created by ALURA on 06/10/23.

import Foundation

protocol Endpoint {

}
COPIAR CÓDIGO
Entre suas chaves vamos criar algumas variáveis que são pedaços de uma requisição, e vamos deixar isso configurável de acordo com a necessidade. Primeiro, vamos criar uma variável que vamos chamar de scheme. Ela será do tipo String e, como precisaremos dessa variável, vamos passar um get entre chaves.

Vamos copiar essa linha com "Command+C" e colaremos esse código nas cinco linhas abaixo desta, para ganhar tempo, alterando apenas o nome dessas variáveis para host, path, method, header e body.

No method, temos o método da requisição, que pode ser Get, Put, Post ou Delete. Vamos deixar isso configurável também. Então, o tipo desse method não será String, vamos criar um tipo específico que chamaremos de RequestMethod.

O header é onde podemos enviar informações adicionais em uma requisição. Podemos enviar, por exemplo, o token ou alguma configuração a mais que o back-end solicite. Vamos deixar o tipo dele como chave e valor. Ou seja, vamos abrir um par de colchetes e entre eles escolher um dicionário de String: String.

E, por último, temos o body, com o qual podemos enviar informações no corpo da requisição. O tipo dele também pode ser um dicionário de String: String.

Com isso, temos o scheme, o host, o path, o method, o header e o body.

//
// Endpoint.swift
// Vollmed

// Created by ALURA on 06/10/23.

import Foundation

protocol Endpoint {
   var scheme: String { get }
   var host: String { get }
   var path: String { get }
   var method: RequestMethod { get }
   var header: [String: String] { get }
   var body: [String: String] { get }
}
COPIAR CÓDIGO
Tudo isso foi quebrado em pequenos pedaços para conseguirmos deixar isso mais reutilizável à medida que formos criando as requisições. Por enquanto, ele não vai deixar "buildar" (compilar) o projeto porque não existe esse RequestMethod, mas não tem problema, a seguir vamos criá-lo.

Essa é a estrutura inicial que temos no primeiro arquivo, o Endpoint. E há algumas coisas nele que podemos deixar pré-configuradas, ou seja, coisas que não vão mudar com muita frequência, como o schema e o host. Por isso, vamos criar uma extensão desse protocolo.

Para isso, abaixo do bloco de chaves do protocolo, adicionaremos o bloco extension Endpoint. Entre suas chaves vamos deixar, então, algumas coisas pré-configuradas. Por exemplo, o scheme, que é uma String. Vamos abrir um par de chaves para ele, em cujo interior podemos retornar o valor dela por meio de um return "http" que é um protocolo HTTP.

Utilizamos o protocolo HTTP porque estamos em um ambiente de teste, ou seja, rodando uma aplicação Node que retorna essas informações que estamos exibindo na aplicação. Contudo, se fosse em um ambiente de produção, provavelmente utilizaríamos um HTTPS.

Abaixo do bloco scheme, vamos deixar também pré-configurado o host, que também é uma String. Entre suas chaves, vamos retornar seu valor com aquele que estamos usando aqui: o localhost.

//
// Endpoint.swift
// Vollmed

// Created by ALURA on 06/10/23.

import Foundation

protocol Endpoint {
   var scheme: String { get }
   var host: String { get }
   var path: String { get }
   var method: RequestMethod { get }
   var header: [String: String] { get }
   var body: [String: String] { get }
}

extension Endpoint {
   var scheme: String {
       return "http"
   }
   var host: String {
       return "localhost"
   }
}
COPIAR CÓDIGO
Como isso não será alterado com muita frequência, criamos essa extensão para que toda vez que alguém implementar esse protocolo, já venha com esse valor por padrão. Esse é o primeiro arquivo que criamos da nossa camada de networking. A seguir, vamos continuar com as implementações.

@@05
Os problemas das Views 'massivas' em projetos iOS

Um dos principais problemas que encontramos em projetos em produção, são as chamadas Views 'massivas', ou massive ViewControllers. Por que massive View se torna um problema no projeto?

"Views" massivas são uma prática recomendada em desenvolvimento iOS, pois tornam o código mais eficiente e fácil de gerenciar."Views" massivas são uma prática recomendada em desenvolvimento iOS, pois tornam o código mais eficiente e fácil de gerenciar.
 
Alternativa correta
"Views" massivas são Views em aplicativos iOS que são especialmente grandes em tamanho, o que aumenta o desempenho da interface do usuário.
 
Alternativa correta
"Views" massivas em aplicativos iOS que têm muitas responsabilidades diferentes, como gerenciamento de lógica de interface do usuário, lógica de negócios e chamadas para APIs. Isso é prejudicial porque viola o princípio de separação de responsabilidades e torna o código difícil de entender e manter.
 
"Views" massivas ou seja, que têm muitas responsabilidades diferentes, como gerenciamento de lógica de interface do usuário, lógica de negócios e chamadas para APIs. Isso é prejudicial porque viola o princípio de separação de preocupações e torna o código difícil de entender e manter.
Alternativa correta
"Views" massivas referem-se a telas em aplicativos iOS com muitos elementos de interface do usuário, o que torna a experiência do usuário mais rica e envolvente.

@@06
Para saber mais: evitando a duplicidade de código em Swift - Métodos práticos para código mais limpo e eficaz

Oi, tudo bem? Vamos falar de um assunto muito importante quando trabalhamos com programação: a duplicidade de código. No mundo da programação, precisamos sempre buscar a eficiência e simplicidade no nosso código, correto? Por isso, é tão importante evitar duplicar o mesmo código em diferentes partes do programa.
Agora vem a pergunta: por que devemos evitar duplicidade de código? Simplesmente porque manter muitas cópias do mesmo código pode causar problemas sérios. Imagine que você tenha usado o mesmo bloco de código em 10 lugares diferentes. Se algo precisar ser mudado naquele bloco, você terá que lembrar de todos os 10 lugares para alterar. Além disso, o código duplicado torna o seu programa mais difícil de entender e manter.

Então, como podemos evitar a duplicidade de código em Swift? Aqui estão algumas técnicas práticas!

1. Reutilização de Código
Trata-se de utilizar o mesmo código em diferentes partes do programa. Em Swift, você pode fazer isso, utilizando funções e métodos. Funções ajudam a agrupar blocos de código que realizam uma tarefa específica. Quando você precisa realizar essa tarefa em outra parte do programa, basta chamar a função, ao invés de escrever o mesmo código novamente.

2. Herança e Polimorfismo
Esses são dois conceitos chave na programação orientada a objetos. A herança permite que você crie uma nova classe, conhecida como subclasse, a partir de uma classe existente. A subclasse herda todos os atributos e comportamentos da classe mãe. Isso significa que você não precisa escrever o mesmo código na subclasse. O polimorfismo permite que a subclasse sobrescreva ou estenda o comportamento da classe mãe. Isso evita a duplicação de código, ao permitir que a subclasse tenha sua própria implementação de um método herdado.

3. Protocolos
Um protocolo define um conjunto de métodos que uma classe, estrutura ou enumeração pode adotar. Isso permite que você evite a duplicação de código, ao definir a implementação de um método em um protocolo, ao invés de várias classes.

Gostou dessas dicas? Espero que ajude você a escrever códigos mais limpos e eficientes em Swift. Lembre-se: a simplicidade e a reutilização são fundamentais para um bom código. Continue a praticar e a aprofundar seus conhecimentos em Swift. Você está no caminho certo!

@@07
Faça como eu fiz: implementando MVVM em Swift

A Clínica Médica Voll está tentando aprimorar seu aplicativo móvel para melhor gerenciamento de registros de pacientes e médicos. O aplicativo tem uma tela inicial onde os pacientes podem ver todos os especialistas disponíveis. No entanto, a ação de "logout" está atualmente acoplada à View, ao invés de estar no ViewModel. Sua tarefa é reestruturar o código para aderir ao padrão MVVM, o que significa mover o método de "logout" do View para o ViewModel para melhor separação de responsabilidades. Considere a reutilização do código e o desacoplamento.

Criamos um model 'Patient' que contém as informações pertinentes que precisamos sobre um paciente. Em seguida, definimos uma 'view' que pode exibir um paciente ou um erro. O ViewModel é onde chamamos o serviço web para buscar os dados do paciente e, em seguida, atualizamos a 'view' de acordo. Dessa forma, cada componente tem sua própria responsabilidade: o Model guarda os dados, a View os exibe e o ViewModel os busca.
Finalmente, o código define a View da página inicial, onde a função logout é chamada quando o botão de logout é pressionado.

struct HomeViewModel {

     let service = WebService()
     var authManager = AuthenticationManager.shared

     func logout() async {
         do {
             let response = try await service.logoutPatient()
             if response {
                 authManager.removeToken()
                 authManager.removePatientID()
             }
         } catch {
             print("ocorreu um erro no logout: \\(error)")
         }
     }
}

struct HomeView: View {

     let service = WebService()
     var viewModel = HomeViewModel()

     var body: some View {
         Button(action: {
             Task {
                 await viewModel.logout()
             }
         }, label: {
             Text("Logout")
         })
     }
}

@@08
O que aprendemos?

Nessa aula, você aprendeu como:
Aplicar o padrão Model View ViewModel (MVVM) em projetos de programação, especialmente na refatoração de código, melhorando a organização e manutenção.
Implementar o método GetSpecialists no ViewModel, transferindo sua responsabilidade da View para o ViewModel.
Refatorar o método de Logout, separando suas responsabilidades e transferindo suas funções da View para o ViewModel usando o padrão MVVM.
Entender que o ViewModel não serve apenas para chamadas de API, mas também para validar regras de negócio.
Compreender a importância de testar nosso código após cada refatoração. No vídeo, foi feito isso ao testar a funcionalidade de Logout após sua refatoração e a importância de organizar a estrutura do projeto para facilitar o gerenciamento de requisições, com o foco em aplicações MVVM.

#### 21/04/2024

@03-Camada de networking

@@01
Projeto da aula anterior

Você pode revisar o seu código e acompanhar o passo a passo do desenvolvimento do nosso projeto e, se preferir, pode baixar o projeto da aula anterior.
Bons estudos!

https://github.com/alura-cursos/ios-mvvm-pattern/archive/refs/heads/aula-2.zip

@@02
Manuseando erros em requisições Swift

Anteriormente, criamos o protocolo endpoint e na linha 14 temos um erro, pois não está sendo encontrado o RequestMethod, afinal, ainda não o criamos.
Começaremos esse vídeo criando um menu para representar os diferentes tipos de método do projeto. Vamos lá!

Configurando enums
No menu lateral esquerdo do XCode, clicamos com o botão direito na pasta "base" e depois em "New File". Na janela que abre, selecionamos a opção "Swift File" e clicamos em "Next". Depois, nomeamos o novo arquivo como "RequestMethod" e clicamos no botão "Create".

Ao invés de utilizarmos uma string, criaremos um enum, pois por meio dele conseguimos utilizar o valor que configuramos para cada case evitando erros de digitação, por exemplo.

Após o import Foundation, na linha 10, começaremos criando um enumchamado RequestMethod que será do tipo String. Após adicionamos chaves. Dentro, passamos case delete igual à DELETE, entre aspas duplas, pois é uma string.

Na linha abaixo, escrevemos case get igual à string GET. Em seguida, passamos case patch igual à string PATCH, seguido de case post igual à string POST e case put igual à string PUT. Assim, temos um enum, que é um RequestMethod.

importFoundation

enum RequestMethod: String {
        se delete = "DELETE"
        case get = "GET"
        case patch = "PATCH"
        case post = "POST"
        case put = "PUT"
}
COPIAR CÓDIGO
Endpoint
Se voltarmos ao arquivo Endpoint, agora deve compilar. Pressionamos o comando "Command + B" para fazermos um build e verificar se não há erros. Está tudo funcionando bem. Com isso, fechamos o protocolo de endpoint.

Outro arquivo que precisamos criar na pasta "base" é o de erro. Uma requisição pode ter vários tipos de erro, então mapearemos alguns deles.

Criando o RequestError
Clicamos com o botão direito na pasta "Base" e depois em "New File". Na janela que abre, selecionamos "Swift File" e clicamos no botão "Next", na lateral inferior direita. Nomeamos o arquivo de RequestError e clicamos em "Create".

Na linha 10, criamos um enum chamado RequestError do tipo Error, ou seja, irá representar um erro em uma requisição. Abrimos chaves e dentro criamos o erro case decode, que é quando enviamos ou recebemos um objeto com um tipo diferente do esperado.

Na linha abaixo, passamos case invalidURL, seguido de case noResponse, quando não há resposta. Criaremos também o erro para quando é feito o login sem enviar o token, para isso escrevemos case unauthorized.

Também criamos o erro case unknow, que é desconhecido e o case custom(), nos parênteses passaremos uma mensagem de erro, então escrevemos _error: [String: Any].

Além disso, também podemos deixar pré-definido um valor para cada tipo de erro, caso queiramos uma mensagem. Para isso, na linha 18, criamos a variável customMessage do tipo String {}.

Nas chaves, podemos mapear cada caso de erro que criamos. Então, nas chaves passamos switch self {}. Nas chaves, na linha abaixo, passamos case .decode:. Dentro passamos o retorno de uma mensagem, então return"erro de decodificação".

Na linha 22, escrevemos case .unauthotized. Abaixo passamos return "sessão expirada". Caso não seja nenhum desses erros, passamos também o default que retornará a mensagem erro desconhecido.

import Foundation

enum RequestError: Error {
        case decode
        case invalidURL
        case noResponse
        case unauthorized
        case unknown
        case custom(_ error: [String: Any])

        var customMessage: String {
                switch self {
                case .decode: 
                        return "erro de decodificação" 
                case unauthorized:
                        return "sessão expirada"
                default:
                        return "erro desconhecido "|
        }
}
COPIAR CÓDIGO
Esse é um exemplo de enum que podemos tratar alguns casos de erro em uma conexão. Esse é um template interessante para seu projeto, lembrando que você também pode adicionar outros casos e customizar as mensagens de erro.

Te esperamos no vídeo seguinte!

@@03
Uso de protocolos e generics no Swift

Criamos várias estruturas na pasta base, como o protocolo Endpoint, o RequestMethod em que mapeamos os verbos das requisições, e o enum de erro.
Chegou o momento de juntarmos tudo. Para isso, criaremos o HTTPClient, que é a função que usaremos quando for preciso criar uma requisição.

Criando o HTTPCLient
Novamente, na basta "Base", clicamos com o botão direito e depois em "New File". Na janela que abre, selecionamos "Swift File" e clicamos no botão "Next". Depois, nomeamos o arquivo como HTTPClient e clicamos em "Create".

Esse também será um protocolo, então na linha 10 escrevemos protocol HTTPClient {}. Esse protocolo terá um método que usaremos para, de fato, criar uma requisição.

Então, nas chaves, na linha abaixo, escrevemos func sendRequest. A partir de agora usaremos uma estrutura um pouco diferente do que usamos anteriormente.

Sempre que criamos um método ou uma variável, colocamos um tipo de parâmetro que o método espera receber. Um exemplo seria em sendRequest() passar nos parênteses _ email: String.

Porém, como estamos criando uma estrutura reutilizável, usaremos um recurso chamado Generics. A ideia dos genéricos é utilizar tipos onde não precisamos pré-defini-los na implementação do método e sim quando formos utilizá-lo.

Então, em sendRequest, colocamos o sinal de menor e maior <> e dentro colocaremos T: Decodable. o T significa que é um tipo genérico que precisa implementar o protocolo Decodable, ou seja, quando for utilizar essa função, precisamos passar um tipo que implemente o protocolo Decodable.

Continuaremos escrevendo o nosso método, então, após o sinal de maior, adicionamos parênteses. Dentro, passamos endpoint: Endpoint que é o arquivo que criamos anteriormente. Adicionamos vírgula e passamos responseModel: T.Type. Tudo isso será uma função assíncrona, então, fora dos parênteses, escrevemos async.

Na mesma linha passamos ->. O retorno do método será um Result<> do tipo genérico T ou o erro RequestError.

import Foundation

protocol HTTPClient {
        func sendRequest<T: Decodable> (endpoint: Endpoint, responseModel: T.Type) async -> 
                Result<T, RequestError>
}
COPIAR CÓDIGO
Essa é a estrutura do método sendRequest. A princípio, pode parecer um pouco estranho ao criá-lo pela primeira vez, já que não tem um tipo fixo. Porém, essa é a estrutura do generics.

Na próxima aula descobriremos como utilizar esse método que criamos utilizando os generics. Até lá!

@@04
Todas as requisições em um arquivo

Durante a aula, analisamos o projeto VollMed desenvolvido até o momento. Percebemos que a classe WebService é responsável pela implementação de todos os métodos de requisição do aplicativo. Quais são possíveis problemas que você poderia destacar ao colocar todos os métodos em uma única classe:

Colocar todos os métodos de requisição em uma única classe é uma prática recomendada em desenvolvimento de software, pois facilita o gerenciamento das requisições.
 
Alternativa correta
A classe WebService, apesar de cuidar apenas de requisições http, pode se tornar um arquivo muito grande a medida que o projeto cresce. Ou seja, não é escalável.
 
Esse tipo de implementação pode crescer a medida que o projeto aumentar, o que acarretaria em problemas de manutenção.
Alternativa correta
Concentrar todas as requisições no mesmo arquivo pode prejudicar a escalabilidade do projeto, e dificultaria o entendimento de quais requisições pertencem a quais funcionalidades do projeto.
 
Quando colocamos tudo em um único lugar, se torna muito mais complicado de encontrar e entender o que faz cada requisição no projeto.
Alternativa correta
O arquivo pode ficar muito grande, o que implicaria na demora do tempo de resposta de uma requisição.
 
Parabéns, você acertou!

@@05
Faça como eu fiz: refatorando Clínica Voll com MVVM

A Clínica Médica Voll enfrenta um problema envolvendo o registro de consultas. O código para registro de consultas está misturado no arquivo ConsultaViewController com muita lógica de negócio. Seu objetivo é refatorar o código para o padrão Model-View-ViewModel (MVVM) separando a lógica de negócio da View, aumentando assim a manutenibilidade e a legibilidade do código.
class ConsultaViewController: UIViewController {
    var consulta: Consulta?

    // Lógica de negócios misturada com a vista
    func confirmarConsulta() {
        guard let consulta = consulta else {
            return
        }

        consulta.status = .confirmada
        // .... Código para atualizar UI ....
    }
}

Refatorar o código para o padrão MVVM implica em isolar a lógica de negócio em um ViewModel:
class ConsultaViewModel {
    var consulta: Consulta?

    func confirmarConsulta() {
        guard let consulta = consulta else {
            return
        }

        consulta.status = .confirmada
    }
}

class ConsultaViewController: UIViewController {
    var viewModel: ConsultaViewModel?

    func confirmarConsultaTouchUpInside() {
        viewModel?.confirmarConsulta()
        // Código para atualizar UI
    }
}

@@06
O que aprendemos?

Nessa aula, você aprendeu como:
Criar um protocolo Endpoint em Swift e como corrigir erros comuns que podem surgir nesta etapa.
Criar uma enumeração para diferentes tipos de erros que podem ocorrer durante uma requisição, essencial para um bom gerenciamento de erros.
Personalizar mensagens de erro, permitindo uma melhor interpretação e resolução de problemas.
Criar várias estruturas para organizar o nosso código, incluindo um protocolo endpoint, um request method e um enum de erro.
Criar um HTTP client para realizar requisições. Este é um exemplo prático de como juntar várias partes de código para criar uma estrutura mais complexa.
Utilizar decodable juntamente com genéricos para criar tipos genéricos que implementem um protocolo específico.

#### 22/04/2024

@04-Criando HTTPClient

@@01
Projeto da aula anterior

Você pode revisar o seu código e acompanhar o passo a passo do desenvolvimento do nosso projeto e, se preferir, pode baixar o projeto da aula anterior.
Bons estudos!

https://github.com/alura-cursos/ios-mvvm-pattern/archive/refs/heads/aula-3.zip

@@02
Implementando o protocolo HTTP Client

Agora que já temos a estrutura do nosso método no protocolo HTTPClient, ou seja, o método sendRequest, é hora de implementarmos a lógica desse método.
Implementando a lógica do método
HTTPClient
import Foundation

protocol HTTPClient {
func pendRequest<T: Decodable> (endpoint: Endpoint, responseModel: T.Type) async -> Result<T, RequestError>
}
COPIAR CÓDIGO
Por isso, vamos começar criando uma extensão, extension HTTPClient após o fechamos de chaves. Agora será um trabalho mais intenso, porque teremos que fazer toda a configuração de uma requisição, mas apenas uma vez.

HTTPClient
import Foundation

protocol HTTPClient {
func pendRequest<T: Decodable> (endpoint: Endpoint, responseModel: T.Type) async -> Result<T, RequestError>
}

extension HTTPClient {

}
COPIAR CÓDIGO
Clicando na classe WebService do lado esquerdo, temos, por exemplo, no método logout, a mesma implementação várias vezes em vários métodos de requisição.

WebService
// código omitido

func logoutPatient() async throws -> Bool {
let endpoint = baseURL + "/auth/logout"

guard let url = URL(string: endpoint) else {
print("Erro na URL!") 
return false
}

guard let token = authManager.token else {
print("Token não informado!")
return false
}
var request = URLRequest(url: url)
request.httpMethod = "POST" 
request.addValue("Bearer \(token), forHTTPHeaderField: "Authorization")

let (_, response) = try await URLSession.shared.data(for: request)

if let httpResponse = response as ? HTTPURLResponse, httpResponse.statusCode == 200 {
return true
}
return false
}

// código omitido
COPIAR CÓDIGO
Então, no método da linha 41 de loginPatient(), como já analisamos anteriormente, temos várias implementações iguais. A ideia da classe do nosso protocolo HTTP Client, vamos abri-lo aqui novamente, é implementarmos uma única vez e depois reutilizá-la.

Dentro de extension ficará a implementação do método sendRequest(). Aqui ele não está dando autocomplete, mas para ganhar tempo podemos copiar a linha 11 e vamos colá-la dentro de extension HTTPClient{}. A única diferença é que agora iremos abrir e fechar chaves para colocarmos dentro a implementação.

Por enquanto, temos:

HTTPClient
import Foundation

protocol HTTPClient {
func pendRequest<T: Decodable> (endpoint: Endpoint, responseModel: T.Type) async -> Result<T, RequestError>
}

extension HTTPClient {
func pendRequest<T: Decodable> (endpoint: Endpoint, responseModel: T.Type) async -> Result<T, RequestError> {

}
}
COPIAR CÓDIGO
Iniciaremos criando na linha 17 uma variável que se chamará UrlComponents e ela será igual à classe que temos UrlComponents. Instanciamos o UrlComponents e a partir dele conseguimos criar vários pedaços da URL para depois ele formatar e virar uma única URL.

Na linha seguinte, podemos chamar UrlComponents.scheme, que será igual a algo que veremos. Podemos pegar aqui UrlComponents.host, que é igual a algum valor que vamos atribuir.

HTTPClient
import Foundation

protocol HTTPClient {
func pendRequest<T: Decodable> (endpoint: Endpoint, responseModel: T.Type) async -> Result<T, RequestError>
}

extension HTTPClient {
func pendRequest<T: Decodable> (endpoint: Endpoint, responseModel: T.Type) async -> Result<T, RequestError> {

var UrlComponents = UrlComponents()
UrlComponents.scheme = 
UrlComponents.host = 
}
}
COPIAR CÓDIGO
Parece que já vimos uma estrutura que tem scheme, que tem host, que tem path. Vamos analisar o arquivo Endpoints dentro da pasta Base. Então, vamos abrir novamente o nosso protocolo.

Endpoints
import Foundation

protocol Endpoint {
var scheme: String { get } 
var host: String { get }
var path: String { get }
var method: RequestMethod { get}
var header: [String: String] { get }
var body: [String: String] { get}
}

extension Endpoint {
var scheme: String { 
return "http" 
}
var host: String {
return "localhost" 
}
}
COPIAR CÓDIGO
Agora é hora de utilizarmos exatamente essa estrutura que criamos, que é configurável, uma única vez dentro do nosso protocolo. Voltando ao arquivo HTTP Client.

Tudo o que fizemos até agora vamos usar nesse UrlComponents. E ele será igual ao endpoint que estamos recebendo por parâmetro na linha 15. Copiamos então o endpoint e iremos utilizá-lo na linha 18. endpoint.scheme.

Na linha 19, endpoint.host. Na linha seguinte, temos que terminar de configurar o nosso UrlComponents. Depois de host, na linha 20, configuramos o path, que é igual ao endpoint.path. Na linha 21, digitamos UrlComponents. Repare que no nosso caso, por estarmos rodando a aplicação localmente, usamos isso na porta 3000.

HTTPClient
import Foundation

protocol HTTPClient {
func pendRequest<T: Decodable> (endpoint: Endpoint, responseModel: T.Type) async -> Result<T, RequestError>
}

extension HTTPClient {
func pendRequest<T: Decodable> (endpoint: Endpoint, responseModel: T.Type) async -> Result<T, RequestError> {

var UrlComponents = UrlComponents()
UrlComponents.scheme = endpoint.scheme
UrlComponents.host = endpoint.host
UrlComponents.path = endpoint.path
UrlComponents.
}
}
COPIAR CÓDIGO
Verificando a porta
Abrimos o terminal. Como sabemos que é na porta 3000? O terminal nos mostra quando rodamos o nosso projeto em Node.

server running on port 3000
Portanto, rodamos na porta 3000.

Assim como no arquivo Endpoints, vamos abri-lo. Não especificamos a porta, e é uma boa prática não fazê-lo neste momento. Agora, teremos que configurar a porta no UrlComponents.

Abrimos o HTTP Client novamente. Após o urlComponents, inserimos um .port. Note que precisamos passar um Int, que representa a porta em que estamos executando nossa aplicação. Portanto, vamos passar 3000.

Mas e se não estivermos executando isso localmente? Se estivermos usando um serviço na nuvem? Nesse caso, não será necessário essa linha. Estamos adicionando apenas porque estamos executando isso localmente.

HTTPClient
import Foundation

protocol HTTPClient {
func pendRequest<T: Decodable> (endpoint: Endpoint, responseModel: T.Type) async -> Result<T, RequestError>
}

extension HTTPClient {
func pendRequest<T: Decodable> (endpoint: Endpoint, responseModel: T.Type) async -> Result<T, RequestError> {

var UrlComponents = UrlComponents()
UrlComponents.scheme = endpoint.scheme
UrlComponents.host = endpoint.host
UrlComponents.path = endpoint.path
UrlComponents.port = 3000
}
}
COPIAR CÓDIGO
Configuramos a URL. Agora, de fato, vamos criar essa URL.

Criando a URL
Pulamos uma linha e digitamos guard let url é igual a UrlComponents.url. Se der algum problema na hora de montar a URL, já podemos retornar uma falha. Em seguida, podemos retornar um erro.

HTTPClient
// código omitido

var UrlComponents = UrlComponents()
UrlComponents.scheme = endpoint.scheme
UrlComponents.host = endpoint.host
UrlComponents.path = endpoint.path
UrlComponents.port = 3000

guard let url = UrlComponents.url else {
return 
}
}
}
COPIAR CÓDIGO
Note que na assinatura do nosso método, após o async, na linha 11, temos o retorno do método representado pela seta ->, que é um Result, que pode ser algo genérico <T ou um erro do tipo RequestError.

Criamos esse enum de erro. Vamos abrir o arquivo RequestError no menu lateral esquerdo.

RequestError
// código omitido

enum RequestError: Error {
case decode
case invalidURL
case noResponse
case unauthorized
case unknown
case custom( error: [String: Any])

// código omitido
COPIAR CÓDIGO
E observe que em nosso enum, temos aqui na linha 12 um caso de URL inválida. Podemos utilizar esse caso se não conseguirmos construir a URL. Vamos voltar ao HTTP Client. Então, já poderíamos retornar um erro caso não consigamos criar a URL. Qual é o erro? invalidURL.

Continuando, na linha 27, podemos criar o URLRequest, que criamos em todas as requisições. Então, chamamos de request que será igual a URLRequest. Quando o instanciamos, podemos passar a URL. A URL acabamos de criar na linha 23. Então, iremos utilizá-la aqui na linha 27 passando-a como parâmetro.

HTTPClient
// código omitido

var UrlComponents = UrlComponents()
UrlComponents.scheme = endpoint.scheme
UrlComponents.host = endpoint.host
UrlComponents.path = endpoint.path
UrlComponents.port = 3000

guard let url = UrlComponents.url else {
return .failure(.invalidURL)
}

var request = URLRequest(url: url)

}
}
COPIAR CÓDIGO
No request, também temos algumas configurações adicionais que podemos ajustar. Vamos passar o request.httpMethod, que representa o método da requisição, ou seja, o verbo utilizado: GET, PUT, DELETE.

Para evitar repetições, estamos passando isso como parâmetro. Então, vamos pegar o endpoint.method. Como se trata de um enum e queremos o valor, utilizaremos o .rawValue. Dessa forma, ele acessa o valor específico do enum. Por isso, incluímos esse rawValue.

Além disso, temos também o header disponível, caso queiram passar alguma informação através do header da requisição. Então, em nossa request, utilizaremos a propriedade allHTTPHeaderFields. Vamos definir que ela é equivalente a endpoint.headers.

Para concluir, podemos enviar informações também através do body, ou seja, do corpo da requisição. Então, vamos verificar se há algo que foi fornecido no corpo da requisição. Em nossa implementação, na linha 31, estamos checando se há algo a ser enviado no body da requisição. Portanto, utilizaremos a condição if let body igual a endpoint.body.

HTTPClient
// código omitido

guard let url = UrlComponents.url else {
return .failure(.invalidURL)
}

var request = URLRequest(url: url)
request.httpMethod = endpoint.method.rawValue
request.allHTTPHeaderFields = endpoint.headers

if let body = endpoint.body {

}
}
}
COPIAR CÓDIGO
Como aqui ele não é um opcional, na linha 31, clicamos em cima de body. Seremos redirecionados para a linha 16 do arquivo Endpoint.

Endpoint
// código omitido

var body [String: String] { get }

// código omitido
COPIAR CÓDIGO
Como podemos ter conteúdo ou não no body, no nosso protocolo, vamos deixá-lo opcional. Então, na linha 16, após definirmos o protocolo, o tornaremos opcional adicionando um ponto de interrogação após o fechamento dos colchetes.

Endpoint
// código omitido

var body [String: String]? { get }

// código omitido
COPIAR CÓDIGO
Voltaremos então ao nosso HTTP Client. Se houver conteúdo no body, pegaremos o request.httpBody e o enviaremos através do body. Como fazemos isso? Utilizando try? JSONSerialization.data. Em seguida, passamos isso para o body.

HTTPClient
// código omitido

guard let url = UrlComponents.url else {
return .failure(.invalidURL)
}

var request = URLRequest(url: url)
request.httpMethod = endpoint.method.rawValue
request.allHTTPHeaderFields = endpoint.headers

if let body = endpoint.body {
request.httpBody = try? JSONSerialization.data(withJSONObject: body)
}
}
}
COPIAR CÓDIGO
Por enquanto, ainda está reclamando, porque precisamos retornar o método com um Result, mas ainda não terminamos a implementação. Mas até aqui, é isso que queria mostrar para vocês.

Estamos implementando uma única vez e vamos reutilizar todas as vezes que for necessário com apenas uma implementação. Está dando trabalho, mas estamos criando isso apenas uma vez para depois reutilizar.

Então, continuaremos no próximo vídeo!

@@03
Tratando respostas do servidor

Agora que temos tudo o que precisamos para, de fato, enviar a requisição para o servidor, vamos terminar a implementação desse método sendRequest utilizando todas as configurações que já estávamos fazendo.
HTTPClient
// código omitido

guard let url = UrlComponents.url else {
return .failure(.invalidURL)
}

var request = URLRequest(url: url)
request.httpMethod = endpoint.method.rawValue
request.allHTTPHeaderFields = endpoint.headers

if let body = endpoint.body {
request.httpBody = try? JSONSerialization.data(withJSONObject: body)
}
}
}
COPIAR CÓDIGO
Na linha 35 do arquivo HTTPClient, começaremos, de fato, a enviar tudo isso para o servidor. Como pode ocorrer algum erro por ter a throwFunction dentro desses métodos, começaremos usando um do {} catch{}. Dentro do do{}, criaremos uma constante que terá duas variáveis dentro; chamamos isso de tupla em Swift.

Uma será com os dados (data) e a outra será com a resposta (response). Tudo isso será igual ao try await, e então usaremos a classe URLSession, que já conhecemos dos cursos anteriores. Chamaremos esse método de data, onde passaremos o URLRequest.

HTTPClient
// código omitido

if let body = endpoint.body {
request.httpBody = try? JSONSerialization.data(withJSONObject: body)
}
do {
let (data,response) = try await URLSession.shared.data(for: URLRequest)
} catch {

}
}
}
COPIAR CÓDIGO
**O que é esse parâmetro, o URLRequest? **

São as configurações que fizemos na linha 27. Criamos um URLRequest, passando a url, configuramos o método na linha 28, e se houver cabeçalho (header) na requisição, estamos também passando pelo parâmetro allHTTPHeaderFields. Estamos utilizando tudo isso que configuramos aqui na linha 27 na nossa requisição na linha 36.

HTTPClient
// código omitido

var request = URLRequest(url: url)
request.httpMethod = endpoint.method.rawValue
request.allHTTPHeaderFields = endpoint.headers

// código omitido
COPIAR CÓDIGO
Então, passaremos o request após o for:. Ele tem um segundo parâmetro, que é esse delegate, vamos passar nil, porque não vamos utilizar. Feito isso, faremos uma verificação para analisar se existem valores nessas variáveis, porque com base nisso, conseguiremos saber se a requisição funcionou ou não. Para isso, converteremos o response da linha 36 em um tipo que é o HTTPURLResponse.

Criaremos na linha 38 um guard let, que chamaremos de response, que será igual à resposta que temos na linha 36. Ou seja, verificaremos se há valor, se houver, tentaremos converter para essa classe HTTPURLResponse. Caso não consigamos, significa que já temos aqui o primeiro erro.

Podemos corrigir um erro. O erro consiste em não ter uma resposta; portanto, vamos retornar .failure, passando um erro. Já criamos um enum onde configuramos alguns erros que podem ocorrer em nossa requisição, este é o enum chamado RequestError.

HTTPClient
// código omitido

if let body = endpoint.body {
request.httpBody = try? JSONSerialization.data(withJSONObject: body)
}
do {
let (data,response) = try await URLSession.shared.data(for: request,
delegate:nil)

guard let response = response as? HTTPURLResponse else {
return .failured()
}


} catch {

}
}
}
COPIAR CÓDIGO
No menu lateral esquerdo, temos o arquivo RequestError, e temos um caso de noResponse, e é ele que vamos utilizar lá.

RequestError
// código omitido

case noResponse

// código omitido
COPIAR CÓDIGO
Voltando no arquivo HTTPClient, digitamos .noResponse, na linha 39, então, já temos a primeira validação, se temos uma resposta vinda do servidor ou não.

HTTPClient
// código omitido

if let body = endpoint.body {
request.httpBody = try? JSONSerialization.data(withJSONObject: body)
}
do {
let (data,response) = try await URLSession.shared.data(for: request,
delegate:nil)

guard let response = response as? HTTPURLResponse else {
return .failured(.noResponse)
}


} catch {

}
}
}
COPIAR CÓDIGO
Continuando, com base nisso, conseguimos fazer algumas verificações baseadas no código de status (statusCode).

statusCode: qualquer requisição que fazemos para o servidor, ele devolve uma resposta e um código.
Vamos visualizar os principais códigos aqui, por exemplo, respostas da classe de 200, ou seja, código de status de 200 até 299, já sabemos que geralmente é sucesso. Com base nesses códigos de status, conseguimos fazer algumas validações para garantir a resposta correta para a pessoa usuária.

Como fazemos isso? Vamos criar um switch. Pegaremos a response que foi criada na linha 38 e faremos uma verificação usando response.statusCode. No primeiro caso, o que faremos é o seguinte: no case em que o código estiver entre 200 e 299, sabemos que foi um sucesso.

O que faremos aqui? Vamos extrair o valor retornado pelo servidor e convertê-lo. Em outras palavras, faremos a decodificação desse valor em um objeto que será passado como parâmetro. A razão pela qual configuramos esse método com generics é crucial nesse ponto.

HTTPClient
// código omitido

do {
let (data,response) = try await URLSession.shared.data(for: request,
delegate:nil)

guard let response = response as? HTTPURLResponse else {
return .failured(.noResponse)
}

switch response.statusCode {
case 200…299:
}

} catch {

}
}
}
COPIAR CÓDIGO
Vamos navegar até a definição do nosso protocolo, na linha 11.

HTTPClient
import Foundation

protocol HTTPClient {
func pendRequest<T: Decodable> (endpoint: Endpoint, responseModel: T.Type) async -> Result<T, RequestError>
}

// código omitido
COPIAR CÓDIGO
Nesta instância, precisamos receber um tipo, que não é especificado, pois é genérico. Isso significa que podemos usar qualquer tipo, contanto que ele implemente o protocolo Decodable.

Por que realizamos essa ação? Porque é essencial empregar esse protocolo para transformar o que o servidor nos enviou no objeto que estamos recebendo nesta situação. Embora não saibamos precisamente qual é esse objeto, temos a certeza de que ele deve obedecer a uma restrição específica, que é a implementação do protocolo Decodable.

Dessa forma, tornamos nosso método altamente reutilizável, pois não é preciso definir um tipo específico; em vez disso, optamos por um tipo genérico. Isso proporciona uma flexibilidade notável.

Retornando à linha 44, vamos tentar realizar essa conversão do que o servidor nos devolveu, ou seja, decodificar para o objeto que recebemos por parâmetro. Então, guard let, iremos denominar isso de responseModel, que é igual ao responseModel presente na assinatura do nosso método.

Se não conseguirmos obter esse valor, significa que nosso método é um get, por exemplo, não o obtém, ou seja, não estamos aguardando nenhum objeto para a decodificação. Nesse caso, o que podemos fazer? Simplesmente dar um return .success, mas sem passar nenhum valor.

Minha requisição não necessita que passe nenhum parâmetro.

HTTPClient
// código omitido

do {
let (data,response) = try await URLSession.shared.data(for: request,
delegate:nil)

guard let response = response as? HTTPURLResponse else {
return .failured(.noResponse)
}

switch response.statusCode {
case 200…299:
guard let responseModel = responseModel else {
return .success(nil)
}

}

} catch {

}
}
}
COPIAR CÓDIGO
Aqui estamos reclamando que não podemos passar nil, mas podemos alterar a definição do método como opcional adicionando um ponto de interrogação após o Type das linhas 11 e 15.

HTTPClient
import Foundation

protocol HTTPClient {
func pendRequest<T: Decodable> (endpoint: Endpoint, responseModel: T.Type?) async -> Result<T, RequestError>
}

extension HTTPClient {
func pendRequest<T: Decodable> (endpoint: Endpoint, responseModel: T.Type?) async -> Result<T, RequestError> {

}
}
COPIAR CÓDIGO
Por que opcional? Por exemplo, se estivermos fazendo uma requisição do tipo get, não precisamos devolver um objeto, um modelo de resposta. Podemos apenas indicar que a requisição foi bem-sucedida, sem precisar devolver nenhum objeto.

No entanto, no caso de uma requisição do tipo post, precisamos realmente realizar a decodificação desse objeto. Portanto, ainda falta essa etapa, e vamos abordar isso no próximo vídeo.

Até mais!

@@04
Implementação de decodificação de respostas

Continuando, acabamos de tratar o caso onde a requisição retorna 200, mas não precisamos enviar nenhum objeto, nem retornar nenhum objeto decodificado. Esse é o primeiro caso de 200.
HTTPClient
// código omitido

do {
let (data,response) = try await URLSession.shared.data(for: request,
delegate:nil)

guard let response = response as? HTTPURLResponse else {
return .failured(.noResponse)
}

switch response.statusCode {
case 200…299:
guard let responseModel = responseModel else {
return .success(nil)
}

} catch {

}
}
}
COPIAR CÓDIGO
Temos também outro caso de erro 200, que ocorre quando fazemos uma requisição e o servidor devolve um JSON ou um formato binário, e precisamos converter isso para um objeto que temos no projeto, ou seja, precisamos fazer a decodificação. Neste caso, realmente precisamos devolver um objeto.

Decodificando o objeto
Então, qual será nosso próximo passo? Vamos criar um guard let para lidar com esse caso de resposta decodificada, decodeResponse. Usaremos o JSONDecoder na linha 49. Vamos instanciar e chamar o método decode.

Neste método, precisamos passar um objeto e os dados que o servidor retornou. Já temos o objeto, que é esse modelo de resposta genérico (responseModel). Então, esta é a parte interessante, porque na assinatura do método, na linha 15, solicitamos um responseModel genérico como parâmetro e agora o usaremos para realizar essa decodificação.

Vamos passar o responseModel em decode(). E em relação à data, vamos passar os dados que temos, localizados na linha 36. Criamos essa tupla.

O que faremos com isso? Se não funcionar, ou seja, se entrarmos no bloco else, retornaremos um erro. Então, faremos return .failure e passaremos um erro de decodificação, se ocorrer falha.

Se funcionar, retornaremos, de fato, o objeto decodificado. Portanto, usaremos .success e passaremos o response decodificado (decodeResponse).

HTTPClient
// código omitido

do {
let (data,response) = try await URLSession.shared.data(for: request,
delegate:nil)

guard let response = response as? HTTPURLResponse else {
return .failured(.noResponse)
}

switch response.statusCode {

case 200…299:
guard let responseModel = responseModel else {
return .success(nil)
}

guard let decodeResponse = try? JSONDecoder().decode(responseModel,
from: data) else {
return .failured(.decode)
}

return .success(decodeResponse)

} catch {

}
}
}
COPIAR CÓDIGO
Esse é o caso de sucesso.

Tratando os erros
Temos também a possibilidade de lidar com casos de erro. Por exemplo, um erro comum é o 401. Mapearemos esse erro também. O erro 401 ocorre quando a pessoa usuária não tem autorização para realizar uma determinada requisição.

Por exemplo, algum endpoint onde precisamos do token da pessoa usuária, ou seja, quando ela faz o login, ela guarda um token e esse token é uma chave de acesso que pode ser utilizada para obter algumas informações no aplicativo.

Se não enviarmos esse token no header de uma requisição, o servidor pode devolver um erro 401 de não autorizado. Esse é um caso clássico onde temos um erro de não autorizado. A pessoa usuária não está autorizada a pegar determinado recurso do servidor.

Existem vários status codes. Estamos passando pelos principais, incluindo o erro 400. O erro 500 ocorre quando há algum problema de implementação no back-end.

Como não vamos abordar todos eles, vamos estabelecer um default para lidar com erros que não estejam na faixa de 200 a 299, conforme indicado na linha 44, e também para o erro 401, que foi mapeado na linha 54.

Optaremos por enviar um erro padrão. Dessa forma, iremos reportar uma falha, por exemplo, um erro desconhecido, para conseguirmos mapear a nossa ocorrência. É necessário fechar mais uma chave. Portanto, após a linha 58, iremos encerrar o nosso switch case.

HTTPClient
// código omitido

switch response.statusCode {

case 200…299:
guard let responseModel = responseModel else {
return .success(nil)
}

guard let decodeResponse = try? JSONDecoder().decode(responseModel,
from: data) else {
return .failured(.decode)
}

return .success(decodeResponse)

case 401:
return .failure(.unauthorized)

default:
return .failure(.unknown)
}

} catch {

}
}
}
COPIAR CÓDIGO
Para finalizar essa implementação, temos o catch na linha 61, onde também precisamos retornar um erro, porque a tentativa de fazer a requisição falhou, e precisamos informar isso para o método que invocou essa função.

Vamos dar um return failure, e também pode ser uma falha desconhecida, e conseguimos tratar isso de diversas maneiras. Vamos apagar esse espaço na linha 64.

O código ficou um pouco extenso, como vocês puderam visualizar nesses últimos vídeos, mas o mais interessante é que implementamos ele uma única vez, e agora sempre que precisarmos, vamos conseguir reutilizar isso sem precisar ficar copiando e colando o código.

HTTPClient
// código omitido

} catch {
return .failure(.unknown)
}
}
}
COPIAR CÓDIGO
Para verificar se está tudo funcionando, teclamos "Command + B".Compilou com sucesso. Vamos rodar o simulador clicando com o botão no ícone de play na parte superior.

No simulador exibido, há o logotipo da VollMed na parte superior central, a mensagem de boas-vindas e abaixo a lista de especialistas. No canto superior direito há o botão "logout".

Temos então uma estrutura onde podemos reutilizar bastante parte do código da criação de uma requisição.

Próximos Passos
O próximo passo é de fato criar um endpoint, usando tudo isso que fizemos até agora, e começar a refatoração no nosso projeto.

Vamos aprender isso a seguir!

@@05
Organizando o projeto com endpoints

Transcrição

Para finalizar essa aula, vamos utilizar tudo o que construímos até agora.Desde o HTTPClient, que terminamos no último vídeo, o RequestMethod, o RequestError e o Endpoint, todos esses arquivos que estão dentro da pasta Base de Networking.
Vamos juntar para começar a organizar nosso projeto em relação ao arquivo WebService, que é aquele que tem todas as requisições.

Na pasta networking, trabalhamos bastante na Base, criando os quatro arquivos, e agora vamos começar a criar o primeiro endpoint.

Criando o primeiro endpoint
Neste momento, você vai começar a enxergar valor, de fato, em tudo isso que fizemos até esse momento. Conseguimos, a partir de agora, começar a separar os endpoints por feature, ou seja, por funcionalidade no nosso projeto.

No arquivo WebService, agrupamos todas as APIs em um único arquivo. Daqui em diante, vamos organizá-las por funcionalidade.

Dessa forma, se novas pessoas desenvolvedoras entrarem para trabalhar no projeto, será mais fácil para elas abrir um arquivo que lista todas as chamadas para APIs de uma determinada funcionalidade, em vez de tentar compreender tudo o que está contido em um único arquivo.

Assim, a implementação do nosso projeto começará a se tornar mais eficiente.

Dentro da pasta Endpoints que temos na árvore de pastas do nosso projeto, clicamos com o botão direito para gerar um novo arquivo Swift file. Na sequência selecionamos "Next". O arquivo que vamos criar se chama HomeEndpoint e clicamos em "Create" no canto inferior direito.

HomeEndpoint
import Foundation
COPIAR CÓDIGO
A proposta é que criemos um enum abrangendo todos os métodos relacionados à home, todas as chamadas de API. Vamos desenvolver um enum que chamaremos de HomeEndpoint e, dentro desse enum, incluiremos os diversos cases.

No primeiro caso que temos, vamos abrir o simulador mais uma vez. Pegaremos como exemplo a listagem de médicos. Essa representa a primeira chamada que encontramos na home ao acessarmos nosso aplicativo. É um método que realiza um GET de todos os especialistas. Portanto, fazemos um GET de todos os especialistas.

HomeEndpoint
import Foundation

enum HomeEndpoint {
    case getAllSpecialists
}
COPIAR CÓDIGO
Com este primeiro caso, já podemos colocar em prática o protocolo endpoint que desenvolvemos. Sendo assim, vamos abrir o protocolo, selecionando o arquivo Endpoint no lado esquerdo. Dentro desse protocolo, há várias configurações que podemos ajustar, e é exatamente isso que iremos realizar agora em nosso HomeEndpoint.

Endpoint
// código omitido

protocol Endpoint {
var scheme: String get}
var host: String { get }
var path: String { get }
var method: RequestMethod { get }
var header: [String: String] { get }
var body! [String: String]? { get }
}

// código omitido
COPIAR CÓDIGO
Voltando ao arquivo HomeEndpoint, criaremos uma extension desse protocolo recém-criado, chamado HomeEndpoint, e implementaremos o protocolo Endpoint.

Neste momento, começaremos a compreender o reuso do nosso código. Quando implementamos o protocolo endpoint, percebemos que a nossa extension não está em conformidade com o protocolo endpoint. Em outras palavras, há muitos ajustes que precisamos realizar, e começaremos a abordar essas questões agora.

Há uma mensagem em vermelho escrito:

Type 'HomeEndpoint' does not conform to protocol 'Endpoint'
Selecionamos ela e depois no botão "Fix" e teremos um autocomplete:

HomeEndpoint
import Foundation

enum HomeEndpoint {
    case getAllSpecialists
}

extension Home Endpoint: Endpoint {
var path: String {
code
}
var method: RequestMethod {
code
}
var header: [String: String] {
code
}
var body: [String: String]? {
code
}
COPIAR CÓDIGO
Primeiramente, temos o path. O que precisamos configurar no path? O path representa o final do endpoint responsável por capturar os especialistas. Então, qual será a nossa abordagem?

Dado que há mais de um caso no nosso enum, é crucial realizar essa verificação. Vamos executar um switch no nosso próprio enum e validar. Se estivermos lidando com todos os especialistas, o que faremos? Retornaremos o path, que é uma string.

HomeEndpoint
import Foundation

enum HomeEndpoint {
    case getAllSpecialists
}

extension HomeEndpoint: Endpoint {
var path: String {
switch self {
case .getAllSpecialists:
 return ""
}
}
var method: RequestMethod {
code
}
var header: [String: String] {
code
}
var body: [String: String]? {
code
}
COPIAR CÓDIGO
Vamos revisitar o que precisamos inserir no path do GET para especialistas. Voltaremos ao arquivo webservice. Procuraremos onde está o método que obtém os especialistas. Observe que, mesmo para nós, que trabalhamos no projeto, torna-se um pouco desafiador localizar o GET. Ele está no final, na linha 218. Portanto, esse é o path que utilizaremos nessa classe, nesse enum de endpoint que criamos.

/especialista
Copiamos com "Command + C", na linha 219. Voltaremos à pasta Endpoint, no arquivo HomeEndpoint. O path para o GET de especialistas será /especialista. Assim, configuramos o path.

HomeEndpoint
import Foundation

enum HomeEndpoint {
    case getAllSpecialists
}

extension HomeEndpoint: Endpoint {
var path: String {
switch self {
case .getAllSpecialists:
 return "/especialista"
}
}
var method: RequestMethod {
code
}
var header: [String: String] {
code
}
var body: [String: String]? {
code
}
COPIAR CÓDIGO
Agora, precisamos configurar nosso método. Vamos ter que fazer um switch, porque mais adiante aqui podem haver vários casos.

Na linha 11, temos apenas um caso. No entanto, poderiam existir vários métodos diferentes, com vários endpoints. Portanto, precisamos verificar qual é o endpoint com o qual estamos trabalhando. É por isso que estamos inserindo o switch na linha 23.

Utilizamos o switch do nosso próprio enum, onde verificamos os casos. Se for o caso de GET especialista, retornamos o método GET. No header, não precisamos incluir nada. Assim, ao verificar o nosso enum, se for um GET especialista, não retornamos nada e utilizamos return nil na linha 32.

Quanto ao body, também não é necessário fornecer informações. Assim, aplicamos a mesma verificação com um switch em self. Se for um GET especialista, realizamos return nil.

HomeEndpoint
// código omitido

var method: RequestMethod {
switch self {
case .getAllSpecialists:
return .get
}
}
var header: [String String] {
switch self {
case .getAllSpecialists:
return nil
}
}
var body: [String: String]? { switch self {
case .getAllSpecialists: I
return nil
}
}
COPIAR CÓDIGO
Está apontando um erro na linha 32, porque ele não está deixando retornar nil no header. Vamos entrar, então, de novo no arquivo Endpoint. Na linha 15, realmente, temos um dicionário onde passamos o tipo String: String e ele não aceita opcional.

var header: [String: String] { get }
Então, no final, vamos colocar um ponto de interrogação para aceitarmos esse tipo de valor opcional ou não, já que nem todas as requisições precisamos passar informações no header, por isso, ele pode ser opcional.

Endpoint
var header: [String: String]? { get }
COPIAR CÓDIGO
Vamos voltar ao arquivo HomeEndpoint. Precisamos tornar opcional na linha 29, conforme definimos no protocolo.

HomeEndpoint
// código omitido

var header: [String String]? {
switch self {
case .getAllSpecialists:
return nil
}

// código omitido
COPIAR CÓDIGO
Agora, para testarmos, pressionamos "Command + B" para tentarmos buildar o projeto. Obtivemos sucesso, o que significa que não há nenhum erro de compilação.

Apenas por precaução, vamos gerar um build e subir o simulador para garantir que tudo esteja funcionando corretamente.

Benefícios de organizar por funcionalidade
Observem o benefício que alcançamos. Primeiramente, quando um novo membro junta-se ao nosso projeto, facilita muito ter uma pasta de endpoints, organizada por funcionalidade, para que possam explorar e entender as características.

Por exemplo, desejamos verificar quais são os endpoints da home. Clicamos no arquivo HomeEndpoint e já temos todos os paths. Especialmente para os especialistas em GET, pode haver vários outros em um único arquivo.

Em segundo lugar, temos um template, que é esse endpoint onde reutilizamos todos os elementos que definimos no protocolo Endpoint.

Endpoint
// código omitido

protocol Endpoint {
var scheme: String get}
var host: String { get }
var path: String { get }
var method: RequestMethod { get }
var header: [String: String] { get }
var body! [String: String]? { get }
}

// código omitido
COPIAR CÓDIGO
Em scheme, host, path, method, header e body, conseguimos reutilizar a implementação no arquivo HomeEndpoint. Além de ficar muito mais organizado, conseguimos criar componentes customizáveis e reutilizáveis no nosso projeto.

Conclusão
A ideia desse vídeo foi exatamente essa. Começamos a mostrar para você como tratamos e separamos a responsabilidade dos endpoints de acordo com cada funcionalidade no nosso projeto.

@@06
Generics no protocolo HTTPClient

Conforme desenvolvido em aula, criamos o protocolo HTTPClient:
protocol HTTPClient {
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type?) async -> Result<T?, RequestError>
}
COPIAR CÓDIGO
No exemplo de código fornecido, há um protocolo chamado HTTPClient que faz uso de generics. Qual é o propósito principal de usar generics nesse protocolo?


Alternativa correta
Generics são usados para garantir que o HTTPClient seja compatível apenas com tipos de dados específicos, como inteiros e strings.
 
Alternativa correta
Generics permitem que o HTTPClient retorne resultados de solicitações HTTP em um formato genérico, o que significa que pode lidar com respostas de diferentes tipos de modelos de dados.
 
No protocolo HTTPClient, o uso de generics na função sendRequest permite que a função seja parametrizada com um tipo T que deve ser decodificável (Decodable). Isso significa que o método pode ser usado para enviar solicitações HTTP e receber respostas em qualquer tipo de modelo de dados que seja Decodable, tornando-o genérico e flexível o suficiente para lidar com diferentes tipos de respostas de forma dinâmica. Isso é especialmente útil em cenários onde diferentes endpoints podem retornar diferentes tipos de dados, mas você deseja tratar essas respostas de forma genérica.
Alternativa correta
Generics permitem que o HTTPClient aceite qualquer tipo de endpoint como entrada, independentemente de sua conformidade com protocolos específicos.
 
Ops! Nesse caso, como definimos no inicio do método <T: Decodable>, é obrigatório que quem for implementar esse protocolo, esteja em conformidade com o protocolo Decodable.
Alternativa correta
Generics são usados para permitir que o HTTPClient realize operações de rede de maneira mais eficiente.

@@07
Faça como eu fiz: implementando networking em cadastro de consulta

A Clinica Médica Voll tem crescido e os funcionários estão tendo dificuldades em gerenciar as consultas. Eles precisam de uma forma eficiente de cadastrar as consultas dos pacientes. Como desenvolvedor, sua tarefa é criar uma camada de Networking para o aplicativo. Você precisa refatorar o arquivo ConsultaViewController e separar a lógica de negócios da View aplicando o modelo MVVM.

Aqui nós definimos um protocolo chamado "Endpoint". O protocolo define um contrato que todos os objetos que afirmam implementar o protocolo precisam cumprir. Neste protocolo, estamos estipulando que todos os endpoints precisam ter um caminho (path) e um método HTTP. Então, quando definimos nosso 'AgendarConsultaEndpoint', precisamos fornecer o caminho para o endpoint e o método HTTP que será usado, neste caso POST. Com essa abordagem, cada parte da lógica de nossa aplicação fica em um local específico, facilitando a manutenção do código a longo prazo.
import Foundation

//Criamos um enum para gerenciar os diferentes tipos de métodos HTTP
enum HTTPMethod: String {
    case GET
    case POST
}

//Criamos um protocolo para definir características de um endpoint
protocol Endpoint {
    var path: String { get }
    var httpMethod: HTTPMethod { get }
}

//Criamos um 'struct' para representar o nosso endpoint de cadastro de consulta
struct AgendarConsultaEndpoint: Endpoint {
    var path: String {
        return "/consultas/agendar"
    }
    
    var httpMethod: HTTPMethod {
        return .POST
    }
}

@@08
O que aprendemos?

Nessa aula, você aprendeu como:
Criar um HTTP client para realizar requisições. Este é um exemplo prático de como juntar várias partes de código para criar uma estrutura mais complexa.
Entender o uso de genéricos em Swift para criar estruturas reutilizáveis que não precisam ter seus tipos pré-definidos.
Entender como é possível utilizar decodable juntamente com genéricos para criar tipos genéricos que implementem um protocolo específico.
Realizar verificações nos valores retornados por uma requisição a um servidor para determinar se a requisição funcionou.
Criar arquivos separados para os endpoints, permitindo uma melhor organização e facilitando a compreensão por desenvolvedores que venham a se juntar ao projeto.
