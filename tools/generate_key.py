#!/usr/bin/env python3
import argparse
import hashlib
import secrets


def make_key() -> str:
    alphabet = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
    parts = ["".join(secrets.choice(alphabet) for _ in range(4)) for _ in range(3)]
    return f"NINJA-{'-'.join(parts)}"


def sha256_hex(raw_key: str) -> str:
    return hashlib.sha256(raw_key.strip().upper().encode("utf-8")).hexdigest()


def main():
    parser = argparse.ArgumentParser(description="Генератор Премиум-ключей (SHA-256)")
    parser.add_argument("--count", type=int, default=1)
    args = parser.parse_args()
    for idx in range(1, args.count + 1):
        key = make_key()
        print(f"{idx}. Ключ: {key}")
        print(f'   SHA-256: "{sha256_hex(key)}"\n')


if __name__ == "__main__":
    main()
