# Desafio DevOps

![Terraform](https://img.shields.io/badge/Terraform-IaC-blue)
![Docker](https://img.shields.io/badge/Docker-Container-blue)
![CI/CD](https://img.shields.io/badge/GitHub%20Actions-CI/CD-green)
![Status](https://img.shields.io/badge/Status-Working-brightgreen)


## Objetivo
Implementar um ambiente simples demonstrando práticas de DevOps, incluindo:

- Containerização com Docker  
- Infraestrutura como Código com Terraform  
- Pipeline CI/CD com GitHub Actions  
- Monitoramento com Prometheus, Grafana e cAdvisor  

---

## Arquitetura do Projeto

O projeto consiste em:

Aplicação:
- Um site simples "Hello World" servido por Nginx em container Docker

Infraestrutura:
- Containers criados automaticamente com Terraform
- Rede Docker dedicada para comunicação entre serviços

Monitoramento:
- cAdvisor para métricas de containers
- Prometheus para coleta de métricas
- Grafana para visualização

CI/CD:
- Pipeline automático no GitHub Actions
- Build e publicação automática da imagem Docker

---

## Estrutura do Projeto

desafio-devops/
│
├── app/                # Aplicação Hello World
│   ├── Dockerfile
│   └── index.html
│
├── infra/              # Infraestrutura Terraform
│   └── main.tf
│
├── monitoring/         # Configuração Prometheus
│   └── prometheus.yml
│
├── .github/workflows/  # Pipeline CI/CD
│   └── ci.yml
│
└── README.md

---

## Como Executar Localmente

### 1. Clonar o repositório

git clone https://github.com/laissagma/desafio-devops.git
cd desafio-devops

### 2. Subir infraestrutura

cd infra
terraform init
terraform apply

---

## Acessos

Aplicação:
http://localhost:8080  

Grafana:
http://localhost:3000  

Prometheus:
http://localhost:9090  

cAdvisor:
http://localhost:8081  

---

## CI/CD

O pipeline é executado automaticamente a cada push na branch **main**.

Etapas:
1. Checkout do código
2. Build da imagem Docker
3. Publicação da imagem no GitHub Container Registry

---

## Monitoramento

O ambiente possui:

- Métricas dos containers via cAdvisor  
- Coleta e armazenamento via Prometheus  
- Dashboards via Grafana  

Usuário padrão Grafana:
admin

Senha:
admin

---

## Tecnologias Utilizadas

- Docker
- Terraform
- GitHub Actions
- Prometheus
- Grafana
- cAdvisor

---

## Autor

Projeto desenvolvido como parte de um desafio técnico de DevOps.
