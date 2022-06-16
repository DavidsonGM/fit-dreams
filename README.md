# FIT DREAMS API

Repositório com o objetivo de implementar uma API REST em rails de um sistema de uma academia, em que vários alunos podem ser matriculados em diversas aulas, das quais cada uma será ministrada por um único professor. 

Os usuários podem ter uma dentre 3 _roles_, que são criadas por seed, sendo elas 'aluno' (id 1), 'professor' (id 2) e 'admin' (id 3), sendo que apenas os professores e admins tem permissão de manipular (criar, editar e excluir) categorias e aulas. Um aluno pode se matricular/desmatriculr em alguma aula, porém não pode matricular outro aluno, enquanto que os professores e adminstradores tem permissão de matricular/desmatricular qualquer aluno de qualquer aula.

## Banco de Dados
O esquemático do banco de dados pode ser em encontrado no [db_diagram](https://dbdiagram.io/d/629a017954ce263527550fb3) e o SGBD escolhido para o projeto foi o postgreSQL.

## Gems utilizadas e versões
Para o desenvolvimento do projeto foi optado pela utilização da versão 6.1.5 do rails e da versão 2.7.2 do ruby. Adicionalmente, foram utilizadas outras gems para simplificar e facilitar o desenvolvimento do projeto, dentre elas:
- [devise](https://github.com/heartcombo/devise) e [simple_token_authentication](https://github.com/gonzalo-bulnes/simple_token_authentication) para autenticação de usuário;
- [active_model_serializer](https://github.com/rails-api/active_model_serializers) para a padronização das respostas (no formato JSON) das requisiçõs;
- [rubocop](https://github.com/rubocop/rubocop) como linter para padronização de codificação
- [rspec](https://github.com/rspec/rspec-rails) e [factory_bot](https://github.com/thoughtbot/factory_bot) para os testes das models e das controllers

## Rodando o projeto
Para inicializar o projeto, comece rodando `bundle` seguido de um `rails db:setup` e, caso tenha dado tudo certo, basta rodar um `rails s` para rodar o servidor. 
