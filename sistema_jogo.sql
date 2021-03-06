
/*
Descrição     : Projeto final da disciplina de Banco de Dados I: 
              : Sistema de Jogos.	
										
Autores       : André Melotti,
              : Lucas Zanon,
              : Pedro Lima,
              : Roberto Bastos,
              : Vitor Motta (OCVitin),
              : Yuri Soares.
Orientador    : prof. Abrantes Araújo Silva Filho.
Versão SGBD   : PostgreSQL 14.2
*/


/* --------------------------------------------------------------------------- */
/* LIMPEZA GERAL:                                                              */
/* --------------------------------------------------------------------------- */
/* Esta seção do script faz uma "limpeza geral" no banco de dados, removendo o */
/* banco de dados "sistema_jogo", se ele existir, e o usuário "ocvitin", se    */
/* ele existir.                                                                */
/* --------------------------------------------------------------------------- */

-- Remove o banco de dados "sistema_jogo", se existir:
\echo
\echo Removendo o banco de dados "sistema_jogo" e o usuário "ocvitin":
DROP DATABASE IF EXISTS sistema_jogo;

-- Remove o usuário "ocvitin", se existir:
DROP USER IF EXISTS ocvitin;


/* --------------------------------------------------------------------------- */
/* CRIA USUÁRIO E BANCO DE DADOS:                                              */
/* --------------------------------------------------------------------------- */
/* Agora que estamos com o banco de dados "zerado", precisamos recriar o       */
/* usuário "ocvitin" e o banco de dados "sistema_jogo".                        */
/* --------------------------------------------------------------------------- */

-- Cria o usuário "ocvitin", que será o dono do banco de dados "sistema_jogo". Por
-- segurança esse usuário não será um super-usuário. E como este é um
-- script de demonstração, usaremos a super-senha "123".
\echo
\echo Criando o usuário "ocvitin":
CREATE USER ocvitin WITH
	NOSUPERUSER
	CREATEDB
	CREATEROLE
	LOGIN
	ENCRYPTED PASSWORD '123';

-- Agora que o usuário já está criado, vamos criar o banco de dados "sistema_jogo" e
-- colocar o usuário "ocvitin" como o dono desse banco de dados. Além disso
-- configuraremos algumas opções de linguagem para o português do Brasil.
\echo
\echo Criando o banco de dados "sistema_jogo":
CREATE DATABASE sistema_jogo WITH
  OWNER      ocvitin
  TEMPLATE   template0
  ENCODING   'UTF8'
  LC_COLLATE 'pt_BR.UTF-8'
  LC_CTYPE   'pt_BR.UTF-8';

COMMENT ON DATABASE sistema_jogo IS 'Banco de Dados do trabalho final para um sistema de jogos.';


/* --------------------------------------------------------------------------- */
/* CONEXÃO AO BANCO SISTEMA_JOGO E CRIAÇÃO DO SCHEMA JOGO:                     */
/* --------------------------------------------------------------------------- */
/* Com o usuário e o banco prontos, faremos a conexão ao banco "sistema_jogo"  */
/* com o usuário "ocvitin" e criaremos o schema "jogo". Também ajustaremos o   */
/* SEARCH_PATH do usuário para manter o scheme "jogo" como o padrão.           */
/* --------------------------------------------------------------------------- */

-- Conexão ao banco "sistema_jogo" como usuário "ocvitin", passando a senha via string
-- de conexão. Obviamente isso só está sendo feito porque é um script de
-- demonstração, não se deve passar senhas em scripts em formato texto puro
-- (existem exceções, claro, mas considere que essa regra é válida na maioria
-- das vezes).
\echo
\echo Conectando ao novo banco de dados:
\connect "dbname=sistema_jogo user=ocvitin password=123";

-- Criação do schema "jogo":
\echo
\echo Criando e configurando o schema "jogo":
CREATE SCHEMA jogo AUTHORIZATION ocvitin;

COMMENT ON SCHEMA jogo IS 'Schema para o trabalho final.';

-- Configura o SEARCH_PATH do usuário ocvitin:
ALTER USER ocvitin
SET SEARCH_PATH TO jogo, "$user", public;

-- Ajusta o SEARCH_PATH da conexão atual ao banco de dados:
SET SEARCH_PATH TO jogo, "$user", public; 


/* --------------------------------------------------------------------------- */
/* LOCAL_UF:                                                                   */
/* --------------------------------------------------------------------------- */
/* Nesta seção faremos a criação da tabela "local_uf" e outros objetos         */
/* relacionados (constraints, PKs, checks, etc.).                              */
/* --------------------------------------------------------------------------- */

-- Cria a tabela "local_uf":
\echo
\echo Criando a tabela "local_uf" e objetos relacionados:
CREATE TABLE local_uf (
                codigo_uf INTEGER      NOT NULL,
                uf        VARCHAR(100) NOT NULL,
                CONSTRAINT local_uf_pk PRIMARY KEY (codigo_uf)
);

-- Comentários da tabela "local_uf":
COMMENT ON TABLE local_uf IS 'Tabela de identificação dos Estados. Associa cada código único a um estado específico de cada país.';
COMMENT ON COLUMN local_uf.codigo_uf IS 'PK da tabela. Código de identificação de cada Estado do jogador.';
COMMENT ON COLUMN local_uf.uf IS 'Nome do estado.';


/* --------------------------------------------------------------------------- */
/* LOCAL_PAÍS:                                                                 */
/* --------------------------------------------------------------------------- */
/* Nesta seção faremos a criação da tabela "local_pais" e outros objetos       */
/* relacionados (constraints, PKs, checks, etc.).                              */
/* --------------------------------------------------------------------------- */

-- Cria a tabela "local_pais":
\echo
\echo Criando a tabela "local_pais" e objetos relacionados:
CREATE TABLE local_pais (
                codigo_pais INTEGER     NOT NULL,
                pais        VARCHAR(50) NOT NULL,
                codigo_uf   INTEGER,
                CONSTRAINT local_pais_pk PRIMARY KEY (codigo_pais)
);

-- Comentários da tabela "local_pais":
COMMENT ON TABLE local_pais IS 'Tabela de identificação de países. Associa cada código único a um país específico.';
COMMENT ON COLUMN local_pais.codigo_pais IS 'PK da tabela. Código de identificação de cada país do jogador.';
COMMENT ON COLUMN local_pais.pais IS 'Nome do país.';
COMMENT ON COLUMN local_pais.codigo_uf IS 'PK da tabela. Código de identificação de cada Estado do jogador.';


/* --------------------------------------------------------------------------- */
/* SPRITES                                                                     */
/* --------------------------------------------------------------------------- */
/* Nesta seção faremos a criação da tabela "sprites" e outros objetos          */
/* relacionados (constraints, PKs, checks, etc.).                              */
/* --------------------------------------------------------------------------- */

-- Cria a tabela "sprites":
\echo
\echo Criando a tabela "sprites" e objetos relacionados:
CREATE TABLE sprites (
                codigo_imagem INTEGER      NOT NULL,
                imagem        VARCHAR(100) NOT NULL,
                CONSTRAINT sprites_pk PRIMARY KEY (codigo_imagem)
);

-- Comentários da tabela "sprites":
COMMENT ON TABLE sprites IS 'Armazena as sprites (imagens que representam as animações) dos personagens.';
COMMENT ON COLUMN sprites.codigo_imagem IS 'PK da tabela. Código de identificação de cada imagem de cada sprite do personagem.';
COMMENT ON COLUMN sprites.imagem IS 'Guarda o caminho para a raiz da imagem. Não armazena a imagem em si.';


/* --------------------------------------------------------------------------- */
/* MÚSICAS                                                                     */
/* --------------------------------------------------------------------------- */
/* Nesta seção faremos a criação da tabela "musicas" e outros objetos          */
/* relacionados (constraints, PKs, checks, etc.).                              */
/* --------------------------------------------------------------------------- */

-- Cria a tabela "musicas":
\echo
\echo Criando a tabela "musicas" e objetos relacionados:
CREATE TABLE musicas (
                codigo_som INTEGER     NOT NULL,
                som        VARCHAR(50) NOT NULL,
                CONSTRAINT musicas_pk PRIMARY KEY (codigo_som)
);

-- Comentários da tabela "musicas":
COMMENT ON TABLE musicas IS 'Tabela de identificação de músicas. Associa cada código único a uma música específica.';
COMMENT ON COLUMN musicas.codigo_som IS 'PK da tabela. Código de identificação de cada música.';
COMMENT ON COLUMN musicas.som IS 'Música escolhida.';


/* --------------------------------------------------------------------------- */
/* TRILHA_SONORA                                                               */
/* --------------------------------------------------------------------------- */
/* Nesta seção faremos a criação da tabela "trilha_sonora" e outros objetos    */
/* relacionados (constraints, PKs, checks, etc.).                              */
/* --------------------------------------------------------------------------- */

-- Cria a tabela "trilha_sonora":
\echo
\echo Criando a tabela "trilha_sonora" e objetos relacionados:
CREATE TABLE trilha_sonora (
                codigo   CHAR(3)      NOT NULL,
                nome     VARCHAR(100) NOT NULL,
                valencia VARCHAR(50)  NOT NULL,
                CONSTRAINT trilha_sonora_pk PRIMARY KEY (codigo),
                CONSTRAINT ck_trilha_sonora_valencia CHECK (valencia IN ('positivo', 'negativo', 'neutro'))
);

-- Comentários da tabela "trilha_sonora":
COMMENT ON TABLE trilha_sonora IS 'Armazena as trilhas sonoras dos níveis.';
COMMENT ON COLUMN trilha_sonora.codigo IS 'PK da tabela. É o código de identificação de cada trilha sonora.';
COMMENT ON COLUMN trilha_sonora.nome IS 'Nome da trilha sonora.';
COMMENT ON COLUMN trilha_sonora.valencia IS 'Valência. Pode ser negativa, positiva e neutra.';


/* --------------------------------------------------------------------------- */
/* MISSÕES                                                                     */
/* --------------------------------------------------------------------------- */
/* Nesta seção faremos a criação da tabela "missoes" e outros objetos          */
/* relacionados (constraints, PKs, checks, etc.).                              */
/* --------------------------------------------------------------------------- */

-- Cria a tabela "missoes":
\echo
\echo Criando a tabela "missoes" e objetos relacionados:
CREATE TABLE missoes (
                codigo_missoes CHAR(3)      NOT NULL,
                nome           VARCHAR(100) NOT NULL,
                descricao      VARCHAR(500),
                tempo_max      TIME,
                pontuacao      INTEGER      NOT NULL,
                CONSTRAINT missoes_pk PRIMARY KEY (codigo_missoes)
);

-- Comentários da tabela "missoes":
COMMENT ON TABLE  missoes IS 'Armazena as missões dos níveis.';
COMMENT ON COLUMN missoes.codigo_missoes IS 'PK da tabela. É o código de identificação de cada missão.';
COMMENT ON COLUMN missoes.nome IS 'Nome da missão.';
COMMENT ON COLUMN missoes.descricao IS 'Descrições sobre as missões.';
COMMENT ON COLUMN missoes.tempo_max IS 'Tempo máximo para fazer a missão.';
COMMENT ON COLUMN missoes.pontuacao IS 'Pontuação da missão.';


/* --------------------------------------------------------------------------- */
/* JOGADORES                                                                   */
/* --------------------------------------------------------------------------- */
/* Nesta seção faremos a criação da tabela "jogadores" e outros objetos        */
/* relacionados (constraints, PKs, checks, etc.).                              */
/* --------------------------------------------------------------------------- */

-- Cria a tabela "jogadores":
\echo
\echo Criando a tabela "jogadores" e objetos relacionados:
CREATE TABLE jogadores (
                codigo        CHAR(3)      NOT NULL,
                nome          VARCHAR(100) NOT NULL,
                apelido       VARCHAR(50)  NOT NULL,
                imagem        VARCHAR(100) NOT NULL,
                data_registro DATE         NOT NULL,
                codigo_pais   INTEGER,
                CONSTRAINT jogadores_pk PRIMARY KEY (codigo)
);

-- Comentários da tabela "jogadores":
COMMENT ON TABLE jogadores IS 'Armazena informações sobre os jogadores.';
COMMENT ON COLUMN jogadores.codigo IS 'PK da tabela. É o código de identificação de cada jogador.';
COMMENT ON COLUMN jogadores.nome IS 'Nome do jogador.';
COMMENT ON COLUMN jogadores.apelido IS 'Apelido do jogador. Também conhecido como nickname.';
COMMENT ON COLUMN jogadores.imagem IS 'Foto de perfil do jogador. Guarda o caminho para a raiz da imagem. Não armazena a imagem em si.';
COMMENT ON COLUMN jogadores.data_registro IS 'Data de quando o jogador criou sua conta.';
COMMENT ON COLUMN jogadores.codigo_pais IS 'PK da tabela. Código de identificação de cada país do jogador.';


/* --------------------------------------------------------------------------- */
/* CORES                                                                       */
/* --------------------------------------------------------------------------- */
/* Nesta seção faremos a criação da tabela "cores" e outros objetos            */
/* relacionados (constraints, PKs, checks, etc.).                              */
/* --------------------------------------------------------------------------- */

-- Cria a tabela "cores":
\echo
\echo Criando a tabela "cores" e objetos relacionados:
CREATE TABLE cores (
                codigo_cor INTEGER     NOT NULL,
                cor        VARCHAR(15) NOT NULL,
                CONSTRAINT cores_pk PRIMARY KEY (codigo_cor)
);

-- Comentários da tabela "cores":
COMMENT ON TABLE cores IS 'Tabela de identificação de cores. Associa cada código único a uma cor específica.';
COMMENT ON COLUMN cores.codigo_cor IS 'PK da tabela. Código de identificação de cada cor.';
COMMENT ON COLUMN cores.cor IS 'Hexadecimal da cor.';


/* --------------------------------------------------------------------------- */
/* BACKGROUND                                                                  */
/* --------------------------------------------------------------------------- */
/* Nesta seção faremos a criação da tabela "background" e outros objetos       */
/* relacionados (constraints, PKs, checks, etc.).                              */
/* --------------------------------------------------------------------------- */

-- Cria a tabela "background":
\echo
\echo Criando a tabela "background" e objetos relacionados:
CREATE TABLE background (
                codigo_imagem INTEGER     NOT NULL,
                imagem_fundo  VARCHAR(100) NOT NULL,
                CONSTRAINT background_pk PRIMARY KEY (codigo_imagem)
);

-- Comentários da tabela "background":
COMMENT ON TABLE background IS 'Tabela de identificação de imagens de fundo. Associa cada código único a uma imagem específica.';
COMMENT ON COLUMN background.codigo_imagem IS 'PK da tabela. Código de identificação de cada imagem do background.';
COMMENT ON COLUMN background.imagem_fundo IS 'Guarda o caminho para a raiz da imagem. Não armazena a imagem em si.';


/* --------------------------------------------------------------------------- */
/* CONFIGURACOES                                                               */
/* --------------------------------------------------------------------------- */
/* Nesta seção faremos a criação da tabela "configuracoes" e outros objetos    */
/* relacionados (constraints, PKs, checks, etc.).                              */
/* --------------------------------------------------------------------------- */

-- Cria a tabela "configuracoes":
\echo
\echo Criando a tabela "configuracoes" e objetos relacionados:
CREATE TABLE configuracoes (
                codigo        CHAR(3) NOT NULL,
                volume        INTEGER NOT NULL,
                brilho        INTEGER NOT NULL,
                codigo_cor    INTEGER NOT NULL,
                codigo_imagem INTEGER NOT NULL,
                CONSTRAINT configuracoes_pk PRIMARY KEY (codigo),
                CONSTRAINT ck_configuracoes_volume CHECK (volume BETWEEN 0 AND 100),
                CONSTRAINT ck_configuracoes_brilho CHECK (brilho BETWEEN 0 AND 100)
);

-- Comentários da tabela "configuracoes":
COMMENT ON TABLE configuracoes IS 'Armazena configurações básicas de cada jogo.';
COMMENT ON COLUMN configuracoes.codigo IS 'PK da tabela. É o código de identificação de cada configuração.';
COMMENT ON COLUMN configuracoes.volume IS 'Volume geral de cada jogo. É uma valor de 0 a 100.';
COMMENT ON COLUMN configuracoes.brilho IS 'Brilho geral do jogo. É uma valor de 0 a 100.';
COMMENT ON COLUMN configuracoes.codigo_cor IS 'FK para a tabela cores.';
COMMENT ON COLUMN configuracoes.codigo_imagem IS 'FK para a tabela background.';


/* --------------------------------------------------------------------------- */
/* JOGOS                                                                       */
/* --------------------------------------------------------------------------- */
/* Nesta seção faremos a criação da tabela "jogos" e outros objetos            */
/* relacionados (constraints, PKs, checks, etc.).                              */
/* --------------------------------------------------------------------------- */

-- Cria a tabela "jogos":
\echo
\echo Criando a tabela "jogos" e objetos relacionados:
CREATE TABLE jogos (
                codigo        CHAR(3)      NOT NULL,
                nome          VARCHAR(100) NOT NULL,
                objetivo      VARCHAR(100) NOT NULL,
                numero_niveis INTEGER      NOT NULL,
                data_criacao  DATE         NOT NULL,
                CONSTRAINT jogos_pk PRIMARY KEY (codigo)
);

-- Comentários da tabela "jogos":
COMMENT ON TABLE jogos IS 'Armazena o jogo.';
COMMENT ON COLUMN jogos.codigo IS 'PK da tabela. É o código de identificação de cada jogo.';
COMMENT ON COLUMN jogos.nome IS 'Nome do jogo.';
COMMENT ON COLUMN jogos.objetivo IS 'Objetivo geral do jogo.';
COMMENT ON COLUMN jogos.numero_niveis IS 'Quantidade de níveis que o jogo possui.';
COMMENT ON COLUMN jogos.data_criacao IS 'Data do início da criação do jogo.';


/* --------------------------------------------------------------------------- */
/* PERSONALIZACOES                                                             */
/* --------------------------------------------------------------------------- */
/* Nesta seção faremos a criação da tabela "personalizacoes" e outros objetos  */
/* relacionados (constraints, PKs, checks, etc.).                              */
/* --------------------------------------------------------------------------- */

-- Cria a tabela "personalizacoes":
\echo
\echo Criando a tabela "personalizacoes" e objetos relacionados:
CREATE TABLE personalizacoes (
                codigo_configuracoes CHAR(3)      NOT NULL,
                codigo_jogo          CHAR(3)      NOT NULL,
                data_configuracao    DATE         NOT NULL,
                hora                 TIME         NOT NULL,
                imagem               VARCHAR(100) NOT NULL,
                codigo_som           INTEGER      NOT NULL,
                CONSTRAINT personalizacoes_pk PRIMARY KEY (codigo_configuracoes, codigo_jogo)
);

-- Comentários da tabela "personalizacoes":
COMMENT ON TABLE personalizacoes IS 'Tabela de relacionamento N:N entre jogos e configurações.';
COMMENT ON COLUMN personalizacoes.codigo_configuracoes IS 'PFK da tabela. É a PK composta da tabela e código de identificação das configurações.';
COMMENT ON COLUMN personalizacoes.codigo_jogo IS 'PFK da tabela. É a PK composta da tabela e código de identificação dos jogos.';
COMMENT ON COLUMN personalizacoes.data_configuracao IS 'Data em que foi feita a última modificação.';
COMMENT ON COLUMN personalizacoes.hora IS 'Hora em que foi feita a última modificação.';
COMMENT ON COLUMN personalizacoes.imagem IS 'Guarda o caminho para a raiz da imagem. Não armazena a imagem em si.';
COMMENT ON COLUMN personalizacoes.codigo_som IS 'FK para a tabela música.';


/* --------------------------------------------------------------------------- */
/* OBJETOS                                                                     */
/* --------------------------------------------------------------------------- */
/* Nesta seção faremos a criação da tabela "objetos" e outros objetos          */
/* relacionados (constraints, PKs, checks, etc.).                              */
/* --------------------------------------------------------------------------- */

-- Cria a tabela "objetos":
\echo
\echo Criando a tabela "objetos" e objetos relacionados:
CREATE TABLE objetos (
                codigo    CHAR(3)      NOT NULL,
                nome      VARCHAR(100) NOT NULL,
                descricao VARCHAR(700),
                CONSTRAINT codigo_objetos_pk PRIMARY KEY (codigo)
);

-- Comentários da tabela "objetos":
COMMENT ON TABLE objetos IS 'Armazena os objetos que compôem os níveis dos jogos.';
COMMENT ON COLUMN objetos.codigo IS 'PK da tabela. É o código de identificação de cada objeto.';
COMMENT ON COLUMN objetos.nome IS 'Nome de cada objeto.';
COMMENT ON COLUMN objetos.descricao IS 'Descrição dos elementos visuais e características do objeto.';


/* --------------------------------------------------------------------------- */
/* NÍVEIS                                                                      */
/* --------------------------------------------------------------------------- */
/* Nesta seção faremos a criação da tabela "niveis" e outros objetos           */
/* relacionados (constraints, PKs, checks, etc.).                              */
/* --------------------------------------------------------------------------- */

-- Cria a tabela "niveis":
\echo
\echo Criando a tabela "niveis" e objetos relacionados:
CREATE TABLE niveis (
                codigo       CHAR(3)      NOT NULL,
                nome         VARCHAR(100) NOT NULL,
                objetivo     VARCHAR(100) NOT NULL,
                codigo_jogos CHAR(3)      NOT NULL,
                CONSTRAINT niveis_pk PRIMARY KEY (codigo)
);

-- Comentários da tabela "niveis":
COMMENT ON TABLE niveis IS 'Armazena os níveis de cada jogo.';
COMMENT ON COLUMN niveis.codigo IS 'PK da tabela. É o código de identificação de cada nível.';
COMMENT ON COLUMN niveis.nome IS 'Nome de cada nível.';
COMMENT ON COLUMN niveis.objetivo IS 'Objetivo do nível.';
COMMENT ON COLUMN niveis.codigo_jogos IS 'FK para a tabela jogos.';


/* --------------------------------------------------------------------------- */
/* CONSOMEM                                                                    */
/* --------------------------------------------------------------------------- */
/* Nesta seção faremos a criação da tabela "consomem" e outros objetos         */
/* relacionados (constraints, PKs, checks, etc.).                              */
/* --------------------------------------------------------------------------- */

-- Cria a tabela "consomem":
\echo
\echo Criando a tabela "consomem" e objetos relacionados:
CREATE TABLE consomem (
                codigo_trilha CHAR(3) NOT NULL,
                codigo_nivel  CHAR(3) NOT NULL,
                CONSTRAINT consomem_pk PRIMARY KEY (codigo_trilha, codigo_nivel)
);

-- Comentários da tabela "consomem":
COMMENT ON TABLE consomem IS 'Tabela de relacionamento N:N entre níveis e trilha_sonora.';
COMMENT ON COLUMN consomem.codigo_trilha IS 'PFK da tabela. É a PK composta da tabela e código de identificação das trilhas sonoras.';
COMMENT ON COLUMN consomem.codigo_nivel IS 'PFK da tabela. É a PK composta da tabela e código de identificação dos níveis.';


/* --------------------------------------------------------------------------- */
/* REALIZAM                                                                    */
/* --------------------------------------------------------------------------- */
/* Nesta seção faremos a criação da tabela "realizam" e outros objetos         */
/* relacionados (constraints, PKs, checks, etc.).                              */
/* --------------------------------------------------------------------------- */

-- Cria a tabela "realizam":
\echo
\echo Criando a tabela "realizam" e objetos relacionados:
CREATE TABLE realizam (
                codigo_missoes CHAR(3) NOT NULL,
                codigo_nivel   CHAR(3) NOT NULL,
                CONSTRAINT realizam_pk PRIMARY KEY (codigo_missoes, codigo_nivel)
);

-- Comentários da tabela "realizam":
COMMENT ON TABLE realizam IS 'Tabela de relacionamento N:N entre missões e niveis.';
COMMENT ON COLUMN realizam.codigo_missoes IS 'PFK da tabela. É a PK composta da tabela e código de identificação das missões.';
COMMENT ON COLUMN realizam.codigo_nivel IS 'PFK da tabela. É a PK composta da tabela e código de identificação dos níveis.';


/* --------------------------------------------------------------------------- */
/* PARTIDAS                                                                    */
/* --------------------------------------------------------------------------- */
/* Nesta seção faremos a criação da tabela "partidas" e outros objetos         */
/* relacionados (constraints, PKs, checks, etc.).                              */
/* --------------------------------------------------------------------------- */

-- Cria a tabela "partidas":
\echo
\echo Criando a tabela "partidas" e objetos relacionados:
CREATE TABLE partidas (
                codigo_jogadores CHAR(3) NOT NULL,
                codigo_nivel     CHAR(3) NOT NULL,
                data_inicio      DATE    NOT NULL,
                data_fim         DATE    NOT NULL,
                hora_inicio      TIME    NOT NULL,
                hora_fim         TIME    NOT NULL,
                pontuacao        INTEGER NOT NULL,
                CONSTRAINT partidas_pk PRIMARY KEY (codigo_jogadores, codigo_nivel)
);

-- Comentários da tabela "partidas":
COMMENT ON TABLE partidas IS 'Tabela de relacionamento N:N entre jogadores e niveis.';
COMMENT ON COLUMN partidas.codigo_jogadores IS 'PFK da tabela. É a PK composta da tabela e código de identificação dos jogadores.';
COMMENT ON COLUMN partidas.codigo_nivel IS 'PFK da tabela. É a PK composta da tabela e código de identificação dos níveis.';
COMMENT ON COLUMN partidas.data_inicio IS 'Data de início da partida.';
COMMENT ON COLUMN partidas.data_fim IS 'Data da finalização da partida.';
COMMENT ON COLUMN partidas.hora_inicio IS 'Hora em que a partida iniciou.';
COMMENT ON COLUMN partidas.hora_fim IS 'Hora em que a partida encerrou.';
COMMENT ON COLUMN partidas.pontuacao IS 'Pontuação feita pelo jogador na partida.';


/* --------------------------------------------------------------------------- */
/* COMPOSICOES                                                                 */
/* --------------------------------------------------------------------------- */
/* Nesta seção faremos a criação da tabela "composicoes" e outros objetos      */
/* relacionados (constraints, PKs, checks, etc.).                              */
/* --------------------------------------------------------------------------- */

-- Cria a tabela "composicoes":
\echo
\echo Criando a tabela "composicoes" e objetos relacionados:
CREATE TABLE composicoes (
                codigo_nivel  CHAR(3)      NOT NULL,
                codigo_objeto CHAR(3)      NOT NULL,
                ponto_inicio  VARCHAR(100) NOT NULL,
                pontos        INTEGER      NOT NULL,
                CONSTRAINT composicoes_pk PRIMARY KEY (codigo_nivel, codigo_objeto)
);

-- Comentários da tabela "composicoes":
COMMENT ON TABLE composicoes IS 'Tabela de relacionamento N:N entre objetos e níveis. Armazena a posição inicial (spawn) dos objetos e seus pontos.';
COMMENT ON COLUMN composicoes.codigo_nivel IS 'PFK da tabela. É a PK composta da tabela e código de identificação dos níveis.';
COMMENT ON COLUMN composicoes.codigo_objeto IS 'PFK da tabela. É a PK composta da tabela e código de identificação dos objetos.';
COMMENT ON COLUMN composicoes.ponto_inicio IS 'Posição/coordenada inicial (spawn) de cada objeto em relação ao nível.';
COMMENT ON COLUMN composicoes.pontos IS 'definem os espaços que podem ser ocupados por personagens e objetos (coordenadas)';


/* --------------------------------------------------------------------------- */
/* PERSONAGENS                                                                 */
/* --------------------------------------------------------------------------- */
/* Nesta seção faremos a criação da tabela "personagens" e outros objetos      */
/* relacionados (constraints, PKs, checks, etc.).                              */
/* --------------------------------------------------------------------------- */

-- Cria a tabela "personagens":
\echo
\echo Criando a tabela "personagens" e objetos relacionados:
CREATE TABLE personagens (
                codigo        CHAR(3)      NOT NULL,
                nome          VARCHAR(100) NOT NULL,
                codigo_imagem INTEGER      NOT NULL,
                CONSTRAINT codigo_personagens_pk PRIMARY KEY (codigo)
);

-- Comentários da tabela "personagens":
COMMENT ON TABLE personagens IS 'Armazena os personagens dos níveis do jogo.';
COMMENT ON COLUMN personagens.codigo IS 'PK da tabela. É o código de identificação de cada personagem.';
COMMENT ON COLUMN personagens.nome IS 'Nome completo de cada personagem.';
COMMENT ON COLUMN personagens.codigo_imagem IS 'PK da tabela. Código de identificação de cada imagem de cada sprite do personagem.';


/* --------------------------------------------------------------------------- */
/* ENVOLVEM                                                                    */
/* --------------------------------------------------------------------------- */
/* Nesta seção faremos a criação da tabela "envolvem" e outros objetos         */
/* relacionados (constraints, PKs, checks, etc.).                              */
/* --------------------------------------------------------------------------- */

-- Cria a tabela "envolvem":
\echo
\echo Criando a tabela "envolvem" e objetos relacionados:
CREATE TABLE envolvem (
                codigo_nivel      CHAR(3) NOT NULL,
                codigo_personagem CHAR(3) NOT NULL,
                CONSTRAINT envolvem_pk PRIMARY KEY (codigo_nivel, codigo_personagem)
);

-- Comentários da tabela "envolvem":
COMMENT ON TABLE envolvem IS 'Tabela de relacionamento que liga personagens com níveis.';
COMMENT ON COLUMN envolvem.codigo_nivel IS 'PFK da tabela. É a PK composta da tabela e código de identificação dos níveis.';
COMMENT ON COLUMN envolvem.codigo_personagem IS 'PFK da tabela. É a PK composta da tabela e código de identificação dos personagens.';


/* --------------------------------------------------------------------------- */
/* CENÁRIOS                                                                    */
/* --------------------------------------------------------------------------- */
/* Nesta seção faremos a criação da tabela "cenarios" e outros objetos         */
/* relacionados (constraints, PKs, checks, etc.).                              */
/* --------------------------------------------------------------------------- */

-- Cria a tabela "cenarios":
\echo
\echo Criando a tabela "cenarios" e objetos relacionados:
CREATE TABLE cenarios (
                codigo CHAR(3)      NOT NULL,
                nome   VARCHAR(100) NOT NULL,
                tema   VARCHAR(100) NOT NULL,
                CONSTRAINT codigo_cenario_pk PRIMARY KEY (codigo)
);

-- Comentários da tabela "cenarios":
COMMENT ON TABLE cenarios IS 'Armazena cenários dos níveis.';
COMMENT ON COLUMN cenarios.codigo IS 'PK da tabela. É o código de identificação de cada cenário.';
COMMENT ON COLUMN cenarios.nome IS 'Nome do cenário de cada nível.';
COMMENT ON COLUMN cenarios.tema IS 'Divisão de temas para agrupar cenários semelhantes.';


/* --------------------------------------------------------------------------- */
/* COMPÔEM                                                                     */
/* --------------------------------------------------------------------------- */
/* Nesta seção faremos a criação da tabela "compoem" e outros objetos          */
/* relacionados (constraints, PKs, checks, etc.).                              */
/* --------------------------------------------------------------------------- */

-- Cria a tabela "compoem":
\echo
\echo Criando a tabela "compoem" e objetos relacionados:
CREATE TABLE compoem (
                codigo_cenario CHAR(3) NOT NULL,
                codigo_nivel   CHAR(3) NOT NULL,
                CONSTRAINT compoem_pk PRIMARY KEY (codigo_cenario, codigo_nivel)
);

-- Comentários da tabela "compoem":
COMMENT ON TABLE compoem IS 'Tabela de relacionamento N:N entre cenarios e niveis.';
COMMENT ON COLUMN compoem.codigo_cenario IS 'PFK da tabela. É a PK composta da tabela e código de identificação dos cenários.';
COMMENT ON COLUMN compoem.codigo_nivel IS 'PFK da tabela. É a PK composta da tabela e código de identificação dos níveis.';

\echo
\echo Criando as foreign keys de todas as tabelas:
-- Foreign keys da tabela "local_pais":
ALTER TABLE local_pais ADD CONSTRAINT local_uf_local_pais_fk
FOREIGN KEY (codigo_uf)
REFERENCES local_uf (codigo_uf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Foreign keys da tabela "jogadores":
ALTER TABLE jogadores ADD CONSTRAINT local_pais_jogadores_fk
FOREIGN KEY (codigo_pais)
REFERENCES local_pais (codigo_pais)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Foreign keys da tabela "personagens":
ALTER TABLE personagens ADD CONSTRAINT sprites_personagens_fk
FOREIGN KEY (codigo_imagem)
REFERENCES sprites (codigo_imagem)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Foreign keys da tabela "personalizacoes":
ALTER TABLE personalizacoes ADD CONSTRAINT musicas_personalizacoes_fk
FOREIGN KEY (codigo_som)
REFERENCES musicas (codigo_som)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Foreign keys da tabela "consomem":
ALTER TABLE consomem ADD CONSTRAINT trilha_sonora_consomem_fk
FOREIGN KEY (codigo_trilha)
REFERENCES trilha_sonora (codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Foreign keys da tabela "realizam":
ALTER TABLE realizam ADD CONSTRAINT missoes_realizam_fk
FOREIGN KEY (codigo_missoes)
REFERENCES missoes (codigo_missoes)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Foreign keys da tabela "partidas":
ALTER TABLE partidas ADD CONSTRAINT jogadores_partidas_fk
FOREIGN KEY (codigo_jogadores)
REFERENCES jogadores (codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Foreign keys da tabela "configuracoes":
ALTER TABLE configuracoes ADD CONSTRAINT cores_configuracoes_fk
FOREIGN KEY (codigo_cor)
REFERENCES cores (codigo_cor)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE configuracoes ADD CONSTRAINT background_configuracoes_fk
FOREIGN KEY (codigo_imagem)
REFERENCES background (codigo_imagem)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Foreign keys da tabela "personalizacoes":
ALTER TABLE personalizacoes ADD CONSTRAINT configuracoes_personalizacoes_fk
FOREIGN KEY (codigo_configuracoes)
REFERENCES configuracoes (codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


-- Foreign keys da tabela "niveis":
ALTER TABLE niveis ADD CONSTRAINT jogos_niveis_fk
FOREIGN KEY (codigo_jogos)
REFERENCES jogos (codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Foreign keys da tabela "personalizacoes":
ALTER TABLE personalizacoes ADD CONSTRAINT jogos_personalizacoes_fk
FOREIGN KEY (codigo_jogo)
REFERENCES jogos (codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Foreign keys da tabela "composicoes":
ALTER TABLE composicoes ADD CONSTRAINT objetos_composicoes_fk
FOREIGN KEY (codigo_objeto)
REFERENCES objetos (codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE composicoes ADD CONSTRAINT niveis_composicoes_fk
FOREIGN KEY (codigo_nivel)
REFERENCES niveis (codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Foreign keys da tabela "compoem":
ALTER TABLE compoem ADD CONSTRAINT niveis_compoe_fk
FOREIGN KEY (codigo_nivel)
REFERENCES niveis (codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Foreign keys da tabela "envolvem":
ALTER TABLE envolvem ADD CONSTRAINT niveis_envolvem_fk
FOREIGN KEY (codigo_nivel)
REFERENCES niveis (codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Foreign keys da tabela "partidas":
ALTER TABLE partidas ADD CONSTRAINT niveis_partidas_fk
FOREIGN KEY (codigo_nivel)
REFERENCES niveis (codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Foreign keys da tabela "realizam":
ALTER TABLE realizam ADD CONSTRAINT niveis_realizam_fk
FOREIGN KEY (codigo_nivel)
REFERENCES niveis (codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Foreign keys da tabela "consomem":
ALTER TABLE consomem ADD CONSTRAINT niveis_consomem_fk
FOREIGN KEY (codigo_nivel)
REFERENCES niveis (codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Foreign keys da tabela "envolvem":
ALTER TABLE envolvem ADD CONSTRAINT personagens_envolvem_fk
FOREIGN KEY (codigo_personagem)
REFERENCES personagens (codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Foreign keys da tabela "compoem":
ALTER TABLE compoem ADD CONSTRAINT cenarios_compoe_fk
FOREIGN KEY (codigo_cenario)
REFERENCES cenarios (codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
