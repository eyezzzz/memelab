# MemeLab

Terminal de pesquisa de tokens Solana, sem execução de ordens.

- [Aplicação](https://memelab.mcpe3004.workers.dev/)
- `/api/health`: status e versão.
- `/api/scanner`: até 30 endereços Solana dos perfis recentes do DexScreener, com métricas do par de maior liquidez encontrado. Não é um feed completo de lançamentos nem um detector de golpes.
- Cache de 60 segundos; atualização da interface a cada minuto quando visível.
- Watchlist local ao navegador, limitada aos tokens do feed atual.
- Dados ausentes são apresentados como indisponíveis. Compras/vendas são contagens de transações, não de carteiras únicas.

## Deploy

O módulo `worker.mjs` é o código publicado no Cloudflare Worker `memelab`. Deploy manual via API, ainda sem integração contínua. Não há credenciais no código. Não inserir chaves privadas, seed phrases ou tokens de API no Git.

## Roadmap

P0: ampliar descoberta de tokens, persistência da watchlist e validação ponta a ponta.
P1: histórico e monitoramento de carteiras.
P2: indicadores de risco on-chain.
P3: narrativas.
P4: simulador e diário.
P5: copiloto de estudo.

Dados de mercado não são recomendações de investimento.
