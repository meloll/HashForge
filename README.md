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

---

<div align="center"><a href="#-hashforge">🇧🇷 Português</a> · <strong>🇺🇸 English</strong></div>

---

# 🔐 HashForge

> Entropy generator and cryptographic key derivation through custom hash pipelines.

---

## 📌 About

**HashForge** is a local web application — a single `.html` file — that runs directly in the browser, with no installation, no server, and no external dependencies.

The core idea: you choose a meaningful phrase, define the order of hash algorithms, and the program generates a high-entropy final hash — ready to be used as the basis for cryptographic key derivation.

---

## 🎯 Motivation

Many password and key generation tools rely on external entropy sources or random generators. HashForge proposes a deterministic and personal approach: **the entropy comes from you**, through a phrase only you know, processed by a pipeline of algorithms only you define.

---

## ✨ Features

- **Phrase input** — The user types any phrase of their choice
- **Automatic normalization** — Removes spaces and converts everything to lowercase before processing
- **Customizable hash pipeline** — Choose which algorithms to apply and in what order
- **100% Web Crypto API** — Zero manual cryptographic code, Mozilla-audited implementation
- **Key derivation** — Native PBKDF2 and HKDF support
- **Saved profiles** — Save and reuse your favorite pipelines via localStorage
- **Single file** — Everything in a single `.html`, no external dependencies
- **100% offline** — No network requests, no CDN libraries

---

## 🧮 Supported Algorithms

All algorithms are provided by the **native browser Web Crypto API** — a C++ implementation audited by Mozilla, available in Tor Browser and any modern browser.

| Algorithm | Family | Output | Notes |
|---|---|---|---|
| SHA-256 | SHA-2 | 256 bits | ✅ Recommended |
| SHA-384 | SHA-2 | 384 bits | ✅ Recommended |
| SHA-512 | SHA-2 | 512 bits | ✅ Recommended |
| SHA-1 | SHA-1 | 160 bits | ⚠️ Avoid as final step |
| PBKDF2-SHA256 | KDF | 256 bits | ✅ 100k iterations, ideal as final step |
| PBKDF2-SHA512 | KDF | 256 bits | ✅ 100k iterations, ideal as final step |
| HKDF-SHA256 | KDF | 256 bits | ✅ Key derivation |
| HKDF-SHA512 | KDF | 256 bits | ✅ Key derivation |

> **Why only these?** The Web Crypto API is intentionally minimalist — it includes only algorithms considered secure and audited. Using only native algorithms eliminates any risk of incorrect implementation of manual cryptographic code.

---

## 🖥️ How It Works

```
User phrase
      │
      ▼
Normalization (lowercase + remove spaces)
      │
      ▼
┌─────────────────────────────────────┐
│           Hash Pipeline              │
│  SHA-256 → SHA-512 → PBKDF2-SHA512  │  ← defined by the user
└─────────────────────────────────────┘
      │
      ▼
Final hash (high entropy)
```

---

## 💾 Profiles

The user can save pipelines as **named profiles** for reuse:

| Profile Name | Pipeline |
|---|---|
| `my-key` | SHA-256 → SHA-512 → PBKDF2-SHA512 |
| `derivation` | SHA-512 → HKDF-SHA512 |
| `simple` | SHA-256 |

> Profiles are saved in the browser's `localStorage`. On Tails, enable **persistent storage** to keep profiles between sessions.

---

## 🚀 How to Use

1. Download the `hashforge-v0.2.0.html` file
2. Open in your browser (`File > Open` or drag into the browser)
3. Type your phrase, build the pipeline and run it

On **Tails OS**, save the file in the encrypted persistent volume and open it directly in **Tor Browser**.

---

## 🛠️ Stack

| Component | Technology |
|---|---|
| Language | HTML + JavaScript (vanilla) |
| Interface | Plain HTML/CSS, no frameworks |
| Algorithms | Web Crypto API (native browser) |
| Storage | localStorage |
| Distribution | Single `.html` file |
| Dependencies | Zero |

---

## 🧅 Tails OS Compatibility

| Requirement | Status |
|---|---|
| Opens in Tor Browser | ✅ |
| Works without internet | ✅ |
| No package installation | ✅ |
| Single file in persistent volume | ✅ |
| Web Crypto API available in Tor Browser | ✅ |

---

## 🗺️ Roadmap

- [x] Phrase normalization (lowercase + remove spaces)
- [x] Customizable algorithm pipeline
- [x] Native algorithms via Web Crypto API
- [x] Profile system with localStorage
- [x] Copy result to clipboard
- [x] Key derivation via PBKDF2 and HKDF
- [x] Offline HTML/CSS interface
- [x] PT/EN automatic language detection with manual toggle
- [x] Export result as .txt
- [x] Export encrypted .enc (AES-256-CBC, OpenSSL compatible)
- [ ] Tests with official vectors (NIST) for validation
- [ ] Export result in different formats (hex, base64, bytes)
- [ ] Option to configure PBKDF2 iterations

---

## ⚠️ Security Notice

This project is for **personal use**. The security of a cryptographic system depends on much more than the hash algorithms used. Do not use the results as the sole layer of protection in critical systems without a proper security review.

---

## 📄 License

Distributed under the **MIT** License. See [LICENSE](LICENSE) for more details.

---
