# 📁 File Manager

## Desafio

Desenvolver a camada de modelos de um sistema de arquivos persistido em um banco de dados SQL onde seja possível criar diretórios e arquivos. Os diretórios poderão conter sub-diretórios e arquivos. O conteúdo dos arquivos podem ser persistidos como blob, S3 ou mesmo em disco.

## Regras de Negócio

- Um diretórios pode ter vários arquivos e vários diretórios;
- Um arquivo não pode ter diretórios, mas sempre terá um diretório pai;
- Não podemos ter dois diretórios com mesmo nome em nível (mesmo diretório);
- Não podemos ter arquivos com mesmo nome, no mesmo diretório (Um plus seria olhar o formato e permitir formatos diferentes);
- Os nomes dos diretórios e arquivos devem ser case insensitive;

## Modelagem

### 1. Modelos Separados (`Directory` e `StoredFile`)

Nesta abordagem, utilizamos dois modelos distintos:

* `Directory`: representa um diretório, que pode conter subdiretórios e arquivos.
* `StoredFile`: representa um arquivo, que pertence a um diretório.

#### Vantagens

* Separação clara de responsabilidades.
* Regras de negócio específicas aplicadas com facilidade (ex: apenas diretórios podem ter filhos).
* Validações e constraints com ActiveRecord são diretas e robustas.
* Mais legível e sustentável em sistemas complexos.

#### Desvantagens

* Mais tabelas e relacionamentos para gerenciar.
* Requer duplicação de código comum (pode ser minimizado com `concerns`).
* Consultas complexas (ex: todos os itens filhos de um diretório vão precisar de um JOIN entre as duas tabelas).

---

### 2. Herança Polimórfica com STI (`Storable`, `Directory`, `StoredFile`)

Nesta abordagem, usamos uma única tabela (`storables`) para armazenar tanto diretórios quanto arquivos. A distinção é feita pela coluna type:

* `Storable` (abstract): modelo base com atributos comuns.
* `DirectoryStorable < Storable`: representa um diretório.
* `FileStorable < Storable`: representa um arquivo.

#### Vantagens

* Estrutura compacta com menos tabelas.
* Compartilhamento fácil de atributos e comportamentos.
* Consultas genéricas mais simples (ex: todos os itens filhos de um diretório).

#### Desvantagens

* Complexidade para impor regras de negócio distintas (ex: arquivos não podem ter filhos).
* Validações dependem de lógica condicional por tipo.
* A tabela pode crescer com colunas irrelevantes para alguns registros.
* STI tem limitações no Rails (ex: índices específicos por tipo, validações obrigatórias).

---

#### Diagramas

##### Modelos Separados

```plaintext
Directory
├── id: integer
├── name: string
├── parent_id: integer
└── timestamps

StoredFile
├── id: integer
├── name: string
├── directory_id: integer
└── timestamps
```

##### Herança Polimórfica

```plaintext
Storable
├── id: integer
├── name: string
├── type: string ("DirectoryStorable" ou "FileStorable")
├── parent_id: integer
└── timestamps
```

## Abordagem

Primeiro será implementado utilizando herança polimórfica, pois precisamos implementar inicialmente uma estrutura compacta, que compartilha todos os campos. Por fim, será feita a implementação dos mdoelos separados para comparação de desempenho deles. Essa comparação será um plus e não um requisito obrigatório.

## TODO List

- [x] Modelagem com Herança Polimórfica
- [x] Modelagem com Modelos Separados (plus)
- [x] Integração com ActiveStorage
- [x] Migrations para os modelos com herança
- [x] Testes unitários para validação dos modelos com herança
- [x] Implementação de regras de negócio
- [x] Persistência em múltiplos sistemas de storage (S3, blob, disco)
- [ ] Migrations para os modelos separados (plus)
- [ ] Testes unitários para validação dos modelos separados (plus)
- [ ] Performance de recuperação e listagem (plus)
- [ ] Benchmark com árvore de 1000 níveil e performance de recuperação/listagem (plus)
- [ ] Interface de importação/exportação (plus)
