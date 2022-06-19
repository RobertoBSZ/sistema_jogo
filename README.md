# Trabalho Final: Sistema Jogo
Este projeto é uma aplicação de todos os conceitos fundamentais para a criação de um banco de dados. A partir de um **modelo de entidade relacionamento** (ER) dado (neste caso, um sistema de gerenciamento de jogos), precisamos criar o seu modelo lógico para, então, implementar o sistema em um SGBD. 

O principal objetivo deste projeto está em transformar o modelo ER em lógico, seguindo o processo de **normalização** para garantir a melhor consistência e menor redundância do sistema. O SGBD escolhido foi o [PostgreSQL](https://www.postgresql.org "Página Inicial do PostgreSQL")

Este projeto foi desenvolvido em um grupo de 6 (seis) pessoas:
- [André Melotti](https://github.com/AndreMelotti "Perfil do André Melotti"),
- [Lucas Zanon](https://github.com/marsh090 "Perfil do Lucas Zanon"),
- [Pedro Lima](https://github.com/PedroLimaCarari "Perfil do Pedro Lima"),
- [Roberto Bastos](https://github.com/RobertoBSZ "Perfil do Roberto Souza"),
- [Vitor Motta](https://github.com/OCVitin "Perfil do Vitor Motta"),
- [Yuri Soares](https://github.com/yurisoaresm "Perfil do Yuri Soares").

Também foi **orientado** por: [prof. Abrantes Araújo S. Filho](https://github.com/abrantesasf "Perfil do prof. Abrantes Araújo S. Filho").

Este documento explica como o projeto foi planejado, adaptado e implementado.

## 1. Modelo Conceitual 
O modelo de ER traz todas as informações de como o projeto funciona na realidade. Ele serve de base para a futura implementação do banco completo e é obtido diretamente através do cliente. Nele deve estar presente as principais entidades (tabelas), os principais relacionamentos e cardinalidade, e os atributos conforme suas características particulares (simples, composto, multivalorado, ...) Neste trabalho, o modelo apresentado foi o **sistema de jogo**, elaborado pela professora **Eliana Caus Sampaio** no [BrModelo](https://github.com/brmodeloweb/brmodelo-app "Repositório no GitHub do BrModelo").

## 2. Modelo Lógico
O modelo lógico é uma adaptação do modelo de alto nível para um conceito de modelo utilizado no SGBD que neste caso é o **modelo relacional de dados**. Assim, as entidades viram tabelas (ou relações), os tipos de dados dos atributos são definidos, relações são criadas e outros elementos são adicionados conforme a necessidade. A ferramenta usada aqui para criá-lo foi o [SQL Power Architect](http://www.bestofbi.com/page/architect "SQL Power Architect"). Neste repositório há dois arquivos para visualizá-lo: [o arquivo em PDF](https://github.com/RobertoBSZ/sistema_jogo/blob/master/sistema_jogo.pdf "Modelo lógico do projeto em PDF") e o em formato padrão do Power Architect (para ser aberto com o programa).

### 2.1 Sobre o Projeto
O Sistema Jogo gerencia vários aspectos que envolvem a criação de um ou mais jogos. Há a necessidade de guardar as configurações de cada jogo (configurações e personalizações), os níveis de cada, objetos dos mapas, cenários, personagens, missões e músicas. Além disso, também salvaremos as informações básicas dos jogadores, como seu nome, apelido, data de criação da conta e localização.

### 2.2 Regras de Normalização
Antes de criar o modelo lógico, é preciso saber que esse processo é algo extramamente complexo. É preciso entender bem como cada entidade funciona e seus relacionamentos, bem como também o que cada atributo representa. Uma vez feito isso, é importante seguir um **padrão** para garantir que o banco de dados seja implementado com o mínimo de redundância possível, ou seja, tenha consistência. Para tanto, existem regras de **normalização** para chegar a uma forma íntegra do sistema. Aqui usamos a **primeira forma normal**, que é obtida seguindo as seguintes condições:

1. *Em geral*, cada entidade será transformada numa tabela;
2. Relacionamentos *1:1* e *1:N* não serão transformados em tabelas;
3. Relacionamentos do tipo *N:N* serão transformados em tabelas;
4. Atributos *semelhantes* devem ser consistentes (mesmo *datatype* e *domínio*);
5. a. *Não pode* existir atributos multivalorados;
b. *Não é recomendado* manter atributos compostos;
c. Identificar *informações/atributos* que podem ser transformados em ***tabela de validação***.

### 2.3 Relacionamentos
Conforme visto no [modelo lógico no repositório](https://github.com/RobertoBSZ/sistema_jogo/blob/master/sistema_jogo.pdf "Modelo lógico do projeto em PDF"), a maioria dos relacionamentos são do tipo N:N ("compoem", "envolvem", "personalizacoes", "consomem", "partidas", "realizam"). Conforme o item 3 de normalização supracitado, essas relações se tornam tabelas.

Uma relação comum que envolve 1:N é entre a tabela "jogos" e "niveis". Por isso, não há uma tabela representando essa relação, conforme o item 2 de normalização.

### 2.4 Tabelas de Validação
Servem para criar evitar que um atributo seja inserido manualmente por um usuário. Criamos muitas delas usando um código de identificação para cada atributo que queremos. Por exemplo, na tabela "background" ligada à "configuracoes", criamos uma PK chamada "codigo_imagem" e um outro atributo que é a imagem em si. Na tabela "configuracoes", ligamos ela por meio de uma FK que é o código da imagem. Ao escolher um determinado código (definido na inserção dos dados pelo desenvolvedor), uma imagem específica será retornada. No programa, a imagem pode ser retomada por meio de um menu de seleção (dropbox) ou coisa do gênero. 

Entre outras tabelas, temos: "cores", "musicas", "local_pais", "local_uf" e "sprites".

### 2.5 Tipos de Dados
Os nomes de um modo geral não são muito grandes, como o nome do cenário e níveis. Optamos por manter o VARCHAR de tamanho 100 nesses casos. Algumas exeções estão, por exemplo, no atributo "descricao" na tabela "objetos", cujo tamanho é 700. Datas possuem o padrão DATE e horas TIME. Os códigos que **não são das tabelas de validação** são CHAR(3), porque é uma combinação entre letras (26) e algarismos (10), totalizando 36³ = 46656 combinações. Os códigos da tabela de validade são do tipo INTEGER. As imagens também são VARCHAR(100), pois a ideia é de que sejam armazenadas o caminho para a raíz da imagem dentro da pasta do jogo.

### 2.6 Adaptações
O modelo ER apresentado foi criado exclusivamente para este trabalho; portanto, não se trata de uma aplicação direta para uma empresa. Caso fosse, o correto seria esclarecer todas as dúvidas diretamente com o cliente. Porém aqui nos foi dado uma liberdade para interpratarmos algumas características do sistema conforme nosso melhor juízo.

Um exemplo disso está na entidade local. A localização *precisa* do jogador não é algo muito importante para um sistema de jogos, mas sua região sim, porque em um jogo seria mais fácil para encontrar pessoas próximas. Nisso, a entidade local se transformou em "local_pais" (representando o país do jogador) e "local_uf" (indicando o estado em que mora). Também são opcionais, então não é obrigatório guardar essas informações caso o usuário não queira.

Outras modificações estão na tabela de relacionamento "personalizacoes". Retirmamos os atributos "cor" e "brilho", sabendo que eles já estão na tabela "configuracoes". Não sabemos também ao certo a diferença entre "volume" (em "configuracoes") e "som" (em "personalizacoes"). Por isso, optamos por deixar um como a música do menu e outro como o volume geral do jogo (não existe outras opções de volume, como volume dos efeitos, volume de voz, etc.).

### 3. Implementando o modelo no PostgreSQL
A primeira parte do script é garantir que ele possa ser rodado diversas vezes. Para tanto, as opções de DROP USER e DROP DATABASE ficam no topo, para evitar conflito com o programa anterior.

Todo o [script](https://github.com/RobertoBSZ/sistema_jogo/blob/master/sistema_jogo.sql "Script do Projeto") foi documentado com comentários. O comando *echo* exibe uma mensagem acerca do que está sendo feito quando ele for executado via terminal. Cada atributo e tabela também tem seus comentários por meio do comando `COMMENT ON` do PostgreSQL.

Não é recomendável usar o usuário padrão do SGBD para realizar tarefas no banco de dados. Portanto, criamos um usuário (ocvitin) com permissões para se conectar e criar banco de dados, com senha '123' (evidentemente a senha é apenas para teste) e sem a permissão de superusuário. 

Em seguida criamos o banco de dados do projeto, chamado **sistema_jogo**, com codificação de caracteres UTF-8. Junto a ele também criamos um esquema onde armazenaremos as tabelas do projeto. Não é bom misturar projetos em um mesmo esquema; caso exista duas tabelas com o mesmo nome, por exemplo, haverá conflito e não será possível especifical qual delas queremos consultar. O esquema que criamos chama-se **jogo**.

Ainda não estamos no esquema criado. Portanto, tudo que for criado continuará no "public" (esquema padrão). Antes de prosseguirmos será preciso alterar o esquema atual para o desejado executando o comando seguinte:

    SET SEARCH_PATH TO <nome do esquema>, "$user", public;

Pronto. Tudo que for feito no banco de dados sistema_jogo será salvo no esquema "jogo". Contudo, sempre que nos reconectarmos a esse banco de dados com o usuário criado o esquema voltará a ser o "public". Para resolver esse problema, use o comando abaixo (ele irá definir o esquema "jogo" sempre como padrão para o usuário):

    ALTER USER <nome do usuário> SET SEARCH_PATH TO <nome do esquema>, "$user", public;

Após isso, criamos as tabelas com seus atributos e comentários. No final do script colocamos todas as *Foreign Keys* do projeto.
