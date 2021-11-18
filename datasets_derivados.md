## Construção do raciocínio para derivação de datasets a partir de um único datapackage

### Estrutura de pastas do repositório

- templates/
  - description/
    - CONTRIBUTING.md
    - README.md
    - CHANGELOG.md
  - datapackage.yaml

- datasets/
  - dataset/
    - description/
      - CONTRIBUTING.md
      - README.md
      - CHANGELOG.md
    - datapackage.yaml
    - datapackage.json

- Exemplo:

- datasets/
  - restos_pagar/
    - description/
      - CONTRIBUTING.md
      - README.md
      - CHANGELOG.md
    - datapackage.yaml
    - datapackage.json
  - compras_contratos/
    - description/
      - CONTRIBUTING.md
      - README.md
      - CHANGELOG.md
    - datapackage.yaml
    - datapackage.json
  - etc...

### TODO

- [ ] Remover propriedade "dialect" do arquivo datapackage.json. Arquivo dialect-v1.json deverá ser criado dentro da pasta "schemas", nos moldes [deste repositório](https://github.com/dados-mg/google-analytics/tree/master/schema)

- [ ] Copiar arquivo [age7.yaml](https://github.com/transparencia-mg/age7/blob/main/age7.yaml) para este repositório. Ele será a base de iteração para construção de todos os conjuntos, portanto propriedade resources deverá ficar vazia neste arquivo `"resources": []`

- [ ] Criar os arquivos base CONTRIBUTING.md, README.md e CHANGELOG.md que ficarão dentro da pasta templates/description

- [ ] Criar um arquivo datapackage.yaml na dentro da pasta templates. Este arquivo deverá ter todas as propriedades que serão personalizadas para cada recurso

- [ ] Criar função para criação da estrutura de pastas
  - pasta "datasets" existe? se sim mantém, se não cria
  - itera sobre a propriedade "consultas" do arquivo age7.yaml
    - nome da propriedade iterada conside com pasta dentro de "datasets"? se sim mantém, se não cria
    - Se cria:
      - Cria pasta description com arquivos CONTRIBUTING.md, README.md e CHANGELOG.md padrão
      - Chama função para criar/atualizar datapackage.yaml na raiz do conjunto

- [ ] Função para Cria/Atualiza datapackage.yaml na raiz do conjunto
  - se não existe cria:
    - durante criação utiliza informações padrões do arquivo datapackage.yaml da pasta templates
    - itera sobre o arquivo age7.yaml para buscar os recursos do conjunto, deixando ali somente a propriedade nome
  - se existe atualiza
    - itera sobre o arquivo age7.yaml para buscar/atualizar os recursos do conjunto, deixando ali somente a propriedade nome

- [ ] Criar função para montar o arquivo datapackage.json
  - Pseudocódigo

  ```
  # Lê o arquivo datapackage.json para, entre outros, extrair os recursos daquele conjunto
  base_dp = Package('datapackage.json')

  # Lê o arquivo datapakcage.yaml para extrair os metadados do conjunto
  target_dp = Package('packages/receita/datapackage.yaml')


  # Inclui no base_dp os metadados extraídos do arquivo datapackage.yaml
  for k in target_dp.keys:
      base_dp.update(k)

  # Atualiza a propriedade description com os arquivos README, CONTRIBUTING, CHANGELOG
  base_dp.update(description) # README, CONTRIBUTING, CHANGELOG

  # Analisa quais recursos existentes no base_dp deverão ser excluídos

  drop_resources = setdiff(base_dp.resource_names, target_dp.resource_names)

  # Remove os recursos a mais
  base_dp.remove_resources(drop_resources)

  # Escreve/Atualiza datapackage.json dentro do dataset
  base_dp.write_package('packages/receita/datapackage.json')
  ```

- [ ] Cria função para revisão dos documentos "description" da pasta
  - função poderá ser acionada sempre que o template de algum dos documentos for alterado
  - durante a chamada da função se "all" for passado como nome da consulta todos os documentos "description" serão atualizados
  - durante a chamada da função se o nome da consulta for informado apenas os documentos "description" desta consulta serão atualizados

### Perguntas
  - Na estrutura das pastas, utilizar o nome datasets ou conjuntos? Prefiro dataset.
  - Incluí dentro de cada pasta de dataset uma pasta description para trazer arquivos README.md, CONTRIBUTING, CHANGELOG.md
  - Na pasta de schemas existente hj do Age7 há esquemas para mesmas tabelas (ft-restos-pagar-2002,yaml), não seria melhor deixar apenas um schema? Aonde poderíamos indicar que etas tabelas estão quebradas (nos dados) mas que os esquemas são os mesmos?
  - Os arquivos de schema estão separados por hifem ("-") isso poderá dar problema?

### Referência

- [Issue aberto](https://github.com/transparencia-mg/age7/issues/194)
- [Relação conjunto tabelas](https://github.com/transparencia-mg/age7/blob/main/age7.yaml)

