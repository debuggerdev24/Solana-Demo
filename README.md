# 🪙 Solana Wallet Demo — Flutter

A Flutter demo project demonstrating **Solana wallet connection**, **message signing & verification**, and **JWT token generation**, complete with interactive UI and secure local storage.

---

## 📘 Overview

This project showcases how to:

- Connect Solana wallets (Phantom, Solflare) using `solana_wallet_adapter`.
- Sign and verify messages locally with Ed25519.
- Generate JWT tokens for connected wallets.
- Securely store tokens using Flutter Secure Storage.
- Display wallet info, token validity, and verification status interactively.
- Add unique visual identities and a polished user experience.

It is a fully functional **proof-of-concept** for Web3 authentication flows in Flutter.

---

## 🧩 Tech Stack

| Layer | Technology |
|-------|------------|
| Framework | Flutter 3.9.2 |
| Language | Dart |
| Blockchain SDK | [`solana_wallet_adapter`](https://pub.dev/packages/solana_wallet_adapter) |
| Crypto | [`cryptography`](https://pub.dev/packages/cryptography), [`bs58`](https://pub.dev/packages/bs58) |
| JWT | [`dart_jsonwebtoken`](https://pub.dev/packages/dart_jsonwebtoken) |
| Storage | [`flutter_secure_storage`](https://pub.dev/packages/flutter_secure_storage) |
| State Management | Provider |

---

## 🏗️ Architecture

### High-Level Flow
