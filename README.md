# MemeLab v0.4

Terminal de pesquisa de tokens Solana, sem execução de ordens.

[Aplicação](https://memelab.mcpe3004.workers.dev/)

## API

- `/api/health`: versão e teste de conexão D1.
- `/api/scanner`: até 90 endereços deduplicados dos perfis recentes, boosts recentes e top boosts DexScreener. Boosts são publicidade, não qualidade ou recomendação. Não cobre todos os lançamentos. Cache de 60 segundos; resposta indica `partial` se uma fonte de descoberta falhar.
- `/api/history`: contagem e horário do último snapshot armazenado.
- `/api/wallet/{address}`: saldo SOL e até 15 transações confirmadas via RPC público Solana, cache de 120 segundos. Não classifica swaps nem calcula PnL. RPC sujeito a limites e bloqueios.

- `/api/intelligence/{address}`: até 10 assinaturas recentes, detalhes em lotes de 2 via RPC público. Deltas SPL agregados por mint e proprietário com aritmética inteira; classifica entradas, saídas, possíveis trocas e fluxos complexos. Não confirma swaps, não calcula PnL nem win rate. Delta SOL nativo inclui taxas e possíveis ajustes de aluguel; não é preço de execução. Cobertura parcial é explícita. Cache de 180 segundos.

## Persistência

D1 `memelab-db` vinculado como `DB`. Aplicar `migrations/0001_market_snapshots.sql`. Cron `*/5 * * * *` coleta snapshots completos e não vazios, deduplicados por intervalo de cinco minutos; retenção aproximada de sete dias. Watchlists de tokens e carteiras ficam no navegador, não no D1. A watchlist de tokens mostra somente o feed atual.

## Deploy

`worker.mjs` é o módulo publicado. Deploy manual via Cloudflare API; ainda sem CI. Nenhuma chave ou credencial no código. Não inserir seed phrases ou chaves privadas.

## Roadmap

P0: coleta e scanner, validação ponta a ponta e descoberta mais abrangente.
P1: análise inicial de fluxo implementada; falta confirmação por programas DEX, histórico paginado, PnL verificável e alertas.
P2: indicadores de risco.
P3: narrativas.
P4: simulador e diário.
P5: copiloto de estudo.

Dados não constituem recomendações de investimento.
