# 🔐 HashForge

> Gerador de entropia e derivação de chaves criptográficas através de pipelines de hash personalizados.

---

## 📌 Sobre o Projeto

**HashForge** é uma aplicação web local — um único arquivo `.html` — que roda diretamente no navegador, sem instalação, sem servidor, sem dependências externas.

A ideia central: você escolhe uma frase significativa, define a ordem dos algoritmos de hash, e o programa gera um hash final com alta entropia — pronto para ser usado como base para derivação de chaves criptográficas.

---

## 🎯 Motivação

Muitas ferramentas de geração de senhas e chaves dependem de fontes externas de entropia ou geradores aleatórios. O HashForge propõe uma abordagem determinística e pessoal: **a entropia vem de você**, através de uma frase que só você conhece, processada por um pipeline de algoritmos que só você define.

---

## ✨ Funcionalidades

- **Entrada de frase** — O usuário digita qualquer frase de sua escolha
- **Normalização automática** — Remove espaços e converte tudo para minúsculo antes de processar
- **Pipeline de hash customizável** — Escolha quais algoritmos aplicar e em qual ordem
- **100% Web Crypto API** — Zero código criptográfico manual, implementação auditada pelo Mozilla
- **Derivação de chaves** — Suporte a PBKDF2 e HKDF nativos
- **Perfis salvos** — Salve e reutilize seus pipelines favoritos via localStorage
- **Arquivo único** — Tudo num único `.html`, sem dependências externas
- **100% offline** — Nenhuma requisição de rede, nenhuma lib de CDN

---

## 🧮 Algoritmos Suportados

Todos os algoritmos são fornecidos pela **Web Crypto API nativa do browser** — implementação em C++ auditada pelo Mozilla, presente no Tor Browser e em qualquer browser moderno.

| Algoritmo | Família | Output | Observação |
|---|---|---|---|
| SHA-256 | SHA-2 | 256 bits | ✅ Recomendado |
| SHA-384 | SHA-2 | 384 bits | ✅ Recomendado |
| SHA-512 | SHA-2 | 512 bits | ✅ Recomendado |
| SHA-1 | SHA-1 | 160 bits | ⚠️ Evitar como etapa final |
| PBKDF2-SHA256 | KDF | 256 bits | ✅ 100k iterações, ideal como etapa final |
| PBKDF2-SHA512 | KDF | 256 bits | ✅ 100k iterações, ideal como etapa final |
| HKDF-SHA256 | KDF | 256 bits | ✅ Derivação de chave |
| HKDF-SHA512 | KDF | 256 bits | ✅ Derivação de chave |

> **Por que somente esses?** A Web Crypto API é intencionalmente minimalista — inclui apenas algoritmos considerados seguros e auditados. Usar somente algoritmos nativos elimina qualquer risco de implementação incorreta de código criptográfico manual.

---

## 🖥️ Como Funciona

```
Frase do usuário
      │
      ▼
Normalização (lowercase + remove espaços)
      │
      ▼
┌─────────────────────────────────────┐
│           Pipeline de Hash           │
│  SHA-256 → SHA-512 → PBKDF2-SHA512  │  ← definido pelo usuário
└─────────────────────────────────────┘
      │
      ▼
Hash final (alta entropia)
```

---

## 💾 Perfis

O usuário pode salvar pipelines como **perfis nomeados** para reutilização:

| Nome do Perfil | Pipeline |
|---|---|
| `minha-chave` | SHA-256 → SHA-512 → PBKDF2-SHA512 |
| `derivacao` | SHA-512 → HKDF-SHA512 |
| `simples` | SHA-256 |

> Os perfis são salvos no `localStorage` do navegador. No Tails, habilite o **armazenamento persistente** para não perder os perfis entre sessões.

---

## 🚀 Como Usar

1. Baixe o arquivo `hashforge-offline.html`
2. Abra no navegador (`File > Open` ou arraste para o browser)
3. Digite sua frase, monte o pipeline e execute

No **Tails OS**, salve o arquivo no volume persistente criptografado e abra direto no **Tor Browser**.

---

## 🛠️ Stack

| Componente | Tecnologia |
|---|---|
| Linguagem | HTML + JavaScript (vanilla) |
| Interface | HTML/CSS puro, sem frameworks |
| Algoritmos | Web Crypto API (nativa do browser) |
| Armazenamento | localStorage |
| Distribuição | Arquivo único `.html` |
| Dependências | Zero |

---

## 🧅 Compatibilidade com Tails OS

| Requisito | Status |
|---|---|
| Abre no Tor Browser | ✅ |
| Funciona sem internet | ✅ |
| Sem instalação de pacotes | ✅ |
| Arquivo único no volume persistente | ✅ |
| Web Crypto API disponível no Tor Browser | ✅ |

---

## 🗺️ Roadmap

- [x] Normalização de frase (lowercase + remove espaços)
- [x] Pipeline customizável de algoritmos
- [x] Algoritmos nativos via Web Crypto API
- [x] Sistema de perfis com localStorage
- [x] Copiar resultado para clipboard
- [x] Derivação de chave via PBKDF2 e HKDF
- [x] Interface HTML/CSS offline
- [ ] Testes com vetores oficiais (NIST) para validação
- [ ] Exportação do resultado em diferentes formatos (hex, base64, bytes)
- [ ] Opção de configurar iterações do PBKDF2

---

## ⚠️ Aviso de Segurança

Este projeto é para **uso pessoal**. A segurança de um sistema criptográfico depende de muito mais do que os algoritmos de hash utilizados. Não utilize os resultados como única camada de proteção em sistemas críticos sem uma revisão de segurança adequada.

---

## 📄 Licença

Distribuído sob a licença **MIT**. Veja [LICENSE](LICENSE) para mais detalhes.

---
