# Controle de Viagens - Sistema de Gestão para Transporte Rodoviário

Sistema completo de gerenciamento de viagens para transportadoras e caminhoneiros autônomos, desenvolvido em Flutter. Oferece controle detalhado de frotas, análise de desempenho por motorista e combinação de veículos, além de geração automatizada de relatórios em PDF.

## Visão Geral

O Controle de Viagens é uma solução mobile multiplataforma que permite o registro e análise completa de operações de transporte rodoviário. O sistema fornece insights sobre eficiência operacional, custos por viagem, desempenho de motoristas e consumo de combustível por configuração de veículos.

## Arquitetura do Sistema

### Estrutura de Dados

O sistema utiliza armazenamento local persistente através do SharedPreferences, garantindo que todos os dados permaneçam disponíveis offline. A arquitetura segue o padrão MVC (Model-View-Controller) com separação clara de responsabilidades:

- **Models**: Estruturas de dados imutáveis representando viagens, fretes e despesas
- **Services**: Camada de lógica de negócio para persistência e geração de relatórios
- **Screens**: Interface do usuário organizada por módulos funcionais
- **Widgets**: Componentes reutilizáveis para manter consistência visual

### Tecnologias Utilizadas

- **Flutter 3.0+**: Framework para desenvolvimento multiplataforma
- **Dart 3.0+**: Linguagem de programação com tipagem forte
- **Material Design 3**: Sistema de design moderno e responsivo
- **SharedPreferences**: Armazenamento de dados local baseado em chave-valor
- **PDF**: Biblioteca para geração de documentos PDF
- **Printing**: Sistema de visualização e compartilhamento de PDFs

## Funcionalidades Principais

### 1. Autenticação e Segurança

O sistema implementa um mecanismo de autenticação baseado em senha local, garantindo que apenas usuários autorizados tenham acesso aos dados. Na primeira inicialização, o usuário é guiado por um processo de onboarding que explica as principais funcionalidades antes de configurar sua senha de acesso.

**Características de Segurança:**
- Senha armazenada localmente no dispositivo
- Validação de força mínima de senha (4 caracteres)
- Possibilidade de alteração de senha através do menu de configurações
- Animação de erro em caso de senha incorreta para feedback visual

### 2. Registro de Viagens

Cada viagem registra um conjunto abrangente de informações organizadas em categorias:

**Dados do Motorista e Veículos:**
- Nome do motorista
- Placa do cavalo mecânico
- Placa da carreta
- Número identificador da viagem

**Informações da Viagem:**
- Data de saída e data de chegada
- Litros de combustível abastecidos
- Quilometragem inicial e final do hodômetro
- Cálculo automático de quilômetros rodados
- Cálculo automático de média de consumo (km/L)

**Fretes Transportados:**
O sistema suporta múltiplos fretes por viagem, permitindo registrar:
- Local de origem
- Local de destino
- Valor do frete
- Observações adicionais

**Despesas da Viagem:**
Categorização detalhada de todos os custos:
- Óleo diesel
- Pedágios
- Estacionamento
- Borracheiro
- Mecânico
- Despesas diversas

**Resumo Financeiro:**
- Valor total dos fretes recebidos
- Comissão do motorista
- Total de despesas
- Cálculo automático do saldo da viagem
- Dinheiro destinado à próxima viagem

### 3. Dashboard Analítico

O dashboard oferece uma visão consolidada de todas as operações através de indicadores-chave de desempenho (KPIs):

**Métricas Globais:**
- Total de viagens realizadas
- Quilometragem total acumulada
- Receita total de fretes
- Total de despesas operacionais
- Total de comissões pagas a motoristas
- Média de quilometragem por viagem
- Consumo médio geral de combustível

**Análise de Lucro:**
- Cálculo consolidado: (Receita - Despesas - Comissões)
- Indicador visual de lucratividade
- Tendência de desempenho

### 4. Perfil de Motorista

Uma das funcionalidades mais avançadas do sistema é a análise detalhada por motorista, acessível através do dashboard clicando no card de cada profissional.

**Estatísticas Individuais:**
- Total de comissões recebidas
- Quilometragem total percorrida
- Número total de fretes transportados (não apenas viagens)
- Média geral de consumo de combustível

**Análise por Combinação de Veículos:**

O sistema identifica e analisa cada combinação única de cavalo mecânico e carreta utilizada pelo motorista. Para cada combinação, são calculados:

- Número de viagens realizadas com essa configuração
- Quilometragem total percorrida
- Litros totais consumidos
- Média de consumo específica (km/L)
- Comparação percentual com a média geral do motorista

**Insights de Eficiência:**
- Identificação da combinação mais eficiente
- Indicadores visuais de performance (acima ou abaixo da média)
- Ranking de configurações por consumo

Esta funcionalidade permite decisões estratégicas sobre:
- Qual combinação de veículos alocar para rotas longas
- Identificação de veículos que necessitam manutenção
- Planejamento de substituição de frota
- Otimização de custos operacionais

### 5. Geração de Relatórios PDF

O sistema gera relatórios profissionais em formato PDF, seguindo o layout tradicional de folhas de viagem utilizadas no setor de transporte. O documento inclui:

- Cabeçalho com identificação da viagem
- Dados completos do motorista e veículos
- Detalhamento de quilometragem e consumo
- Lista de todos os fretes transportados
- Discriminação de todas as despesas
- Resumo financeiro com cálculos automáticos
- Formatação padronizada e profissional

Os PDFs podem ser visualizados, impressos ou compartilhados diretamente do aplicativo.

### 6. Sistema de Temas

Interface adaptável com dois modos visuais:

**Tema Claro:**
- Otimizado para ambientes bem iluminados
- Contraste adequado para leitura prolongada
- Cores suaves e profissionais

**Tema Escuro:**
- Redução de fadiga visual em ambientes com pouca luz
- Economia de bateria em telas OLED/AMOLED
- Paleta de cores ajustada para conforto noturno

A alternância entre temas é persistida e aplicada em toda a interface.

## Casos de Uso

### Transportadora com Múltiplos Motoristas

Uma empresa de transporte pode utilizar o sistema para:
- Monitorar o desempenho individual de cada motorista
- Comparar eficiência entre diferentes profissionais
- Identificar necessidades de treinamento baseadas em consumo
- Calcular comissões automaticamente
- Gerar relatórios para prestação de contas

### Caminhoneiro Autônomo

Um profissional autônomo pode:
- Manter registro detalhado de todas as viagens
- Controlar receitas e despesas
- Identificar quais combinações de veículos são mais lucrativas
- Gerar documentação para contabilidade
- Analisar tendências de consumo ao longo do tempo

### Gestor de Frota

Um gestor pode utilizar o sistema para:
- Analisar eficiência de diferentes combinações de veículos
- Planejar manutenção preventiva baseada em consumo anormal
- Tomar decisões sobre renovação de frota
- Otimizar alocação de veículos para diferentes tipos de carga
- Identificar padrões de desgaste

## Instalação e Configuração

### Pré-requisitos

- Flutter SDK versão 3.0 ou superior
- Dart SDK versão 3.0 ou superior
- Android Studio ou Visual Studio Code (recomendado)
- Dispositivo Android ou iOS para testes (ou emulador)

### Dependências do Projeto
```yaml
dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.2.2  # Armazenamento local
  pdf: ^3.10.7                # Geração de PDF
  printing: ^5.11.1           # Visualização de PDF
```

### Passos para Instalação

1. Clone o repositório:
```bash
git clone https://github.com/EduardoTBuss/Trucks_app
cd Trucks_app/src
```

2. Instale as dependências:
```bash
flutter pub get
```

3. Execute em modo de desenvolvimento:
```bash
# Para web
flutter run -d chrome

# Para Android
flutter run -d android

# Para iOS
flutter run -d ios
```

4. Gere o build de produção:
```bash
# APK para Android
flutter build apk --release

# App Bundle para Google Play
flutter build appbundle --release

# iOS
flutter build ios --release
```

## Estrutura de Diretórios
```
src/lib/
├── main.dart                           # Ponto de entrada da aplicação
├── models/                             # Modelos de dados
│   └── trip_model.dart                # Modelo de viagem com fretes e despesas
├── screens/                           # Telas da aplicação
│   ├── splash_screen.dart            # Tela inicial animada
│   ├── onboarding_screen.dart        # Tutorial de primeiro acesso
│   ├── settings_screen.dart          # Configurações do sistema
│   ├── auth/                         # Módulo de autenticação
│   │   ├── set_password_screen.dart  # Cadastro de senha
│   │   └── login_screen.dart         # Tela de login
│   ├── home/                         # Módulo principal
│   │   ├── home_screen.dart          # Tela principal com navegação
│   │   ├── dashboard_screen.dart     # Dashboard analítico
│   │   └── driver_profile_screen.dart # Perfil detalhado do motorista
│   └── trip/                         # Módulo de viagens
│       └── add_trip_screen.dart      # Registro de nova viagem
├── widgets/                          # Componentes reutilizáveis
│   ├── trip_card.dart               # Card de exibição de viagem
│   └── stat_card.dart               # Card de estatística
├── services/                        # Camada de serviços
│   ├── storage_service.dart        # Persistência de dados
│   └── pdf_service.dart            # Geração de PDF
└── theme/                          # Configuração visual
    └── app_theme.dart              # Temas claro e escuro
```

## Fluxo de Dados

### Persistência

1. Usuário registra uma nova viagem
2. Dados são convertidos para modelo TripModel
3. StorageService serializa o modelo para JSON
4. JSON é armazenado via SharedPreferences
5. Ao carregar, JSON é deserializado de volta para modelo

### Cálculos Estatísticos

O StorageService processa todas as viagens para gerar estatísticas:

1. Itera sobre todas as viagens armazenadas
2. Agrupa dados por motorista
3. Para cada motorista, agrupa por combinação de veículos
4. Calcula métricas acumuladas e médias
5. Retorna estrutura de dados hierárquica

### Geração de PDF

1. PDFService recebe modelo de viagem
2. Calcula totais de fretes e despesas
3. Constrói documento usando biblioteca pw (PDF Widgets)
4. Aplica formatação conforme layout padrão
5. Retorna PDF pronto para visualização/compartilhamento

## Roadmap Futuro

Possíveis melhorias e expansões:

- Sincronização em nuvem (Firebase/Supabase)
- Exportação para Excel
- Integração com APIs de preços de combustível
- Geocodificação automática de rotas
- Notificações de manutenção preventiva
- Análise preditiva de consumo
- Multi-idiomas (Português/Espanhol/Inglês)
- Modo offline completo com sincronização posterior
- Dashboard web para gestores
- API REST para integração com sistemas ERP

## Considerações de Performance

- Armazenamento otimizado com índices JSON
- Lazy loading de estatísticas
- Cache de cálculos complexos
- Animações nativas com 60fps
- Build size otimizado (~50MB no Android)

## Suporte e Documentação

Para reportar bugs ou solicitar funcionalidades, abra uma issue no repositório GitHub.

## Licença

Este projeto está licenciado sob a Licença MIT. Consulte o arquivo LICENSE para mais detalhes.

## Autores

Desenvolvido como projeto de demonstração de capacidades Flutter para sistemas empresariais.

---

Versão: 1.0.0  
Última atualização: Janeiro 2026