# MemeLab v0.9

Terminal de pesquisa de tokens Solana, sem execução de ordens.

[Aplicação](https://memelab.mcpe3004.workers.dev/)

## API

- `/api/health`: versão e teste de conexão D1.
- `/api/scanner`: até 90 endereços deduplicados dos perfis recentes, boosts recentes e top boosts DexScreener. Boosts são publicidade, não qualidade ou recomendação. Não cobre todos os lançamentos. Cache de 60 segundos; resposta indica `partial` se uma fonte de descoberta falhar.
- `/api/history`: contagem e horário do último snapshot armazenado.
- `/api/wallet/{address}`: saldo SOL e até 15 transações confirmadas via RPC público Solana, cache de 120 segundos. Não classifica swaps nem calcula PnL. RPC sujeito a limites e bloqueios.

- `/api/intelligence/{address}`: até 10 assinaturas recentes, detalhes em lotes de 2 via RPC público. Deltas SPL agregados por mint e proprietário com aritmética inteira; classifica entradas, saídas, possíveis trocas e fluxos complexos. Não confirma swaps, não calcula PnL nem win rate. Delta SOL nativo inclui taxas e possíveis ajustes de aluguel; não é preço de execução. Cobertura parcial é explícita. Cache de 180 segundos.

- `/api/risk/{mint}`: autoridades de emissão e congelamento, concentração bruta das 10/20 maiores contas SPL e liquidez do maior par DexScreener. Não identifica beneficiários, insiders ou liquidez bloqueada; extensões Token-2022 não são analisadas completamente. Dados parciais explícitos; cache de 180 segundos. Limiar de US$10 mil e concentração de 50% são heurísticas de triagem, não certificação de risco.

- Narrative Intelligence: grupos heurísticos pelo nome/símbolo e classificação manual local, com contagem, soma de volumes 24h conhecidos e mediana da variação 5m. Não monitora redes sociais nem estima fluxos líquidos de capital.

- `/api/quotes?mints=...`: até 20 mints Solana válidos, preço indicativo e liquidez do maior par no DexScreener, cache de 15 segundos.
- Paper Trading: banca virtual em USD (padrão US$1.000), compra pelo custo total, venda integral, taxas e slippage configuráveis, tese obrigatória na entrada, notas de saída, PnL realizado, win rate das posições fechadas, patrimônio marcado a mercado e drawdown observado. Limite de 20 posições e de 1% da liquidez informada por operação; modelo heurístico, não garantia de execução. Cotações ausentes ou vencidas impedem execução e patrimônio completo. Diário e curva de até 500 observações ficam no localStorage, com exportação JSON; não sincronizados entre dispositivos. Sem ordens reais, alavancagem, replay ou simulação de profundidade de livro.

- Trading Copilot: treinador local baseado em regras (sem modelo generativo), revisão de risco e evidências, perguntas sobre tese e invalidação, cenários hipotéticos de perda sobre patrimônio virtual, revisão de diário (expectância, profit factor, médias, custos, duração, notas e drawdown), glossário e exportação JSON. Teses e notas não são enviadas ao servidor; apenas o mint é usado para consultar `/api/risk`. Não valida tese semântica, não prevê retornos, não gera sinais de negociação.

- `/api/data-quality`: contagens de coletas finalizadas nas últimas 24h, últimas 20 execuções e metadados do snapshot mais recente. Registra falhas por fonte/lote; diagnósticos anteriores continuam genéricos.
- Data Engine: tentativas limitadas para falhas transitórias (sem retry imediato de HTTP 429), resultados parciais por lote, cobertura de preços e fallback histórico de até 24h claramente marcado no scanner. O fallback não é utilizado por `/api/quotes` do simulador. Snapshots sem preço utilizável não são armazenados. Persistência tenta privilegiar maior cobertura ou substituição de parcial por completo no mesmo intervalo.

## Persistência

D1 `memelab-db` vinculado como `DB`. Aplicar `migrations/0001_market_snapshots.sql`. Cron `*/5 * * * *` coleta snapshots não vazios, inclusive parciais identificados no payload, deduplicados por intervalo de cinco minutos; retenção aproximada de sete dias. Aplicar também `migrations/0002_collection_runs.sql` para registrar tentativas de coleta, inclusive falhas. `/api/history` retorna a última execução registrada. Aplicar `migrations/0003_risk_snapshots.sql`. O scanner grava snapshots também no acesso web (deduplicados por 5 minutos); a investigação de risco registra até 30 tokens distintos por hora, um registro por mint/hora, retenção aproximada de sete dias com limpeza em novas consultas de risco. Respostas indicam disponibilidade da persistência; `stored-or-existing` pode representar um snapshot anterior no intervalo, não o clique atual. `/api/history` inclui contagem de investigações e horário da última. Classificações manuais de narrativas ficam no navegador. Watchlists de tokens e carteiras ficam no navegador, não no D1. A watchlist de tokens mostra somente o feed atual.

## Deploy

`worker.mjs` é o módulo publicado. Deploy manual via Cloudflare API; ainda sem CI. Nenhuma chave ou credencial no código. Não inserir seed phrases ou chaves privadas.

## Roadmap

P0: coleta e scanner, validação ponta a ponta e descoberta mais abrangente.
P1: análise inicial de fluxo implementada; falta confirmação por programas DEX, histórico paginado, PnL verificável e alertas.
P2: Risk Lab inicial implementado; falta resolver proprietários e pools, extensões, histórico de distribuição e conexões entre carteiras.
P3: agrupamento heurístico inicial e classificação manual implementados; falta monitoramento social e séries históricas de narrativas.
P4: simulador e diário locais implementados; falta validação de execução e dados, replay e sincronização autenticada.
P5: treinador baseado em regras implementado; falta integração opcional com modelo generativo e validação ponta a ponta.

Dados não constituem recomendações de investimento.
